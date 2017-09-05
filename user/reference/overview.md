---
title: Build Environment Overview
layout: en
permalink: /user/reference/overview/
redirect_from:
  - /user/ci-environment/
---

### What This Guide Covers

This guide provides an overview on the various different environments in which
Travis CI can run your builds, and why you might want to pick one over another.

<div id="toc"></div>

## Virtualization environments

Each build runs in one of the following virtual environments:

- Sudo-enabled: a sudo enabled, full virtual machine per build
- Container-based: Fast boot time environment in which `sudo` commands are not available
- [OS X](/user/reference/osx/): for Objective-C and other OS X specific projects

Each Linux environment runs either [Ubuntu Precise 12.04](/user/reference/precise/) or [Ubuntu Trusty 14.04](/user/reference/trusty/).

The following table summarizes the differences between the virtual environments:

|                  | Ubuntu Precise                     | Ubuntu Precise                        | Ubuntu Trusty                     | Ubuntu Trusty                        | [OS X](/user/reference/osx/) |
|:-----------------|:-----------------------------------|:--------------------------------------|:----------------------------------|:-------------------------------------|:-----------------------------|
| Name             | Container-based                    | Sudo-enabled VM                       | Container-based                   | Sudo-enabled VM                      | OS X                         |
| Status           | Retired as of September 2017       | Current                               | Default as of August 2017         | Current                              | Current                      |
| Infrastructure   | Container                          | Virtual machine on GCE                | Container                         | Virtual machine on GCE               | Virtual machine              |
| `.travis.yml`    | `sudo: false` <br> `dist: precise` | `sudo: required` <br> `dist: precise` | `sudo: false` <br> `dist: trusty` | `sudo: required` <br> `dist: trusty` | `os: osx`                    |
| Allows `sudo`    | No                                 | Yes                                   | No                                | Yes                                  | Yes                          |
| Approx boot time | 1-6s                               | 20-50s                                | 1-6s                              | 20-50s                               | 60-90s                       |
| File system      | AUFS                               | EXT4                                  | AUFS                              | EXT4                                 | HFS+                         |
| Operating system | Ubuntu 12.04                       | Ubuntu 12.04                          | Ubuntu 14.04                      | Ubuntu 14.04                         | OS X                         |
| Memory           | 4 GB max                           | 7.5 GB                                | 4 GB max                          | 7.5 GB                               | 4 GB                         |
| Cores            | 2                                  | ~2, bursted                           | 2                                 | ~2, bursted                          | 2                            |
