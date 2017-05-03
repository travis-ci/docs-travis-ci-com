---
title: Building an Elixir Project
layout: en
permalink: /user/languages/elixir/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Elixir projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

## CI Environment for Elixir Projects

To choose the Elixir VM, declare in your `.travis.yml`:

```yaml
language: elixir
```

Note that Elixir has requirements regarding the underlying
Erlang OTP Release version.

If the specified OTP Release version (implicity or explicitly)
does not meet this requirement, Travis CI will choose one
for you.

You can also override this OTP Release choice by adding the `otp_release`.
For example:

```yaml
language: elixir
elixir:
  - 1.2.2
otp_release:
  - 18.2.1
```

To test multiple Elixir versions with different OTP release versions:

```yaml
language: elixir

elixir:
  - 1.0.5
otp_release: 17.4

matrix:
  include:
    - elixir: 1.2
      otp_release: 18.0
```

## Trusty Beta Support Recommended

As of May 2017, [software updates to the hex.pm hosting provider](https://status.fastly.com/incidents/4n5jrrhh5fyh) are causing problems with Travis CI builds. Builds error out with symptoms like this:

 ```
Installing Elixir 1.3.4
$ wget https://repo.hex.pm/builds/elixir/v1.3.4.zip
--2017-05-03 01:06:54--  https://repo.hex.pm/builds/elixir/v1.3.4.zip
Resolving repo.hex.pm (repo.hex.pm)... 151.101.33.5
Connecting to repo.hex.pm (repo.hex.pm)|151.101.33.5|:443... connected.
OpenSSL: error:1407742E:SSL routines:SSL23_GET_SERVER_HELLO:tlsv1 alert protocol version
Unable to establish SSL connection.


The command "wget https://repo.hex.pm/builds/elixir/v1.3.4.zip" failed and exited with 4 during .

Your build has been stopped.
```

The default Ubuntu distro used on Travis (12.04) can not negotiate TLS with the upgraded hex.pm. You can work around this by requesting a newer version of Ubuntu, which you can enable by adding the following to your .travis.yml file:

```
dist: trusty
```

Please see the [warnings related to beta support for the "trusty" distro](https://docs.travis-ci.com/user/trusty-ci-environment/).


## Build Matrix

For elixir projects, `env`, `elixir` and `otp_release` can be given as arrays
to construct a build matrix.

## Default commands

By default, the install command is

```bash
mix local.rebar --force # for Elixir 1.3.0 and up
mix local.hex --force
mix deps.get
```

and the script command is

```bash
mix test
```

## Environment Variables

The version of Elixir a job is using is available as:

```
TRAVIS_ELIXIR_VERSION
```

As with the Erlang VM, the version of OTP release a job is using is available as:

```
TRAVIS_OTP_RELEASE
```
