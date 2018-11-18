---
title: Building a D Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to D projects. Please make
sure to read our [Tutorial](/user/tutorial/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community Supported Language

D is a community-supported language in Travis CI. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues) and cc
[@MartinNowak](https://github.com/MartinNowak) and [@wilzbach](https://github.com/wilzbach).
Please report compiler-specific issues at [DMD's issue tracker](https://issues.dlang.org), or
[LDC's issue tracker](https://github.com/ldc-developers/ldc/issues), or
[GDC's issue tracker](https://bugzilla.gdcproject.org)
[DUB](https://github.com/dlang/dub) related problems should be reported to [DUB's issue tracker](https://github.com/dlang/dub/issues).

## Choosing compilers to test against

By default Travis CI will use the latest dmd version. It is also possible to test projects against
gdc or ldc and to choose specific compiler versions. To do
so, specify the compiler using the `d:` key in `.travis.yml`.

Examples:

```yml
d: dmd-2.066.1
```

```yml
# latest dmd, gdc and ldc
d:
  - dmd
  - gdc
  - ldc
```

```yml
# latest dmd and ldc-0.15.1
d:
  - dmd
  - ldc-0.15.1
```

```yml
# dmd nightlies and beta of dmd, ldc
d:
  - dmd-nightly
  - dmd-beta
  - ldc-beta
```

All valid versions from the [D's official install script](https://dlang.org/install.html) are supported.
Testing against multiple compilers will create one row in your build matrix for each compiler. The
Travis CI D builder will export the `DC` env variable to point to `dmd`, `ldc2` or `gdc` and the
`DMD` env variable to point to `dmd`, `ldmd2` or `gdmd`.

## Default Test Script

Travis CI by default assumes your project is built and tested using [dub](http://code.dlang.org) and
runs the following command using the latest released version of dub.

```bash
dub test --compiler=${DC}
```

Projects that find this sufficient can use a very minimalistic .travis.yml file:

```yaml
language: d
```
{: data-file=".travis.yml"}

This can be overridden as described in the [general build configuration](/user/customizing-the-build/)
guide. For example, to build by running make, override the `script:` key in `.travis.yml` like this:

```yaml
script: make test
```
{: data-file=".travis.yml"}

## Dependency Management

Because project dependencies are already handled by dub, Travis CI skips dependency installation for
D projects.  If you need to perform special tasks before your tests can run, override the `install:`
key in your `.travis.yml`:

```yaml
install: make get-deps
```
{: data-file=".travis.yml"}

See [general build configuration guide](/user/customizing-the-build/) to learn more.

## Build Matrix

For D projects, `env` and `d` can be given as arrays
to construct a build matrix.
