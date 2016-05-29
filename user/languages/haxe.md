---
title: Building a Haxe Project
layout: en
permalink: /user/languages/haxe/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
[Haxe](http://haxe.org/) projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Haxe is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=haxe)
and cc @andyli @waneck @Simn.

## Choosing Haxe versions to test against

Haxe workers on travis-ci.org download and install the binary of Haxe.
To select one or more versions, use the `haxe:`
key in your `.travis.yml` file, for example:

    language: haxe
    haxe:
      - "3.2.1"
      - development

## Default Haxe Version

If you leave the `haxe:` key out of your `.travis.yml`, Travis CI will use
Haxe 3.2.1.

## Default Neko Version

By default, [Neko](http://nekovm.org/) 2.1.0 will also be downloaded and installed.
Use the `neko:` key in your `.travis.yml` file to specify a different Neko version,
for example:

    language: haxe
    neko: "2.0.0"

However, unlike `haxe:`, you can provide only one value (not an array) to `neko:`.

## Test Configuration

If your project makes use of the standard hxml files for building, you can specify
the list of hxml files using the `hxml:` key, for example:

    language: haxe
    hxml:
      - build.hxml

In the *install* phase, the worker will run `yes | haxelib install $hxml` for
each of the provided values. Similarly, in the *script* (test) phase,
the worker will run `haxe $hxml` for each of the provided values.

You can replace the default *install* and *script* behavior by using the
`install:` and `script:` keys, respectively, as described
in the [general build configuration](/user/customizing-the-build/) guide.

## Build Matrix

For Haxe projects, `env:` and `haxe:` can be given as arrays
to construct a build matrix.

## Environment Variable

The versions of Haxe and Neko a job is using are available as:

    TRAVIS_HAXE_VERSION
    TRAVIS_NEKO_VERSION
