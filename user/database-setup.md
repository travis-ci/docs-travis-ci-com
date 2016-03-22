---
title: Setting up Databases
layout: en
permalink: /user/database-setup/
redirect_from:
  - /user/using-postgresql/
---

This guide covers setting up the most popular databases and other services in the Travis CI environment.

<div id="toc"></div>

All services use default settings, with the exception of some added users and relaxed security settings.

## Starting Services

Travis CI environments do not start services by default, to make more RAM available
to build scripts. Start services by adding them to the `services:` section of your
`.travis.yml`:

```yaml
services: mongodb
```

> If you install a service in the `addons:` section, such as MariaDB, you do not need to add it to the `services:` section as well.

To start several services:

```yaml
services:
  - riak
  - rabbitmq
  - memcached
```

> Note that this feature only works for services we provision in our [CI environment](/user/ci-environment/). If you download Apache Jackrabbit
> you still have to start it in a `before_install` step.


## MySQL

Start MySQL in your `.travis.yml`:

```yaml
services:
  - mysql
```

MySQL binds to 127.0.0.1 and requires authentication. You can connect using the username "travis" or "root" and a blank password.

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

### MySQL 5.6

The recommended way to get MySQL 5.6 is switching to our [Trusty CI Environment](/user/trusty-ci-environment/) and manually installing the required packages by adding the following lines to the `.travis.yml`:

```yaml
dist: trusty
sudo: required
addons:
  apt:
    packages:
    - mysql-server-5.6
    - mysql-client-core-5.6
    - mysql-client-5.6
```

Note that you'll need to use the user `root` as `travis` is not available yet.

For example, if you were running: ``mysql -e 'create database your_db_name;' ``

You should run instead: ``mysql -u root -e 'create database your_db_name;'``

## PostgreSQL

Start PostgreSQL in your `.travis.yml`:

```yaml
services:
  - postgresql
```

### Using PostgreSQL in your Builds

The default user for accessing the local PostgreSQL server is `postgres` with a blank password.

Create a database for your application by adding a line to your .travis.yml:

```yaml
before_script:
  - psql -c 'create database travis_ci_test;' -U postgres
```

For a Rails application, you can now use the following `database.yml` configuration to access the database locally:

```yaml
test:
  adapter: postgresql
  database: travis_ci_test
```

If your local test setup uses different credentials or settings to access the local test database, we recommend putting these settings in a `database.yml.travis` in your repository and copying that over as part of your build:

  - curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.4.deb && sudo dpkg -i --force-confnew elasticsearch-1.2.4.deb
```yaml
before_script:
  - cp config/database.yml.travis config/database.yml
```

### Using a different PostgreSQL Version

The Travis CI build environments use version 9.4 by default, but other versions from the official [PostgreSQL APT repository](http://apt.postgresql.org) are also available. To use a version other than the default, specify only the **major.minor** version in your `.travis.yml`:

```yaml
addons:
  postgresql: "9.1"
```

The following patch releases are available:

| Version | yaml in `.travis.yml`
| ------- | :-------------------:
| 9.1.15  | `postgresql: "9.1"`
| 9.2.10  | `postgresql: "9.2"`
| 9.3.6   | `postgresql: "9.3"`
| 9.4.1   | `postgresql: "9.4"`

### Using PostGIS

All installed versions of PostgreSQL include PostGIS 2.1 .

You need to activate the extension in your `.travis.yml`:

```yaml
before_script:
  - psql -U postgres -c "create extension postgis"
```

### PostgreSQL and Locales

The following locales are installed on Travis CI build environements:

* C
* C.UTF-8
* en_AG
* en_AG.utf8
* en_AU.utf8
* en_BW.utf8
* en_CA.utf8
* en_DK.utf8
* en_GB.utf8
* en_HK.utf8
* en_IE.utf8
* en_IN
* en_IN.utf8
* en_NG
* en_NG.utf8
* en_NZ.utf8
* en_PH.utf8
* en_SG.utf8
* en_US.utf8
* en_ZA.utf8
* en_ZM
* en_ZM.utf8
* en_ZW.utf8
* POSIX

You can find what language packs are currently available for Ubuntu 12.04 [on the packages site.](http://packages.ubuntu.com/search?keywords=language-pack&searchon=names&suite=precise&section=all)

#### Installing Locales

The following example shows the lines you need to add to your `.travis.yml` to install the Spanish language pack. The `sudo` command is not available on [container based infrastructure](/user/workers/container-based-infrastructure) so you currently cannot install locales on it.

> Note that you need to remove the PostgreSQL version from the `addons` section of your .travis.yml:

```yaml
before_install:
  - sudo apt-get update
  - sudo apt-get install language-pack-es
  - sudo /etc/init.d/postgresql stop
  - sudo /etc/init.d/postgresql start 9.3
```

## MariaDB

MariaDB is a community-developed fork of MySQL. It is available as an addon on Travis CI.

To use MariaDB, specify the "major.minor" version you want to use in your `.travis.yml`. Versions are listed on the [MariaDB web page](https://downloads.mariadb.org/).


```yaml
addons:
  mariadb: '10.0'
```

The version number is exported as the `TRAVIS_MARIADB_VERSION` environment variable.

## SQLite3

The easiest and simplest relational database.

### SQLite3 in Ruby Projects

Add the sqlite3 ruby bindings to your bundle:

```ruby
# Gemfile
# for CRuby, Rubinius, including Windows and RubyInstaller
gem "sqlite3", :platform => [:ruby, :mswin, :mingw]

# for JRuby
gem "jdbc-sqlite3", :platform => :jruby
```

If you use ActiveRecord, add the following to your `config/database.yml`:

```yaml
test:
  adapter: sqlite3
  database: ":memory:"
  timeout: 500
```

Or if you're not using a `config/database.yml`, connect to the database manually:

```ruby
ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
                                        :database => ':memory:'
```

## MongoDB

Start MongoDB in your `.travis.yml`:

```yaml
services:
  - mongodb
```

MongoDB binds to 127.0.0.1 and requires no authentication or database creation up front. If you add an `admin` user authentication is enabled, since `mongod` is started with the `--auth` argument.

> Note: Admin users are users created in the admin database.

To create users for your database, add a `before_script` section to your `.travis.yml`:

```yaml
before_script:
  - mongo mydb_test --eval 'db.addUser("travis", "test");'
```

### MongoDB does not immediately accept connections

A few users have reported that MongoDB does not accept connections when from the build script.

The issue is intermittent, and the only reliable way to avoid it is to
inject an artificial wait before making the first connection:

Add the following `before_script` to your `.travis.yml` to wait before connecting to MongoDB:

```yaml
before_script:
  - sleep 15
  - mongo mydb_test --eval 'db.addUser("travis", "test");'
```

## CouchDB

Start CouchDB in your `.travis.yml`:

```yaml
services:
  - couchdb
```

CouchDB binds to 127.0.0.1, uses default configuration and does not require authentication (in CouchDB terms it runs in admin party).

Before using CouchDB you need to create the database as part of your build process:

```yaml
before_script:
  - curl -X PUT localhost:5984/myapp_test
```

## RabbitMQ

RabbitMQ requires `setuid` flags, so you can only run RabbitMQ on standard, OSX or Trusty infrastructure (ie, your `.travis.yml` must contain `sudo: required`).

Start RabbitMQ in your `.travis.yml`:

```yaml
services:
  - rabbitmq
```

RabbitMQ uses the default configuration:

* vhost: `/`
* username: `guest`
* password: `guest`

You can set up more vhosts and roles in the `before_script` section of your `.travis.yml`.

## Riak

Start Riak in your `.travis.yml`:

```yaml
services:
  - riak
```

Riak uses the default configuration apart from the storage backend, which is [LevelDB](http://docs.basho.com/riak/latest/ops/advanced/backends/leveldb/).

Riak Search is enabled.

## Memcached

Start Memcached service in your `.travis.yml`:

```yaml
services:
  - memcached
```

Memcached uses the default configuration and binds to localhost.

## Redis

Start Redis in your `.travis.yml`:

```yaml
services:
  - redis-server
```

Redis uses the default configuration and is available on localhost.

## Cassandra

Start Cassandra in your `.travis.yml`:

```yaml
services:
  - cassandra
```

Cassandra is provided by [Datastax Community Edition](http://www.datastax.com/products/community) and uses the default configuration. It is available on 127.0.0.1.

### Installing older versions of Cassandra

Use the following example to install a specific older version of Cassandra in your `.travis.yml`:

```yaml
before_install:
  - sudo rm -rf /var/lib/cassandra/*
  - wget http://www.us.apache.org/dist/cassandra/1.2.18/apache-cassandra-1.2.18-bin.tar.gz && tar -xvzf apache-cassandra-1.2.18-bin.tar.gz && sudo sh apache-cassandra-1.2.18/bin/cassandra
```

> If you're using [Container-based infrastructure](/user/ci-environment/#Virtualization-environments) you won't be able to install other versions of Cassandra as the `sudo` command is not available.

## Neo4J

Start Neo4J in your `.travis.yml`:

```yaml
services:
  - neo4j
```

Neo4J Server uses default configuration and binds to localhost on port 7474.

> Neo4j does not start on container-based infrastructure. See <a href="https://github.com/travis-ci/travis-ci/issues/3243">https://github.com/travis-ci/travis-ci/issues/3243</a>

## ElasticSearch

Start ElasticSearch in your `.travis.yml`:

```yaml
services:
  - elasticsearch
```

ElasticSearch takes few seconds to start, to make sure it is available when the build script runs add a small delay to your build script:

```yaml
before_script:
  - sleep 10
```

ElasticSearch uses the default configuration and is available on 127.0.0.1.

### Installing specific versions of ElasticSearch

You can overwrite the installed ElasticSearch with the version you need (e.g., 1.2.4) with the following:

```yaml
before_install:
```
> `sudo` is not available on [Container-based infrastructure](/user/ci-environment/#Virtualization-environments).

### Truncated Output in the Build Log

When ElasticSearch starts, you may see a truncated error message such as:

```
$ sudo service elasticsearch start
 * Starting ElasticSearch Server       ission denied on key 'vm.max_map_count'
```

This is due to a [recent change in ElasticSearch](https://github.com/elasticsearch/elasticsearch/issues/4397),
as reported [here](https://github.com/elasticsearch/elasticsearch/issues/4978).
The message is harmless, and the service is functional.

## Multiple Database Builds

If you need to run multiple builds using different databases, you can configure environment variables
and a `before_script` or `before_install` line to create a build matrix.

### Using environemnt variables and a before_script step

Use the `DB` environment variable to specify the name of the database configuration. Locally you would run:

```sh
DB=postgres [commands to run your tests]
```

On Travis CI you want to create a [build matrix](/user/customizing-the-build/#Build-Matrix) of three builds each having the `DB` variable exported with a different value, and for that you can use the `env` option in `.travis.yml`:

```yaml
env:
  - DB=sqlite
  - DB=mysql
  - DB=postgres
```

Then you can use those values in a `before_install` (or `before_script`) step to set up each database. For example:

```yaml
before_script:
  - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests_tmp;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests_tmp;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'mysql' ]; then mysql -e 'create database IF NOT EXISTS doctrine_tests_tmp;create database IF NOT EXISTS doctrine_tests;'; fi"
```

> Travis CI does not have any special support for these variables, it just creates three builds with different exported values. It is up to your
build script and `before_install` or `before_script` steps to make use of them.

For a real example, see [doctrine/doctrine2 .travis.yml](https://github.com/doctrine/doctrine2/blob/master/.travis.yml).

### Using Ruby

Another approach is put all database configuration in one YAML file (`test/database.yml` for example), like ActiveRecord does:

```yaml
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
```

Then, in your test suite, read that data into a configurations hash:

```ruby
configs = YAML.load_file('test/database.yml')
ActiveRecord::Base.configurations = configs

db_name = ENV['DB'] || 'sqlite'
ActiveRecord::Base.establish_connection(db_name)
ActiveRecord::Base.default_timezone = :utc
```
