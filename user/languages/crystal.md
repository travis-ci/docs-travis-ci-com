---
title: Building a Crystal Project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| Crystal                                     | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#dependency-management) | `shards install`                          |
| [Default `script`](#default-build-script)   | `crystal spec`                            |
| [Matrix keys](#build-matrix)                | `crystal`, `env`                          |
| Support                                     | [Community Support](https://travis-ci.community/c/languages/crystal) |

Minimal example:

```yaml
language: crystal
```
{: data-file=".travis.yml"}

</aside>

This guide covers build environment and configuration topics specific to [Crystal](http://crystal-lang.org)
projects. Please make sure to read our
[Tutorial](/user/tutorial/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Crystal is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:crystal)
and cc [@asterite](https://github.com/asterite),
[@jhass](https://github.com/jhass),
[@waj](https://github.com/waj),
[@will](https://github.com/will), and
[@bcardiff](https://github.com/bcardiff).

## Configuration options

By default Travis CI will use the latest Crystal stable release. It is also possible
to test projects against the nightly or specific version build of Crystal. To do so, set the
`crystal` key in `.travis.yml`. For example, to test against the latest stable release, the 
most recent nightly, and a specific version stable release:

```yaml
dist: xenial
language: crystal
crystal:
  - latest
  - nightly
  - 0.35.1. # example of specific version
```
{: data-file=".travis.yml"}

> Note that the nightly build will only be available on Linux environments

> You can also have a look at the [Crystal](https://config.travis-ci.com/ref/language/crystal) section in our [Travis CI Build Config Reference](https://config.travis-ci.com/).
