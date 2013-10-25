---
title: Building an Objective-C Project
layout: en
permalink: objective-c/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Objective-C projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## CI environment for Objective-C Projects

Travis OS X VMs currently run 10.8 and have Homebrew installed.

## Dependency Management

If you have a `Podfile` in your repository, Travis CI automatically runs `pod install` during the install phase.

If you use some other dependency management system, override the `install:` key in your `.travis.yml`:

    install: make get-deps

See [general build configuration guide](/docs/user/build-configuration/) to learn more.

## Default Test Script

Travis CI is going to assume that your project is buildable by `xcodebuild`. However, since `xcodebuild` uses the same exit code for passing and failing tests, we have a version of [Justin Spahr-Summers](https://github.com/jspahrsummers)' [objc-build-scripts](https://github.com/jspahrsummers/objc-build-scripts) preinstalled on the VMs. The default command we will use to run the tests is

    ~/travis-utils/osx-cibuild.sh

The contents of this script can be found [in this Gist](https://gist.github.com/henrikhodne/73151fccea7af3201f63).

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: objective-c

This can be overridden as described in the [general build configuration](/docs/user/build-configuration/) guide. For example, to build by running make without arguments, override the `script:` key in `.travis.yml` like this:

    script: make

## Examples

