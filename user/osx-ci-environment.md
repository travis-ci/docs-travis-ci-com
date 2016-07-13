---
title: The OS X Build Environment
layout: en
permalink: /user/osx-ci-environment/
---

### What This Guide Covers

This guide explains what packages, tools and settings are available in the
Travis OS X CI environment (often referred to as the “CI environment”).

<div id="toc"></div>

## Overview

Travis CI runs builds in virtual machines that are snapshotted before each build
and rolled back at the end of it. This offers a number of benefits:

* Host OS is not affected by test suites
* No state persists between runs
* Passwordless sudo is available
* It is possible for test suites to install various services via `brew`
  and then customize the configuration of those services at the
  beginning of each build.

The environment available to test suites is known as the *Travis CI
environment*.

## OS X Version

Travis CI uses OS X 10.9.5 (and Xcode 6.1) by default . You can use another version of OS X (and Xcode) by specifying the corresponding `osx_image` key from the following table:

<table>

<tr align="left"><th>osx_image value</th><th>Xcode version</th><th>OS X version</th></tr>
{% for image in site.data.xcodes.osx_images %}
<tr>
  <td><code>osx_image: {{image.image}}</code>{% if image.default == true %}  <em>Default</em> {% endif %}</td>
  <td><a href="http://docs.travis-ci.com/user/osx-ci-environment/#Xcode-{{image.xcode}}">Xcode {{ image.xcode_full_version }}</a></td>
  <td>OS X {{ image.osx_version}}
  </td></tr>
{% endfor %}
</table>

>At this time we are unable to provide pre-release versions of Xcode due to the
NDA imposed on them. We do test them internally, and our goal is to make new
versions available the same day they come out. If you have any further questions
about Xcode pre-release availability, send us an email at support@travis-ci.com.

## Homebrew

Homebrew is installed and updated every time the VMs are updated. It is
recommended that you run `brew update` before installing anything with Homebrew.

### A note on upgrading packages

When upgrading a package with `brew upgrade`, the command will fail if the most up-to-date version of the package is already installed (so an upgrade didn't occur).

Depending on how you are upgrading the package, it could cause the build to error:

```
$ brew upgrade xctool
Error: xctool-0.1.16 already installed
The command "brew upgrade xctool" failed and exited with 1 during .

Your build has been stopped.
```

Or it can result in the command not found:

```
xctool: command not found
```


This is intended behaviour from Homebrew's side, but you can get around it by running first checking if the command needs an upgrade with `brew outdated`, like this:

    before_install:
      - brew update
      - brew outdated <package-name> || brew upgrade <package-name>

For example, if you always want the latest version of xctool, you can run this:

    before_install:
      - brew update
      - brew outdated xctool || brew upgrade xctool

## File System

VMs running OS X use the default file system, HFS+.
This file system is case-insensitive, and returns entities within a
directory alphabetically.


## JDK and OS X

The JDK available in the OS X environment is tied to the Xcode version selected for your build, it is not set independently. To use a particular JDK for your build, be sure to select an [OS X image](#OS-X-Version) which includes the version of Java that you need.


## Compilers and Build toolchain

* apple-gcc42
* autoconf 2.69
* automake 1.14
* maven 3.2
* mercurial 2.9
* pkg-config 0.28
* subversion 1.8.10
* wget 1.15
* xctool 0.2.1
* cmake

## Languages

* go 1.3.1

## Services

* postgis 2.1.3
* postgresql 9.3.5


## Runtimes

Every worker has at least one version of Ruby, Java and Python to accommodate
projects that may need one of those runtimes during the build.

## Environment variables

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


## Maven version

Stock Apache Maven 3.

## Ruby versions/implementations

* system (depends on OS X version) -- You need to use `sudo` to install gems with this ruby
* 1.9.3
* 2.0.0 (default)
* 2.1.5
* 2.2.1

Rubies are built using [RVM](http://rvm.io/) that is installed per-user.

## Bundler version

Recent 1.7 version (usually the most recent)

## Gems in the global gem set

* bundler
* rake
* cocoapods

## Xcode version

Xcode 6.1 is installed with the iOS 7.0, 7.1 and 8.1 simulators and SDKs.
Command Line Tools are also installed.

{% for image in site.data.xcodes.osx_images %}
### Xcode {{ image.xcode }}

Xcode {{ image.xcode_full_version }} is available by adding `osx_image: {{ image.image }}` to your .travis.yml.

{% if image.default == true %} -- **Default when no other `osx_image:` is specified** {% endif %}

{% if image.image_note != nil %}
{{image.image_note}}
{% endif %}

Our Xcode {{ image.xcode_full_version }} images have the following SDKs preinstalled:

{% for sdk in image.sdks %}
- {{ sdk }}{% endfor %}

The Xcode {{ image.xcode_full_version }} image also comes with the following simulators:
{% for simulator in image.simulators %}
- {{ simulator }}{% endfor %}

{% endfor %}
