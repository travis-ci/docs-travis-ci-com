---
title: How to skip a build
layout: en
permalink: /user/how-to-skip-a-build/
---

### What This How-To Covers

This How-To explains how to make travis-ci.org skip a build, for example, when
working on documentation or stylesheets. We recommend you start with the
[Getting Started](/user/getting-started/) and [Build
Configuration](/user/build-configuration/) guides before reading this one.

## Not All Commits Need CI Builds

Sometimes all you are changing is the README, some documentation or other
things which have no effect on the tests. In this case, you may not want a
build to be created for that commit. To do this, all you need to do is to add
`[ci skip]` somewhere in the commit message.

Commits that have `[ci skip]` anywhere in the commit messages will be ignored.
`[ci skip]` does not have to appear on the first line, so it is possible to use
it without polluting your project's history.

Alternatively, you can also use `[skip ci]`.
