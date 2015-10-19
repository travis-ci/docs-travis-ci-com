---
title: The Trusty beta Build Environment
layout: en
permalink: /user/trusty-ci-environment/
---

## tl;dr - Using Trusty

If you just want to get started using our Trusty beta, then add the following to your `.travis.yml`.

``` yaml
sudo: required
dist: trusty
```

This is enabled for both public and private repositories.

If you'd like to know more about the pros, cons, and current state of
the Trusty beta, read on ...

### What This Guide Covers

This guide explains what packages, tools and settings are available in
the Trusty beta environment.

A couple of important points to note:

- All Trusty images have `sudo` enabled, so you're able to make any
  changes you wish to the images using our various `before_*:`
  keys or custom scripts.

- The Trusty images are what our [Docker beta](/user/docker/)
  runs on as well.

<div id="toc"></div>

## Overview

Travis CI runs each Trusty build in an isolated [Google Compute Engine](https://cloud.google.com/compute/docs/) virtual machine that offer a vanilla build
environment for every build.

This has the advantage that no state persists between builds, offering a clean
slate and making sure that your tests run in an environment built from scratch.

Builds have access to a variety of services for data storage and messaging, and
can install anything that's required for them to run.


## Image differences from Precise

In our Precise based environments, we've traditionally built a library
of images based on common language runtimes like `ruby`, `go`, `php`,
`python`, etc.

For our Trusty beta, in part due to the architecture and speed of GCE,
we're only making two images.

- A **minimal** image which contains no runtimes or services. This image
  is only used for `language: generic` at this time.
- A **mega** image which will contains almost all of (soon to be all)
  our commonly supported runtimes and services.

## Distribution release

Our Ubuntu 14.04 Trusty Tahr images are based on the
**ubuntu-1404-trusty-v20150909a** Google Compute Engine image, which itself is based on [2015-09-08 revision of 14.04.3](https://cloud-images.ubuntu.com/releases/14.04.3/release-20150908/)

## Using the Trusty beta

Add the following to your `.travis.yml` file. This works for both
public and private repositories.

``` yaml
sudo: required
dist: trusty
```

## Environment common to all VM images

We currently have a custom **mega** image that we are building, which
contains a number of common language runtimes, tools, and data services.

_Note: the **mega** image does not currently contain all the common
tools and services present in our Precise images. This is something
we'll be expanding over the next couple of months_

### Version control

All VM images have the following pre-installed:

 * A Git 1.9.x release
 * Mercurial (official Ubuntu packages)
 * Subversion (official Ubuntu packages)


### Compilers & Build toolchain

GCC, Clang, make, autotools, cmake, scons.
- Essentially everything from `build-essential` and **clang** from the
`llvm-3.4` Ubuntu package.

- gcc 4.8.4
- llvm clang 3.5.0

### Networking tools

curl, wget, OpenSSL, rsync

### Docker

Docker 1.8.2 is installed. We use the official [Docker apt
repository](https://blog.docker.com/2015/07/new-apt-and-yum-repos/), so
you can easily install another version with `apt-get` if needed.

[docker-compose](https://docs.docker.com/compose/)
version [1.4.2](https://github.com/docker/compose/releases/tag/1.4.2) is also
installed.

See our [Using Docker in Builds](/user/docker/)
section for more details on our Docker beta and its usage.

### Runtimes

#### Ruby

[rvm](https://rvm.io/rvm/about) is installed and we've pre-installed the following Ruby versions
with it.


- jruby-9.0.1.0
- ruby-1.9.3-p551
- ruby-2.0.0-p647
- ruby-2.1.7
- ruby-2.2.3

#### Python

We pre-install the following python versions

- pypy 2.6.1
- pypy3 2.4.0
- python 2.6.9
- python 2.7.10
- python 3.2.6
- python 3.3.6
- python 3.4.3
- python 3.5.0

[pyenv](https://github.com/yyuu/pyenv#simple-python-version-management-pyenv) is also installed.

#### Node.JS

[nvm](https://github.com/creationix/nvm#installation) is installed and we've pre-installed the following Node versions
with it

- iojs-v1.6.4
- v0.6.21
- v0.8.28
- v0.10.40
- v0.11.16
- v0.12.7
- 4.1.2

#### Go

[gimme](https://github.com/travis-ci/gimme#gimme) is installed and we've pre-installed the following Go versions
with it

- go 1.0.3
- go 1.1.2
- go 1.2.2
- go 1.3.3
- go 1.4.2
- go 1.5.1

#### JVM

- We install the latest OpenJDK versions from the official Ubuntu
  Trusty packages. (1.8.0_60 as of 2015-10-13)
- We install the latest Oracle JDK versions from Oracle.
- [jdk_switcher](https://github.com/michaelklishin/jdk_switcher#what-jdk-switcher-is) is installed if you need another version.
- gradle 2.5 is installed.
- Maven 3.1.1 is installed.
- leiningen 2.5.1 is installed.
- sbt 0.13.9

#### PHP

We do not currently have any PHP versions pre-installed in the **mega**
image. This is at the top of our list for our next update.


But we do have [phpenv](https://github.com/phpenv/phpenv) installed and
it's able to install the following PHP versions.

- PHP 5.3
- PHP 5.4
- PHP 5.5
- PHP 5.6
- PHP 7.0.0 RCs

_Note: We're unable to build **PHP 5.2** on Trusty so far, so trying to use
it will result in a build failure when phpenv fails to compile it_

#### Other runtimes

Other runtimes are available to install using `apt-get` and the official
Ubuntu packages, any third party PPAs or custom scripts that you
manually setup in your `.travis.yml`

### Data Stores

We pre-install the following services and they can be activated with the built-in [services](/user/database-setup/) support.

* PostgreSQL 9.4.5
* SQLite 3.8.2
* Redis 3.0.4

*Note: The following services that are included with our Precise images
are **not included** in the Trusty **mega** images at this time but some
will/may be added in the coming months. 
You'll need to install them manually for the time being.*

- MySQL
- Riak
- ElasticSearch
- Apache Cassandra
- CouchDB
- Neo4J

### Firefox

Firefox 31.6.0esr is installed by default.

If you need a specific version of Firefox, use the Firefox addon to install
it during the `before_install` stage of the build.

For example, to install version 17.0, add the following to your
`.travis.yml` file:

    addons:
      firefox: "17.0"

### Headless Browser Testing Tools

* [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
* [PhantomJS](http://phantomjs.org/)

### Environment variables

There is a [list of default environment variables](/user/environment-variables#Default-Environment-Variables) available in each build environment.

### apt configuration

apt is configured to not require confirmation (assume -y switch by default) using both `DEBIAN_FRONTEND` env variable and apt configuration file. This means `apt-get install -qq` can be used without the -y flag.

### Group membership

The user executing the build (`$USER`) belongs to one primary group derived from that user.
If your project needs extra memberships to run the build, follow these steps:

1. Set up the environment. This can be done any time during the build lifecycle prior to the build script execution.
    - Set up and export environment variables.
    - Add `$USER` to desired secondary groups: `sudo usermod -a -G SECONDARY_GROUP_1,SECONDARY_GROUP_2 $USER`
    You may modify the user's primary group with `-g`.
1. Your `script` would look something like:

```bash
script: sudo -E su $USER -c 'COMMAND1; COMMAND2; COMMAND3'
```
This will pass the environment variables down to a `bash` process which runs as `$USER`,
while retaining the environment variables defined
and belonging to secondary groups given above in `usermod`.

### Build system information

In the build log, relevant software versions (including the available language versions)
is show in the "Build system information".
