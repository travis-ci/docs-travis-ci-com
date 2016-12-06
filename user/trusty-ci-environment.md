---
title: The Trusty beta Build Environment
layout: en
permalink: /user/trusty-ci-environment/
---

## Using Trusty

In order to use sudo-enabled Ubuntu Trusty, add the following to your
`.travis.yml`.

```yaml
dist: trusty
sudo: required
```

Or, if you want to route to the sudo-less beta, add:

```yaml
dist: trusty
sudo: false
```

This is enabled for both public and private repositories.

If you'd like to know more about the pros, cons, and current state of using
Trusty, including details specific to the container-based beta, read on ...

### What This Guide Covers

This guide provides a general overview of which packages, tools and settings are
available in the Trusty beta environment.

<div id="toc"></div>

## Overview

### Fully-virtualized via `sudo: required`

When specifying `sudo: required`, Travis CI runs each build in an isolated
[Google Compute Engine](https://cloud.google.com/compute/docs/) virtual machine
that offer a vanilla build environment for every build.

This has the advantage that no state persists between builds, offering a clean
slate and making sure that your tests run in an environment built from scratch.

Builds have access to a variety of services for data storage and messaging, and
can install anything that's required for them to run.

### Container-based with `sudo: false`

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
- A considerably larger image which contains (almost) all runtimes and services
  present in Precise environments.

## Routing to Trusty

Add the following to your `.travis.yml` file. This works for both public and
private repositories.

```yaml
dist: trusty
sudo: required
```

Or, if you want to route to the container-based beta:

```yaml
dist: trusty
sudo: false
```

## Environment common to all Trusty images

*NOTE: The Trusty images do not currently contain all the common
tools and services present in our Precise images. This is something
we expect will change over time.*

### Version control

All VM images have the following pre-installed:

- A Git 2.x release
- Mercurial (official Ubuntu packages)
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

### Runtimes

#### Ruby

[rvm](https://rvm.io/rvm/about) is installed and we pre-installed at least two
of the latest point releases such as `2.2.5` and `2.3.1`.  Any versions that are
not pre-installed will be dynamically installed at runtime from a local cache.

#### Python

We pre-install at least two of the latest releases of CPython in the `2.x` and
`3.x` series such as `2.7.12` and `3.5.2`, and at least one version of PyPy.
Any versions that are not pre-installed will be dynamically installed at runtime
from a local cache.

[pyenv](https://github.com/yyuu/pyenv#simple-python-version-management-pyenv) is
also installed.

#### Node.JS

[nvm](https://github.com/creationix/nvm#installation) is installed and we
pre-install at least two of the latest point releases such as `4.1.2` and
`0.12.7`.  Any versions that are not pre-installed will be dynamically installed
by `nvm`.

#### Go

[gimme](https://github.com/travis-ci/gimme#gimme) is installed and we
pre-install at least two of the latest point releases such as `1.6.3` and
`1.7.3`.  Any versions that are not pre-installed will be dynamically installed
by `gimme`.

#### JVM

- We install the latest OpenJDK versions from the official Ubuntu Trusty
  packages.
- We install the latest Oracle JDK versions from Oracle.
- [jdk_switcher](https://github.com/michaelklishin/jdk_switcher#what-jdk-switcher-is)
  is installed if you need another version.
- gradle
- Maven
- leiningen
- sbt

#### PHP

[phpenv](https://github.com/phpenv/phpenv) is installed and we pre-install at
least two of the latest point releases such as `7.0.7` and `5.6.24`.  Any
versions that are not pre-installed will be dynamically installed from a local
cache, or built via `phpenv` if unavailable.

*Note: We're unable to build **PHP 5.2** on Trusty, so trying to use it will
result in a build failure when phpenv fails to compile it*

#### Other software

When `sudo: required` is specified, you may install other Ubuntu packages using
`apt-get`, or add third party PPAs or custom scripts.  For further details,
please see the document on [installing
dependencies](/user/installing-dependencies/).

### Data Stores

We pre-install the following services which may be activated with the built-in
[services](/user/database-setup/) support.

- MongoDB
- PostgreSQL
- RabbitMQ
- Redis
- SQLite

The following services that are included with our Precise images are **not
included** in the Trusty images, but may be installed via `apt` if necessary:

- Apache Cassandra
- CouchDB
- ElasticSearch
- Neo4J
- Riak

### Firefox

Firefox is installed by default.

If you need a specific version of Firefox, use the Firefox addon to install
it during the `before_install` stage of the build.

For example, to install version 17.0, add the following to your
`.travis.yml` file:

```yaml
addons:
  firefox: "17.0"
```

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

In the build log, relevant software versions (including the available language versions)
is show in the "Build system information".
