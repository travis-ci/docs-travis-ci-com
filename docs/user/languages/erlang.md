---
title: Building a Erlang project
kind: content
---

## What This Guide Covers

This guide covers build environment and configuration topics specific to Erlang projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.


## Choosing OTP releases to test against

Travis VMs provide 32-bit [Erlang OTP](http://www.erlang.org/download.html) releases R14B04, R14B03 and R14B02 built using [kerl](https://github.com/spawngrid/kerl/tree/).
To specify OTP releases you want your project to be tested against, use the `otp_release` key:

    language: erlang
    otp_release:
       - R15B
       - R14B04
       - R14B03
       - R14B02



## Default Test Script

Travis CI by default assumes your project is built using [Rebar](https://github.com/basho/rebar) and uses EUnit. The exact command Erlang builder
will use by default is

    rebar compile && rebar skip_deps=true eunit

if your project has `rebar.config` or `Rebar.config` files in the repository root. If this is not the case, Erlang builder will fall back to

    make test



## Dependency Management

Because Erlang builder on travis-ci.org assumes [Rebar](https://github.com/basho/rebar). is used by default, it naturally uses

    rebar get-deps

to installs project's [dependencies as listed in the rebar.config file](https://github.com/basho/riak/blob/master/rebar.config).



## Examples

 * [cowboy](https://github.com/extend/cowboy/blob/master/.travis.yml)
 * [elixir](https://github.com/josevalim/elixir/blob/master/.travis.yml)
