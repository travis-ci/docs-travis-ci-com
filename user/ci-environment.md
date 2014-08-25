---
title: The Build Environment
layout: en
permalink: ci-environment/
---

### What This Guide Covers

This guide explain what packages, tools and settings are available in the Travis
CI environment (often referred to as "CI environment").

<div id="toc"></div>

## Overview

Travis CI runs builds in isolated virtual machines that offer a vanilla build
environment for every build.

This has the advantage that no state persists between builds, offering a clean
slate and making sure that your tests can run in an environment built from
scratch.

To set up the system for your build, you can use the `sudo` command to install
packages, to change configuration, create users, and so on.

Builds have access to a variety of services for data storage and messaging, and
can install anything that's required for them to run.

## The Build Machine

On the Linux platform, builds have 3 GB of memory available. Disk space is limited,
but there's no fixed limit per build. Builds have up to two cores available (bursted).

## CI environment OS

Travis CI virtual machines are based on Ubuntu 12.04 LTS Server Edition 64 bit.

## Networking

The containers running the tests have IPv6 enabled. They don't have any external IPv4 address but are fully able to communicate with any external IPv4 service.

The IPv6 stack can have some impact on Java services in particular, where one might need to set the flag `java.net.preferIPv4Stack` to force the JVM to resort to the IPv4 stack should services show issues of not booting up or not being reachable via the network: `-Djava.net.preferIPv4Stack=true`.

Most services work normally when talking to the local host by either `localhost` or `127.0.0.1`.

## Environment common to all VM images

### Git, etc

All VM images have the following pre-installed

 * A (very) recent Git release from the [Peter van der Does' Git PPA](https://launchpad.net/~pdoes/+archive/ppa)
 * Mercurial (official Ubuntu packages)
 * Subversion (official Ubuntu packages)


### Compilers & Build toolchain

GCC 4.6.x, Clang 3.2.x, make, autotools, cmake, scons.


### Networking tools

curl, wget, OpenSSL, rsync


### Go

Go compiler/build tools 1.3.1.


### Runtimes

Every worker has at least one version of

* Ruby
* OpenJDK
* Python
* Node.js
* Go compiler/build tool

to accommodate projects that may need one of those runtimes during the build.

Language-specific workers have multiple runtimes for their respective language (for example, Ruby workers have about 10 Ruby versions/implementations).

### Data Stores

* MySQL 5.5.x
* PostgreSQL 9.1.x, 9.2.x and 9.3.x
* SQLite 3.7.x
* MongoDB 2.4.x
* Redis 2.8.x
* Riak 1.4.x
* Apache Cassandra 2.0.x
* Neo4J Community Edition 1.7.x
* ElasticSearch 1.3.x
* CouchDB 1.6.x

### Messaging Technology

* [RabbitMQ](http://rabbitmq.com) 3.x
* [ZeroMQ](http://zeromq.org/) 2.1.x

### Headless Browser Testing Tools

* [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
* [PhantomJS](http://phantomjs.org/) 1.9.7

### Environment variables

* `CI=true`
* `TRAVIS=true`
* `CONTINUOUS_INTEGRATION=true`
* `DEBIAN_FRONTEND=noninteractive`
* `HAS_JOSH_K_SEAL_OF_APPROVAL=true`
* `USER=travis` (**do not depend on this value**)
* `HOME=/home/travis` (**do not depend on this value**)
* `LANG=en_US.UTF-8`
* `LC_ALL=en_US.UTF-8`
* `RAILS_ENV=test`
* `RACK_ENV=test`
* `MERB_ENV=test`
* `JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"`

Additionally, Travis CI sets environment variables you can use in your build, e.g.
to tag the build, or to run post-build deployments.

* `TRAVIS_BRANCH`:For builds not triggered by a pull request this is the
  name of the branch currently being built; whereas for builds triggered
  by a pull request this is the name of the branch targeted by the pull
  request (in many cases this will be `master`).
* `TRAVIS_BUILD_DIR`: The absolute path to the directory where the repository
  being built has been copied on the worker.
* `TRAVIS_BUILD_ID`: The id of the current build that Travis CI uses internally.
* `TRAVIS_BUILD_NUMBER`: The number of the current build (for example, "4").
* `TRAVIS_COMMIT`: The commit that the current build is testing.
* `TRAVIS_COMMIT_RANGE`: The range of commits that were included in the push
  or pull request.
* `TRAVIS_JOB_ID`: The id of the current job that Travis CI uses internally.
* `TRAVIS_JOB_NUMBER`: The number of the current job (for example, "4.1").
* `TRAVIS_PULL_REQUEST`: The pull request number if the current job is a pull
  request, "false" if it's not a pull request.
* `TRAVIS_SECURE_ENV_VARS`: Whether or not secure environment vars are being
  used. This value is either "true" or "false".
* `TRAVIS_REPO_SLUG`: The slug (in form: `owner_name/repo_name`) of the
  repository currently being built. (for example, "travis-ci/travis-build").
* `TRAVIS_OS_NAME`: On multi-OS builds, this value indicates the platform the job is running on.
  Values are `linux` and `osx` currently, to be extended in the future.
* `TRAVIS_TAG`: If the current build for a tag, this includes the tag's name.

Language-specific builds expose additional environment variables representing
the current version being used to run the build. Whether or not they're set
depends on the language you're using.

* `TRAVIS_GO_VERSION`
* `TRAVIS_JDK_VERSION`
* `TRAVIS_NODE_VERSION`
* `TRAVIS_OTP_RELEASE`
* `TRAVIS_PERL_VERSION`
* `TRAVIS_PHP_VERSION`
* `TRAVIS_PYTHON_VERSION`
* `TRAVIS_RUBY_VERSION`
* `TRAVIS_SCALA_VERSION`

### Libraries

* OpenSSL
* ImageMagick


### apt configuration

apt is configured to not require confirmation (assume -y switch by default) using both `DEBIAN_FRONTEND` env variable and apt configuration file. This means `apt-get install -qq` can be used without the -y flag.

### Group membership

The user executing the build (`$USER`) belongs to one primary group derived from that user.
If your project needs extra memberships to run the build, follow these steps:

1. Set up the environment. This can be done any time during the build lifecycle prior to the build script execution.
    1. Set up and export environment variables.
    1. Add `$USER` to desired secondary groups: `sudo usermod -a -G SECONDARY_GROUP_1,SECONDARY_GROUP_2 $USER`
    You may modify the user's primary group with `-g`.
1. Your `script` would look something like:

```bash
script: sudo -E su $USER -c 'COMMAND1; COMMAND2; COMMAND3'
```
This will pass the environment variables down to a `bash` process which runs as `$USER`,
while retaining the environment variables defined
and belonging to secondary groups given above in `usermod`.

## Go VM images

The following additional Go runtimes are installed:  1.0.3, 1.1.2, 1.2.2.

The following aliases are available, and are recommended
in order to minimize frictions when images are updated:

* `go1`, `go1.0` → 1.0.3
* `go1.1` → 1.1.2
* `go1.2` → 1.2.2

## JVM (Clojure, Groovy, Java, Scala) VM images

### JDK

* Oracle JDK 7u6 (oraclejdk7)
* OpenJDK 7 (openjdk7)
* OpenJDK 6 (openjdk6)
* Oracle JDK 8 (oraclejdk8)

OracleJDK 7 is the default because we have a much more recent patch level compared to OpenJDK 7 from the Ubuntu repositories. Sun/Oracle JDK 6 is not provided because
it reached End of Life in fall 2012.

### Maven version

Stock Apache Maven 3. Maven is configured to use Central and oss.sonatype.org mirrors at http://maven.travis-ci.org

### Leiningen versions

travis-ci.org has both standalone ("uberjar") Leiningen 1.7.x at `/usr/local/bin/lein1` and Leiningen 2.4.x at `/usr/local/bin/lein2`.
The default is 2.4.x; `/usr/local/bin/lein` is a symbolic link to `/usr/local/bin/lein2`.

### SBT versions

travis-ci.org potentially provides any version of Simple Build Tool (sbt or SBT) thanks to very powerful [sbt-extras](https://github.com/paulp/sbt-extras) alternative. In order to reduce build time, popular versions of sbt are already pre-installed (like for instance 0.13.5 or 0.12.4), but `sbt` command is able to dynamically detect and install the sbt version required by your Scala projects.

### Gradle version

Gradle 2.0.

## Erlang VM images

### Erlang/OTP releases

* 17.1
* 17.0
* R16B
* R16B01
* R16B02
* R16B03
* R16B03-1
* R15B03
* R15B02
* R15B01
* R15B
* R14B04
* R14B03
* R14B02

Erlang/OTP releases are built using [kerl](https://github.com/spawngrid/kerl).


### Rebar

travis-ci.org provides a recent version of Rebar. If a repository has rebar binary bundled at `./rebar` (in the repo root), it will
be used instead of the preprovisioned version.


## Node.js VM images

### Node.js versions

* 0.10.x (latest stable release)
* 0.8.x
* 0.6.x
* 0.11.x (latest development release, may be unstable)

Node runtimes are built using [nvm](https://github.com/creationix/nvm).

### SCons

Scons 2.x.


## Haskell VM images

### Haskell Platform Version

[Haskell Platform](http://hackage.haskell.org/platform/contents.html) 2012.02 and GHC 7.0, 7.4, 7.6 and 7.8.


## Perl VM images

### Perl versions

* 5.20
* 5.20-shrplib
* 5.18
* 5.18-shrplib
* 5.16
* 5.14
* 5.12
* 5.10
* 5.8

installed via [Perlbrew](http://perlbrew.pl/).
Those runtimes that end with the `-shrplib` suffix have been compiled with
`-Duseshrplib` flag.

### cpanm

cpanm (App::cpanminus) version 1.5007

## PHP VM images

### PHP versions

* 5.6
* 5.5
* 5.4
* 5.3
* [hhvm](https://github.com/facebook/hhvm)

PHP runtimes are built using [php-build](https://github.com/CHH/php-build).

### XDebug

Is supported.

### Extensions

    [PHP Modules]
    bcmath
    bz2
    Core
    ctype
    curl
    date
    dom
    ereg
    exif
    fileinfo
    filter
    ftp
    gd
    gettext
    hash
    iconv
    intl
    json
    libxml
    mbstring
    mcrypt
    mysql
    mysqli
    mysqlnd
    openssl
    pcntl
    pcre
    PDO
    pdo_mysql
    pdo_pgsql
    pdo_sqlite
    pgsql
    Phar
    posix
    readline
    Reflection
    session
    shmop
    SimpleXML
    soap
    sockets
    SPL
    sqlite3
    standard
    sysvsem
    sysvshm
    tidy
    tokenizer
    xdebug
    xml
    xmlreader
    xmlrpc
    xmlwriter
    xsl
    zip
    zlib

    [Zend Modules]
    Xdebug

## Python VM images

### Python versions

* 2.6
* 2.7
* 3.2
* 3.3
* 3.4
* pypy
* pypy3

Every Python has a separate virtualenv that comes with `pip` and `distribute` and is activated before running the build.

Python 2.4 and Jython *are not supported* and there are no plans to support them in the future.

### Preinstalled pip packages

* nose
* py.test
* mock
* wheel

On all versions except pypy and pypy3 have `numpy` as well.

## Ruby (aka common) VM images

### Ruby versions/implementations

* 2.1.2
* 2.1.1
* 2.0.0
* 1.9.3 (default)
* 1.9.2
* jruby-18mode (1.7.13 in Ruby 1.8 mode)
* jruby-19mode (1.7.13 in Ruby 1.9 mode)
* ruby-head  (upgraded every time [CI](https://travis-ci.org/ruby/ruby) passes)
* jruby-head (upgraded every time [CI](https://travis-ci.org/jruby/jruby) passes)
* 1.8.7
* ree (2012.02)

[Ruby 1.8.6 and 1.9.1 are no longer provided on travis-ci.org](https://twitter.com/travisci/status/114926454122364928).

Rubies are built using [RVM](http://rvm.io/) that is installed per-user and sourced from `~/.bashrc`.

These are only the pre-installed versions of Ruby. RVM is able to install other
versions on demand. For example, to test against Rubinius 2.2.1, you can use
`rbx-2.2.1` and RVM will download binaries on-demand.

### Bundler version

Recent 1.7.x version (usually the most recent)

### Gems in the global gem set

* bundler
* rake

