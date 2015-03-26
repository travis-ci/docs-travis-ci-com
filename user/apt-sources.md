---
title: APT Sources
layout: en
permalink: /user/apt-sources/
---
<div id="toc">
</div>

When using the [container based infrastructure](/user/workers/container-based-infrastructure/), `sudo` is disabled in
user-defined build phases such as `before_install`. This prevents the addition of APT sources such as one might do with
`apt-add-repository`.

To add APT sources before your custom build steps, use the `addons.apt_sources` key, e.g.:

``` yaml
addons:
  apt_sources:
  - deadsnakes
  - ubuntu-toolchain-r-test
```

The aliases for the allowed sources (such as `deadsnakes` above) are managed in a
[whitelist](https://github.com/travis-ci/apt-source-whitelist), and any attempts to add disallowed sources will result
in a log message indicating how to submit sources for approval.
