---
title: Building on Multiple CPU Architectures
layout: en
permalink: /user/multi-cpu-architectures/
---

> This is a beta stage of this feature and we are [eager to hear back from you](https://travis-ci.community/c/environments/multi-cpu-arch), both for `Arm`-based and `IBM`-based feedback. The definition keys used in the `.travis.yml` file may be further adapted on short notice.
{: .beta}

> `IBM Power` and `IBM Z`-based building is only available for Open Source repositories (at both travis-ci.org and travis-ci.com). While available to all Open Source repositories, the concurrency available for multiple CPU arch-based jobs is limited during the beta period.
>
> An attempt to run `IBM Power` and `IBM Z`-based builds for a private repository will result in a build run on standard, `AMD`-based infrastructure. For any commercial queries with regards to multi-arch builds before they are available, please [contact us](mailto:support@travis-ci.com).
>
> `Arm`-based building on `Arm64` CPU  is only available for Open Source repositories (at both travis-ci.org and travis-ci.com). While available to all Open Source repositories, the concurrency available for multiple CPU arch-based jobs is limited during the beta period. 
>
> `Arm`-based building on `Arm64 Graviton2` CPU now supports both Open Source and commercial projects. The total concurrency capacity is limited, but may adjusted based on the demand.

## Multi CPU availaibility

If your code is used on multiple CPU architectures it probably should be tested on multiple CPU architectures. Travis CI can test on 

* `amd64`, 
* `ppc64le` (IBM Power CPUs), 
* `s390x` (IBM Z CPUs), 
* `arm64` (run on ARMv8 compliant CPUs) 
* `arm64-graviton2` (new gen of ARMv8 compliant CPUs on AWS, available only on [travis-ci.com](https://travis-ci.com)) 

if the operating system is Linux. The table below gives a brief perspective about the CPU and project type combinations:

| Architecture            | Open Source   | Commercial    | Available on travis-ci.* |
| :-----------------------| :------------ | :------------ | :------------|
| `amd64`                 | Yes           | Yes           | .org & .com  |
| `ppc64le`.              | Yes           | No            | .org & .com  |
| `s390x`                 | Yes           | No            | .org & .com  |
| `arm64` (v8)            | Yes           | No            | .org & .com  |
| `arm64-graviton2` (v8)  | Yes           | Yes           | .com only    |

The two `arm64` tags are used right now to distinguish between OSS-support only (`arch: arm64`) and available both for OSS & commercial (`arch: arm64-graviton2`, available only on travis-ci.com). 

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
  - arm64  # please note arm64-graviton2 requires explicit virt: [lxd|vm] tag so it's recommended for jobs.include, see below
os: linux  # different CPU architectures are only supported on Linux
```
{: data-file=".travis.yml"}

If you are already using a [build matrix](/user/customizing-the-build/#build-matrix) to test multiple versions, the `arch` key also multiplies the matrix.

- The `ppc64le` (IBM Power) and `s390x` (IBM Z) build jobs are run in an LXD compliant Linux OS image. 
- The `arm64` CPU architecture build job is run in an LXD compliant Linux OS image.
- The `arm64-graviton2` architecture builds can be run on both LXD and regular 'full VM' environments. You **need** to explicitely set the target environment by using `virt` key. A `virt: vm` routes build jobs to a full virtual machine setup while `virt: lxd` routes build jobs to an LXD container setup. 
- The default LXD image supported by Travis CI is Ubuntu Xenial 16.04 and by using `dist` you can select different supported LXD images. Also see our [CI Environment Overview - Virtualisation Environment vs Operating System](https://docs.travis-ci.com/user/reference/overview/#virtualisation-environment-vs-operating-system) documentation. The LXD host, on which LXD-based builds are run, is on Ubuntu 18.04.
- The amd64 CPU architecture build job currently runs as a regular 'full VM' and will be transitioned to an LXD compliant Linux OS image usage over time.

## Example Multi Architecture Build Matrix

Here’s an example of a `.travis.yml` file using the `arch` key to compile against `amd64`, `arm64`, `arm64-graviton2`, `ppc64le` (IBM Power) and `s390x` (IBM Z) under Linux and using C as the programming language. 

```yaml
language: c

arch:
  - amd64
  - arm64  # please note arm64-graviton2 requires explicit virt: [lxd|vm] tag so it's recommended for jobs.include, see below
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
   - os: linux
     arch: arm64-graviton2
     virt: lxd
     group: edge
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


## LXD related limitations

For more details see [Build Environment Overview](/user/reference/overview/#linux-security-and-lxd-container).
