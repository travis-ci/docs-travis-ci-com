---
title: APT Sources and Packages
layout: en
permalink: /user/apt/
---
<div id="toc">
</div>

APT packages can be installed through the APT addon, which is avaliable in all infrastructures. When using the
[container based infrastructure](/user/workers/container-based-infrastructure/), `sudo` is disabled in user-defined build
phases such as `before_install`. This prevents installation of APT packages via `apt-get` as well as the addition of APT
sources such as one might do with `apt-add-repository`. To circumvent this issue, one may use the APT addon, which is
documented below.

 > Note: When using APT sources and packages together, you need to make
 > sure they are under the same key space in the YAML file. e.g.

``` yaml
addons:
  apt:
    sources:
    - ubuntu-toolchain-r-test
    packages:
    - gcc-4.8
    - g++-4.8
```

## Adding APT Sources

To add APT sources before your custom build steps, use the `addons.apt.sources` key, e.g.:

``` yaml
addons:
  apt:
    sources:
    - deadsnakes
    - ubuntu-toolchain-r-test
```

The aliases for the allowed sources (such as `deadsnakes` above) are managed in a
[whitelist](https://github.com/travis-ci/apt-source-whitelist), and any attempts to add disallowed sources will result
in a log message indicating how to submit sources for approval.

## Adding APT Packages

To install packages before your custom build steps, use the `addons.apt.packages` key, e.g.:

``` yaml
addons:
  apt:
    packages:
    - cmake
    - time
```

The allowed packages are managed in a [whitelist](https://github.com/travis-ci/apt-package-whitelist), and any attempts
to install disallowed packages will result in a log message detailing the package approval process.
