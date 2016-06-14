---
title: Running jobs on Mac OS X infrastructure
layout: en
permalink: /user/workers/os-x-infrastructure/
---

<div id="toc"></div>

This document describes our build infrastructure running OS X VMs.

When you specify the language to be [Objective-C](/user/languages/objective-c),
your build will be sent to VMs running  OS X.

You can also send your job to the OS X VMs using [Multiple Operating System Builds](/user/multi-os) by adding `os: osx` to your `.travis.yml`.

## File System

VMs running OS X use the default file system, HFS+.
This file system is case-insensitive, and returns entities within a
directory alphabetically.
