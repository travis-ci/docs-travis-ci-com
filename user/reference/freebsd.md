---
title: FreeBSD Build Environment
layout: en
---

## Overview

This guide provides an overview of the packages, tools, and settings available in the FreeBSD CI environment.

To use our FreeBSD build infrastructure, you can use the following:

* [FreeBSD 14.2](/user/reference/freebsd/) **default**

> Note: We use FreeBSD 14.2 as the default version.

## Use FreeBSD

To use FreeBSD, add the following to your `.travis.yml`:

```yaml
os: freebsd
```


Travis CI also supports the [Ubuntu Linux Build Environment](/user/reference/linux/), [Windows Build Environment](/user/reference/windows/) 
and [macOS Build Environment](/user/reference/osx/).

> FreeBSD is available on our hosted fully virtualized infrastructure.

### FreeBSD Improvements

FreeBSD includes the following changes and improvements:

#### Remove third-party pkg-repositories 

To specify a third-party pkg-repository, you can add the source with the `pkg` addon and specify
the packages.

For example:

```yaml
os: freebsd
addons:
  pkg:
    - go
    - curl
```


## Common Environment for FreeBSD 14.2 Images

The following versions of version control software and compilers are present on all FreeBSD
14.2 builds, along with more language-specific software described below.

Any preinstalled software not provided by the distribution is installed from ports – either a prebuilt binary
if available, or a source release built with default options. For preinstalled language
interpreters, a standard version manager like `rvm` is used, if available for the language.

## Ruby Support

* Pre-installed Rubies: 3.2.2.
* Available Ruby versions: 2.6.5, 2.7.0, 3.2.2.
* Other Ruby versions can be installed during build time:

```yaml
language: ruby
rvm:
  - 2.6 # RVM should install 2.6 for FreeBSD
  - 3.2 # should use default pre-installed 3.2.2
```


## C and C++ Support

Pre-installed compilers and linkers:

* Make
* GNU Autotools
* Clang 18.1.6
* CMake 3.31.3
* Ccache 3.7.12

## Python Support

* Supported Python versions: 3.8 and higher.
* Pre-installed Python versions: 3.8.1.
* Pre-installed PIP: 19.2.3.

## Go Support

* Go is **not pre-installed** but can be installed manually using `pkg`.

## Julia Support

* Julia is **not pre-installed** but can be installed manually using `pkg`.

## Java Support

* Default version: 17
* Pre-installed OpenJDK versions: 17.0.13
* Pre-installed Apache Ant(TM) version: 1.10.13
* Pre-installed Gradle version: 8.6
* Apache Maven is **not properly configured** due to missing `JAVA_HOME`.

## Docker Support

Currently unsupported. See [FreeBSD wiki about Docker](https://wiki.freebsd.org/Docker) for more details and [FreeBSD wiki on Container Orchestration](https://wiki.freebsd.org/ContainerOrchestration) for more native solutions.

---
