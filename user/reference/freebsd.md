---
title: The FreeBSD Build Environment
layout: en
 
---

## Overview

This guide provides an overview of the packages, tools and settings available in the FreeBSD CI environment.

You can use the following distribution:

* [FreeBSD 12.1](/user/reference/freebsd/) **default**

## Using FreeBSD distributions

To use our FreeBSD build infrastructure, you can use the distribution above.

## Default

We use FreeBSD 12.1 as default.

## Using FreeBSD

To use FreeBSD, add the following to your your `.travis.yml`.

```yaml
os: freebsd
```
{: data-file=".travis.yml"}

Travis CI also supports the [Ubuntu Linux Build Environment](/user/reference/linux/), [Windows Build Environment](/user/reference/windows/) 
and [macOS Build Environment](/user/reference/osx/).

> FreeBSD is available on our hosted fully virtualized infrastructure. 

### FreeBSD improvements

FreeBSD includes the following changes and improvements:

#### Third party pkg-repositories removed

To specify a third party pkg-repository, you can add the source with the pkg addon and specify
the packages. 

For example:

```yaml
os: freebsd
addons:
pkg:
- go
- curl
```
{: data-file=".travis.yml"}

## Environment common to all FreeBSD 12.1 images

The following versions of version control software and compilers are present on all FreeBSD
12.1 builds, along with more language specific software described in detail below.

Any preinstalled software not provided by the distro is installed from ports – either a prebuilt binary
if available, or a source release built with default options. For preinstalled language
interpreters, a standard version manager like rvm is used, if available for the language.

## Ruby support

* Pre-installed Rubies: 2.6.5.
* Available ruby versions: 1.8.6, 1.8.7, 1.9.1, 1.9.2, 1.9.3, 2.0.0, 2.1.10, 2.2.10, 2.3.8, 2.4.6, 2.5.5, 2.6.3, 2.7.0 (preview1)
*  Other ruby versions can be installed during build time:

```yaml
language: ruby
rvm:
- 2.5 # RVM should install 2.5 for FreeBSD
- 2.6 # should use default pre-installed 2.6.5
```
{: data-file=".travis.yml"}

## C and C++ support

Pre-install compilers and linkers:
* Make
* GNU autotools
* Scons
* Shellcheck
* Shfmt
* Clang
* GCC
* CMake
* Ccache
* Llvm

## Python support

* Supported Python versions: 2.7, 3.4 or higher.
* Pre-installed Python versions: 3.6 and 3.8.
* Pre-installed PyPy
* Pre-installed PIP

## Go support

* Pre-installed Go: 1.11
* Other Go versions can be installed during build time by specifying the language versions with the go:-key.


## Julia support

* Supported Julia versions: starting with version 0.7 and higher

## JAVA support

* Default version: 8
* Pre-installed OpenJDK version 8, 11, 12, 13 (OpenJDK10 not supported in FreeBSD)
* Pre-installed Apache Ant(TM) version 1.10.6
* Pre-installed Apache Maven version 3.6.3
* Pre-installed Gradle version 6.0.1

## Docker

Currently unsupported. See [FreeBSD wiki](https://wiki.freebsd.org/Docker) for more details.
