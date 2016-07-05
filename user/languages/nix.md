---
title: Building a Nix Project
layout: en
permalink: /user/languages/nix/
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

To set up Travis to provide the Nix environment, add the following line to `.travis.yml`:

```yaml
language: nix
```

This will install the Nix store and set up a basic single-user profile. The default channel for "nixpkgs" will be "nixpkgs-unstable". More information on configuring channels is provided in the manual below.

## Provided Tools

The following command line tools are available in the Nix environment:

* nix-env
* nix-build
* nix-shell
* nix-store
* nix-channel

More information on writing Nix expression and how each of the above tools works is available in the [Nix manual](https://NixOS.org/nix/manual/).

## Default Target

In addition, the default script will attempt to build all derivations in "default.nix" in the root of the repository using the "nix-build" tool. This can be overridden by adding a "script" key to the .yaml file:

```yaml
language: nix
script: nix-build -A tarball release.nix
```

The above configuration will attempt to build the attribute "tarball" from the Nix expression in release.nix.

## Default Nix Version

Currently, only version "1.11.2" of Nix is provided. In the future, it may be possible to configure different versions with .travis.yml.
