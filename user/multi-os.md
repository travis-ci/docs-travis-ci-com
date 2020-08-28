---
title: Testing Your Project on Multiple Operating Systems
layout: en

---

If your code is used on multiple operating systems it probably should be tested on
multiple operating systems. Travis CI can test on Linux and macOS.

To enable testing on multiple operating systems add the `os` key to your `.travis.yml`:

```yaml
os:
  - linux
  - osx
```
{: data-file=".travis.yml"}

The value of the `$TRAVIS_OS_NAME` variable is set to `linux` or `osx` according to the operating system a particular build is running on, so you can use it to conditionalize your build scripts.

If you are already using a [build matrix](/user/customizing-the-build/#build-matrix) to test multiple versions, the `os` key also multiplies the matrix.

## Operating System differences

When you test your code on multiple operating systems, be aware of differences
that can affect your tests:

- Not all tools may be available on macOS.

  We are still working on building up the toolchain on the [macOS Environment](/user/reference/osx/).
  Missing software may be available via Homebrew.

- Language availability.

  Not all languages are available on all operating systems, and different versions maybe installed on different systems.
  Before you embark on the multi-os testing journey, be sure to check
  this GitHub issue [detailing what languages are available](https://github.com/travis-ci/travis-ci/issues/2320).

- The file system behavior is different.

  The HFS+ file system on our macOS workers is case-insensitive (which is the default for macOS),
  and the files in a directory are returned sorted.
  On Linux, the file system is case-sensitive, and returns directory entries in
  the order they appear in the directory internally.

   Your tests may implicitly rely on these behaviors, and could fail because of them.

- They are different operating systems, after all.

  Commands may have the same name on the Mac and Linux, but they may have different flags,
  or the same flag may mean different things.
  In some cases, commands that do the same thing could have different names.
  These need to be investigated case by case.

## Allowing Failures on Jobs Running on One Operating System

To ignore the results of jobs on one operating system, add the following
to your `.travis.yml`:

```yaml
jobs:
  allow_failures:
    - os: osx
```
{: data-file=".travis.yml"}

## Example Multi OS Build Matrix

Here's an example `.travis.yml` file using if/then directives to customize the [build lifecycle](/user/job-lifecycle/) to use [Graphviz](https://graphviz.gitlab.io/) in both Linux and macOS.

```yaml
language: c

os:
  - linux
  - osx

compiler:
  - gcc
  - clang

addons:
  apt:
    packages:
      - graphviz

before_install:
  - if [ "$TRAVIS_OS_NAME" = "osx" ]; then brew update          ; fi
  - if [ "$TRAVIS_OS_NAME" = "osx" ]; then brew install graphviz; fi

script:
  - cd src
  - make all
```
{: data-file=".travis.yml"}

There are many options available and using the `matrix.include` key is essential to include any specific entries. For example, this matrix would route builds to the [Trusty build environment](/user/reference/trusty/) and to a [macOS image using Xcode 7.2](/user/languages/objective-c#supported-xcode-versions):

```yaml
jobs:
  include:
    - os: linux
      dist: trusty
    - os: osx
      osx_image: xcode7.2
```
{: data-file=".travis.yml"}

### Python example (unsupported languages)

For example, this `.travis.yml` uses the `matrix.include` key to include four specific entries in the build matrix. It also takes advantage of `language: generic` to test Python on macOS. Custom requirements are installed in `./.travis/install.sh` below.

```yaml
language: python

jobs:
  include:
    - os: linux
      python: 3.2
      env: TOXENV=py32
    - os: linux
      python: 3.3
      env: TOXENV=py33
    - os: osx
      language: generic
      env: TOXENV=py32
    - os: osx
      language: generic
      env: TOXENV=py33
install:
    - ./.travis/install.sh
script: make test
```
{: data-file=".travis.yml"}

This custom install script (pseudo code only) uses the `$TRAVIS_OS_NAME` and `$TOXENV` variables to install (Python) prerequisites specific to macOS, Linux and each specific python version.

```bash
#!/bin/bash

if [ $TRAVIS_OS_NAME = 'osx' ]; then

    # Install some custom requirements on macOS
    # e.g. brew install pyenv-virtualenv

    case "${TOXENV}" in
        py32)
            # Install some custom Python 3.2 requirements on macOS
            ;;
        py33)
            # Install some custom Python 3.3 requirements on macOS
            ;;
    esac
else
    # Install some custom requirements on Linux
fi
```

Travis CI then tests the four expanded builds using `make test` automatically.
