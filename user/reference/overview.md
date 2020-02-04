---
title: Build Environment Overview
layout: en
permalink: /user/reference/overview/
redirect_from:
  - /user/ci-environment/
  - /user/migrating-from-legacy/
---

### What This Guide Covers

This guide provides an overview on the different environments in which Travis CI can run your builds, and why you might want to pick one over another.

## Virtualization environments

Each build runs in one of the following virtual environments.

### Linux

A sudo enabled, full virtual machine per build, that runs Linux, one of:

* [Ubuntu Bionic 18.04](/user/reference/bionic/)
* [Ubuntu Xenial 16.04](/user/reference/xenial/) **default**
* [Ubuntu Trusty 14.04](/user/reference/trusty/)
* [Ubuntu Precise 12.04](/user/reference/precise/)

LXD compliant OS images for arm64 are run in [Packet](https://www.packet.com/). Have a look at [Building on Multiple CPU Architectures](/user/multi-cpu-architectures) for more information.

### macOS

A [macOS](/user/reference/osx/) environment for Objective-C and other macOS specific projects

### Windows

A [Windows](/user/reference/windows/) environment running Windows Server, version 1803.

### Virtualisation Environment vs Operating System

The following table summarizes the differences across virtual environments and operating systems:

|                      | Ubuntu Linux  ([Bionic](/user/reference/bionic/), [Xenial](/user/reference/xenial/) , [Trusty](/user/reference/trusty/), [Precise](/user/reference/precise/)) | [macOS](/user/reference/osx/) | [Windows](/user/reference/windows) | Ubuntu Linux / LXD container with ([Bionic](/user/reference/bionic/)), [Xenial](/user/reference/xenial/) |
|:---------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------|:-----------------------------------|:-------------------------------------------------------|
| Name                 | Ubuntu                                                                                                                                                        | macOS                         | Windows                            | Ubuntu                                                 |
| Status               | Current                                                                                                                                                       | Current                       | Early release                      | Early release                                          |
| Infrastructure       | Virtual machine on GCE                                                                                                                                        | Virtual machine               | Virtual machine on GCE             | ARM: LXD container on Packet<br />IBM Power: LXD container on IBM Cloud<br />IBM Z: LXD container on IBM Cloud                             |
| CPU architecture     | amd64                                                                                                                                                         | amd64                         | amd64                              | arm64 (armv8)<br />ppc64le (IBM Power)<br />s390x (IBM Z)                                          |
| `.travis.yml`        | `dist: bionic` or `dist: xenial` or `dist: trusty` or `dist: precise`                                                                                         | `os: osx`                     | `os: windows`                      | `os: linux arch: arm64 dist: bionic` or `os: linux arch: arm64 dist: xenial`or `os: linux arch: ppc64le dist: bionic` or `os: linux arch: ppc64le dist: xenial` or `os: linux arch: s390x dist: bionic` or `os: linux arch: s390x dist: xenial`                              |
| Allows `sudo`        | Yes                                                                                                                                                           | Yes                           | No                                 | Yes                                                    |
| <a name="approx-boot-time"></a>Approx boot time     | 20-50s                                                                                                                                                        | 60-90s                        | 60-120s                            | <10s                                                   |
| File system          | EXT4                                                                                                                                                          | HFS+                          | NTFS                               | EXT4                                                   |
| Operating system     | Ubuntu Linux                                                                                                                                                  | macOS                         | Windows Server 2016                | Ubuntu Linux                                           |
| Memory               | 7.5 GB                                                                                                                                                        | 4 GB                          | 8 GB                               | ~4 GB                                                  |
| Cores                | 2                                                                                                                                                             | 2                             | 2                                  | 2                                                      |
| IPv4 network         | IPv4 is available                                                                                                                                             | IPv4 is available             | IPv4 is available                  | IPv4 is available                                      |
| IPv6 network         | IPv6 is not available                                                                                                                                         | IPv6 is not available         | IPv6 is not available              | IPv6 is available                                      |
| Available disk space | approx 18GB                                                                                                                                                   | approx 41GB                   | approx 40 GB                       | approx 18GB (Arm, IBM Power, IBM Z)                                           |

> Available disk space is approximate and depends on the base image and language selection of your project.
  The best way to find out what is available on your specific image is to run `df -h` as part of your build script.

## What infrastructure is my environment running on?

Usually, knowing the virtualization environment characteristics from the [table above](#virtualisation-environment-vs-operating-system) is sufficient.

But, if you do need more detail, you have one of these two questions:

* you want to see what infrastructure a [finished build](#for-a-finished-build) ran on.
* you want to determine what infrastructure a [particular `.travis.yml` configuration](#for-a-particular-travisyml-configuration) will run on.

### For a finished build

To see what infrastructure a finished build ran on, look at the *hostname* at the top of the build log:

![Infrastructure shown in hostname](/images/ui/what-infrastructure.png "Infrastructure shown in hostname")

if it contains:

* `gce` → the build ran in a virtual machine on Google Compute Engine.
* `wjb` → the build ran on macOS.
* `1803-containers` → the build ran on Windows.
* `lxd-arm64` → the build ran within an LXD container on Arm64-based infrastructure (currently delivered by Packet)
* `lxd-ppc64le` → the build ran within an LXD container on Power-based infrastructure (currently delivered by IBM)
* `lxd-s390x` → the build ran within an LXD container on Z-based infrastructure (currently delivered by IBM)

### For a particular .travis.yml configuration

* Our default infrastructure is an Ubuntu Linux (`os: linux`) virtual machine running on AMD64 architecture (`arch: amd64`), on Google Compute Engine. You can specify which version of Ubuntu using the `dist` key.

* Using `os: osx`, setting a version of Xcode using `osx_image:`, or using a macOS specific language such as `language: objective-c` routes your build to macOS infrastructure.

* Using `os: windows` routes your build to Windows infrastructure.

* Using `arch: arm64` routes your build to Arm-based LXD containers. You can specify which version of Ubuntu using the `dist` key.

* Using `arch: ppc64le` routes your build to IBM Power-based LXD containers. You can specify which version of Ubuntu using the `dist` key.

* Using `arch: s390x` routes your build to IBM Z-based LXD containers. You can specify which version of Ubuntu using the `dist` key.

## Deprecated Virtualization Environments

Historically, Travis CI has provided the following virtualization environments.

- **Trusty Container-based environment**: was available between [July, 2017](https://blog.travis-ci.com/2017-07-11-trusty-as-default-linux-is-coming) and [December, 2018](https://blog.travis-ci.com/2018-10-04-combining-linux-infrastructures).
- **Precise Container-based environment**: was available between [December, 2014](https://blog.travis-ci.com/2014-12-17-faster-builds-with-container-based-infrastructure/) and [September, 2017](https://blog.travis-ci.com/2017-08-31-trusty-as-default-status).
- **Legacy Linux environment**: was available until [December, 2015](https://blog.travis-ci.com/2015-11-27-moving-to-a-more-elastic-future).

If you're trying to use `sudo: false` or `dist: precise` keys in your `travis.yml`, we recommend you remove them and switch to our current [Xenial Linux infrastructure](/user/reference/xenial/).

## Build Config Reference

You can find more information on the build config format for [Operating Systems](https://config.travis-ci.com/ref/os) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).
