---
title: Building a Dart Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
[Dart](https://www.dartlang.org/) projects. Please make sure to read our
[Tutorial](/user/tutorial/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Dart is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:dart)
and cc `@nex3` and `@a14n`.

## Choosing Dart versions to test against

Dart workers on Travis CI download and install the Dart SDK archives. See
the [Dart Download Archive](https://www.dartlang.org/install) for the list of
available archives. By default, the latest stable SDK version is downloaded. To
explicitly select one or more versions, use the `dart` key. For example:

```yaml
language: dart
dart:
# Install the latest stable release
- stable
# Install the latest dev release
- dev
# Install a specific stable release - 1.15.0
- "1.15.0"
# Install a specific dev release, using a partial download URL - 1.16.0-dev.3.0
- "dev/release/1.16.0-dev.3.0"
```
{: data-file=".travis.yml"}

This creates a separate Travis job for each Dart version. It can be used in
conjunction with `env` or similar fields to create a [build matrix][].

[build matrix]: /user/customizing-the-build/#Build-Matrix

## Dependency Management

If your Dart package has a `pubspec.yaml` file, then `pub get` will be run
before your tests to install any dependencies of the package.

## Running Tests

If your package depends on the [`test` package][test], `pub run test` will be
run by default. This typically only runs tests on the Dart VM, but you can
[configure it][] to run on additional platforms by default.

[test]: https://pub.dartlang.org/packages/test
[configure it]: https://github.com/dart-lang/test/blob/master/doc/configuration.md#platforms

You can also customize the arguments Travis passes to the test runner using the
`dart_task` field in `.travis.yml`.

```yaml
language: dart
dart_task:
- test: --platform vm
- test: --platform chrome
```
{: data-file=".travis.yml"}

Each task creates a separate Travis job. It can be used in conjunction with
`env`, `dart`, or similar fields to create a [build matrix][].

### Available Browsers

Travis comes with Firefox and Chrome installed by default on Linux, and Safari
on OS X. However, if you want to run your tests on Dartium, you'll need to
install it by adding `install_dartium: true` either at the top level or for a
particular task.

```yaml
language: dart
dart_task:
- test: --platform vm
- test: --platform dartium
  install_dartium: true
```
{: data-file=".travis.yml"}

### XVFB

On Linux, the test runner uses [XVFB][] by default so that it can use browsers
like Chrome that require a display. However, this may interfere with certain
applications, so you can turn it off by setting `xvfb: false` either at the top
level or for a particular task.

[XVFB]: https://www.x.org/archive/X11R7.6/doc/man/man1/Xvfb.1.xhtml

```yaml
language: dart
dart_task:
- test: --exclude-tags no-xvfb
- test: --tags no-xvfb
  xvfb: false
```
{: data-file=".travis.yml"}

XVFB is never used on OS X, since it doesn't use the X windows system.

## Other Tasks

Several tasks are available in addition to running tests.

### Analyzer

To run the [Dart analyzer][] to verify that your code doesn't have any static
errors, add a task with `dartanalyzer: true`. By default it analyzes all Dart
files in your repository, but you can configure it by providing arguments
instead of `true`.

[Dart analyzer]: https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer

```yaml
language: dart
dart_task:

# As long as you don't want any other configuration, you can just use the name
# of a task instead of "name: true".
- test

# Warnings are fatal, but we only analyze the lib/ directory.
- dartanalyzer: --fatal-warnings lib
```
{: data-file=".travis.yml"}

### Formatter

To run the [Dart formatter][] to verify that all your files are correctly
formatted, add a task with `dartfmt: true`. If your package depends on the
`dart_style` package, it'll use that package's formatter version; otherwise,
it'll use the `dartfmt` that comes with your Dart SDK.

[Dart formatter]: https://github.com/dart-lang/dart_style#readme

```yaml
language: dart
dart_task:
- test: --platform vm
- test: --platform chrome
- dartfmt
```
{: data-file=".travis.yml"}

## Environment Variables

* The version of Dart a job is using is available as `TRAVIS_DART_VERSION`.
* `TRAVIS_DART_TEST` will be `true` if the current task uses `test`.
* `TRAVIS_DART_ANALYZE` will be `true` if the current task uses `dartanalyzer`.
* `TRAVIS_DART_FORMAT` will be `true` if the current task uses `dartfmt`.
