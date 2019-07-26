---
title: The Ubuntu Linux Build Environments
layout: en
 
---

## Overview

This page gives an overview of the different Ubuntu Linux distributions you can use as your CI environment.

You can choose one of the following distributions:

* [Ubuntu Bionic 18.04](/user/reference/bionic/)
* [Ubuntu Xenial 16.04](/user/reference/xenial/)
* [Ubuntu Trusty 14.04](/user/reference/trusty/) **default**
* [Ubuntu Precise 12.04](/user/reference/precise/)

## Using Ubuntu Linux distributions

To use our Ubuntu Linux build infrastructure, you can choose between the distributions above.

## Default 

We use Ubuntu Trusty 14.04 as default. You find more about packages, tools and settings in [Ubuntu Trusty 14.04](/user/reference/trusty/).

## Using Trusty

To use Ubuntu Trusty, add the following to your `.travis.yml`.

```yaml
dist: trusty
```
{: data-file=".travis.yml"}

Travis CI also supports the [Windows Build Environment](/user/reference/windows/) and [macOS Build Environment](/user/reference/osx/).
