---
title: Building a D Project
layout: en
permalink: d/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to D projects. Please make
sure to read our [Getting Started](/user/getting-started/) and
[general build configuration](/user/build-configuration/) guides first.

### Beta Warning

Travis CI support for D is currently in beta and may be removed or altered at any time. It is a
community-supported language. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues) and cc
[@ibuclaw](https://github.com/ibuclaw), [@klickverbot](https://github.com/klickverbot) and
[@MartinNowak](https://github.com/MartinNowak).

## Choosing compilers to test against

By default Travis CI will use the latest dmd release. It is also possible to test projects against
specific versions of dmd, ldc or gdc. To do so, specify the compiler using the `d:` key in
`.travis.yml`. For example, to build with dmd:

    d: dmd-2.065.0

or to use dmd, gdc and ldc:

    d:
      - dmd-2.066.1
      - gdc-4.8.2
      - ldc-0.14.0

Testing against multiple compilers will create one row in your build matrix for each compiler. The
Travis CI D builder will export the `DC` env variable to point to `dmd`, `ldc2` or `gdc` and the
`DMD` env variable to point to `dmd`, `ldmd2` or `gdmd`.

## Default Test Script

Travis CI by default assumes your project is built and tested using [dub](http://code.dlang.org) and
runs the following command using the latest released version of dub.

    dub test --compiler=${DC}

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: d

This can be overridden as described in the [general build configuration](/user/build-configuration/)
guide. For example, to build by running make, override the `script:` key in `.travis.yml` like this:

    script: make test

## Dependency Management

Because project dependencies are already handled by dub, Travis CI skips dependency installation for
D projects.  If you need to perform special tasks before your tests can run, override the `install:`
key in your `.travis.yml`:

    install: make get-deps

See [general build configuration guide](/user/build-configuration/) to learn more.

## Build Matrix

For D projects, `env` and `d` can be given as arrays
to construct a build matrix.
