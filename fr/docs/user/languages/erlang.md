---
title: Building a Erlang project
kind: content
---

### Provided tools

Travis VMs provide

* 32-bit [Erlang OTP](http://www.erlang.org/download.html) R14B0X.
* A recent version of  [Rebar](https://github.com/basho/rebar).

### Setting up a Erlang project on travis-ci.org

Erlang projects on travis-ci.org are managed with [Rebar](https://github.com/basho/rebar).. Typical build then has two operations:

    rebar get-deps
    rebar compile && rebar skip_deps=true eunit

The first command installs the project's [dependencies as listed in the rebar.config file](https://github.com/basho/riak/blob/master/rebar.config). The second command runs the test suite.

Travis will do a Rebar build if a rebar.config is present in the root of the project. If no rebar.config is found, the following operation will be triggered instead:

    make tests

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: erlang
    otp_release:
       - R14B03
       - R14B02
       - R14B01

If you need a more fine-grained setup, specify operations to use in your .travis.yml like this:

    language: erlang
    before_script: "rebar get-deps"
    script: "rebar compile eunit"

### Examples

 * [wardbekker/elixer](https://github.com/wardbekker/elixir/blob/master/.travis.yml)
 * [wardbekker/distel](https://github.com/wardbekker/distel/blob/master/.travis.yml)

### Background information

Multiple Erlang/OTP distributions are installed alongside using [Kerl](https://github.com/spawngrid/kerl/tree/). Before every build one of the versions is activated an provides a basic installation of Erlang/OTP. Erlang projects do not a have consistent build technique. Some use Rebar, some good old make and even a combinaties of the two. As Rebar has a good handling of project dependencies, it's a sensible default for Travis.

