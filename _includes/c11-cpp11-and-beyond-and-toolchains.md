## C11/C++11 (and Beyond) and Toolchain Versioning

If your project requires tools compatible with C11, C++11, or a more recent language standard, then it is likely that you will have to upgrade your compiler and/or build tools. This section covers specifically how to upgrade GCC, clang, and cmake; for other dependencies please see [Installing Dependencies](/user/installing-dependencies/).

### GCC on Linux

Ubuntu 12.04 ships with GCC 4.6.3 and Ubuntu 14.04 ships with GCC 4.8.2.

Note that [GCC support for ISO C11 reached a similar level of completeness as ISO C99 in 4.9](https://gcc.gnu.org/wiki/C11Status) and that C++11 is feature-complete in 4.8.1, but [support for `<regex>` does not exist until 4.9](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53631).

To upgrade GCC to a more recent version, you will have to install the appropriate version from the `ubuntu-toolchain-r-test` source; see below for examples:

```yaml
matrix:
  include:
    # works on Precise and Trusty
    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-4.9
      env:
         - MATRIX_EVAL="CC=gcc-4.9 && CXX=g++-4.9"

    # works on Precise and Trusty
    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-5
      env:
         - MATRIX_EVAL="CC=gcc-5 && CXX=g++-5"

    # works on Precise and Trusty
    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-6
      env:
        - MATRIX_EVAL="CC=gcc-6 && CXX=g++-6"

    # works on Precise and Trusty
    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-7
      env:
        - MATRIX_EVAL="CC=gcc-7 && CXX=g++-7"

before_install:
    - eval "${MATRIX_EVAL}"
```
{: data-file=".travis.yml"}

### GCC on OS X

On OS X, `gcc` is an alias for `clang`, and `g++` is an alias for `clang++`.
So you must set CC and CXX to specific `gcc`/`g++` versions:

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
        - MATRIX_EVAL="brew install gcc6 && CC=gcc-6 && CXX=g++-6"

    - os: osx
      osx_image: xcode8
      env:
        - MATRIX_EVAL="brew install gcc && CC=gcc-7 && CXX=g++-7"

before_install:
    - eval "${MATRIX_EVAL}"
```
{: data-file=".travis.yml"}

### Clang

Ubuntu 12.04 ships with Clang 3.4 and Ubuntu 14.04 ships with Clang 3.5.0.

Note that [C++11 support is complete starting from Clang 3.3](http://clang.llvm.org/cxx_status.html).

To upgrade Clang to a more recent version, you will have to install the appropriate version from a `llvm-toolchain-*` source (the `ubuntu-toolchain-r-test` source must also be pulled in for dependency resolution); see below for examples:

```yaml
matrix:
  include:
    # works on Precise and Trusty
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

    # works on Precise and Trusty
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

    # works on Precise and Trusty
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

    # works on Trusty
    - os: linux
      addons:
        apt:
          sources:
            - llvm-toolchain-trusty-3.9
          packages:
            - clang-3.9
      env:
        - MATRIX_EVAL="CC=clang-3.9 && CXX=clang++-3.9"

    # works on Trusty
    - os: linux
      addons:
        apt:
          sources:
            - llvm-toolchain-trusty-4.0
          packages:
            - clang-4.0
      env:
        - MATRIX_EVAL="CC=clang-4.0 && CXX=clang++-4.0"

    # works on Trusty
    - os: linux
      addons:
        apt:
          sources:
            - llvm-toolchain-trusty-5.0
          packages:
            - clang-5.0
      env:
        - MATRIX_EVAL="CC=clang-5.0 && CXX=clang++-5.0"

before_install:
    - eval "${MATRIX_EVAL}"
```
{: data-file=".travis.yml"}

On OS X, the version of `clang` is controlled by the choice of `osx_image`.

#### CMake

Ubuntu 12.04 ships with cmake 2.8.7 and Ubuntu 14.04 ships with cmake 3.9.2.

You can upgrade cmake to 3.2.3 on Precise from the `george-edison55-precise-backports` source (note that the `cmake-data` package contains dependencies which Aptitude does not automatically resolve), c.f.

```yaml
addons:
  apt:
    sources:
      - george-edison55-precise-backports
    packages:
      - cmake-data
      - cmake
```
{: data-file=".travis.yml"}

On OS X, the version of `cmake` is controlled by the choice of `osx_image`.
