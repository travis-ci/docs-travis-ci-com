---
title: Building a D Project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| D                                           | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#dependency-management) | N/A                                       |
| [Default `script`](#default-build-script)   | `dub test --compiler=${DC}`               |
| [Matrix keys](#build-matrix)                | `d`, `env`                                |
| Support                                     | [Community Support](https://travis-ci.community/c/languages/d) |

Minimal example:

```yaml
language: d
```
{: data-file=".travis.yml"}

</aside>

This guide covers build environment and configuration topics specific to D projects. Please make
sure to read our [Tutorial](/user/tutorial/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community Supported Language

D is a community-supported language in Travis CI, maintained by [@MartinNowak](https://github.com/MartinNowak) and [@wilzbach](https://github.com/wilzbach). If you run into any problems, please report them in the
[Travis CI community forum](https://travis-ci.community/c/languages/d).
Please report compiler-specific issues at [DMD's issue tracker](https://issues.dlang.org),
[LDC's issue tracker](https://github.com/ldc-developers/ldc/issues), or
[GDC's issue tracker](https://bugzilla.gdcproject.org).
[DUB](https://github.com/dlang/dub) related problems should be reported to [DUB's issue tracker](https://github.com/dlang/dub/issues).

## Choosing compilers to test against

By default Travis CI will use the latest dmd version. It is also possible to test projects against
gdc or ldc and to choose specific compiler versions. To do
so, specify the compiler using the `d:` key in `.travis.yml`.

Examples:

```yml
d: dmd-2.089.1
```

```yml
# latest dmd, gdc and ldc
d:
  - dmd
  - gdc
  - ldc
```

```yml
# nightlies and betas of dmd, ldc
d:
  - dmd-nightly
  - ldc-latest-ci
  - dmd-beta
  - ldc-beta
```

All valid versions from the [D's official install script](https://dlang.org/install.html) are supported.
Testing against multiple compilers will create one row in your build matrix for each compiler. The
Travis CI D builder will export the `DC` env variable to point to `dmd`, `ldc2` or `gdc` and the
`DMD` env variable to point to `dmd`, `ldmd2` or `gdmd`.

> You can also have a look at the [D](https://config.travis-ci.com/ref/language/d) section in our [Travis CI Build Config Reference](https://config.travis-ci.com/).


