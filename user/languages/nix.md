---
title: Building a Nix Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Nix projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

<div id="toc"></div>

### Community-Supported Warning

Travis CI support for Nix is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:nix)
and cc @domenkozar @garbas and @matthewbauer .

## Overview

To install the Nix store and set up a basic single-user profile, set the `language` key in `.travis.yml` to `nix`.

```yaml
language: nix
```
{: data-file=".travis.yml"}

The default channel for `nixpkgs` will be `nixpkgs-unstable`.

## Provided Tools

The following command line tools are available in the Nix environment:

- nix-env
- nix-build
- nix-shell
- nix-store
- nix-channel

## Default Nix Version

Currently, only version "1.11.2" of Nix is provided. In the future, it may be possible to configure different versions with `.travis.yml`.

## Default Target

The default build script is `nix-build` which builds everything in the `default.nix` file of the repository root. This can be overridden by setting the `script` key in the `.travis.yml` file. For example,

```yaml
language: nix
script: nix-build -A tarball release.nix
```
{: data-file=".travis.yml"}

The above configuration will attempt to build the attribute "tarball" from the Nix expression in release.nix.

## Nix manual

More information on writing Nix expressions and how each of the above tools works is available in the [Nix manual](https://nixos.org/nix/manual/).
