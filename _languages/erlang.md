---
title: Building a Erlang project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Erlang projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

Erlang builds are not available on the OS X environment.

## Choosing OTP releases to test against

Travis CI VMs provide 64-bit [Erlang OTP](http://www.erlang.org/download.html) releases built using [kerl](https://github.com/spawngrid/kerl). To specify OTP releases you want your project to be tested against, use the `otp_release` key:

```yaml
language: erlang
otp_release:
  - 18.2.1
  - 18.1
  - 18.0
  - 17.5
  - R16B03
```

Get a complete list of the pre-compiled versions available on the VM by adding `kerl list installations` to the `before_script:` section of your `.travis.yml`. Note that this list does *not* include releases which are downloaded on demand, such as 18.1 .  

## Default Test Script

Travis CI by default assumes your project is built using [Rebar](https://github.com/rebar/rebar) and uses EUnit. The exact command Erlang builder will use by default is

```bash
rebar compile && rebar skip_deps=true eunit
```

if your project has `rebar.config` or `Rebar.config` files in the repository root. If this is not the case, Erlang builder will fall back to

```bash
make test
```

## Dependency Management

The Erlang builder on travis-ci.org assumes [Rebar](https://github.com/basho/rebar) is used for dependency management, and runs

```bash
rebar get-deps
```

to install [project dependencies ](https://github.com/basho/riak/blob/master/rebar.config) as listed in the `rebar.config` file.

## Build Matrix

For Erlang projects, `env` and `otp_release` can be given as arrays
to construct a build matrix.

## Environment Variable

The version of OTP release a job is using is available as:

```
TRAVIS_OTP_RELEASE
```

## Examples

- [elixir](https://github.com/elixir-lang/elixir/blob/master/.travis.yml)
- [mochiweb](https://github.com/mochi/mochiweb/blob/master/.travis.yml)
- [ibrowse](https://github.com/cmullaparthi/ibrowse/blob/master/.travis.yml)

## Tutorial(s)

- [(English) Continuous Integration for Erlang With Travis-CI](http://blog.equanimity.nl/blog/2013/06/04/continuous-integration-for-erlang-with-travis-ci/)
- [(Dutch) Geautomatiseerd testen with Erlang en Travis-CI](http://blog.equanimity.nl/blog/2013/04/25/geautomatiseerd-testen-met-erlang/)
