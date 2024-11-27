---
title: Ubuntu Linux Build Environments
layout: en
 
---

## Overview

This page gives an overview of the different Ubuntu Linux distributions you can use as your CI environment.

You can choose one of the following distributions:
* [Ubuntu Jammy 22.04](/user/reference/jammy/)  **recommended**
* [Ubuntu Focal 20.04](/user/reference/focal/)  **recommended**
* [Ubuntu Bionic 18.04](/user/reference/bionic/) *deprecation warning, will be available for some time more*
* [Ubuntu Xenial 16.04](/user/reference/xenial/) **default** *deprecation warning: by end of 2024*
* [Ubuntu Trusty 14.04](/user/reference/trusty/) *deprecation warning: by end of 2024*
* [Ubuntu Precise 12.04](/user/reference/precise/) *deprecated*

## Ubuntu Linux Distributions

To use our Ubuntu Linux build infrastructure, you can choose between the distributions above.

We use Ubuntu Xenial 16.04 as default. You find more about packages, tools and settings in [Ubuntu Xenial 16.04](/user/reference/xenial/).

### Use Ports

Travis CI Linux build images do utilize default open ports as follows:

53 for dns, 
22 for ssh, 
323 for ntp,  
68 for dhcp

On top of that, some of the services pre-installed in the build image or installed during execution of the build job execution as dependencies (e.g. database engine or docker) may occupy additional ports. 
Travis CI build image configurations do not override such defaults.

If, in any case, during a build job, you run into a situation a port you want to use is occupied/not available, please re-run the build using 
following `nestat` call in your `.travis.yml` at the beginning of the script phase or directly before the step, which you suspect clashes over occupied ports.

```yaml
script:
# select proper step in your build execution and add this line before it
 - sudo netstat -tulpn
```
{: data-file=".travis.yml"}

to show all open ports occupied during the build job runtime.

### Use Xenial

To use Ubuntu Xenial, add the following to your `.travis.yml`.

```yaml
dist: xenial
```
{: data-file=".travis.yml"}

Travis CI also supports the [Windows Build Environment](/user/reference/windows/), [macOS Build Environment](/user/reference/osx/) and [FreeBSD Build Environment](/user/reference/freebsd/).

## Migration Guides

As Precise and Trusty are EOL by Canonical, try updating to a newer image and see our [Precise to Trusty Migration Guide](/user/precise-to-trusty-migration-guide) and [Trusty to Xenial Migration Guide](/user/trusty-to-xenial-migration-guide).
