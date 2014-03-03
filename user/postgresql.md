---
title: Using PostgreSQl on Travis CI
layout: en
permalink: using-postgresql/
---
<div id="toc">
</div>

One of the databases available on Travis CI is [PostgreSQL](http://postgresql.org).

### Choosing a PostgreSQL Version

By default, the build environment will have version 9.1 running already.

You can easily choose a different version by way of your .travis.yml.

We have PostgreSQL 9.1, 9.2 and 9.3 installed, usually with their latest patch releases. We install them from the official [PostgreSQL APT repository](http://apt.postgresql.org).

Currently, you'll find the **following versions installed: 9.1.11, 9.2.6 and 9.3.2**, respectively.

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

