---
title: Databases and other services in the Travis CI Environment
layout: en
permalink: database-setup/
---

### What This Guide Covers

This guide covers data stores and other services (e.g. RabbitMQ) offered in the Travis [CI environment](/docs/user/ci-environment/) and what users and settings projects hosted on travis-ci.org can rely on. Most of the content is applicable to any technology but there are subtle aspects in the behavior of some database drivers that this guide will try to cover. We recommend you start with the [Getting Started](/docs/user/getting-started/) and [Build Configuration](/docs/user/build-configuration/) guides before reading this one.

## Services (data stores, messaging brokers, etc) in the Travis CI Environment

[Travis CI Environment](/docs/user/ci-environment/) has multiple popular data stores preinstalled. Some of the services available are:

* MySQL
* PostgreSQL
* MongoDB
* CouchDB
* Redis
* Riak
* RabbitMQ
* Memcached
* Cassandra
* Neo4J
* ElasticSearch
* Kestrel
* SQLite3

All the aforementioned services use mostly stock default settings. However, when it makes sense, new users are added and security settings are relaxed (because for continuous integration ease of use is more important): one example of such adaptation is PostgreSQL that has strict default access settings.

## Configure Your Projects to Use Services in Tests

Here is how to configure your project to use databases in its tests. This assumes you have already read the [Build configuration](/docs/user/build-configuration/) documentation.

### Enabling Services

Most services are not started on boot to make more RAM available to project test suites.

If your project needs, say, MongoDB running, you can add the following to your `.travis.yml`:

    services: mongodb

or if you need several services, you can use the following:

    services:
      - riak     # will start riak
      - rabbitmq # will start rabbitmq-server
      - memcache # will start memcached

This allows us to provide nice aliases for each service and normalize common differences between names, like RabbitMQ for example. Note that this feature only
works for services we provision in our [CI environment](http://about.travis-ci.org/docs/user/ci-environment/). If you download, say, Apache Jackrabbit and
start it manually in a `before_install` step, you will still have to do it the same way.



### MySQL

MySQL on Travis CI is **started on boot**, binds to 127.0.0.1 and requires authentication. You can connect using the username "travis" and a blank password.

You do have to create the `myapp_test` database first. Run this as part of your build script:

    # .travis.yml
    before_script:
      - mysql -e 'create database myapp_test;'

#### config/database.yml Example

`config/database.yml` example for Ruby projects using ActiveRecord:

    test:
      adapter: mysql2
      database: myapp_test
      username: travis
      encoding: utf8


### PostgreSQL

PostgreSQL is **started on boot**, binds to 127.0.0.1 and requires authentication with "postgres" user and no password.

You have to create the database as part of your build process:

    # .travis.yml
    before_script:
      - psql -c 'create database myapp_test;' -U postgres

#### config/database.yml Example

`config/database.yml` example for Ruby projects using ActiveRecord:

    test:
      adapter: postgresql
      database: myapp_test
      username: postgres



### SQLite3

Probably the easiest and simplest solution for your relation database needs. If you don't specifically want to test how your code behaves with other databases,
in memory SQLite might be the best option.

#### Ruby Projects

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

However, if your project is a general library or plugin, you need to handle connecting to the database yourself in tests. For example, connecting with ActiveRecord:

    ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
                                            :database => ':memory:'

### MongoDB

MongoDB is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - mongodb

to your `.travis.yml`.

MongoDB binds to 127.0.0.1 and requires no authentication or database creation up front.

However, authentication will be enabled upon adding an admin user as mongod is started with the `--auth` parameter.

Note: Admin users are users created on the admin database.

In cases you need to create users for your database, you can do it using a `before_script` in your `.travis.yml` file::

    # .travis.yml
    before_script:
      - mongo mydb_test --eval 'db.addUser("travis", "test");'

#### JVM-based projects

For JVM-based projects that use the official MongoDB Java driver, you'll have to use `127.0.0.1` instead of `localhost` to connect to
work around [this known MongoDB Java driver issue](https://jira.mongodb.org/browse/JAVA-249) that affects Linux. Note that this issue has been
fixed in version 2.8.0 of the Java client for MongoDB, so it only affects projects using versions older than that.

### CouchDB

CouchDB is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - couchdb

to your `.travis.yml`.

CouchDB binds to 127.0.0.1, uses stock configuration and requires no authentication (it runs in admin party).

You have to create the database as part of your build process:

    # .travis.yml
    before_script:
      - curl -X PUT localhost:5984/myapp_test


### RabbitMQ

RabbitMQ is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - rabbitmq

to your `.travis.yml`.

RabbitMQ uses stock configuration, so default vhost (`/`), username (`guest`) and password (`guest`) can be relied on.
You can set up more vhosts and roles via a `before_script` if needed (for example, to test authentication).


### Riak

Riak is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - riak

to your `.travis.yml`.

Riak uses stock configuration with one exception: it is configured to use [LevelDB storage backend](http://wiki.basho.com/LevelDB.html).
Riak Search is enabled.

### Memcached

Memcached is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - memcached

to your `.travis.yml`.

Memcached uses stock configuration and binds to localhost.

### Redis

Redis is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - redis-server

to your `.travis.yml`.

Redis uses stock configuration and is available on localhost.


### Cassandra

Cassandra is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - cassandra

to your `.travis.yml`.

Cassandra is provided via [Datastax Community Edition](http://www.datastax.com/products/community) and uses stock configuration (available on 127.0.0.1).

### Neo4J

Neo4J Server (Community Edition) is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - neo4j

to your `.travis.yml`.

Neo4J Server uses default configuration (localhost, port 7474).

### ElasticSearch

ElasticSearch is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - elasticsearch

to your `.travis.yml`.

ElasticSearch is provided via official Debian packages and uses stock configuration (available on 127.0.0.1).

### Kestrel

Kestrel is **not started on boot**. To make Travis CI start the service for you, add

    services:
      - kestrel

to your `.travis.yml`.




### Multiple database systems

If your project's tests need to run multiple times using different databases, this can be configured on Travis CI using a technique
with env variables. The technique is just a convention and requires a `before_script` or `before_install` line to work.

#### Using ENV variables and before_script steps

Now you use the "DB" environment variable to specify the name of the database configuration you want to use. Locally, you would run this as:

    $ DB=postgres [commands to run your tests]

On Travis CI you want to create a matrix of three builds each having the `DB` variable exported with a different value, and for that you can use the "env" option:

    # .travis.yml
    env:
      - DB=sqlite
      - DB=mysql
      - DB=postgres

Then you can use those values in a `before_install` (or `before_script`) step or more to set up each database. For example:

    before_script:
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'DROP DATABASE IF EXISTS doctrine_tests_tmp;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'pgsql' ]; then psql -c 'create database doctrine_tests_tmp;' -U postgres; fi"
      - sh -c "if [ '$DB' = 'mysql' ]; then mysql -e 'create database IF NOT EXISTS doctrine_tests_tmp;create database IF NOT EXISTS doctrine_tests;'; fi"

When doing this, please read and understand everything about the build matrix described in [Build configuration](/docs/user/build-configuration/).

Note: **Travis CI does not have any special support for these variables**, it just creates three builds with different exported values. It is up to your
test suite or `before_install`/`before_script` steps to make use of them.

For a real example, see [doctrine/doctrine2 .travis.yml](https://github.com/doctrine/doctrine2/blob/master/.travis.yml).

#### A Ruby-specific Approach

Another approach that is Ruby-specific is put all database configurations in one YAML file, like ActiveRecord does:

    # test/database.yml
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


### Conclusion

[Travis CI Environment](/docs/user/ci-environment/) provides several popular open source data stores that hosted projects can use. In the majority of cases, said data stores use stock configuration. When it is not the case, the purpose of customizing the configuration is usually to minimize the amount of work developers have to do to use them. Often this means relaxing security settings, which is OK for continuous integration environments.
