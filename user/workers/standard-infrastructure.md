---
title: Using standard infrastructure
layout: en
permalink: /user/workers/standard-infrastructure/
---

<div id="toc"></div>

This document describes running builds on the current (November 2014)
default infrastracture.

Your builds are sent to this infrastructure when specifying `sudo: required` or
using `sudo` within a build stage in `.travis.yml`.

This backend has following characteristics:

1. Allows use of `sudo` (e.g., for installing `apt` packages)
2. For private repositories, allows use of [caches](/user/caching)

For technical reasons, booting the VM takes a little longer
than [the container-based ones](/user/workers/container-based-infrastructure).

## File System

The VMs use `simfs` file system.
It is case-sensitive, and the entities within a directory
may be returned in random order.

