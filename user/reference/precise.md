---
title: The Build Environment
layout: en

redirect_from:
  - /user/workers/container-based-infrastructure/
  - /user/workers/standard-infrastructure/
---

### What This Guide Covers

This guide explain what packages, tools and settings are available in the Travis
CI environment (often referred to as "CI environment").

<div id="toc"></div>

## Overview

Travis CI runs builds in isolated virtual machines that offer a vanilla build
environment for every build.

This has the advantage that no state persists between builds, offering a clean
state and making sure that your tests run in an environment built from scratch.

Builds have access to a variety of services for data storage and messaging, and
can install anything that's required for them to run.


## Networking

The virtual machines in the Legacy environment running the tests have IPv6 enabled. They do not have any external IPv4 address but are fully able to communicate with any external IPv4 service.
The container-based, OS X, and GCE (both Precise and Trusty) builds do not currently have IPv6 connectivity.

The IPv6 stack can have some impact on Java services in particular, where one might need to set the flag `java.net.preferIPv4Stack` to force the JVM to resort to the IPv4 stack should services show issues of not booting up or not being reachable via the network: `-Djava.net.preferIPv4Stack=true`.

Most services work normally when talking to the local host by either `localhost` or `127.0.0.1`.

## Environment common to all Precise images

Below you will find a list of the things common to our Precise based
images.

For other images, see the list below:

- [OS X CI Environment](/user/reference/osx)
- [Trusty CI Environment](/user/reference/trusty)

### Version control

All VM images have the following pre-installed

- A Git 1.8 release from the [git-core PPA](https://launchpad.net/~git-core/+archive/ubuntu/v1.8)
- Mercurial (official Ubuntu packages)
- Subversion (official Ubuntu packages)

### Compilers & Build toolchain

GCC, Clang, make, autotools, cmake, scons.

### Networking tools

curl, wget, OpenSSL, rsync

### Go

Go compiler/build tools.

### Runtimes

Every worker has at least one version of

- Ruby
- OpenJDK
- Python
- Node.js
- Go compiler/build tool

to accommodate projects that may need one of those runtimes during the build.

Language-specific workers have multiple runtimes for their respective language (for example, Ruby workers have about 10 Ruby versions/implementations).

### Data Stores

- MySQL
- PostgreSQL
- SQLite
- MongoDB
- Redis
- Riak
- Apache Cassandra
- Neo4J Community Edition
- ElasticSearch
- CouchDB

### Firefox

All virtual environments have recent version of Firefox installed, currently
31.0 for Linux environments and 25.0 for OS X.

If you need a specific version of Firefox, use the Firefox addon to install
it during the `before_install` stage of the build.

For example, to install version 17.0, add the following to your
`.travis.yml` file:

```yaml
addons:
  firefox: "17.0"
```
{: data-file=".travis.yml"}

Please note that the addon only works in 64-bit Linux environments.

### Messaging Technology

- [RabbitMQ](http://rabbitmq.com)
- [ZeroMQ](http://zeromq.org/)

### Headless Browser Testing Tools

- [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
- [PhantomJS](http://phantomjs.org/)

### Environment variables

There is a [list of default environment variables](/user/environment-variables#Default-Environment-Variables) available in each build environment.

### Libraries

- OpenSSL
- ImageMagick

### apt configuration

apt is configured to not require confirmation (assume -y switch by default) using both `DEBIAN_FRONTEND` env variable and apt configuration file. This means `apt-get install -qq` can be used without the -y flag.

### Group membership

The user executing the build (`$USER`) belongs to one primary group derived from that user.
If your project needs extra memberships to run the build, follow these steps:

1. Set up the environment. This can be done any time during the build lifecycle prior to the build script execution.

   1. Set up and export environment variables.
   2. Add `$USER` to desired secondary groups: `sudo usermod -a -G SECONDARY_GROUP_1,SECONDARY_GROUP_2 $USER`

   You may modify the user's primary group with `-g`.

2. Your `script` would look something like:

   ```bash
   script: sudo -E su $USER -c 'COMMAND1; COMMAND2; COMMAND3'
   ```

This will pass the environment variables down to a `bash` process which runs as `$USER`,
while retaining the environment variables defined and belonging to secondary groups given above in `usermod`.

### Build system information

In the build log, relevant software versions (including the available language versions)
is show in the "Build system information".

## Go VM images

The following aliases are available, and are recommended
in order to minimize frictions when images are updated:

- `go1`, `go1.8` → 1.8.1
- `go1.0` → 1.0.3
- `go1.1.x` → 1.1.2
- `go1.2` → 1.2.2
- `go1.2.x` → 1.2.2
- `go1.3.x` → 1.3.3
- `go1.4.x` → 1.4.3
- `go1.5.x` → 1.5.4
- `go1.6.x` → 1.6.4
- `go1.7.x` → 1.7.5
- `go1.8.x` → 1.8.1
- `go1.x` → 1.8.1
- `go1.x.x` → 1.8.1

## JVM (Clojure, Groovy, Java, Scala) VM images

See the [default JVM options](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/sbt-extras/templates/default/jvmopts.erb)
for specific details on building JVM projects.

### JDK

- Oracle JDK 7 (oraclejdk7)
- OpenJDK 7 (openjdk7)
- OpenJDK 6 (openjdk6)
- Oracle JDK 8 (oraclejdk8)

OracleJDK 7 is the default because we have a much more recent patch level
compared to OpenJDK 7 from the Ubuntu repositories. Sun/Oracle JDK 6 is not
provided because it reached End of Life in fall 2012.

The `$JAVA_HOME` will be set correctly when you choose the `jdk` value for the JVM image.

### Maven version

Stock Apache Maven 3.2.x, configured to use [Central](http://search.maven.org/) and [Sonatype](https://oss.sonatype.org/) mirrors.

### Leiningen versions

Travis CI has both standalone ("uberjar") Leiningen 1.7.x at `/usr/local/bin/lein1` and Leiningen 2.4.x at `/usr/local/bin/lein2`.
The default is 2.4.x; `/usr/local/bin/lein` is a symbolic link to `/usr/local/bin/lein2`.

### SBT versions

Travis CI potentially provides any version of Simple Build Tool (sbt or SBT) thanks to very powerful [sbt-extras](https://github.com/paulp/sbt-extras) alternative. In order to reduce build time, popular versions of sbt are already pre-installed (like for instance 0.13.5 or 0.12.4), but `sbt` command is able to dynamically detect and install the sbt version required by your Scala projects.

See the [default sbt options](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/sbt-extras/templates/default/sbtopts.erb)
for specific details on building projects with sbt.

### Gradle version

Gradle 2.0.

## Erlang VM images

### Erlang/OTP releases

Erlang/OTP releases are built using [kerl](https://github.com/spawngrid/kerl).

### Rebar

Travis CI provides a recent version of Rebar. If a repository has rebar binary bundled at `./rebar` (in the repo root), it will
be used instead of the preprovisioned version.

## JavaScript and Node.js images

### Node.js versions

Node runtimes are built and installed using [nvm](https://github.com/creationix/nvm).

### SCons

Scons

## Haskell VM images

### Haskell Platform Version

[Haskell Platform](http://hackage.haskell.org/platform/contents.html) 2012.02 and GHC 7.0, 7.4, 7.6 and 7.8.

## Perl VM images

### Perl versions

Perl versions are installed via [Perlbrew](http://perlbrew.pl/).
Those runtimes that end with the `-extras` suffix have been compiled with
`-Duseshrplib` and `-Duseithreads` flags.
These also have aliases with the `-shrplib` suffix.

### Pre-installed modules

cpanm (App::cpanminus)
Dist::Zilla
Dist::Zilla::Plugin::Bootstrap::lib
ExtUtils::MakeMaker
LWP
Module::Install
Moose
Test::Exception
Test::Kwalitee
Test::Most
Test::Pod
Test::Pod::Coverage

## PHP VM images



### PHP versions

PHP runtimes are built using [php-build](https://github.com/CHH/php-build).

### XDebug

Is supported.

### Core extensions

See the [default configure options](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/phpbuild/templates/default/default_configure_options.erb) to get an overview of the core extensions enabled.


### Extensions

```
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
```

### Chef Cookbooks for PHP

If you want to learn all the details of how we build and provision multiple PHP installations, see our [php, phpenv and php-build Chef cookbooks](https://github.com/travis-ci/travis-cookbooks/tree/precise-stable/ci_environment).


## Python VM images

### Python versions

Every Python has a separate virtualenv that comes with `pip` and `distribute` and is activated before running the build.

Python 2.4 and Jython *are not supported* and there are no plans to support them in the future.

### Default Python Version

If you leave the `python` key out of your `.travis.yml`, Travis CI will use Python 2.7.

### Preinstalled pip packages

- nose
- py.test
- mock
- wheel

On all versions except pypy and pypy3 have `numpy` as well.

## Ruby images

The Ruby images contain recent versions of:

- Ruby: 2.2.0, 2.1.x, 2.0.0, 1.9.3, 1.9.2 and 1.8.7
- JRuby: 1.7.x (1.8 and 1.9 mode)
- Ruby Enterprise Edition: 1.8.7 2012.02

> Ruby 1.8.6 and 1.9.1 are no [longer available on travis-ci.org](https://twitter.com/travisci/status/114926454122364928).

Pre-compiled versions are downloaded on demand from:
- [rubies.travis-ci.org](http://rubies.travis-ci.org).
- [binaries.rubini.us](http://rubies.travis-ci.org/rubinius).
- [rvm.io/binaries/](https://rvm.io/binaries/).
- [www.jruby.org/download](http://www.jruby.org/download).

Rubinius Rubies are [no longer available on Precise](https://github.com/rubinius/rubinius/issues/3717).

### Bundler version

Recent 1.7.x version (usually the most recent)

### Gems in the global gem set

- bundler
- rake
