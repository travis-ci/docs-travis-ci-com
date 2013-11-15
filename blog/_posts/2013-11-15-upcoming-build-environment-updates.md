---
title: Upcoming Build Environment Updates
author: Josh Kalderimis
twitter: j2h
created_at: Fri 15 Nov 2013 12:00:00 CEST
layout: post
permalink: blog/2013-11-08-ci-environment-updates
---
We're preparing a rollout of fresh updates and new features for our build
environment, and wanted to keep you in the loop on what's coming, what's
changing, and what's possibly breaking.

We'll be rolling out these changes to **<https://travis-ci.org> on Wednesday,
November 20**. The changes will be rolled out to **<https://travis-ci.com> the
following week, on November 25**.

If you're having any problems after the upgrade, please file an issue or [contact
support](mailto:support@travis-ci.com) directly.

Here are all the details on what's new.

### Language Updates:

**C/C++**

- Clang has been updated to 3.3.

**Go**

- Go 1.1.2 now preinstalled and set as the default.

**Java**

- All JDKs have been updated to their latest releases.
- Support for Java 8 via OpenJDK 8 EA, see below for more details.
- Gradle has been updated to v1.8
- Leinigen has been updated to v2.3.1
- Maven has ben updated to v3.1.1

**Erlang / OTP**

- Erlang releases R16B02, R16B01 are now available.

**Node.js**

- Node.js releases have been updated to 0.8.25, 0.8.26, 0.10.21, and 0.11.8.
- For backwards compatibility, 0.8.23, 0.8.25, and 0.10.18 are still available.

**PHP**:

- PHP releases have been updated to 5.3.27, 5.4.21, and 5.5.5 respectively
- New PHP modules are available by default: kerberos, imap, imap-ssl

**Python**:

- Python 2.5 has been removed due to very low overall usage and breaking changes
  in pip and virtualenv.


**Ruby**

- Ruby 2.1-pre is available.
- Ruby and JRuby head are now continuously up-to-date with latest changes.

**Scala**:

- Scala 2.10.3 is set as the new default.
- sbt 0.13.0 is set as new default, but [other releases can be specified in your build configuration](/docs/user/languages/scala/#Projects-using-sbt)
- Build download time improved for Scala projects: Scala and sbt boot libraries
  are now preinstalled for following Scala versions: 2.11.0-M5, 2.10.3, 2.10.2,
  2.10.1, 2.10.0, 2.9.3, 2.9.2
- Scala SBT and JVM default tunings will now only be effective when `language:
  scala` is selected (see https://github.com/travis-ci/travis-build/pull/154).
  It means that having an other language in .travis.yml will lead to use default
  settings from sbt-extras (which should be good enough).
- Maven is installed from Apache packages, which solves [an annoying
  bug](http://stackoverflow.com/questions/19158720/why-does-travis-ci-think-my-code-is-java-1-3-and-how-to-fix-it/19844340#19844340)
  where builds wrongly assume Java 1.3 to be the source version when compiling
  code.


### Updates to the pre-installed database services

- Support for **PostgreSQL 9.1, 9.2, and 9.3**. You can select the version that's
  running in your build environment in your [.travis.yml](/docs/user/addons/#PostgreSQL).
- All PostgreSQL versions are pre-configured with PostGIS 2.1 and [other modules](http://www.postgresql.org/docs/devel/static/contrib.html).
- **Breaking change**: **memcached** and **redis-server** are not auto-started anymore, make sure to add them to the services section in your .travis.yml.
- **Cassandra v2.0.2**
- **ElasticSearch: v0.90.5**
- **MongoDB: v2.4.8**
- **Neo4J: v1.9.4**
- **PhantomJs: v1.9.2**
- **Redis: v2.6.16**
- **Riak: v1.4.2-1**


### Other changes to the build environment

- The data partition shared by PostgreSQL and MySQL has been increased to 768 MB
  available disk space.


### New Features

- Java 8 is now available thanks to the early access releases of OpenJDK 8.


### Known Issues

- At the moment, Gradle does not work with Oracle JDK 8 **on Travis CI virtual machines**. We're investigating... (TODO-JOSHK: tell me if you want more details about that point)
- Travis CI is still equipped by default with `gcc-4.6`, but we are aware that C++11 projects need `gcc-4.8` and we are working on an update...
