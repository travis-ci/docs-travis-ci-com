---
title: Building a C++ Project
layout: en
permalink: /user/languages/cpp/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to C++ projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

## CI environment for C++ Projects

Travis CI VMs are 64-bit and provide versions of:

 * gcc
 * clang
 * core GNU build toolchain (autotools, make), cmake, scons

C++ projects on travis-ci.org assume you use Autotools and Make by default.

For precise versions on the VM, please consult "Build system information" in the build log.


## Dependency Management

Because there is no dominant convention in the community about dependency management, Travis CI skips dependency installation for C++ projects.

If you need to perform special tasks before your tests can run, override the `install:` key in your `.travis.yml`:

    install: make get-deps

See [general build configuration guide](/user/customizing-the-build/) to learn more.



## Default Test Script

Because C++ projects on travis-ci.org assume Autotools and Make by default, naturally, the default command Travis CI will use to
run your project test suite is

    ./configure && make && make test

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: cpp

This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide. For example, to build
by running Scons without arguments, override the `script:` key in `.travis.yml` like this:

    script: scons


## Choosing compilers to test against

It is possible to test projects against either GCC or Clang, or both. To do so, specify the compiler to use using the `compiler:` key
in `.travis.yml`. For example, to build with Clang:

    compiler: clang

or both GCC and Clang:

    compiler:
      - clang
      - gcc

Testing against two compilers will create (at least) 2 rows in your build matrix. For each row, the Travis CI C++ builder will export the `CXX` env variable to point to either `g++` or `clang++` and `CC` to either `gcc` or `clang`.


## Build Matrix

For C++ projects, `env` and `compiler` can be given as arrays
to construct a build matrix.


## Examples

 * [Rubinius](https://github.com/rubinius/rubinius/blob/master/.travis.yml)

## Hints

### OpenMP projects

OpenMP projects should set the environment variable `OMP_NUM_THREADS` to a reasonably small value (say, 4).
OpenMP detects the cores on the hosting hardware, rather than the VM on which your tests run.

### MPI projects

The default environment variables `$CC` and `$CXX` are known to interfere with MPI projects.
In this case, we recommend unsetting it:

```yaml
before_install:
  - test -n $CC  && unset CC
  - test -n $CXX && unset CXX
```

### Modern C++ and Compiler Versioning

If you need a more modern toolchain or more granular control over your tools, you will have to handle that yourself. Fortunately, the community has already whitelisted the [repositories](https://github.com/travis-ci/apt-source-whitelist/blob/master/ubuntu.json) and [packages](https://github.com/travis-ci/apt-package-whitelist/blob/master/ubuntu-precise) necessary for such upgrades.

#### GCC on Linux

Ubuntu 12.04 shipped with GCC 4.6.3 and Ubuntu 14.04 shipped with GCC 4.8.2. If you need a more recent version (if you are working with C++11, you *must* do this; support for C++11 was not finished until GCC 4.9), you will want to follow these directions:

```yaml
matrix:
  include:
    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-4.9
      env:
         - MATRIX_EVAL="CXX=g++-4.9"

    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-5
      env:
         - MATRIX_EVAL="CXX=g++-5"

    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-6
      env:
        - MATRIX_EVAL="CXX=g++-6"

before_install:
    - eval "${MATRIX_EVAL}"
```

#### GCC on OSX

```yaml
matrix:
  include:
    - os: osx
      osx_image: xcode8
      env:
        - MATRIX_EVAL="CC=gcc-4.9 && CXX=g++-4.9"

    - os: osx
      osx_image: xcode8
      env:
        - MATRIX_EVAL="brew install gcc5 && CC=gcc-5 && CXX=g++-5"

    - os: osx
      osx_image: xcode8
      env:
        - MATRIX_EVAL="brew install gcc && CC=gcc-6 && CXX=g++-6"

before_install:
    - eval "${MATRIX_EVAL}"
```

#### LLVM

Be warned that the LLVM-Travis ecosystem [has faced some stability problems for over a year now](https://github.com/travis-ci/apt-source-whitelist/issues/156).

```yaml
matrix:
  include:
    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
            - llvm-toolchain-precise-3.6
          packages:
            - clang-3.6
      env:
        - MATRIX_EVAL="CC=clang-3.6 && CXX=clang++-3.6"

    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
            - llvm-toolchain-precise-3.7
          packages:
            - clang-3.7
      env:
        - MATRIX_EVAL="CC=clang-3.7 && CXX=clang++-3.7"

    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
            - llvm-toolchain-precise-3.8
          packages:
            - clang-3.8
      env:
        - MATRIX_EVAL="CC=clang-3.8 && CXX=clang++-3.8"

before_install:
    - eval "${MATRIX_EVAL}"
```

On OSX, the version of `clang` is controlled by the choice of `osx_image`.

#### CMake

To upgrade `cmake` (note that the most recent verison of `cmake` that has been backported is 3.2), add the following to each `apt` addon which requires it:

```yaml
addons:
  apt:
    sources:
      - george-edison55-precise-backports
    packages:
      - cmake-data
      - cmake
```

On OSX, the version of `cmake` is controlled by the choice of `osx_image`.
