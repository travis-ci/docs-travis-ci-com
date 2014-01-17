---
title: How to skip a build
layout: en
permalink: how-to-skip-a-build/
---

### What This How-To Covers

This How-To explains how to make travis-ci.org skip a build, for example, when
working on documentation or stylesheets. We recommend you start with the
[Getting Started](/user/getting-started/) and [Build
Configuration](/user/build-configuration/) guides before reading this one.

## Not All Commits Need CI Builds

Sometimes you just change a README, some docs or just stuff which has no effect
on the app itself. So you would like to know how to prevent your push from
being built.

It's easy - just add the following to the commit message:

    [ci skip]

Commits that have `[ci skip]` anywhere in the commit messages will be ignored.
`[ci skip]` does not have to appear on the first line, so it is possible to use
it without polluting your project's history.

Alternatively, you can also use `[skip ci]`.

## Example

Here is an example:

![ci skip example](https://img.skitch.com/20111013-pu5e4gijiw4416m4y4uc29fxwa.jpg)
