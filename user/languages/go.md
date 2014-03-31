---
title: Building a Go Project
layout: en
permalink: go/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Go projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/build-configuration/) guides first.

## CI environment for Go Projects

Travis CI VMs are 64 bit and currently provide

 * any tagged version of Go (via gvm)
 * core GNU build toolchain (autotools, make), cmake, scons

Go projects on travis-ci.org assume you use Make or straight Go build tool by default.

## Specifying a Go version to use

Travis CI uses gvm, so you can use any tagged version of Go or use `tip` to get the latest version.

    language: go
    
    go:
      - 1.0
      - 1.1
      - 1.2
      - tip

## Dependency Management

Because there is no dominant [convention in the community about dependency management](https://groups.google.com/forum/?fromgroups#!topic/golang-nuts/t01qsI40ms4), Travis CI uses

    go get -d -v ./... && go build -v ./...

to build Go project's dependencies by default.

If you need to perform special tasks before your tests can run, override the `install:` key in your `.travis.yml`:

    install: make get-deps

It is also possible to specify a list of operations, for example, to `go get` remote dependencies:

    install:
      - go get github.com/bmizerany/assert
      - go get github.com/mrb/hob

See [general build configuration guide](/user/build-configuration/) to learn more.

### Installing Private Dependencies

As `go get` uses HTTPS to clone dependencies from GitHub rather than SSH, it
requires a different workaround from our [recommended way of handling private
dependencies](/user/travis-pro/#How-can-I-configure-Travis-Pro-to-use-private-GitHub-repositories-as-dependencies%3F).

When cloning via HTTPS, git uses curl under the covers, which in turn allows you
to specify a [.netrc](http://linux.die.net/man/5/netrc) file, where you can
store custom authentication credentials for specific domains, github.com for
instance.

Go to your [GitHub account](https://github.com/settings/applications) and create
a personal access token.

![](/images/personal-token.jpg)

Make sure to give it the `repo` scope, which allows accessing private
repositories.

To reduce access rights of the token, you can also create a separate user
account with access to only the repositories you need for a particular project.

Copy the token and store it in a .netrc in your repository, with the following
data:

    machine github.com
      login <username>
      password <token>

Add this to your repository and add the following steps to your .travis.yml:

    before_install:
      - cp .netrc ~
      - chmod 600 .netrc

You can leave out the second step if your .netrc already has access permissions
set only for the owner. That's a requirement for it to be read from curl.

## Default Test Script

Go projects on travis-ci.org assume that either Make or Go build tool are used by default. In case there is a Makefile in the repository root,
the default command Travis CI will use to run your project test suite is

    make

In case there is no Makefile, it will be

    go test -v ./...

instead.

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: go

This can be overridden as described in the [general build configuration](/user/build-configuration/) guide. For example, to omit the `-v` flag,
override the `script:` key in `.travis.yml` like this:

    script: go test ./...

To build by running Scons without arguments, use this:

    script: scons

## Build Matrix

For Go projects, `env` and `go` can be given as arrays
to construct a build matrix.


## Examples

 * [Go AMQP client](https://github.com/streadway/amqp/blob/master/.travis.yml)
 * [mrb/hob](https://github.com/mrb/hob/blob/master/.travis.yml)
 * [globocom/tsuru](https://github.com/globocom/tsuru/blob/master/.travis.yml)
