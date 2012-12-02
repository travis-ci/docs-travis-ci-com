---
title: About Travis CI Environment
layout: en
permalink: ci-environment/
---

### What This Guide Covers

This guide explain what packages, tools and settings are available in the Travis CI environment (often referred to as "CI environment") as well as how virtual machines that travis-ci.org workers use are upgraded and deployed. The latter explains how soon you should expect new versions of
Ruby, PHP, Node.js and so on to be provided.

## Overview

Travis CI runs builds in virtual machines that are snapshotted before each build and rolled back at the end of it. This offers a number of benefits:

* Host OS is not affected by test suites
* No state persists between runs
* Passwordless sudo is available (so you can install dependencies using apt and so on)
* It is possible for test suites to create databases, add RabbitMQ vhosts/users and so on

The environment available to test suites is known as the *Travis CI environment*. VMs are deployed from VM images ("boxes") that are available to the public. Provisioning of VM images is highly automated, new versions are deployed on average about once a week.

## CI environment OS

travis-ci.org uses 32-bit Ubuntu Linux 12.04 (server edition).

## How travis-ci.org VMs are provisioned

Provisioning of VMs is automated using [Opscode Chef](http://www.opscode.com/chef/). VMs are never upgraded "on the go", we always replace entire images. VM images are first uploaded to our internal network and deployed to each individual worker during slow periods of the day. On average, we try to deploy new versions of runtimes (e.g. Ruby or PHP) and software like data stores within a week from their public availability, given that Travis Core Team is aware of or notified about the release.

## Environment common to all VM images

### Git, etc

All VM images have

 * A (very) recent Git release from the [Peter van der Does' Git PPA](https://launchpad.net/~pdoes/+archive/ppa)
 * Mercurial (official Ubuntu packages)
 * Subversion (official Ubuntu packages)

preinstalled.


### Compilers & Built toolchain

GCC 4.6.x, Clang 3.1.x, make, autotools, cmake, scons.


### Networking tools

curl, wget, OpenSSL, rsync


### Go

Go compiler/build tool 1.0.


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
* PostgreSQL 9.1.x
* SQLite 3.7.x
* MongoDB 2.2.x
* Redis 2.4.x
* Riak 1.2.x
* Apache Cassandra 1.1.x
* Neo4J Community Edition 1.7.x
* ElasticSearch 0.19.x
* CouchDB 1.2.x

### Messaging Technology

* [RabbitMQ](http://rabbitmq.com) 2.8.x
* [ZeroMQ](http://www.zeromq.org/) 2.1.x

### Headless Browser Testing Tools

* [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
* [PhantomJS](http://www.phantomjs.org/) 1.6.x

### Environment variables

* `CI=true`
* `TRAVIS=true`
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

Additionally, Travis sets environment variables you can use in your build, e.g.
to tag the build, or to run post-build deployments.

* `TRAVIS_BRANCH`: The name of the branch currently being built.
* `TRAVIS_JOB_ID`: The id of the current job that Travis uses internally.
* `TRAVIS_PULL_REQUEST`: True if the current build is for a pull request.

Language-specific builds expose additional environment variables representing
the current version being used to run the build. Whether or not they're set
depends on the language you're using.

* `TRAVIS_RUBY_VERSION`
* `TRAVIS_JDK_VERSION`
* `TRAVIS_NODE_VERSION`
* `TRAVIS_PHP_VERSION`
* `TRAVIS_PYTHON_VERSION`

### Libraries

* OpenSSL
* ImageMagick


### apt configuration

apt is configured to not require confirmation (assume -y switch by default) using both `DEBIAN_FRONTEND` env variable and apt configuration file). This means `apt-get install -qq` can be used without the -y flag.

## JVM (Clojure, Groovy, Java, Scala) VM images

### JDK

* Oracle JDK 7u6 (oraclejdk7)
* OpenJDK 7 (alias: openjdk7)
* OpenJDK 6 (openjdk6)

OracleJDK 7 is the default because we have a much more recent patch level compared to OpenJDK 7 from the Ubuntu repositories. Sun/Oracle JDK 6 is not provided because
it reaches End of Life in the fall 2012.

### Maven version

Stock Apache Maven 3. Maven is configured to use Central and oss.sonatype.org mirrors at http://maven.travis-ci.org

### Leiningen versions

travis-ci.org has both standalone ("uberjar") Leiningen 1.7.x at `/usr/local/bin/lein` and Leiningen 2.0 (a recent preview)
at `/usr/local/bin/lein2`.

### SBT version

travis-ci.org provides a recent SBT 0.11.x version.

### Gradle version

Gradle 1.1.

## Erlang VM images

### Erlang/OTP releases

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

* 0.8.x
* 0.6.x
* 0.9.x (development, may be unstable)


Node runtimes are built using [NVM](https://github.com/creationix/nvm).

### SCons

Scons 2.x.


## Haskell VM images

### Haskell Platform Version

[Haskell Platform](http://hackage.haskell.org/platform/contents.html) 2012.02 and GHC 7.4.


## Perl VM images

### Perl versions

* 5.16
* 5.14
* 5.12
* 5.10

installed via [Perlbrew](http://perlbrew.pl/).

### cpanm

cpanm (App::cpanminus) version 1.5007

## PHP VM images

### PHP versions

* Recent 5.4.x release
* 5.3 (recent 5.3.x release, 5.3.3)

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

* 2.5
* 2.6
* 2.7
* 3.2
* pypy

Every Python has a separate virtualenv that comes with `pip` and `distribute` and is activated before running the build.

Python 2.4 and Jython *are not supported* and there are no plans to support them in the future.

### Preinstalled pip packages

* nose
* py.test
* mock

## Ruby (aka common) VM images

### Ruby versions/implementations

* 1.9.3 (default)
* 1.9.2
* jruby-18mode (1.6.7 in Ruby 1.8 mode)
* jruby-19mode (1.6.7 in Ruby 1.9 mode)
* rbx-18mode (alternative alias: rbx)
* rbx-19mode (in Ruby 1.9 mode)
* ruby-head (upgraded every 2-3 weeks)
* jruby-head (upgraded every 2-3 weeks)
* 1.8.7
* ree (2012.02)
* 2.0.0 (2.0.0-preview1)

[Ruby 1.8.6 and 1.9.1 are no longer provided on travis-ci.org](https://twitter.com/travisci/status/114926454122364928).

Rubies are built using [RVM](https://rvm.beginrescueend.com/) that is installed per-user and sourced from `~/.bashrc`.

### Bundler version

Recent 1.2.x version (usually the most recent)

### Gems in the global gem set

* bundler
* rake

## How VM images are upgraded and deployed

We currently use Vagrant to develop, test, build, export and import VM images
(a.k.a "Vagrant boxes"). Provisioning is automated using [Opscode
Chef](http://www.opscode.com/chef/). VM images are then uploaded to our internal
network and deployed to each individual worker during slow periods of the day
(around 03:00 GMT). VM images for different workers vary in size but in general
are **between 1.6 and 3.3 GB in size**.

This means that to provision a new PHP release (for example), we do the following:

* Update our PHP-related cookbooks and possibly tools like php-build that they depend on.
* Test cookbooks locally
* Build a new PHP VM image
* Upload the image to our internal network
* Take php1.worker.travis-ci.org down to import new images

For new releases of data stores or messaging technologies, for example, Riak

* Update our Riak cookbook
* Test the cookbook locally
* Build a new standard VM image, then worker-specific (Ruby, PHP, Node.js and so on) VM images based on the new standard image
* Upload new images to our internal network
* Take travis-ci.org workers down one by one to import new images

The entire process usually takes from one to several hours (depending on how
many VM images need to be rebuilt). Combined with the time for testing, new
releases of runtimes and other widely used software usually go live on
travis-ci.org within a week from the moment Travis Core team is notified about
the release.

## Chef Cookbooks

The Travis CI environment is set up using [Opscode
Chef](http://www.opscode.com/chef/). All the [cookbooks used by
travis-ci.org](https://github.com/travis-ci/travis-cookbooks/tree/master/ci_environment)
are open source and can be found on GitHub. travis-ci.org uses 32-bit Ubuntu
Linux 12.04 but thanks to Chef, migrating to a different Ubuntu version or
another distribution is much easier.

Chef cookbooks are developed using [Vagrant](http://vagrantup.com/) and [Sous
Chef](https://github.com/michaelklishin/sous-chef) so cookbook contributors are
encouraged to use them.

Many cookbooks Travis CI environment uses are taken from the [official Opscode
cookbooks repository](https://github.com/opscode/cookbooks). We modify some of
them for continuous integration needs and sync them periodically or as the need
arises.
