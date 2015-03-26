---
title: APT Package Installation
layout: en
permalink: /user/apt-packages/
---
<div id="toc">
</div>

When using the [container based infrastructure](/user/workers/container-based-infrastructure/), `sudo` is disabled in
user-defined build phases such as `before_install`. This prohibits installation of APT packages via `apt-get`.  In order
to have Travis CI do this on your behalf before `sudo` privilege is removed, use the `addons.apt_packages` key, e.g.:

``` yaml
addons:
  apt_packages:
  - cmake
  - time
```

The allowed packages are managed in a [whitelist](https://github.com/travis-ci/apt-package-whitelist), and any attempts
to install disallowed packages will result in a log message detailing the package approval process.
