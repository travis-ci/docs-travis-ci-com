---
title: Building a Haskell Project
layout: en

---

## What This Guide Covers

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
  - "7.8"
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.trusty_note_no_osx }}

The rest of this guide covers configuring Haskell projects on Travis CI. If
you're new to Travis CI please read our [Tutorial](/user/tutorial/)
and [build configuration](/user/customizing-the-build/) guides first.

## Specifying Haskell compiler versions

The Haskell environment on Travis CI has recent versions of GHC (Glasgow Haskell
Compiler) pre-installed. For a detailed list of pre-installed versions, please
consult "Build system information" in the build log.

You can specify one or more GHC versions using `major.minor` notation. Patch
level versions (`7.6.2` for example) may change any time:

```yaml
ghc:
  - "7.10"
  - "7.8"
  - "7.6"
  - "8.4.1"
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

### Multiple Packages in Subdirectories

If you have multiple packages in subdirectories (each containing a `.cabal` file,
you can specify those directories in an environment variable:

```yaml
ghc:
  - "7.10"
  - "7.8"
  - "7.6"
env:
  - PACKAGEDIR="some-package"
  - PACKAGEDIR="some-other-package"
before_install: cd ${PACKAGEDIR}
```
{: data-file=".travis.yml"}

The build matrix is then constructed such that each package is compiled with each version of GHC.

## Hackage Deployment

Travis can automatically upload your package to [Hackage](https://hackage.haskell.org/).
See [Hackage Deployment](/user/deployment/hackage/).
