---
title: Building a Dart Project
layout: en
permalink: dart/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
[Dart](https://www.dartlang.org/) projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/build-configuration/) guides first.

### Community-Supported Warning

Travis CI support for Dart is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:dart)
and cc @a14n @devoncarew and @sethladd.

## Choosing Dart versions to test against

Dart workers on travis-ci.org download and install the binary of Dart,
either the _stable_ version, the _dev_ version or any specified version build
with apt (See [Dart SDK for Debian and Ubuntu with Apt](https://www.dartlang.org/tools/debian.html)).
To select one or more versions, use the `dart:` key in your `.travis.yml` file,
for example:

    language: dart
    dart:
      - stable
      - dev
      - "1.8.0-1"

## Default Dart Version

If you leave the `dart:` key out of your `.travis.yml`, Travis CI will use
the `stable` channel.

## Dependency Management

If your Dart package has a `pubspec.yaml` file, then `pub get` will be executed
to install any dependencies of the package.

## Default Test Script

If your repository follows the [Pub Package Layout Conventions](https://www.dartlang.org/tools/pub/package-layout.html)
then the following default script will be run:

    if [ -f test/all_test.dart ]; then
      dart test/all_test.dart
    fi

## Build Matrix

For Dart projects, `env` and `dart` can be given as arrays to construct a build
matrix.

## Environment Variable

The version of Dart a job is using is available as:

    TRAVIS_DART_VERSION
