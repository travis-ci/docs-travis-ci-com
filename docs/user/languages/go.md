---
title: Building a Go Project
layout: en
permalink: go/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Go projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## CI environment for Go Projects

Travis VMs are 32 bit and currently provide

 * go 1.0
 * core GNU build toolchain (autotools, make), cmake, scons

Go projects on travis-ci.org assume you use Make or straight Go build tool by default.

As a free community service, Travis CI limits build duration to about 20 minutes.


## Dependency Management

Because there is no dominant [convention in the community about dependency management](https://groups.google.com/forum/?fromgroups#!topic/golang-nuts/t01qsI40ms4), Travis CI uses

    go get -d -v && go build -v

to build Go project's dependencies by default.

If you need to perform special tasks before your tests can run, override the `install:` key in your `.travis.yml`:

    install: make get-deps

It is also possible to specify a list of operations, for example, to `go get` remote dependencies:

    install:
      - go get github.com/bmizerany/assert
      - go get github.com/mrb/hob

See [general build configuration guide](/docs/user/build-configuration/) to learn more.



## Default Test Script

Go projects on travis-ci.org assume that either Make or Go build tool are used by default. In case there is a Makefile in the repository root,
the default command Travis CI will use to run your project test suite is

    make

In case there is no Makefile, it will be

    go test -v

instead.

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: go

This can be overridden as described in the [general build configuration](/docs/user/build-configuration/) guide. For example, to omit the `-v` flag,
override the `script:` key in `.travis.yml` like this:

    script: go test

To build by running Scons without arguments, use this:

    script: scons


## Provided Go versions

Travis CI currently only provides a single Go version, 1.0.


## Examples

 * [peterbourgon/diskv](https://github.com/peterbourgon/diskv/blob/master/.travis.yml)
 * [Go AMQP client](https://github.com/streadway/amqp/blob/master/.travis.yml)
 * [mrb/hob](https://github.com/mrb/hob/blob/master/.travis.yml)
 * [timeredbull/tsuru](https://github.com/timeredbull/tsuru/blob/master/.travis.yml)
