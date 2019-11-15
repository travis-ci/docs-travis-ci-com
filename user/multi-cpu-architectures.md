---
title: Building on Multiple CPU Architectures
layout: en
permalink: /user/multi-cpu-architectures/
---

> This is an alpha stage of this feature and we are [eager to hear back from you](https://travis-ci.community/c/environments/multi-cpu-arch), both for `Arm`-based and `IBM`-based feedback. The definition keys used in the `.travis.yml` file may be further adapted on short notice.
{: .alpha}

> `IBM Power`, `IBM Z` and `Arm`-based building is only available for Open Source repositories (at both travis-ci.org and travis-ci.com). While available to all Open Source repositories, the concurrency available for multiple CPU arch-based jobs is limited during the alpha period.
> An attempt to run `IBM Power`, `IBM Z` and `Arm`-based builds for a private repository will result in a build run on standard, `AMD`-based infrastructure. For any commercial queries with regards to multi-arch builds before they are available, please [contact us](mailto:support@travis-ci.com).

If your code is used on multiple CPU architectures it probably should be tested on multiple CPU architectures. Travis CI can test on amd64, ppc64le (IBM Power CPUs), s390x (IBM Z CPUs) and arm64 (run on ARMv8 compliant CPUs) if the operating system is Linux.

## Default CPU Architecture

The default CPU architecture used in Travis CI builds is `amd64`. It is used when no `arch` key is present. 

## Identifying CPU Architecture of Build Jobs

You can identify for which CPU architecture a build job is run via

- GUI
  - in the build job list, there's a specific label and architecture name based on `arch` tag value
  - in the build job view, the same specific label is displayed near the operating system identifier
- A default environmental variable printed out during your build job: `$TRAVIS_CPU_ARCH` (for a complete list of available default environmental variables please see our [Environment Variables - Default Environment Variables](https://docs.travis-ci.com/user/environment-variables/#default-environment-variables) documentation. 


## Testing on Multiple CPU Architectures

To enable testing on multiple CPU architectures add the `arch` key to your `.travis.yml`:

```yaml
arch:
  - amd64
  - ppc64le
  - s390x
  - arm64
os: linux  # different CPU architectures are only supported on Linux
```
{: data-file=".travis.yml"}

If you are already using a [build matrix](/user/customizing-the-build/#build-matrix) to test multiple versions, the `arch` key also multiplies the matrix.

- The ppc64le (IBM Power) and s390x (IBM Z) build jobs are run in an LXD compliant Linux OS image. 
- The arm64 CPU architecture build job is run in an LXD compliant Linux OS image.
- The default LXD image supported by Travis CI is Ubuntu Xenial 16.04 and by using `dist` you can select different supported LXD images. Also see our [CI Environment Overview - Virtualisation Environment vs Operating System](https://docs.travis-ci.com/user/reference/overview/#virtualisation-environment-vs-operating-system) documentation. The LXD host, on which LXD-based builds are run, is on Ubuntu 18.04.
- The amd64 CPU architecture build job currently runs as a regular VM and will be transitioned to an LXD compliant Linux OS image usage over time.

## Example Multi Architecture Build Matrix

Here’s an example of a `.travis.yml` file using the `arch` key to compile against `amd64`, `arm64`, `ppc64le` (IBM Power), `s390x` (IBM Z) under Linux and using C as the programming language. 

```yaml
language: c

arch:
  - amd64
  - arm64
  - ppc64le
  - s390x

compiler:
  - gcc
  - clang

install: skip

script:
  - cd src
  - make all
```
{: data-file=".travis.yml"}

The `.travis.yml` file above creates a 2x4 [build matrix](/user/customizing-the-build/#build-matrix): compilers x each architecture.

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

Similarly, this matrix would route builds to the `ppc64le` (IBM Power) and `s390x` (IBM Z) architecture environments:

```yaml
jobs:
  include:
   - os: linux
     arch: ppc64le
   - os: linux
     arch: s390x
```
{: data-file=".travis.yml"}

Please note, that explicitly included builds inherit the first value in an array:

```yaml
arch:
  - amd64
  - arm64
  - ppc64le
  - s390x
jobs:
  include:
   - os: linux
     env: LIB_PATH="/usr/bin/shared/x86_64/v1"
   - os: linux
     env: LIB_PATH="/usr/bin/shared/x86_64/v2"
```
{: data-file=".travis.yml"}

For example, the above `.travis.yml`, would result in running both jobs with the environmental variable LIB_PATH assigned different values being run only on `amd64` architecture.

## Using Docker in Multiple CPU Architecture-Based Builds within LXD Containers

It is possible to use Docker in multiple CPU architecture-based builds within an LXD container. You may need a specific CPU architecture compliant docker image as a base or ensure relevant libraries required by your build are added to your Dockerfile.

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

You can try it out also for `ppc64le` (IBM Power) and `s390x` (IBM Z) based docker builds, assuming all dependencies and/or a CPU architecture compliant base docker image are used.

You can also have a look at [Using Docker in Builds](user/docker/).

## Security and LXD Container

### Access to Privileged fs/Features (Apparmor)

> Due to security reasons, builds run in LXD containers will be denied access to privileged filesystems and paths - a privileged container with write access to e.g. /sys/kernel/debugfs might muddle an LXD host.

As a result, for instance a command in `.travis.yaml` like:
```yaml
sudo docker run --privileged --rm -t -v /sys/kernel/debug:/sys/kernel/debug:rw
```
{: data-file=".travis.yml"}

would result in an error.

Also have a look at the [Github issue relevant to the topic](https://github.com/lxc/lxd/issues/2661) and the [LXD apparmor setup](https://github.com/lxc/lxd/blob/master/lxd/apparmor/apparmor.go) for more details.

### System Calls Interception


If you run into a message like:

> System doesn't support syscall interception

It most probably means a system call interception is outside of the list of the ones considered to be safe (LXD can allow system call interception [if it's considered to be safe](https://github.com/lxc/lxd/blob/master/doc/syscall-interception.md)). 

## Hugepages Support from within LXD Container

A build job can’t enable hugepages within an LXD container - this is something that may change in the future, yet it depends on potential Linux kernel changes, which is something that needs to be reviewed and developed.
