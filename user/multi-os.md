---
title: Testing Your Project on Multiple Operating Systems
layout: en
permalink: /user/multi-os/
---

### This is a beta feature
The feature described in this document is considered beta.
Some features may not work as described.

## Introduction
If your code is intended to be used on multiple operating systems
(e.g., a Ruby gem, a Python library, a JVM application),
you can benefit from testing on intended targets.

Travis CI can help by offering testing on Linux and OS X.

## Setting `.travis.yml`
Testing on Linux and OSX is as easy as adding the following to your `.travis.yml`:

```yaml
os:
  - linux
  - osx
```

## `TRAVIS_OS_NAME` environment variable
To distinguish the jobs, you can use `$TRAVIS_OS_NAME`.
The value corresponds to the `os` value in `.travis.yml`,
either `linux` or `osx`.

## Operating System differences
When you test your code on multiple operating systems, always be mindful of differences
that can affect your tests.

1. Not all tools may be available on the Mac

	We are still working on building up the tool chain on the Mac worker.
	Missing pieces of software [may be available](http://braumeister.org/) via Homebrew.

1. The file system behavior is different

	The HFS+ file system on our OS X workers is case-insensitive (which is the factory default),
	and the files in a directory are returned sorted.
	On Linux, on the other hand, the file system is case-sensitive, and returns directory entries in
	the order they appear in the directory internally, which may appear random.

	Your tests may implicitly rely on these behaviors, and could fail because of them.

1. They are different operating systems, after all

	Commands may have the same name on the Mac and Linux, but they may have different flags,
	or the same flag may mean different things.
	In some cases, commands that do the same thing could have different names.
	These need to be investigated case by case.

## Language Support Status
Not all languages are equally available on all operating systems.
Before you embark on the multi-os testing journey, be sure to check
[this GitHub issue](https://github.com/travis-ci/travis-ci/issues/2320).

## Allowing Failures on Jobs Running on One Operating System
If you want to ignore the results of jobs on one operating system, you can add the following
to your `.travis.yml`:

```yaml
matrix:
  allow_failures:
    - os: osx
```
