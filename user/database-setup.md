---
title: Setting up Databases and Services
layout: en

redirect_from:
  - /user/using-postgresql/
---

This guide covers setting up the most popular databases and other services in the Travis CI environment.

You can check databases and services availability in the build environment you are using [here](https://docs.travis-ci.com/user/reference/overview/).

All services use default settings, with the exception of some added users and relaxed security settings.

## Starting Services

Travis CI environments do not start services by default, to make more RAM available
to build scripts. Start services by adding them to the `services:` section of your
`.travis.yml`:

```yaml
services: mongodb
```
{: data-file=".travis.yml"}

> If you install a service in the `addons:` section, such as MariaDB, you do not need to add it to the `services:` section as well.

To start several services:

```yaml
services:
  - riak
  - rabbitmq
  - memcached
```
{: data-file=".travis.yml"}

> If you download and install a service manually, you also have to start it in a `before_install` step. The `services` key only works for services we provision.

## MySQL

Start MySQL in your `.travis.yml`:

```yaml
services:
  - mysql
```
{: data-file=".travis.yml"}

MySQL binds to `127.0.0.1` and a socket defined in `~travis/.my.cnf` and
requires authentication.  You can connect using the username `travis` or `root`
and a blank password.

> Note that the `travis` user does not have the heightened privileges that the
> `root` user does.


|       | Ubuntu Precise | Ubuntu Trusty | Ubuntu Xenial |
|:------|:---------------|:--------------|:--------------|
| MySQL | 5.5.x          | 5.6.x         | 5.7.x         |

You can also [install MySQL 5.7](#mysql-57) on Ubuntu Trusty.

### Using MySQL with ActiveRecord

`config/database.yml` example for Ruby projects using ActiveRecord:

```yaml
test:
  adapter: mysql2
  database: myapp_test
  username: travis
  encoding: utf8
```
{: data-file="config/database.yml"}

You might have to create the `myapp_test` database first, for example in
the `before_install` step in `.travis.yml`:

```yaml
before_install:
  - mysql -e 'CREATE DATABASE myapp_test;'
```
{: data-file=".travis.yml"}

### Note on `test` database

In older versions of MySQL, the Ubuntu package provided the `test` database by
default.  This is no longer the case as of version 5.5.37 due to security
concerns (See [change
log](http://changelogs.ubuntu.com/changelogs/pool/main/m/mysql-5.5/mysql-5.5_5.5.47-0ubuntu0.12.04.1/changelog)).

The `test` database may be created if needed, for example in the
`before_install` step in `.travis.yml`:

```yaml
before_install:
  - mysql -e 'CREATE DATABASE IF NOT EXISTS test;'
```
{: data-file=".travis.yml"}


### MySQL 5.7

MySQL 5.7 is the default on the Xenial image.
On Trusty, you can install MySQL 5.7 by adding the following lines to your `.travis.yml`:


```yaml
addons:
  apt:
    sources:
      - mysql-5.7-trusty
    packages:
      - mysql-server
      - mysql-client
```
{: data-file=".travis.yml"}

You'll also need to reset the root password to something other than `new_password`:

```yaml
before_install:
  - sudo mysql -e "use mysql; update user set authentication_string=PASSWORD('new_password') where User='root'; update user set plugin='mysql_native_password';FLUSH PRIVILEGES;"
  - sudo mysql_upgrade -u root -pnew_password
  - sudo service mysql restart
```
{: data-file=".travis.yml"}

## PostgreSQL

Start PostgreSQL in your `.travis.yml`:

```yaml
services:
  - postgresql
```
{: data-file=".travis.yml"}

### Using PostgreSQL in your Builds

The default user for accessing the local PostgreSQL server is `postgres` with a blank password.

Create a database for your application by adding a line to your .travis.yml:

```yaml
before_script:
  - psql -c 'create database travis_ci_test;' -U postgres
```
{: data-file=".travis.yml"}

For a Rails application, you can now use the following `database.yml` configuration to access the database locally:

```yaml
test:
  adapter: postgresql
  database: travis_ci_test
```
{: data-file="database.yml"}

If your local test setup uses different credentials or settings to access the local test database, we recommend putting these settings in a `database.yml.travis` in your repository and copying that over as part of your build:

```yaml
before_script:
  - cp config/database.yml.travis config/database.yml
```
{: data-file=".travis.yml"}

### Using a different PostgreSQL Version

The Travis CI build environments use version 9.2 by default on Trusty images, but other versions
from the official [PostgreSQL APT repository](http://apt.postgresql.org) are
also available. To use a version other than the default, specify only the
**major.minor** version in your `.travis.yml`:

```yaml
addons:
  postgresql: "9.4"
```
{: data-file=".travis.yml"}

Many PostgreSQL versions have been preinstalled in our build environments, and
others may be added and activated at build time by using a combination of the
`postgresql` and `apt` addons along with a global env var override for `PGPORT`:

``` yaml
addons:
  postgresql: "10"
  apt:
    packages:
    - postgresql-10
    - postgresql-client-10
env:
  global:
  - PGPORT=5433
```
{: data-file=".travis.yml"}

### Using PostGIS

Install the version of PostGIS that matches your PostgreSQL version, and activate the PostGIS extension using:

```yaml
addons:
  postgresql: 9.6
  apt:
    packages:
    - postgresql-9.6-postgis-2.3
before_script:
  - psql -U postgres -c "create extension postgis"
```
{: data-file=".travis.yml"}

### PostgreSQL and Locales

The Travis CI build environment comes with a number of pre-installed locales, but you can also install additional ones, should you require them.

#### Installing Locales

The following example shows the lines you need to add to your `.travis.yml` to install the Spanish language pack.

> Note that you need to remove the PostgreSQL version from the `addons` section of your .travis.yml:

```yaml
before_install:
  - sudo apt-get update
  - sudo apt-get install language-pack-es
  - sudo /etc/init.d/postgresql stop
  - sudo /etc/init.d/postgresql start 9.3
```
{: data-file=".travis.yml"}

### Using `pg_config`

If your builds rely on the `pg_config` command, you need to install an additional
apt package `postgresql-server-dev-X.Y`, where `X.Y` matches the version of PostgreSQL
you are using.

For example:

```yaml
addons:
  postgresql: '9.4'
  apt:
    packages:
      - postgresql-server-dev-9.4
```
{: data-file=".travis.yml"}

See [this GitHub issue](https://github.com/travis-ci/travis-ci/issues/9011) for additional details.

## MariaDB

MariaDB is a community-developed fork of MySQL. It is available as an addon on Travis CI.

To use MariaDB, specify the "major.minor" version you want to use in your `.travis.yml`. Versions are listed on the [MariaDB web page](https://downloads.mariadb.org/).

```yaml
addons:
  mariadb: '10.0'
```
{: data-file=".travis.yml"}

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
{: data-file="config/database.yml"}

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
{: data-file=".travis.yml"}

MongoDB binds to 127.0.0.1 and requires no authentication or database creation up front. If you add an `admin` user authentication is enabled, since `mongod` is started with the `--auth` argument.

> Note: Admin users are users created in the admin database.

To create users for your database, add a `before_script` section to your `.travis.yml`:

```yaml
before_script:
  - mongo mydb_test --eval 'db.createUser({user:"travis",pwd:"test",roles:["readWrite"]});'
```
{: data-file=".travis.yml"}

### MongoDB does not immediately accept connections

A few users have reported that MongoDB does not accept connections when from the build script.

The issue is intermittent, and the only reliable way to avoid it is to
inject an artificial wait before making the first connection:

Add the following `before_script` to your `.travis.yml` to wait before connecting to MongoDB:

```yaml
before_script:
  - sleep 15
  - mongo mydb_test --eval 'db.createUser({user:"travis",pwd:"test",roles:["readWrite"]});'
```
{: data-file=".travis.yml"}

## CouchDB

Start CouchDB in your `.travis.yml`:

```yaml
services:
  - couchdb
```
{: data-file=".travis.yml"}

CouchDB binds to 127.0.0.1, uses default configuration and does not require authentication (in CouchDB terms it runs in admin party).

Before using CouchDB you need to create the database as part of your build process:

```yaml
before_script:
  - curl -X PUT localhost:5984/myapp_test
```
{: data-file=".travis.yml"}

## RabbitMQ

RabbitMQ requires `setuid` flags, so you can only run RabbitMQ as a service on macOS or Ubuntu Trusty infrastructure.

Start RabbitMQ in your `.travis.yml`:

```yaml
services:
  - rabbitmq
```
{: data-file=".travis.yml"}

RabbitMQ uses the default configuration:

- vhost: `/`
- username: `guest`
- password: `guest`

You can set up more vhosts and roles in the `before_script` section of your `.travis.yml`.

RabbitMQ [can be launched](https://docs.travis-ci.com/user/reference/xenial/#third-party-apt-repositories-removed) on Ubuntu Xenial using the APT addon in `.travis.yml`:
```yaml
addons:
  apt:
    packages:
    - rabbitmq-server 
```

## Riak

> Riak is only available in the [Ubuntu Trusty environment](/user/reference/trusty/).

Start Riak in your `.travis.yml`:

```yaml
services:
  - riak
```
{: data-file=".travis.yml"}

Riak uses the default configuration with Bitcask as storage backend.

Riak Search is deactivated by default.

## Memcached

Start Memcached service in your `.travis.yml`:

```yaml
services:
  - memcached
```
{: data-file=".travis.yml"}

Memcached uses the default configuration and binds to localhost.

## Redis

Start Redis in your `.travis.yml`:

```yaml
services:
  - redis-server
```
{: data-file=".travis.yml"}

Redis uses the default configuration and is available on localhost.

## Cassandra

Start Cassandra in your `.travis.yml`:

```yaml
services:
  - cassandra
```
{: data-file=".travis.yml"}

Cassandra is downloaded from the [Apache apt repository](http://www.apache.org/dist/cassandra/debian) and uses the default configuration. It is available on 127.0.0.1.

### Installing older versions of Cassandra

Use the following example to install a specific older version of Cassandra in your `.travis.yml`:

```yaml
before_install:
  - sudo rm -rf /var/lib/cassandra/*
  - wget http://www.us.apache.org/dist/cassandra/1.2.18/apache-cassandra-1.2.18-bin.tar.gz && tar -xvzf apache-cassandra-1.2.18-bin.tar.gz && sudo sh apache-cassandra-1.2.18/bin/cassandra
```
{: data-file=".travis.yml"}


## Neo4j

Start Neo4j in your `.travis.yml`:

```yaml
services:
  - neo4j
```
{: data-file=".travis.yml"}

Neo4j Server uses default configuration and binds to localhost on port 7474.

> Neo4j does not start on container-based infrastructure. See <a href="https://github.com/travis-ci/travis-ci/issues/3243">https&#x3A;//github.com/travis-ci/travis-ci/issues/3243</a>

## ElasticSearch

Start ElasticSearch in your `.travis.yml`:

```yaml
services:
  - elasticsearch
```
{: data-file=".travis.yml"}

ElasticSearch takes few seconds to start, to make sure it is available when the build script runs add a small delay to your build script:

```yaml
before_script:
  - sleep 10
```
{: data-file=".travis.yml"}

ElasticSearch uses the default configuration and is available on 127.0.0.1.

### Installing specific versions of ElasticSearch

You can overwrite the installed ElasticSearch with the version you need (e.g., 2.3.0) with the following:

```yaml
before_install:
  - curl -O https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.0/elasticsearch-2.3.0.deb && sudo dpkg -i --force-confnew elasticsearch-2.3.0.deb && sudo service elasticsearch restart
```
{: data-file=".travis.yml"}

We advise verifying the validity of the download URL [on ElasticSearch's website](https://www.elastic.co/downloads/elasticsearch).

> `sudo` is not available on [Container-based infrastructure](/user/reference/overview/#virtualization-environments).

### Installing ElasticSearch on trusty container-based infrastructure

ElasticSearch is  not installed by default on the [trusty container-based infrastructure](/user/reference/trusty/)
but you can install it by adding the following steps to your `.travis.yml`.

```yaml
env:
  - ES_VERSION=5.1.1 ES_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
install:
  - wget ${ES_DOWNLOAD_URL}
  - tar -xzf elasticsearch-${ES_VERSION}.tar.gz
  - ./elasticsearch-${ES_VERSION}/bin/elasticsearch &
script:
  - wget -q --waitretry=1 --retry-connrefused -T 10 -O - http://127.0.0.1:9200
```
{: data-file=".travis.yml"}

### Truncated Output in the Build Log

When ElasticSearch starts, you may see a truncated error message such as:

```
$ sudo service elasticsearch start
 * Starting ElasticSearch Server       ission denied on key 'vm.max_map_count'
```

This is due to a [recent change in ElasticSearch](https://github.com/elasticsearch/elasticsearch/issues/4397),
as reported [here](https://github.com/elasticsearch/elasticsearch/issues/4978).
The message is harmless, and the service is functional.

## RethinkDB

To use RethinkDB with Travis CI, list it as an addon in the `.travis.yml` configuration file, specifying the version number as a string.

```yaml
addons:
  rethinkdb: '2.3.4'
```
{: data-file=".travis.yml"}

If you specify a partial version number, the addon will install and run the latest version that matches. For example, `'2.3'` will match the latest RethinkDB version in the `2.3.x` line.

Two environment variables are exported:

- `TRAVIS_RETHINKDB_VERSION` is the version specified in the configuration (e.g., `'2.3.4'`, or `'2.3'`).
- `TRAVIS_RETHINKDB_PACKAGE_VERSION` is the full version of the package that was installed (e.g., `'2.3.4+1~0precise'`).

When enabled, RethinkDB will start on `localhost` at the default port (`28015`).

## Multiple Database Builds

If you need to run multiple builds using different databases, you can configure environment variables
and a `before_script` or `before_install` line to create a build matrix.

### Using environment variables and a before_script step

Use the `DB` environment variable to specify the name of the database configuration. Locally you would run:

```bash
DB=postgres [commands to run your tests]
```

On Travis CI you want to create a [build matrix](/user/customizing-the-build/#build-matrix) of three builds each having the `DB` variable exported with a different value, and for that you can use the `env` option in `.travis.yml`:

```yaml
env:
  - DB=sqlite
  - DB=mysql
  - DB=postgres
```
{: data-file=".travis.yml"}

Then you can use those values in a `before_install` (or `before_script`) step to
set up each database. For example:

```yaml
before_script:
  - sh -c "if [ '$DB' = 'postgres' ]; then psql -c 'DROP DATABASE IF EXISTS tests;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'postgres' ]; then psql -c 'DROP DATABASE IF EXISTS tests_tmp;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'postgres' ]; then psql -c 'CREATE DATABASE tests;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'postgres' ]; then psql -c 'CREATE DATABASE tests_tmp;' -U postgres; fi"
  - sh -c "if [ '$DB' = 'mysql' ]; then mysql -e 'CREATE DATABASE IF NOT EXISTS tests_tmp; CREATE DATABASE IF NOT EXISTS tests;'; fi"
```
{: data-file=".travis.yml"}

> Travis CI does not have any special support for these variables, it just
> creates three builds with different exported values. It is up to your build
> script and `before_install` or `before_script` steps to make use of them.

For a real example, see [doctrine/doctrine2
.travis.yml](https://github.com/doctrine/doctrine2/blob/master/.travis.yml).

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
{: data-file="test/database.yml"}

Then, in your test suite, read that data into a configurations hash:

```ruby
configs = YAML.load_file('test/database.yml')
ActiveRecord::Base.configurations = configs

db_name = ENV['DB'] || 'sqlite'
ActiveRecord::Base.establish_connection(db_name)
ActiveRecord::Base.default_timezone = :utc
```
