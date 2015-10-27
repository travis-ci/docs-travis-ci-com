---
title: Building a Dart Project
layout: en
permalink: /user/languages/dart/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
[Dart](https://www.dartlang.org/) projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Dart is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:dart)
and cc @a14n @devoncarew and @sethladd.

## Choosing Dart versions to test against

Dart workers on travis-ci.org download and install the binary of Dart,
either the _stable_ version, the _dev_ version or any archived version
(See [Dart Download Archive](https://www.dartlang.org/tools/download-archive/)).
To select one or more versions, use the `dart:` key in your `.travis.yml` file,
for example:

    language: dart
    dart:
      - stable
      - dev
      - "1.8.0-1"

*WARNING*: Only _dev_ and _stable_ are supported for now.

## Default Dart Version

If you leave the `dart:` key out of your `.travis.yml`, Travis CI will use
the `stable` channel.

## Dependency Management

If your Dart package has a `pubspec.yaml` file, then `pub get` will be executed
to install any dependencies of the package.

## Default Test Script

### Tests written with unittest package

The tests are done by
[Dart Test Runner](https://pub.dartlang.org/packages/test_runner). This tool
will automatically detect and run all the tests in your Dart project in the
correct environment.

Only _VM_ tests are run by default. _Browser_ tests will also be run if you set
`with_content_shell: true` in your `.travis.yml`.

### Tests written with test package

The tests are done by the
[test package](https://pub.dartlang.org/packages/test). This tool
will automatically detect and run all the tests in your Dart project in the
correct environment.

Only _VM_ tests are run by default. If you set
`with_content_shell: true` in your `.travis.yml` then the tests for plateforms
`vm`, `content-shell` and `firefox` will be run.

## Build Matrix

For Dart projects, `env` and `dart` can be given as arrays to construct a build
matrix.

## Environment Variable

The version of Dart a job is using is available as:

    TRAVIS_DART_VERSION
