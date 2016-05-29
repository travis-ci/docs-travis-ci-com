---
title: Testing Your Project on Multiple Operating Systems
layout: en
permalink: /user/multi-os/
---

> The feature described in this document is considered beta.
Some features may not work as described.

If your code is used on multiple operating systems it probably should be tested on
multiple operating systems. Travis CI can test on Linux and OS X.

To enable testing on multiple operating systems add the `os` key to your `.travis.yml`:

```yaml
os:
  - linux
  - osx
```

The value of the `$TRAVIS_OS_NAME` variable is set to `linux` or `osx` according to the operating system a particular build is running on, so you can use it to conditionalize your build scripts.

If you are already using a [build matrix](/user/customizing-the-build/#Build-Matrix) to test multiple versions, the `os` key also multiplies the matrix.

## Operating System differences

When you test your code on multiple operating systems, be aware of differences
that can affect your tests:

* Not all tools may be available on OS X.

  We are still working on building up the toolchain on the [OS X Environment](/user/osx-ci-environment/).
  Missing software may be available via Homebrew.

* Language availability.

  Not all languages are available on all operating systems, and different versions maybe installed on different systems.
  Before you embark on the multi-os testing journey, be sure to check
  this GitHub issue [detailing what languages are available](https://github.com/travis-ci/travis-ci/issues/2320).

* The file system behavior is different.

  The HFS+ file system on our OS X workers is case-insensitive (which is the default for OS X),
  and the files in a directory are returned sorted.
  On Linux, the file system is case-sensitive, and returns directory entries in
  the order they appear in the directory internally.

   Your tests may implicitly rely on these behaviors, and could fail because of them.

* They are different operating systems, after all.

  Commands may have the same name on the Mac and Linux, but they may have different flags,
  or the same flag may mean different things.
  In some cases, commands that do the same thing could have different names.
  These need to be investigated case by case.

## Allowing Failures on Jobs Running on One Operating System

To ignore the results of jobs on one operating system, add the following
to your `.travis.yml`:

```yaml
matrix:
  allow_failures:
    - os: osx
```

## Example Multi OS Build Matrix

Here's an example `.travis.yml` file using if/then directives to customize the [build lifecycle](/user/customizing-the-build/#The-Build-Lifecycle) to use [Graphviz](http://www.graphviz.org/) in both Linux and OS X.

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

before install:
  - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then brew update          ; fi
  - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then brew install graphviz; fi

script:
  - cd src
  - make all
```

There are many options available and using the `matrix.include` key is essential to include any specific entries. For example, this matrix would route builds to the [Trusty beta build environment](/user/trusty-ci-environment/) and to an [OS X image using Xcode 7.2](https://docs.travis-ci.com/user/languages/objective-c#Supported-OS-X-iOS-SDK-versions):

```yaml
matrix:
  include:
    - os: linux
      dist: trusty
      sudo: required
    - os: osx
      osx_image: xcode7.2
```

### Python example (unsupported languages)

For example, this `.travis.yml` uses the `matrix.include` key to include four specific entries in the build matrix. It also takes advantage of `language: generic` to test Python in OS X. Custom requirements are installed in `./.travis/install.sh` below.

```yaml

language: python

matrix:
    include:
        - os: linux
          sudo: required
          python: 3.2
          env: TOXENV=py32
        - os: linux
          sudo: required
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
This custom install script (pseudo code only) uses the `$TRAVIS_OS_NAME` and `$TOXENV` variables to install (Python) prerequisites specific to OS X, Linux and each specific python version.

```bash
#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    # Install some custom requirements on OS X
    # e.g. brew install pyenv-virtualenv

    case "${TOXENV}" in
        py32)
            # Install some custom Python 3.2 requirements on OS X
            ;;
        py33)
            # Install some custom Python 3.3 requirements on OS X
            ;;
    esac
else
    # Install some custom requirements on Linux
fi
```

Travis CI then tests the four expanded builds using `make test` automatically.
