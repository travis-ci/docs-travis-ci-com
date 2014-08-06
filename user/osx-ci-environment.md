---
title: The OS X Build Environment
layout: en
permalink: osx-ci-environment/
---

### What This Guide Covers

This guide explains what packages, tools and settings are available in the
Travis OS X CI environment (often referred to as the “CI environment”).

## Overview

Travis CI runs builds in virtual machines that are snapshotted before each build
and rolled back at the end of it. This offers a number of benefits:

* Host OS is not affected by test suites
* No state persists between runs
* Passwordless sudo is available (so you can install dependencies using apt and
  so on)
* It is possible for test suites to create databases, add RabbitMQ vhosts/users
  and so on

The environment available to test suites is known as the *Travis CI
environment*.

## CI environment OS

Travis CI uses OS X 10.9.2.

## Environment common to all VM images

### Homebrew

Homebrew is installed and updated every time the VMs are updated. It is
recommended that you run `brew update` before installing anything with Homebrew.

#### A note on upgrading packages

When upgrading a package with `brew upgrade`, the command will fail if the most up-to-date version of the package is already installed (so an upgrade didn't occur). This is intended behaviour from Homebrew's side, but you can get around it by running first checking if the command needs an upgrade with `brew outdated`, like this:

    before_install:
      - brew update
      - if brew outdated | grep -qx <package-name>; then brew upgrade <package-name>; fi
      
For example, if you always want the latest version of xctool, you can run this:

    before_install:
      - brew update
      - if brew outdated | grep -qx xctool; then brew upgrade xctool; fi


### Compilers & Build toolchain

* apple-gcc42 4.2.1-5666.3
* autoconf 2.69
* automake 1.14 1.14.1
* maven 3.2.1
* mercurial 2.8 2.9 2.9.1
* pkg-config 0.28
* subversion 1.8.5 1.8.8
* wget 1.14 1.15
* xctool 0.1.14

### Languages

* go 1.1.2 1.2 1.2.1
* node 0.10.26

### Services

* postgis 2.1.1 2.1.2
* postgresql 9.3.3 9.3.4

### Libraries

* freexl 1.0.0g
* gdal 1.10.1 1.10.1_1
* geos 3.4.2
* giflib 4.1.6
* gpp 2.24
* jpeg 8d
* json-c 0.11
* libgeotiff 1.4.0
* libgpg-error 1.12
* libksba 1.3.0
* liblwgeom 2.1.1
* libpng 1.5.17 1.6.10
* libspatialite 4.1.1
* libtiff 4.0.3
* libtool 2.4.2
* libxml2 2.9.1
* libyaml 0.1.4 0.1.5 0.1.6
* lzlib 1.5
* openssl 1.0.1e 1.0.1f
* ossp-uuid 1.6.2
* proj 4.8.0
* readline 6.2.4
* sqlite 3.8.1 3.8.3 3.8.4.2

### Xcode

Xcode 5.1 is installed with the iOS 6.1, 7.0 and 7.1 simulators and SDKs.
Command Line Tools are also installed.

### Runtimes

Every worker has at least one version of Ruby, Java and Python to accommodate
projects that may need one of those runtimes during the build.

### Environment variables

* `CI=true`
* `TRAVIS=true`
* `USER=travis` (**do not depend on this value**)
* `HOME=/Users/travis` (**do not depend on this value**)

Additionally, Travis CI sets environment variables you can use in your build,
e.g.  to tag the build, or to run post-build deployments.

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


### Maven version

Stock Apache Maven 3.

### Ruby versions/implementations

* system (2.0.0) -- You need to use `sudo` to install gems with this ruby
* 1.9.3
* 2.0.0 (default)

Rubies are built using [RVM](http://rvm.io/) that is installed per-user.

### Bundler version

Recent 1.6 version (usually the most recent)

### Gems in the global gem set

* bundler
* rake

