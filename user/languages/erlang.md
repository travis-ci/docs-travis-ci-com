---
title: Building a Erlang project
layout: en
permalink: erlang/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Erlang projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/build-configuration/) guides first.

## Choosing OTP releases to test against

Travis CI VMs provide 64-bit [Erlang OTP](http://www.erlang.org/download.html) releases built using [kerl](https://github.com/spawngrid/kerl). To specify OTP releases you want your project to be tested against, use the `otp_release` key:

    language: erlang
    otp_release:
       - 17.0-rc1
       - R16B03-1
       - R16B03
       - R16B02
       - R16B01
       - R15B03
       - R15B02
       - R15B01
       - R14B04
       - R14B03
       - R14B02 

Note that 17.0 isn't yet available on <https://travis-ci.com>

## Default Test Script

Travis CI by default assumes your project is built using [Rebar](https://github.com/basho/rebar) and uses EUnit. The exact command Erlang builder will use by default is

    rebar compile && rebar skip_deps=true eunit

if your project has `rebar.config` or `Rebar.config` files in the repository root. If this is not the case, Erlang builder will fall back to

    make test

## Dependency Management

Because Erlang builder on travis-ci.org assumes [Rebar](https://github.com/basho/rebar). is used by default, it naturally uses

    rebar get-deps

to installs project's [dependencies as listed in the rebar.config file](https://github.com/basho/riak/blob/master/rebar.config).


## Build Matrix

For Erlang projects, `env` and `otp_release` can be given as arrays
to construct a build matrix.

## Examples

* [elixir](https://github.com/elixir-lang/elixir/blob/master/.travis.yml)
* [mochiweb](https://github.com/mochi/mochiweb/blob/master/.travis.yml)
* [ibrowse](https://github.com/cmullaparthi/ibrowse/blob/master/.travis.yml)

## Tutorial(s)

* [(English) Continuous Integration for Erlang With Travis-CI](http://blog.equanimity.nl/blog/2013/06/04/continuous-integration-for-erlang-with-travis-ci/)
* [(Dutch) Geautomatiseerd testen with Erlang en Travis-CI](http://blog.equanimity.nl/blog/2013/04/25/geautomatiseerd-testen-met-erlang/)
