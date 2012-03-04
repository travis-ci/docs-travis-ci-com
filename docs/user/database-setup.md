---
title: Databases on Travis workers
layout: en
permalink: database-setup/
---

### What This Guide Covers

This guide covers data stores offered in the Travis [CI environment](/docs/user/ci-environment/) and what users & settings projects hosted on travis-ci.org can rely on. Most of the content is applicable to any technology but there are subtle aspects in the behavior of some database drivers that this guide will try to cover. We recommend you start with the [Getting Started](/docs/user/getting-started/) and [Build Configuration](/docs/user/build-configuration/) guides before reading this one.

## Data Stores in the Travis CI Environment

[Travis CI Environment](/docs/user/ci-environment/) has multiple popular data stores preinstalled. Some of the services available are:

* MySQL
* PostgreSQL
* SQLite3
* MongoDB
* CouchDB
* Redis
* Riak
* Memcached

All aforementioned data stores use mostly stock default settings, however, when it makes sense, new users are added and security settings are relaxed (because for continuous integration ease of use is more important): one example of such adaptation is PostgreSQL that has strict default access settings.

## Configure Your Projects to Use Databases in Tests

Here is how to configure your project to use databases in its tests. This assumes you have already visited [Build configuration](/docs/user/build-configuration/) documentation.

### MySQL

MySQL on Travis binds to 0.0.0.0 and requires authentication. You can connect using "root" username and blank password:

    mysql:
      adapter: mysql2
      database: myapp_test
      username: root
      encoding: utf8

If specify a blank username, keep in mind that for some clients, this is the same as "root" but for some it means "anonymous user". When in doubt,
try switching to `root` username.

You do have to create the `myapp_test` database first. Run this as part of your build script:

    # .travis.yml
    before_script:
      - "mysql -e 'create database myapp_test;'"

### PostgreSQL

PostgreSQL binds to 127.0.0.1 and requires authentication with "postgres" user and no password:

    postgres:
      adapter: postgresql
      database: myapp_test
      username: postgres

You have to create the database as part of your build process:

    # .travis.yml
    before_script:
      - "psql -c 'create database myapp_test;' -U postgres"

### SQLite3

Probably the easiest and simplest solution for your relation database needs. If you don't specifically want to test how your code behaves with other databases, in memory SQLite might be the best option.

#### Ruby Projects

For ruby projects, ensure that you have the sqlite3 ruby bindings in your bundle:

    # Gemfile
    # for CRuby, Rubinius, including Windows and RubyInstaller
    gem "sqlite3", :platform => [:ruby, :mswin, :mingw]

    # for JRuby
    gem "jdbc-sqlite3", :platform => :jruby


If your project is a Rails app, all you need to set up is:

    # config/database.yml in Rails
    test:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500

However, if your project is a general library or plugin, you need to handle connecting to the database yourself in tests. For example, connecting with ActiveRecord:

    ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
                                            :database => ':memory:'

### MongoDB

MongoDB binds to 127.0.0.1, uses stock configuration and requires no authentication or database creation up front.

In cases you need to create users for your database, you can do it using a `before_script` in your `.travis.yml` file::

    # .travis.yml
    before_script:
      - mongo mydb_test --eval 'db.addUser("travis", "test");'

#### JVM-based projects

For JVM-based projects that use the official MongoDB Java driver, you'll have to use `127.0.0.1` instead of `localhost` to connect to work around [this known MongoDB Java driver issue](https://jira.mongodb.org/browse/JAVA-249) that affects Linux.

### CouchDB

CouchDB binds to 127.0.0.1, uses stock configuration and requires no authentication (it runs in admin party).

You have to create the database as part of your build process:

    # .travis.yml
    before_script:
      - curl -X PUT localhost:5984/myapp_test

### Riak

Riak uses stock configuration with one exception: it is configured to use [LevelDB storage backend](http://wiki.basho.com/LevelDB.html).

### Redis

Redis uses stock configuration and is available on localhost.

### Neo4J

Neo4J Server Community Edition is available but not started by default. You can start it with a one line `before_script`:

    which neo4j && neo4j start && sleep 5 # give Neo4J some time to start & initialize

### Multiple database systems

If your project's tests need to run multiple times using different databases, this can be configured on Travis CI in several ways.

#### Using ENV variables

Now you use the "DB" environment variable to specify the name of the database configuration you want to use. Locally, you would run this as:

    $ DB=postgres [commands to run your tests]

On Travis CI you want to test against all 3 databases all the time, and for that you can use the "env" option:

    # .travis.yml
    env:
      - DB=sqlite
      - DB=mysql
      - DB=postgres

When doing this, please read and understand everything about the build matrix described in [Build configuration](/docs/user/build-configuration/).

#### Ruby

One approach you might take is put all database configurations in one YAML file, like ActiveRecord does:

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
