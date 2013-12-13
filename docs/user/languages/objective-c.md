---
title: Building an Objective-C Project
layout: en
permalink: objective-c/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Objective-C projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## CI environment for Objective-C Projects

Travis OS X VMs currently run 10.8.5 and have Homebrew installed.

## Dependency Management

If you have a `Podfile` in your repository, Travis CI automatically runs `pod install` during the install phase.

If you use some other dependency management system, override the `install:` key in your `.travis.yml`:

    install: make get-deps

See [general build configuration guide](/docs/user/build-configuration/) to learn more.

## Default Test Script

Travis CI uses [xctool](https://github.com/facebook/xctool) by default to run the tests. In order for xctool to work, you need to tell it the name of your scheme and either project or workspace. For example:

    language: objective-c
    xcode_project: MyNewProject.xcodeproj
    xcode_scheme: MyNewProjectTests

You can also specify an SDK using the `xcode_sdk` variable.

The build script can be overridden as described in the [general build configuration](/docs/user/build-configuration/) guide. For example, to build by running make without arguments, override the `script:` key in `.travis.yml` like this:

    script: make

## Build Matrix

For Objective-C projects, `env`, `rvm`, `gemfile`, `xcode_sdk`, and `xcode_scheme` can be given as arrays
to construct a build matrix.
