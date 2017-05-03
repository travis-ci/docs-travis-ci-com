---
title: Building a Haskell Project
layout: en
permalink: /user/languages/haskell/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Haskell projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

Haskell builds are not available on the OSX environment.

## Overview

The Haskell VM has recent versions of GHC pre-installed.

For precise versions pre-installed on the VM, please consult "Build system information" in the build log.

For full up-to-date list of provided tools, see
our [CI environment guide](/user/ci-environment/). Key build lifecycle commands (dependency installation, running tests) have
defaults that use `cabal`. It is possible to override them to use `make` or any other build tool and dependency management tool.

## Specifying the GHC version

You can specify one or more GHC versions:

```yaml
ghc: 7.4
```

Multiple versions:

```yaml
ghc:
  - 7.8
  - 7.6
  - 7.4
```

It is recommended that you only use the major and minor versions to specify the version to use, as we may update the patchlevel releases at any time.

## Default Test Script

Default test script Travis CI Haskell builder will use is

```
cabal configure --enable-tests && cabal build && cabal test
```

It is possible to override test command as described in the [general build configuration](/user/customizing-the-build/) guide, for example:

```yaml
script:
  - cabal configure --enable-tests -fFOO && cabal build && cabal test
```

## Dependency Management

### Travis CI uses cabal

By default Travis CI use `cabal` to manage your project's dependencies.

The exact default command is

```bash
cabal install --only-dependencies --enable-tests
```

It is possible to override dependency installation command as described in the [general build configuration](/user/customizing-the-build/) guide,
for example:

```yaml
install:
  - cabal install QuickCheck
```

## Build Matrix

For Haskell projects, `env` and `ghc` can be given as arrays
to construct a build matrix.

## Examples

- [jgm/pandoc](https://github.com/jgm/pandoc/blob/master/.travis.yml)
- [hspec/hspec](https://github.com/hspec/hspec/blob/master/.travis.yml)
- [commercialhaskell/stack](https://github.com/commercialhaskell/stack/blob/master/.travis.yml)
- [lwm/es-api](https://github.com/lwm/es-api/blob/master/.travis.yml)
