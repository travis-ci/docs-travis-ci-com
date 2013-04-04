---
title: About OSX Travis CI Environment
layout: en
permalink: osx-ci-environment/
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

travis-ci.org uses Mac OS X 10.8.2

## Environment common to all VM images

### Homebrew

Homebrew is installed and updated every time the VMs are updated. It is recommended that you run `brew update` before installing anything with Homebrew.


### Compilers & Built toolchain

GCC 4.2.1, Clang 4.1, make, autotools.


### Networking tools

curl, wget, OpenSSL, rsync


### Runtimes

Every worker has at least one version of

* Ruby
* Java
* Python

to accommodate projects that may need one of those runtimes during the build.

### Environment variables

* `CI=true`
* `TRAVIS=true`
* `USER=travis` (**do not depend on this value**)
* `HOME=/Users/travis` (**do not depend on this value**)

Additionally, Travis sets environment variables you can use in your build, e.g.
to tag the build, or to run post-build deployments.

* `TRAVIS_BRANCH`: The name of the branch currently being built.
* `TRAVIS_BUILD_DIR`: The absolute path to the directory where the repository
  being built has been copied on the worker.
* `TRAVIS_BUILD_ID`: The id of the current build that Travis uses internally.
* `TRAVIS_BUILD_NUMBER`: The number of the current build (for example, "4").
* `TRAVIS_COMMIT`: The commit that the current build is testing.
* `TRAVIS_COMMIT_RANGE`: The range of commits that were included in the push
  or pull request.
* `TRAVIS_JOB_ID`: The id of the current job that Travis uses internally.
* `TRAVIS_JOB_NUMBER`: The number of the current job (for example, "4.1").
* `TRAVIS_PULL_REQUEST`: The pull request number if the current job is a pull
  request, "false" if it's not a pull request.
* `TRAVIS_SECURE_ENV_VARS`: Whether or not secure environment vars are being
  used. This value is either "true" or "false".
* `TRAVIS_REPO_SLUG`: The slug (in form: `owner_name/repo_name`) of the
  repository currently being built. (for example, "travis-ci/travis-build").


### Maven version

Stock Apache Maven 3.

### Ruby versions/implementations

* 1.8.7 (system, default) -- You need to use `sudo` to install gems with this ruby
* 1.8.7 (installed by RVM)
* 1.9.3

Rubies are built using [RVM](https://rvm.beginrescueend.com/) that is installed per-user and sourced from `~/.bashrc`.

### Bundler version

Recent 1.2.x version (usually the most recent)

### Gems in the global gem set

* bundler
* rake
