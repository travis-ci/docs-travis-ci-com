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

Each build runs in one of the following virtual environments:

- Sudo-enabled: a sudo enabled, full virtual machine per build. Running either Linux [Ubuntu Precise 12.04](/user/reference/precise/) or [Ubuntu Trusty 14.04](/user/reference/trusty/)
- Container-based: Fast boot time environment in which `sudo` commands are not available. Running Linux [Ubuntu Trusty 14.04](/user/reference/trusty/)
- [OS X](/user/reference/osx/): for Objective-C and other OS X specific projects

The following table summarizes the differences between the virtual environments:

|                  | Ubuntu Precise                        | Ubuntu Trusty                     | Ubuntu Trusty                        | [OS X](/user/reference/osx/) |
|:-----------------|:--------------------------------------|:----------------------------------|:-------------------------------------|:-----------------------------|
| Name             | Sudo-enabled VM                       | Container-based                   | Sudo-enabled VM                      | OS X                         |
| Status           | Current                               | Default as of August 2017         | Current                              | Current                      |
| Infrastructure   | Virtual machine on GCE                | Container                         | Virtual machine on GCE               | Virtual machine              |
| `.travis.yml`    | `sudo: required` <br> `dist: precise` | `sudo: false` <br> `dist: trusty` | `sudo: required` <br> `dist: trusty` | `os: osx`                    |
| Allows `sudo`    | Yes                                   | No                                | Yes                                  | Yes                          |
| Approx boot time | 20-50s                                | 1-6s                              | 20-50s                               | 60-90s                       |
| File system      | EXT4                                  | AUFS                              | EXT4                                 | HFS+                         |
| Operating system | Ubuntu 12.04                          | Ubuntu 14.04                      | Ubuntu 14.04                         | OS X                         |
| Memory           | 7.5 GB                                | 4 GB max                          | 7.5 GB                               | 4 GB                         |
| Cores            | ~2, bursted                           | 2                                 | ~2, bursted                          | 2                            |


## Deprecated Virtualization Environments

Historically, Travis CI has provided the following virtualization environments.

- **Precise Container-based environment**: available from the announcement in [December, 2014](https://blog.travis-ci.com/2014-12-17-faster-builds-with-container-based-infrastructure/) to [September, 2017](https://blog.travis-ci.com/2017-08-31-trusty-as-default-status).
- **Legacy environment**: available until [December, 2015](https://blog.travis-ci.com/2015-11-27-moving-to-a-more-elastic-future).
