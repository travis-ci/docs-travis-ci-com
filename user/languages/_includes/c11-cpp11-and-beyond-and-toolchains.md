### C11/C++11 (and Beyond) and Toolchain Versioning

If your project requires tools compatible with C11, C++11, or a more recent language standard, then it is likely that you will have to upgrade your compiler and/or build tools. This section covers specifically how to upgrade GCC, clang, and cmake; for other dependencies please see [Installing Dependencies](/user/installing-dependencies/).

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
