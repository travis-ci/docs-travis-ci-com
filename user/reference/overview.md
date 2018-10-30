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

### Linux Ennvironments

A full virtual machine per build, that runs Linux, either [Ubuntu Precise 12.04](/user/reference/precise/) or [Ubuntu Trusty 14.04](/user/reference/trusty/).

### OS X

An [OS X](/user/reference/osx/) environment for Objective-C and other OS X specific projects

### Windows

A [Windows](/user/reference/windows/) environment running Windows Server 2016.

### Virtualisation Environment vs Operating System

The following table summarizes the differences across virtual environments and operating systems:

|                      | [Ubuntu Precise](/user/reference/precise) | [Ubuntu Trusty](/user/reference/trusty) | [OS X](/user/reference/osx/) | [Windows](/user/reference/windows) |
|:---------------------|:------------------------------------------|:----------------------------------------|:-----------------------------|:-----------------------------------|
| Name                 | Precise                                   | Ubuntu                                  | OS X                         | Windows                            |
| Status               | Current                                   | Current                                 | Current                      | Early release                      |
| Infrastructure       | Virtual machine on GCE                    | Virtual machine on GCE                  | Virtual machine              | Virtual machine on GCE             |
| `.travis.yml`        | `dist: precise`                           | `dist: trusty`                          | `os: osx`                    | `os: windows`                      |
| Allows `sudo`        | Yes                                       | Yes                                     | Yes                          | No                                 |
| Approx boot time     | 20-50s                                    | 20-50s                                  | 60-90s                       | 60-120s                            |
| File system          | EXT4                                      | EXT4                                    | HFS+                         | NTFS                               |
| Operating system     | Ubuntu 12.04                              | Ubuntu 14.04                            | OS X                         | Windows Server 2016                |
| Memory               | 7.5 GB                                    | 7.5 GB                                  | 4 GB                         | 8 GB                               |
| Cores                | 2                                         | 2                                       | 2                            | 2                                  |
| IPv4 network         | IPv4 is available                         | IPv4 is available                       | IPv4 is available            | IPv4 is available                  |
| IPv6 network         | IPv6 is not available                     | IPv6 is not available                   | IPv6 is not available        | IPv6 is not available              |
| Available disk space | approx 22GB                               | approx 18GB                             | approx 41GB                  | approx 19 GB                       |

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

### For a particular .travis.yml configuration

Many different parts of your `.travis.yml` affect what infrastructure your build runs on.
The following list describes some of the main settings that determine build routing:

* Any of the following settings related to docker route your build to a Ubuntu Trusty linux  virtual machine running on Google Cloud Engine.

  - `services: docker`
  - *any* other `sudo` command in your build script
  - *any* other `docker` command in your build script

* Using `os: osx`, setting a version of Xcode using `osx_image:`, or using a macOS specific language such as `language: objective-c` routes your build to macOS infrastructure.

* Using `os: windows` routes your build to Windows infrastructure.

> Between middle of October 2018 and end December 2018 the default infrastructure
> your builds runs on will depend on a [few different
> factors](https://blog.travis-ci.com/2018-10-04-combining-linux-infrastructures)
> while we consolidate everything onto virtual machines running on Google CLoud Engine.

## Deprecated Virtualization Environments

Historically, Travis CI has provided the following virtualization environments.

- **Trusty Container-based environment**
- **Precise Container-based environment**: available from the announcement in [December, 2014](https://blog.travis-ci.com/2014-12-17-faster-builds-with-container-based-infrastructure/) to [September, 2017](https://blog.travis-ci.com/2017-08-31-trusty-as-default-status).
- **Legacy environment**: was available until [December, 2015](https://blog.travis-ci.com/2015-11-27-moving-to-a-more-elastic-future).
