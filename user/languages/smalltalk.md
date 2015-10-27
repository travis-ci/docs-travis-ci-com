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
We currently just support [Squeak/Smalltalk](http://squeak.org/).

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

For a minimum configuration you need to specify two parameters, the language
and the baseline of your project.

```yaml
    language: smalltalk
    env:
      - BASELINE=MyProjectBaseline
```

## Configuration options

By default Travis CI will use `Squeak5.0` release. It is also possible
to test projects against `SqueakTrunk`, `Squeak4.6` and `Squeak4.5`. To do so, set the
`smalltalk` key in `.travis.yml`. For example, to test against both `Squeak5.0` and
the `SqueakTrunk`:

```yaml
    language: smalltalk
    smalltalk:
      - Squeak5.0
      - SqueakTrunk
    env:
      - BASELINE=MyProjectBaseline
```

## Further information

We are using filetreeCI for building Smalltalk projects.
Additional configuration options can be found at [filetreeCI's GitHub repository](https://github.com/hpi-swa/filetreeCI).
