---
title: Databases on Travis workers
kind: article
layout: article
---

Every Travis CI worker has preinstalled software that's commonly used by the open source developer community. Some of the services available are:

* databases – MySQL, PostgreSQL, SQLite3, MongoDB
* key-value stores – Redis, Riak, memcached
* messaging systems – RabbitMQ
* node.js, ImageMagick

You can find the full list of installed software, as well as Ruby engines and versions, in the [worker
configuration file][config]. That file specifies which [recipes from the cookbook][cookbook] are used while building the worker instance.

Some of these, e.g. node.js and memcached, are either available in the PATH or running on a default port, so no special information about them is required. Others, namely databases, may require authentication.

Here is how to configure your project to use databases in its tests. This assumes you have already visited [Build configuration][] documentation.

### SQLite3

Probably the easiest and simplest solution for your relation database needs. If you don't specifically want to test how your code behaves with other databases, SQLite in memory might be the best and fastest option.

For ruby projects, ensure that you have the sqlite3 ruby bindings in your bundle:

    # Gemfile
    gem 'sqlite3'

If your project is a Rails app, all you need to set up is:

    # config/database.yml in Rails
    test:
      adapter: sqlite3
      database: ":memory:"
      timeout: 500

However, if your project is a general library or plugin, you need to handle connecting to the database yourself in tests. For example, connecting with ActiveRecord:

    ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
                                            :database => ':memory:'

### MySQL

MySQL on Travis requires no authentication. Specify an empty username and no password:

    mysql:
      adapter: mysql2
      database: myapp_test
      username: 
      encoding: utf8

You do have to create the `myapp_test` database first. Run this as part of your build script:

    # .travis.yml
    before_script:
      - "mysql -e 'create database myapp_test;' >/dev/null"

### PostgreSQL

PostgreSQL requires authentication with "postgres" user and no password:

    postgres:
      adapter: postgresql
      database: myapp_test
      username: postgres

You have to create the database as part of your build process:

    # .travis.yml
    before_script:
      - "psql -c 'create database myapp_test;' -U postgres >/dev/null"

### MongoDB

MongoDB requires no authentication or database creation up front:

    require 'mongo'
    Mongo::Connection.new('localhost').db('myapp')

In cases you need to create users for your database, you can do something like this:

    # .travis.yml
    before_script:
      - mongo myapp --eval 'db.addUser("travis", "test");'

    # then, in ruby:
    uri = "mongodb://travis:test@localhost:27017/myapp"
    Mongo::Connection.from_uri(uri)

### Multiple database systems

If your project's tests need to run multiple times using different databases, this can be configured on Travis CI in several ways. One approach you might take is put all database configurations in one yaml file:

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

Now you use the "DB" environment variable to specify the name of the database configuration you want to use. Locally, you would run this as:

    $ DB=postgres bundle exec rake

On Travis CI you want to test against all 3 databases all the time, and for that you can use the "env" option:

    # .travis.yml
    env:
      - DB=sqlite
      - DB=mysql
      - DB=postgres

When doing this, please read and understand everything about the build matrix described in [Build configuration][].

Lastly, make sure that you're creating mysql and postgres databases in your build script according to the notes earlier in this document.


[cookbook]: https://github.com/travis-ci/travis-cookbooks
[config]: https://github.com/travis-ci/travis-worker/blob/master/config/worker.production.yml
[build configuration]: /docs/user/build-configuration/
