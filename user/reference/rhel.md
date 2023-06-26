---
title: The RedHat Enterprise Linux Build Environment
layout: en
 
---

## Overview

This guide provides an overview of the packages, tools and settings available in the RHEL CI environment.

You can use the following distribution:

* [RHEL8](/user/reference/rhel/) **default**

## Using RHEL distributions

To use our RHEL build infrastructure, you can use the distribution above.

## Default

We use RHEL 8 as default.

## Using RHEL

To use RHEL, add the following to your your `.travis.yml`.

```yaml
os: linux
dist: rhel8
```
{: data-file=".travis.yml"}

Travis CI also supports the [Ubuntu Linux Build Environment](/user/reference/linux/), [Windows Build Environment](/user/reference/windows/) 
and [macOS Build Environment](/user/reference/osx/).

> RHEL is available on our hosted fully virtualized infrastructure. 


## Environment common to all RHEL8 images

The following versions of version control software and compilers are present on all RHEL 8
builds, along with more language specific software described in detail below.

Any preinstalled software not provided by the distro is installed from ports – either a prebuilt binary
if available, or a source release built with default options. For preinstalled language
interpreters, a standard version manager like rvm is used, if available for the language.

## Ruby support

* Pre-installed Rubies: 2.7.4.
* Available ruby versions: 2.5.9, 2.6.8, 2.7.4
*  Other ruby versions can be installed during build time:

```yaml
language: ruby
rvm:
 - 2.5 # RVM should install 2.5.9 for RHEL8
 - 2.7 # should use default pre-installed 2.7.4
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
* Pre-installed Python versions: 3.8, 3.9
* Pre-installed PyPy
* Pre-installed PIP

## Go support

* Pre-installed Go: 1.17
* Other Go versions can be installed during build time by specifying the language versions with the go:-key.


## JAVA support

* Default version: 11
* Pre-installed OpenJDK version 8, 11, 17
* Pre-installed Apache Ant(TM) version 1.10.12
* Pre-installed Apache Maven version 3.6.3
* Pre-installed Gradle version 6.3

## Docker

Currently unsupported.
