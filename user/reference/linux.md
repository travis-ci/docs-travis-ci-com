---
title: The Ubuntu Linux Build Environments
layout: en
 
---

## Overview

This page gives an overview of the different Ubuntu Linux distributions you can use as your CI environment.

You can choose one of the following distributions:
* [Ubuntu Focal 20.04](/user/reference/focal/)
* [Ubuntu Bionic 18.04](/user/reference/bionic/)
* [Ubuntu Xenial 16.04](/user/reference/xenial/) **default**
* [Ubuntu Trusty 14.04](/user/reference/trusty/) 
* [Ubuntu Precise 12.04](/user/reference/precise/)

## Using Ubuntu Linux distributions

To use our Ubuntu Linux build infrastructure, you can choose between the distributions above.

## Default 

We use Ubuntu Xenial 16.04 as default. You find more about packages, tools and settings in [Ubuntu Xenial 16.04](/user/reference/xenial/).

### Using Xenial

To use Ubuntu Xenial, add the following to your `.travis.yml`.

```yaml
dist: xenial
```
{: data-file=".travis.yml"}

Travis CI also supports the [Windows Build Environment](/user/reference/windows/), [macOS Build Environment](/user/reference/osx/) and [FreeBSD Build Environment](/user/reference/freebsd/).

## Migration Guides

As Precise and Trusty are EOL by Canonical, try updating to a newer image and see our [Precise to Trusty Migration Guide](/user/precise-to-trusty-migration-guide) and [Trusty to Xenial Migration Guide](/user/trusty-to-xenial-migration-guide).
