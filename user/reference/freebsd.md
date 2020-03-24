---
title: The FreeBSD Build Environment
layout: en
 
---

## Overview

This page gives an overview of the different FreeBSD distributions you can use as your CI environment.

You can use the following distribution:

* [FreeBSD 12.1](/user/reference/freebsd/) **default**

## Using FreeBSD distributions

To use our FreeBSD build infrastructure, you can use the distribution above.

## Default

We use FreeBSD 12.1 as default.

## Using FreeBSD

To use FreeBSD, add the following to your your `.travis.yml`.

```yaml
os: freebsd
```
{: data-file=".travis.yml"}

Travis CI also supports the [Ubuntu Linux Build Environment](/user/reference/linux/), [Windows Build Environment](/user/reference/windows/) 
and [macOS Build Environment](/user/reference/osx/).

