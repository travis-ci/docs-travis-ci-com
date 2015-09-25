---
title: Setting up Databases
layout: en
permalink: /user/database-setup/
---

This guide covers setting up the most popular databases and other services in the Travis CI environment. Looking for information on [configuring multiple databases?](/user/database-setup/#Multiple-database-systems).

<div id="toc"></div>

The following services are available, all of them use default settings, with the exception of some added users and relaxed security settings:

{% include databases.html %}

## Starting Services

Most services are not started on boot to make more RAM available to test suites, so you need to tell Travis CI to start them
using the `services` entry in `.travis.yml`:

    services: mongodb

or to start several services:

    services:
      - riak      # start riak
      - rabbitmq  # start rabbitmq-server
      - memcached # start memcached

> Note that this feature only works for services we provision in our [CI environment](/user/ci-environment/). If you download Apache Jackrabbit
> you still have to start it in a `before_install` step.

### Multiple database systems

If your project's tests need to run multiple times using different databases, this can be configured on Travis CI using a technique
with env variables. The technique is just a convention and requires a `before_script` or `before_install` line to work.

#### Using ENV variables and before_script steps

Use the `DB` environment variable to specify the name of the database configuration. Locally you would run:

    $ DB=postgres [commands to run your tests]

On Travis CI you want to create a [build matrix](/user/customizing-the-build/#Build-Matrix) of three builds each having the `DB` variable exported with a different value, and for that you can use the `env` option in `.travis.yml`:

    env:
      - DB=sqlite
      - DB=mysql
      - DB=postgres

Then you can use those values in a `before_install` (or `before_script`) step to set up each database. For example:

    before_script:
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests_tmp;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests_tmp;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'mysql' ]; then mysql -e 'create database IF NOT EXISTS doctrine_tests_tmp;create database IF NOT EXISTS doctrine_tests;'; fi"


> Travis CI does not have any special support for these variables, it just creates three builds with different exported values. It is up to your
test suite or `before_install`/`before_script` steps to make use of them.

For a real example, see [doctrine/doctrine2 .travis.yml](https://github.com/doctrine/doctrine2/blob/master/.travis.yml).

#### A Ruby-specific Approach

Another approach that is Ruby-specific is put all database configurations in one YAML file (`test/database.yml` for example), like ActiveRecord does:

    sqlite:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500
    mysql:
      adapter: mysql2
      database: myapp_test
      username:
      encoding: utf8
    postgres:
      adapter: postgresql
      database: myapp_test
      username: postgres

Then, in your test suite, read that data into a configurations hash:

    configs = YAML.load_file('test/database.yml')
    ActiveRecord::Base.configurations = configs

    db_name = ENV['DB'] || 'sqlite'
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.default_timezone = :utc

## MySQL

MySQL on Travis CI is **started on boot**, binds to 127.0.0.1 and requires authentication. You can connect using the username "travis" or "root" and a blank password.

>Note that the "travis" user does not have full MySQL privileges that the "root" user does.

### Using MySQL with ActiveRecord

`config/database.yml` example for Ruby projects using ActiveRecord:

    test:
      adapter: mysql2
      database: myapp_test
      username: travis
      encoding: utf8

You might have to create the `myapp_test` database first. Run this as part of your build script:

    # .travis.yml
    before_script:
      - mysql -e 'create database myapp_test;'

### Note on `test` database

In older versions of MySQL, Ubuntu package provided the `test` database by default.
This is no longer the case as of version 5.5.37 due to security concerns
(See [change log](http://changelogs.ubuntu.com/changelogs/pool/main/m/mysql-5.5/mysql-5.5_5.5.37-0ubuntu0.12.04.1/changelog)).

If you need it, create it using the following `before_install` line:

```yaml
before_install:
  - mysql -e "create database IF NOT EXISTS test;" -uroot
```

## PostgreSQL


### Selecting a PostgreSQL Version

By default, the build environment will have version 9.1 running already.

You can easily choose a different version by way of your .travis.yml.

We have PostgreSQL 9.1, 9.2 and 9.3 installed, usually with their latest patch releases. We install them from the official [PostgreSQL APT repository](http://apt.postgresql.org).

Currently, you'll find the **following versions installed: 9.1.14, 9.2.9 and 9.3.5**, respectively.

To select a different version than the default, use the following setting in your .travis.yml:

    addons:
      postgresql: "9.3"

This selects PostgreSQL 9.3 as the version your build expects to be running.

**Available selections are "9.1", "9.2" and "9.3"**. Make sure to only specify the major and the minor version, without the patch release.

### Using PostgreSQL in your Builds

The default user for accessing the local PostgreSQL server is `postgres` and doesn't have a password set up.

Creating a database for your application requires just an extra line in your .travis.yml:

    before_script:
      - psql -c 'create database travis_ci_test;' -U postgres

For a Rails application, you can now use the following database.yml configuration to access the database locally:

    test:
      adapter: postgresql
      database: travis_ci_test
      username: postgres

Should your local test setup use different credentials or settings to access the local test database, we recommend putting these settings in a database.yml.travis in your repository and copying that over as part of your build:

    before_script:
      - cp config/database.yml.travis config/database.yml

### Using PostGIS

All available versions of PostgreSQL come with PostGIS 2.1 packages preinstalled.

Your build needs to enable the extension, which isn't done by default. Here's an example for your .travis.yml:

    before_script:
      - psql -U postgres -c "create extension postgis"

### PostgreSQL and Locales

The default set of available locales is limited, so depending on your language needs, you may need to install them.

Here are the steps to install the Spanish language pack. Note that you need to remove the PostgreSQL version from the `addons` section of your .travis.yml:

    before_install:
      - sudo apt-get update
      - sudo apt-get install language-pack-es
      - sudo /etc/init.d/postgresql stop
      - sudo /etc/init.d/postgresql start 9.3

<div class="note-box">
Note that <code>sudo</code> is not available for builds that are running on the <a href="/user/workers/container-based-infrastructure">container-based workers</a>.
</div>


Here's a list of locales currently installed on the system by default:

    C
    C.UTF-8
    en_AG
    en_AG.utf8
    en_AU.utf8
    en_BW.utf8
    en_CA.utf8
    en_DK.utf8
    en_GB.utf8
    en_HK.utf8
    en_IE.utf8
    en_IN
    en_IN.utf8
    en_NG
    en_NG.utf8
    en_NZ.utf8
    en_PH.utf8
    en_SG.utf8
    en_US.utf8
    en_ZA.utf8
    en_ZM
    en_ZM.utf8
    en_ZW.utf8
    POSIX

All language packs currently available for Ubuntu 12.04 can be [found on the packages site.](http://packages.ubuntu.com/search?keywords=language-pack&searchon=names&suite=precise&section=all)

## MariaDB

MariaDB is a community-developed fork of MySQL. It is available as an addon on Travis CI.
Pass the major-minor version string to indicate MariaDB version, like so:

{% highlight yaml %}
addons:
  mariadb: '10.0'
{% endhighlight %}

For valid values, see [MariaDB web page](https://downloads.mariadb.org/).

The version number is exported as `TRAVIS_MARIADB_VERSION`.

## SQLite3

Probably the easiest and simplest solution for your relation database needs. If you don't specifically want to test how your code behaves with other databases,
in memory SQLite might be the best option.

### SQLite3 in Ruby Projects

For Ruby projects, ensure that you have the sqlite3 ruby bindings in your bundle:

    # Gemfile
    # for CRuby, Rubinius, including Windows and RubyInstaller
    gem "sqlite3", :platform => [:ruby, :mswin, :mingw]

    # for JRuby
    gem "jdbc-sqlite3", :platform => :jruby

`config/database.yml` example for projects that use ActiveRecord:

    test:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500

If you're not using a `config/database.yml` file to configure ActiveRecord, you need to connect to the database manually in the tests. For example, connecting with ActiveRecord could be done like this:

    ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
                                            :database => ':memory:'

## MongoDB

MongoDB is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - mongodb

MongoDB binds to 127.0.0.1 and requires no authentication or database creation up front. If you add an admin user, authentication will be enabled, since `mongod` is started with the `--auth` argument.

> Note: Admin users are users created on the admin database.

To create users for your database, add a `before_script` to your `.travis.yml` file:

    # .travis.yml
    before_script:
      - mongo mydb_test --eval 'db.addUser("travis", "test");'

### MongoDB may not be immediately accepting connections

A few users have reported that MongoDB may not be accepting connections when the job attempts to
execute commands.
The issue is intermittent at best, and the only reliable means to avoid it is to
inject artificial wait before making the first connection:

    # .travis.yml
    before_script:
      - sleep 15
      - mongo mydb_test --eval 'db.addUser("travis", "test");'

## CouchDB

CouchDB is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - couchdb

CouchDB binds to 127.0.0.1, uses stock configuration and does not require authentication (in CouchDB speak it runs in admin party).

You have to create the database as part of your build process:

    # .travis.yml
    before_script:
      - curl -X PUT localhost:5984/myapp_test


## RabbitMQ

RabbitMQ is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - rabbitmq

RabbitMQ uses the default configuration of vhost (`/`), username (`guest`) and password (`guest`).
You can set up more vhosts and roles via a `before_script` if needed (for example, to test authentication).


## Riak

Riak is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - riak

Riak uses stock configuration with one exception: it is configured to use [LevelDB storage backend](http://docs.basho.com/riak/latest/ops/advanced/backends/leveldb/).
Riak Search is enabled.

## Memcached

Memcached is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - memcached

Memcached uses stock configuration and binds to localhost.

## Redis

Redis is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - redis-server

Redis uses stock configuration and is available on localhost.


## Cassandra

Cassandra is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - cassandra

Cassandra is provided via [Datastax Community Edition](http://www.datastax.com/products/community) and uses stock configuration (available on 127.0.0.1).

### Older version

If you need an older version of Cassandra, you can add a command like the following to your `.travis.yml`:

```yaml
before_install:
  - sudo rm -rf /var/lib/cassandra/*
  - wget http://www.us.apache.org/dist/cassandra/1.2.18/apache-cassandra-1.2.18-bin.tar.gz && tar -xvzf apache-cassandra-1.2.18-bin.tar.gz && sudo sh apache-cassandra-1.2.18/bin/cassandra
```

> `sudo` is not available on [Container-based workers](/user/ci-environment/#Virtualization-environments).

## Neo4J

Neo4J Server (Community Edition) is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - neo4j

Neo4J Server uses default configuration (localhost, port 7474).

> Neo4j does not start on container-based workers. See <a href="https://github.com/travis-ci/travis-ci/issues/3243">https://github.com/travis-ci/travis-ci/issues/3243</a>

## ElasticSearch

ElasticSearch is **not started on boot**. Add it to `.travis.yml` to start it:

    services:
      - elasticsearch

ElasticSearch may take few seconds to start and may not be available when the script is executed. In that case, we can make Travis CI wait with the ``sleep`` command

    before_script:
      - sleep 10

ElasticSearch is provided via official Debian packages and uses stock configuration (available on 127.0.0.1).

### Using a specific version of ElasticSearch

You can overwrite the installed ElasticSearch with the version you need (e.g., 1.2.4) with the following:

```yaml
before_install:
  - curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.4.deb && sudo dpkg -i --force-confnew elasticsearch-1.2.4.deb
```
> `sudo` is not available on [Container-based workers](/user/ci-environment/#Virtualization-environments).

### Garbled Output

When ElasticSearch starts, you may see a mangled message such as this:

```
$ sudo service elasticsearch start
 * Starting ElasticSearch Server       ission denied on key 'vm.max_map_count'
```

This is due to a [recent change in ElasticSearch](https://github.com/elasticsearch/elasticsearch/issues/4397),
as reported [here](https://github.com/elasticsearch/elasticsearch/issues/4978).
The message is harmless, and the service is functional.

