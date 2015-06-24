---
title: Building a Perl 6 Project
layout: en
permalink: /user/languages/perl6/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
Perl 6 projects. Please make sure to read our [Getting Started](/user/getting-started/)
and [general build configuration](/user/build-configuration/) guides first.

## Choosing Perl 6 versions to test against

Perl 6 workers on travis-ci.org use
[rakudobrew](https://github.com/tadzik/rakudobrew) to provide several Perl 6
versions that your projects can be tested against. To specify them, use the
`perl6:` key in your `.travis.yml` file, for example:

    language: perl6
    perl6:
      - latest
      - 2015.05
      - 2015.04

Over time, new releases come out and we upgrade both rakudobrew and
Perls, aliases like `2015.04` will float and point to different exact
versions, patch levels and so on.

For precise versions pre-installed on the VM, please consult "Build system
information" in the build log.

## Perl 6 Stack

At present the Perl 6 that is built is [Rakudo](http://rakudo.org/) upon
[NQP](https://github.com/perl6/nqp/) with the [MoarVM](http://moarvm.org/)
backend.  Future support for the
[JVM](http://en.wikipedia.org/wiki/Java_virtual_machine) backend is planned.

## Default Perl 6 Version

If you leave the `perl6` key out of your `.travis.yml`, Travis CI will use
the latest Rakudo Perl 6.

## Default Test Script

By default, the following command will be used to run the project's tests:

    panda-test

## Dependency Management

### Travis CI uses panda

By default Travis CI uses `panda` to manage your project's dependencies. It
is possible to override dependency installation command as described in the
[general build configuration](/user/build-configuration/) guide.

### When Overriding Build Commands, Do Not Use sudo

When overriding the `install:` key to tweak dependency installation
commands, do not use sudo.  Travis CI Environment has Perl 6 versions
installed via rakudobrew in a non-privileged user `$HOME` directory. Using
sudo will result in dependencies being installed in unexpected (for the
Travis CI Perl 6 builder) locations and they won't load.

## Build Matrix

For Perl 6 projects, `env` and `perl6` can be given as arrays to construct a
build matrix.

## Environment Variable

The Perl 6 version a job is using is available via:

    TRAVIS_PERL6_VERSION

## Examples

