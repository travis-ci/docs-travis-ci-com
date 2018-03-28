---
title: Building a Crystal Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to [Crystal](http://crystal-lang.org)
projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Crystal is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:crystal)
and cc [@asterite](https://github.com/asterite),
[@jhass](https://github.com/jhass),
[@waj](https://github.com/waj), and
[@will](https://github.com/will) in the issue.

## Basic configuration

If your Crystal project doesn't need any dependencies beyond those specified in
your `shard.yml`, your `.travis.yml` can simply be

```yaml
language: crystal
```
{: data-file=".travis.yml"}

This will run `shards install` to install dependencies and then `crystal spec` to test your project.

## Configuration options

By default Travis CI will use the latest Crystal release. It is also possible
to test projects against the nightly build of Crystal. To do so, set the
`crystal` key in `.travis.yml`. For example, to test against both nightly and
the latest release:

```yaml
language: crystal
crystal:
  - latest
  - nightly
```
{: data-file=".travis.yml"}
