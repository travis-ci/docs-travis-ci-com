---
title: Building on Multiple CPU Architectures
layout: en
permalink: /user/multi-cpu-architectures/
---

> This is an alpha stage of this feature and we are [eager to hear back from you](https://travis-ci.community/t/about-the-arm-cpu-architecture-category/5336). The definition keys used in the `.travis.yml` file may be further adapted on short notice.
{: .alpha}

> `Arm`-based building is only available for Open Source repositories (at both travis-ci.org and travis-ci.com). While available to all Open Source repositories, the concurrency available for `Arm`-based jobs is limited during the alpha period.
> An attempt to run `Arm`-based build for a private repository will result in a build run on standard, non-`Arm` infrastructure. For any commercial queries with regards to multi-arch builds before they are available, please contact [us](support@travis-ci.com).

If your code is used on multiple CPU architectures it probably should be tested on multiple CPU architectures. Travis CI can test on amd64 and arm64 (run on ARMv8 compliant CPUs) if the operating system is Linux.

To enable testing on multiple CPU architectures add the `arch` key to your `.travis.yml`:

```yaml
arch:
  - amd64
  - arm64
os: linux  # different CPU architectures are only supported on Linux
```
{: data-file=".travis.yml"}

If you are already using a [build matrix](/user/customizing-the-build/#build-matrix) to test multiple versions, the `arch` key also multiplies the matrix.

- The arm64 CPU architecture build job is run in an LXD compliant Linux OS image. The default image supported by Travis CI is Ubuntu Bionic 18.04.

- The amd64 CPU architecture build job currently runs as a regular VM and will be transitioned to an LXD compliant Linux OS image usage over time.

## Example Multi Architecture Build Matrix

Here’s an example of a `.travis.yml` file using the `arch` key to compile against both `amd64` and `arm64` under Linux and using C as the programming language.

```yaml
language: c

arch:
  - amd64
  - arm64

compiler:
  - gcc
  - clang

install: skip

script:
  - cd src
  - make all
```
{: data-file=".travis.yml"}

The `.travis.yml` file above creates a 2x2 [build matrix](/user/customizing-the-build/#build-matrix): compilers x each architecture.

There are many options available and using the `matrix.include` key is essential to include any specific entries. For example, this matrix would route builds to the arm64 and amd64 architecture environments:

```yaml
matrix:
  include:
   - os: linux
     arch: amd64
   - os: linux
     arch: arm64
```

Please note, that explicitly included builds inherit the first value in an array:

```yaml
arch:
  - amd64
  - arm64
matrix:
  include:
   - os: linux
     env: LIB_PATH="/usr/bin/shared/x86_64/v1"
   - os: linux
     env: LIB_PATH="/usr/bin/shared/x86_64/v2"
```

For example, the above `.travis.yml`, would result in running both jobs with the environmental variable LIB_PATH assigned different values being run only on `amd64` architecture.
