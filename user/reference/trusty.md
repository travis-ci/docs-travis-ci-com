---
title: The Trusty Build Environment
layout: en
redirect_from:
  - /user/trusty-ci-environment/
---

## What This Guide Covers

This guide provides a general overview of which packages, tools and settings are
available in the Trusty environment.



## Using Trusty

To use sudo-enabled Ubuntu Trusty, add the following to your
`.travis.yml`.

```yaml
dist: trusty
sudo: required
```
{: data-file=".travis.yml"}

Or to route to sudo-less:

```yaml
dist: trusty
sudo: false
```
{: data-file=".travis.yml"}

This is enabled for both public and private repositories.

If you'd like to know more about the pros, cons, and current state of using
Trusty, including details specific to container-based, read on ...

## Fully-virtualized via `sudo: required`

When specifying `sudo: required`, Travis CI runs each build in an isolated
[Google Compute Engine](https://cloud.google.com/compute/docs/) virtual machine
that offer a vanilla build environment for every build.

This has the advantage that no state persists between builds, offering a clean
slate and making sure that your tests run in an environment built from scratch.

Builds have access to a variety of services for data storage and messaging, and
can install anything that's required for them to run.

## Container-based with `sudo: false`

When specifying `sudo: false`, Travis CI runs each build in a container on a
shared host via Docker.  The container contents are a pristine copy of the
Docker image, as guaranteed by Docker itself.

The advantage of running with `sudo: false` is dramatically reduced time between
commit push to GitHub and the start of a job on Travis CI, which works
especially well when one's average job duration is under 3 minutes.

*NOTE: The allowed list of packages that may be installed varies between Precise
and Trusty, with the Precise list being considerably larger at the time of this
writing.  If the packages you need are not yet available on Trusty, it is
recommended that you either target `dist: precise` or `sudo: required` depending
on your needs.*

## Image differences from Precise

In our Precise based environments, we've traditionally built a library of images
based on common language runtimes like `ruby`, `go`, `php`, `python`, etc.

For our Trusty based environments, we're making a smaller set of images that
includes:

- A minimal image which contains a small subset of interpreters, as well as
  `docker` and `packer`.
- A considerably larger image which contains roughly the same runtimes and
  services present in Precise environments.

## Routing to Trusty

Add the following to your `.travis.yml` file. This works for both public and
private repositories.

```yaml
dist: trusty
sudo: required
```
{: data-file=".travis.yml"}

Or, if you want to route to container-based:

```yaml
dist: trusty
sudo: false
```
{: data-file=".travis.yml"}

## Environment common to all Trusty images

### Version control

All VM images have the following pre-installed:

- Git 2.x
- Mercurial
- Subversion (official Ubuntu packages)

### Compilers & Build toolchain

The `build-essential` metapackage is installed, as well as modern versions of:

- GCC
- Clang
- make
- autotools
- cmake
- scons

### Networking tools

- curl
- wget
- OpenSSL
- rsync

### Docker

Docker is installed.  We use the official [Docker apt
repository](https://blog.docker.com/2015/07/new-apt-and-yum-repos/), so you can
easily install another version with `apt` if needed.  When `sudo: required` is
specified, Docker is installed as a service.  When `sudo: false` is specified,
the Docker binaries are available for local use.

*NOTE: When `sudo: false` is specified, the Docker daemon is not supported.*

[docker-compose](https://docs.docker.com/compose/) is also installed.

See our [Using Docker in Builds](/user/docker/) section for more details.

## Ruby images

[rvm](https://rvm.io/rvm/about) is installed and we pre-install at least two of
the latest point releases. These are the currently pre-installed Ruby versions:

- `2.2.7`
- `2.3.4`
- `2.4.1`

Other versions are dynamically installed at runtime from a local cache.

## Python images

We pre-install at least two of the latest releases of CPython in the `2.x` and
`3.x` series such as `2.7.13` and `3.6.1`, and at least one version of PyPy.
Any versions that are not pre-installed will be dynamically installed at runtime
from a local cache.

[pyenv](https://github.com/yyuu/pyenv#simple-python-version-management-pyenv) is
also installed.

### Default Python Version

If you leave the `python` key out of your `.travis.yml`, Travis CI will use
Python 2.7.

### Pre-installed pip packages

Travis CI installs the following packages by default in each virtualenv:

- nose
- pytest
- wheel
- mock
- six

On all Python versions except pypy and pypy3, `numpy` is available as well.

## JavaScript and Node.js images

[nvm](https://github.com/creationix/nvm) is installed and we
pre-install at least two of the latest point releases such as `6.9.4` and
`7.4.0`.

You can specify other versions which will be dynamically installed using `nvm`.

## Go images

[gimme](https://github.com/travis-ci/gimme#gimme) is installed and we
pre-install at least two of the latest point releases such as `1.7.3` and
`1.8.3`.  Any versions that are not pre-installed will be dynamically installed
by `gimme`.

## JVM (Clojure, Groovy, Java, Scala) images

- We install the latest OpenJDK versions from the official Ubuntu Trusty
  packages:
  - Open JDK 7 (`openjdk7`)
  - Open JDK 8 (`openjdk8`)
  - OpenJDK 6 is not installed. To use OpenJDK 6, install
    [`openjdk-6-jdk` package](https://packages.ubuntu.com/trusty/openjdk-6-jdk).
    For example, using [`apt` addon](/user/installing-dependencies/):
    ```yaml
    addons:
      apt:
        packages:
          - openjdk-6-jdk
    jdk: openjdk6
    ```
- We install the latest Oracle JDK versions from Oracle:
  - Oracle JDK 8 (`oraclejdk8`). Default.
  - Oracle JDK 9 (`oraclejdk9`)
  - Oracle JDK 7 is not provided because it reached End of Life in April 2015.

- [jdk_switcher](https://github.com/michaelklishin/jdk_switcher#what-jdk-switcher-is)
  is installed if you need another JDK version.

The `$JAVA_HOME` will be set correctly when you choose the `jdk` value for the
JVM image.

### Gradle version

Gradle 4.0.

### Maven version

Stock Apache Maven 3.5.x, configured to use [Central](http://search.maven.org/)
and [Sonatype](https://oss.sonatype.org/) mirrors.

### Ant version
Ant 1.9.3.

### Leiningen version

Leiningen 2.7.1.

### SBT version

Travis CI potentially provides any version of Simple Build Tool (sbt or SBT)
thanks to the very powerful [sbt-extras](https://github.com/paulp/sbt-extras)
alternative. `sbt` can dynamically detect and install the sbt version required
by your Scala projects.

## PHP images

[phpenv](https://github.com/phpenv/phpenv) is installed and we pre-install at
least two of the latest point releases such as `7.0.7` and `5.6.24`, as well as
`5.5.9`, the version shipped by default with Ubuntu 14.04 LTS. Any versions that
are not pre-installed will be dynamically installed from a local cache, or built
via `phpenv` if unavailable.

*Note: We do not support PHP versions 5.2.x and 5.3.x on Trusty.
Specifying it will result in build failure.
If you need to test with these versions, use Precise.*

```yaml
matrix:
  include:
    - php: 5.2
      dist: precise
    - php: 5.3
      dist: precise
```
{: data-file=".travis.yml"}


### HHVM

[hhvm](https://github.com/facebook/hhvm) is also available.
and the nightly builds are installed on-demand (as `hhvm-nightly`).

```yaml
language: php
sudo: required
dist: trusty
php:
  - hhvm-3.3
  - hhvm-3.6
  - hhvm-3.9
  - hhvm-3.12
  - hhvm-3.15
  - hhvm-3.18
  - hhvm-nightly
```
{: data-file=".travis.yml"}

### Extensions

#### PHP 7.0

The following extensions are preinstalled for PHP 7.0 and nightly builds:

- [apcu.so](http://php.net/apcu)
- [memcached.so](http://php.net/memcached)
- [mongodb.so](https://php.net/mongodb)
- [amqp.so](http://php.net/amqp)
- [zmq.so](http://zeromq.org/bindings:php)
- [xdebug.so](http://xdebug.org)
- [redis.so](http://pecl.php.net/package/redis)

Please note that these extensions are not enabled by default with the exception
of xdebug.

#### PHP 5.6 and below

For PHP versions up to 5.6, the following extensions are available:

- [apc.so](http://php.net/apc) (not available for 5.5 or 5.6)
- [memcache.so](http://php.net/memcache) or [memcached.so](http://php.net/memcached)
- [mongo.so](http://php.net/mongo)
- [amqp.so](http://php.net/amqp)
- [zmq.so](http://zeromq.org/bindings:php)
- [xdebug.so](http://xdebug.org)
- [redis.so](http://pecl.php.net/package/redis)

Please note that these extensions are not enabled by default with the exception
of xdebug.


## Other software

When `sudo: required` is specified, you may install other Ubuntu packages using
`apt-get`, or add third party PPAs or custom scripts.  For further details,
please see the document on [installing dependencies](/user/installing-dependencies/).

## Databases and services

We pre-install the following services which may be activated with the built-in
[services](/user/database-setup/) support.

- Apache Cassandra
- CouchDB
- ElasticSearch
- MongoDB
- MySQL
- Neo4j
- PostgreSQL
- RabbitMQ
- Redis
- Riak
- SQLite

## Firefox

Firefox is installed by default.

If you need a specific version of Firefox, use the Firefox addon to install
it during the `before_install` stage of the build.

For example, to install version 50.0, add the following to your
`.travis.yml` file:

```yaml
addons:
  firefox: "50.0"
```
{: data-file=".travis.yml"}

### Headless Browser Testing Tools

- [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
- [PhantomJS](http://phantomjs.org/)

### Environment variables

There is a [list of default environment
variables](/user/environment-variables#Default-Environment-Variables) available
in each build environment.

### apt configuration

apt is configured to not require confirmation (assume -y switch by default)
using both `DEBIAN_FRONTEND` env variable and apt configuration file. This means
`apt-get install -qq` can be used without the -y flag.

### Group membership

The user executing the build (`$USER`) belongs to one primary group derived from
that user.  When `sudo: required` is specified, you may modify group membership
by following the following steps:

1. Set up the environment. This can be done any time during the build lifecycle
   prior to the build script execution.

   - Set up and export environment variables.
   - Add `$USER` to desired secondary groups: `sudo usermod -a -G
        SECONDARY_GROUP_1,SECONDARY_GROUP_2 $USER`
     You may modify the user's primary group with `-g`.

2. Your `script` would look something like:

```bash
script: sudo -E su $USER -c 'COMMAND1; COMMAND2; COMMAND3'
```

This will pass the environment variables down to a `bash` process which runs as
`$USER`, while retaining the environment variables defined and belonging to
secondary groups given above in `usermod`.

### Build system information

In the build log, relevant software versions (including the available language
versions) is show in the "Build system information".
