---
title: Building a Haskell Project
layout: en

---

<div id="toc">
</div>

<aside markdown="block" class="ataglance">

| Haskell                                     | Default                                                       |
|:--------------------------------------------|:--------------------------------------------------------------|
| [Default `install`](#Dependency-Management) | `cabal install --only-dependencies --enable-tests`            |
| [Default `script`](#Default-Build-Script)   | `cabal configure --enable-tests && cabal build && cabal test` |
| [Matrix keys](#Build-Matrix)                | `env`, `ghc`                                                  |
| Support                                     | [Travis CI](mailto:support@travis-ci.com)                     |

Minimal example:

```yaml
ghc:
  - 7.8
```
{: data-file=".travis.yml"}

</aside>

## What This Guide Covers

{{ site.data.snippets.trusty_note_no_osx }}

The rest of this guide covers configuring Haskell projects on Travis CI. If
you're new to Travis CI please read our [Getting Started](/user/getting-started/)
and [build configuration](/user/customizing-the-build/) guides first.

## Specifying Haskell compiler versions

The Haskell environment on Travis CI has recent versions of GHC (Glasgow Haskell
Compiler) pre-installed. For a detailed list of pre-installed versions, please
consult "Build system information" in the build log.

You can specify one or more GHC versions using `major.minor` notation. Patch
level versions (`7.6.2` for eample) may change any time:

```yaml
ghc:
  - 7.8
  - 7.6
  - 7.4
```
{: data-file=".travis.yml"}

## Default Build Script

The default Haskell build script is:

```bash
cabal configure --enable-tests && cabal build && cabal test
```

## Dependency Management

By default Travis CI uses `cabal` to manage your project's dependencies:

```bash
cabal install --only-dependencies --enable-tests
```

## Build Matrix

For Haskell projects, `env` and `ghc` can be given as arrays
to construct a build matrix.
