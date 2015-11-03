---
title: Building a Smalltalk Project
layout: en
permalink: /user/languages/smalltalk/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Smalltalk
projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.
We currently support [Squeak/Smalltalk](http://squeak.org/) and [Pharo](http://pharo.org/).

### Community-Supported Warning

Travis CI support for Smalltalk is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:smalltalk)
and cc [@bahnfahren](https://github.com/bahnfahren),
[@chistopher](https://github.com/chistopher),
[@fniephaus](https://github.com/fniephaus),
[@jchromik](https://github.com/jchromik), and
[@Nef10](https://github.com/Nef10) in the issue.

## Basic configuration

For a minimum configuration, you need to specify two parameters, the language
and the baseline of your project.

```yaml
language: smalltalk
env:
  global:
    - BASELINE=MyProjectBaseline
```

## Configuration options

Travis CI will use `Squeak-5.0` by default. In order to specify the image(s)
you want your tests to run against, set the `smalltalk` key in your `.travis.yml`.
A list of all images supported can be found [here](https://github.com/hpi-swa/smalltalkCI#images).
For example, to test against both, `Squeak-trunk` and `Squeak-5.0`, use:

```yaml
language: smalltalk
smalltalk:
  - Squeak-trunk
  - Squeak-5.0
env:
  global:
    - BASELINE=MyProjectBaseline
```

## Further information

We are using smalltalkCI for building Smalltalk projects.
Additional configuration options can be found at [smalltalkCI's GitHub repository](https://github.com/hpi-swa/smalltalkCI#templates).
