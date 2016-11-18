---
title: Building an Elixir Project (beta)
layout: en
permalink: /user/languages/elixir/
---

### Warning

The features described here are still in development and are subject to change without backward compatibility or migration support.

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
