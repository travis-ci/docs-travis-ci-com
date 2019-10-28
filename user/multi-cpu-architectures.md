---
title: Building on Multiple CPU Architectures
layout: en
permalink: /user/multi-cpu-architectures/
---

> This is an alpha stage of this feature and we are [eager to hear back from you](https://travis-ci.community/t/about-the-arm-cpu-architecture-category/5336). The definition keys used in the `.travis.yml` file may be further adapted on short notice.
{: .alpha}

> `Arm`-based building is only available for Open Source repositories (at both travis-ci.org and travis-ci.com). While available to all Open Source repositories, the concurrency available for `Arm`-based jobs is limited during the alpha period.
> An attempt to run `Arm`-based build for a private repository will result in a build run on standard, non-`Arm` infrastructure. For any commercial queries with regards to multi-arch builds before they are available, please [contact us](mailto:support@travis-ci.com).

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
jobs:
  include:
   - os: linux
     arch: amd64
   - os: linux
     arch: arm64
```
{: data-file=".travis.yml"}

Please note, that explicitly included builds inherit the first value in an array:

```yaml
arch:
  - amd64
  - arm64
jobs:
  include:
   - os: linux
     env: LIB_PATH="/usr/bin/shared/x86_64/v1"
   - os: linux
     env: LIB_PATH="/usr/bin/shared/x86_64/v2"
```
{: data-file=".travis.yml"}

For example, the above `.travis.yml`, would result in running both jobs with the environmental variable LIB_PATH assigned different values being run only on `amd64` architecture.

## Using Docker in `Arm`-Based Builds within LXD Containers

It is possible to use Docker in `Arm`-based builds within an LXD container. You may need an arm64v8 docker image as a base or ensure arm64 libraries required by your build are added to your Dockerfile. In order to use docker in `Arm`-based build within an LXD container, docker commands must be run with `sudo`.

An example of building a docker image from a Dockerfile adjusted to arm64:

```yaml
arch: arm64
language: c
compiler: gcc
services:
  - docker
script: docker build -t my/test -f Dockerfile.arm64 .
```
{: data-file=".travis.yml"}

An example of running docker image:

```yaml
arch: arm64
services:
  - docker
script: docker run my/test #assuming docker image my/test is arm64v8 ready
```
{: data-file=".travis.yml"}

You can also have a look at [Using Docker in Builds](user/docker/).

## Security and LXD Container

> Due to security reasons, builds run in LXD containers will be denied access to privileged filesystems and paths - a privileged container with write access to e.g. /sys/kernel/debugfs might muddle an LXD host.

As a result, for instance a command in `.travis.yaml` like:
```yaml
sudo docker run --privileged --rm -t -v /sys/kernel/debug:/sys/kernel/debug:rw
```
{: data-file=".travis.yml"}

would result in an error.

Also have a look at the [Github issue relevant to the topic](https://github.com/lxc/lxd/issues/2661) and the [LXD apparmor setup](https://github.com/lxc/lxd/blob/master/lxd/apparmor/apparmor.go) for more details.
