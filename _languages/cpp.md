---
title: Building a C++ Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to C++ projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

## CI environment for C++ Projects

Travis CI VMs are 64-bit and provide versions of:

- gcc
- clang
- core GNU build toolchain (autotools, make), cmake, scons

C++ projects on travis-ci.org assume you use Autotools and Make by default.

For precise versions on the VM, please consult "Build system information" in the build log.

## Dependency Management

Because there is no dominant convention in the community about dependency management, Travis CI skips dependency installation for C++ projects.

If you need to perform special tasks before your tests can run, override the `install:` key in your `.travis.yml`:

```yaml
install: make get-deps
```

See [general build configuration guide](/user/customizing-the-build/) to learn more.

## Default Test Script

Because C++ projects on travis-ci.org assume Autotools and Make by default, naturally, the default command Travis CI will use to
run your project test suite is

```bash
./configure && make && make test
```

Projects that find this sufficient can use a very minimalistic .travis.yml file:

```yaml
language: cpp
```

This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide. For example, to build
by running Scons without arguments, override the `script:` key in `.travis.yml` like this:

```yaml
script: scons
```

## Choosing compilers to test against

It is possible to test projects against either GCC or Clang, or both. To do so, specify the compiler to use using the `compiler:` key
in `.travis.yml`. For example, to build with Clang:

```yaml
compiler: clang
```

or both GCC and Clang:

```yaml
compiler:
  - clang
  - gcc
```

Testing against two compilers will create (at least) 2 rows in your build matrix. For each row, the Travis CI C++ builder will export the `CXX` env variable to point to either `g++` or `clang++` and `CC` to either `gcc` or `clang`.

## Build Matrix

For C++ projects, `env` and `compiler` can be given as arrays
to construct a build matrix.

## Examples

- [Rubinius](https://github.com/rubinius/rubinius/blob/master/.travis.yml)

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

{% include c11-cpp11-and-beyond-and-toolchains.md %}
