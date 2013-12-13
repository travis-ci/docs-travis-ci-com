---
title: Building a Haskell Project
layout: en
permalink: haskell/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Haskell projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Overview

Haskell workers on travis-ci.org use Haskell Platform 2012.2.0.0 and GHC 7.4.1. For full up-to-date list of provided tools, see
our [CI environment guide](/docs/user/ci-environment/). Key build lifecycle commands (dependency installation, running tests) have
defaults that use `cabal`. It is possible to override them to use `make` or any other build tool and dependency management tool.


## Default Test Script

Default test script Travis CI Haskell builder will use is

    cabal configure --enable-tests && cabal build && cabal test

It is possible to override test command as described in the [general build configuration](/docs/user/build-configuration/) guide, for example:

    script:
      - cabal configure --enable-tests -fFOO && cabal build && cabal test


## Dependency Management

### Travis CI uses cabal

By default Travis CI use `cabal` to manage your project's dependencies.

The exact default command is

    cabal install --only-dependencies --enable-tests

It is possible to override dependency installation command as described in the [general build configuration](/docs/user/build-configuration/) guide,
for example:

    install:
      - cabal install QuickCheck


## Build Matrix

For Haskell projects, `env` and `ghc` can be given as arrays
to construct a build matrix.

## Examples

* [spockz/TravisHSTest](https://github.com/spockz/TravisHSTest/blob/master/.travis.yml)
* [ZeusWPI/12Urenloop](https://github.com/ZeusWPI/12Urenloop/blob/master/.travis.yml)
