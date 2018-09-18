---
title: Building a C++ Project
layout: en

---

<div id="toc">
</div>

## What This Guide Covers

<aside markdown="block" class="ataglance">

| C++                                         | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#Dependency-Management) | N/A                                       |
| [Default `script`](#Default-Build-Script)   | `./configure && make && make test`        |
| [Matrix keys](#Build-Matrix)                | `env`, `compiler`                         |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
language: cpp
```

</aside>

{{ site.data.snippets.trusty_note }}

This guide covers build environment and configuration topics specific to C++
projects. Please make sure to read our [Getting Started](/user/getting-started/)
and [general build configuration](/user/customizing-the-build/) guides first.

## CI environment for C++ Projects

Travis CI VMs are 64-bit and provide versions of:

- gcc
- clang
- core GNU build toolchain (autotools, make), cmake, scons

C++ projects on Travis CI assume you use Autotools and Make by default.

For precise versions on the VM, please consult "Build system information" in the build log.

## Dependency Management

Because there is no dominant convention in the community about dependency
management, Travis CI skips dependency installation for C++ projects.

If you need to install dependencies before your tests can run, override the
`install:` key in your `.travis.yml`:

```yaml
install: make get-deps
```
{: data-file=".travis.yml"}

See [build configuration guide](/user/customizing-the-build/) to learn more.

## Default Build Script

The default build command is:


```bash
./configure && make && make test
```

Projects that find this sufficient can use a very minimalistic `.travis.yml` file:

```yaml
language: cpp
```
{: data-file=".travis.yml"}

You can change the build script as described in the [build
configuration](/user/customizing-the-build/) guide:

```yaml
script: scons
```
{: data-file=".travis.yml"}

## Choosing compilers to test against

You can test projects against either GCC or Clang, or both. To do so,
specify the compiler to use using the `compiler:` key in `.travis.yml`. For
example, to build with Clang:

```yaml
compiler: clang
```
{: data-file=".travis.yml"}

or both GCC and Clang:

```yaml
compiler:
  - clang
  - gcc
```
{: data-file=".travis.yml"}

Testing against two compilers will create (at least) 2 rows in your build
matrix. For each row, the Travis CI C++ builder will export the `CXX` env
variable to point to either `g++` or `clang++` and `CC` to either `gcc` or
`clang`.

On OS X, `gcc` is an alias for `clang`, and `g++` is an alias for `clang++`.
Set a specific [GCC version](#gcc-on-os-x) to use GCC on OS X.

## Build Matrix

For C++ projects, `env` and `compiler` can be given as arrays
to construct a build matrix.

## Examples

- [Rubinius](https://github.com/rubinius/rubinius/blob/master/.travis.yml)

## OpenMP projects

OpenMP projects should set the environment variable `OMP_NUM_THREADS` to a reasonably small value (say, 4).
OpenMP detects the cores on the hosting hardware, rather than the VM on which your tests run.

## MPI projects

The default environment variables `$CC` and `$CXX` are known to interfere with MPI projects.
In this case, we recommend unsetting it:

```yaml
before_install:
  - test -n $CC  && unset CC
  - test -n $CXX && unset CXX
```
{: data-file=".travis.yml"}

{% include c11-cpp11-and-beyond-and-toolchains.md %}
