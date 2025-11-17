## C11/C++11 (and Beyond) and Toolchain Versioning

If your project requires tools compatible with C11, C++11, or a more recent language standard, you will likely need to upgrade your compiler and/or build tools. This section covers specifically how to upgrade GCC, clang, and cmake; for other dependencies, please see [Installing Dependencies](/user/installing-dependencies/).

### GCC on Linux

* [Xenial](/user/reference/xenial/) ships with GCC 5.4.0
* [Bionic](/user/reference/bionic/) ships with GCC 7.4.0
* [Focal](/user/reference/focal/) ships with GCC 9.4.0
* [Jammy](/user/reference/jammy/) ships with GCC 11.4.0
* [Noble](/user/reference/noble/) ships with GCC 13.3.0

Note that [GCC support for ISO C11 reached a similar level of completeness as ISO C99 in 4.9](https://gcc.gnu.org/wiki/C11Status) and that C++11 is feature-complete in 5.1 (the C++ language support was feature-complete in 4.8.1 but the standard library didn't support all C++11 features until [later](https://gcc.gnu.org/gcc-5/changes.html#libstdcxx), in particular [support for `<regex>` does not exist until 4.9](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53631)).

To upgrade GCC to a more recent version, you will have to install the appropriate version from the `ubuntu-toolchain-r-test` source; see below for examples:

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
         - MATRIX_EVAL="CC=gcc-4.9 && CXX=g++-4.9"

    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-5
      env:
         - MATRIX_EVAL="CC=gcc-5 && CXX=g++-5"

    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - g++-6
      env:
        - MATRIX_EVAL="CC=gcc-6 && CXX=g++-6"

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

### GCC on FreeBSD

Travis CI FreeBSD image ships with GCC 10.0.0 (it's not in the base system by default).

To upgrade GCC to a more recent version, install the appropriate version from packages; see below for examples:

```yaml
os: freebsd
addons:
    pkg:
      - gcc10
    env:
      - CC=gcc10
      - CXX=g++10
```
{: data-file=".travis.yml"}

### Clang on Linux

* [Xenial](/user/reference/xenial/) ships with Clang 7
* [Bionic](/user/reference/bionic/) ships with Clang 18.1.8
* [Focal](/user/reference/focal/) ships with Clang 18.1.8
* [Jammy](/user/reference/jammy/) ships with Clang 18.1.8
* [Noble](/user/reference/noble/) ships with Clang 18.1.3

To upgrade Clang to a more recent version, it is necessary to install the appropriate version from a `llvm-toolchain-*` source (the `ubuntu-toolchain-r-test` source must also be pulled in for dependency resolution); see below for a Focal example:

```yaml
matrix:
  include:
    - os: linux
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
            - llvm-toolchain-focal-18
          packages:
            - clang-18
      env:
        - MATRIX_EVAL="CC=clang-18 && CXX=clang++-18"
```
{: data-file=".travis.yml"}


### Clang on FreeBSD

> Clang is the default compiler on FreeBSD.

FreeBSD ships with Clang 8.0.1.

To upgrade Clang to a more recent version, install the appropriate version from packages; see below for examples:

```yaml
os: freebsd
addons:
    pkg:
      - llvm90
    env:
      - CC=/usr/local/bin/clang90    # llvm90 installs it to /usr/local/bin/clang90
      - CXX=/usr/local/bin/clang++90 # llvm90 installs it to /usr/local/bin/clang++90
```
{: data-file=".travis.yml"}

> Clang is the default compiler on FreeBSD.

#### CMake

* [Bionic](/user/reference/bionic/) ships with CMake 3.26.3
* [Focal](/user/reference/focal/) ships with Clang 4.2.0
* [Jammy](/user/reference/jammy/) ships with Clang 4.2.0
* [Noble](/user/reference/noble/) ships with Clang 4.1.2
* [FreeBSD](/user/reference/freebsd/) ships with CMake 3.15.5

