---
title: Using PostgreSQL on Travis CI
layout: en
permalink: /user/using-postgresql/
---
<div id="toc">
</div>

One of the databases available on Travis CI is [PostgreSQL](http://postgresql.org).

## Selecting a PostgreSQL Version

By default, the build environment will have version 9.1 running already.

You can easily choose a different version by way of your .travis.yml.

We have PostgreSQL 9.1, 9.2, 9.3 and 9.4 installed, usually with their latest patch releases. We install them from the official [PostgreSQL APT repository](http://apt.postgresql.org).

Currently, you'll find the **following versions (or later) installed: 9.1.15, 9.2.10, 9.3.6 and 9.4.1**, respectively.

To select a different version than the default, use the following setting in your .travis.yml:

    addons:
      postgresql: "9.3"

This selects PostgreSQL 9.3 as the version your build expects to be running.

**Available selections are "9.1", "9.2", "9.3" and "9.4"**. Make sure to only specify the major and the minor version, without the patch release.

## Using PostgreSQL in your Builds

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

## Using PostGIS

All available versions of PostgreSQL come with PostGIS 2.1 packages preinstalled.

Your build needs to enable the extension, which isn't done by default. Here's an example for your .travis.yml:

    before_script:
      - psql -U postgres -c "create extension postgis"

## PostgreSQL and Locales

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
