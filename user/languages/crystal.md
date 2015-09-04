---
title: Building a Crystal Project
layout: en
permalink: /user/languages/crystal/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to [Crystal](http://crystal-lang.org)
projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Crystal is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:crystal)
and cc [@asterite](https://github.com/asterite),
[@jhass](https://github.com/jhass),
[@waj](https://github.com/waj), and
[@will](https://github.com/will) in the issue.

## Basic configuration

If your Crystal project doesn't need any dependencies beyond those specified in
your `Projectfile`, your `.travis.yml` can simply be

    language: crystal

This will run `crystal deps` to install dependencies and then `crystal spec` to test your project.

## Configuration options

Travis CI does not currently support configuration options for your Crystal project at this time.
