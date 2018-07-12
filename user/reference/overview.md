---
title: Build Environment Overview
layout: en
permalink: /user/reference/overview/
redirect_from:
  - /user/ci-environment/
  - /user/migrating-from-legacy/
---

### What This Guide Covers

This guide provides an overview on the different environments in which
Travis CI can run your builds, and why you might want to pick one over another.

<div id="toc"></div>

## Virtualization environments

Each build runs in one of the following virtual environments.

### Sudo-enabled

A sudo enabled, full virtual machine per build, that runs Linux, either [Ubuntu Precise 12.04](/user/reference/precise/) or [Ubuntu Trusty 14.04](/user/reference/trusty/).

### Container-based

A fast boot time environment in which `sudo` commands are not available. Running Linux [Ubuntu Trusty 14.04](/user/reference/trusty/)

### OS X

An [OS X](/user/reference/osx/) environment for Objective-C and other OS X specific projects

### Virtualisation Environment vs Operating System

The following table summarizes the differences across virtual environments and operating systems:

|                      | Ubuntu Precise                        | Ubuntu Trusty                     | Ubuntu Trusty                        | [OS X](/user/reference/osx/) |
|:---------------------|:--------------------------------------|:----------------------------------|:-------------------------------------|:-----------------------------|
| Name                 | Sudo-enabled                          | Container-based                   | Sudo-enabled                         | OS X                         |
| Status               | Current                               | Default as of August 2017         | Current                              | Current                      |
| Infrastructure       | Virtual machine on GCE                | Container on EC2                  | Virtual machine on GCE               | Virtual machine              |
| `.travis.yml`        | `sudo: required` <br> `dist: precise` | `sudo: false` <br> `dist: trusty` | `sudo: required` <br> `dist: trusty` | `os: osx`                    |
| Allows `sudo`        | Yes                                   | No                                | Yes                                  | Yes                          |
| Approx boot time     | 20-50s                                | 1-6s                              | 20-50s                               | 60-90s                       |
| File system          | EXT4                                  | AUFS                              | EXT4                                 | HFS+                         |
| Operating system     | Ubuntu 12.04                          | Ubuntu 14.04                      | Ubuntu 14.04                         | OS X                         |
| Memory               | 7.5 GB                                | 4 GB max                          | 7.5 GB                               | 4 GB                         |
| Cores                | ~2, bursted                           | 2                                 | ~2, bursted                          | 2                            |
| IPv4 network         | IPv4 is available                     | IPv4 is available                 | IPv4 is available                    | IPv4 is available            |
| IPv6 network         | IPv6 is not available                 | IPv6 is available on loopback     | IPv6 is not available                | IPv6 is not available        |
| Available disk space | approx 22GB                           | approx 9GB                        | approx 18GB                          | approx 41GB                  |

> Note that available disk space is approximate and depends on the base image and language selection of your project.
  The best way to find out what is available on your specific image is to run `df -h` as part of your build script.

## What infrastructure is my environment running on?

Usually, knowing the virtualization environment characteristics from the [table above](#Virtualisation-Environment-vs-Operating-System) is sufficient.

But, if you do need more detail, you have one of these two questions:

* you want to see what infrastructure a [finished build](#For-a-finished-build) ran on.
* you want to determine what infrastructure a [particular `.travis.yml` configuration](#For-a-particular-.travis.yml-configuration) will run on.

### For a finished build

To see what infrastructure a finished build ran on, look at the *hostname* at the top of the build log:

![Infrastructure shown in hostname](/images/ui/what-infrastructure.png "Infrastructure shown in hostname")

if it contains:

* `ec2` or `packet` → the build ran in a container-based environment on either Amazon EC2 or Packet.net.
* `gce` → the build ran in a sudo-enabled environment on Google Compute Engine.
* `wjb` → the build ran on macOS

### For a particular .travis.yml configuration

Many different parts of your `.travis.yml` affect what infrastructure your build runs on. The following list describes some of the main settings that determine build routing:

* Any of the following settings related to sudo or docker route your build to a sudo-enabled linux (Ubuntu Trusty) environment unless `sudo: false` is explicitly specified.

  - `services: docker`
  - `sudo: required` or `sudo: true`
  - *any* other `sudo` command in your build script
  - *any* other `docker` command in your build script

* Using `os: osx`, setting a version of Xcode using `osx_image:`, or using a macOS specific language such as `language: objective-c` routes your build to macOS infrastructure.

* If none of the previous keys are present in your `.travis.yml`, the default is a container-based linux (Ubunty Trusty) environment.


## Deprecated Virtualization Environments

Historically, Travis CI has provided the following virtualization environments.

- **Precise Container-based environment**: available from the announcement in [December, 2014](https://blog.travis-ci.com/2014-12-17-faster-builds-with-container-based-infrastructure/) to [September, 2017](https://blog.travis-ci.com/2017-08-31-trusty-as-default-status).
- **Legacy environment**: available until [December, 2015](https://blog.travis-ci.com/2015-11-27-moving-to-a-more-elastic-future).
