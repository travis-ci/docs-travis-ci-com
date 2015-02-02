---
title: APT Package Installation
layout: en
permalink: /user/apt-packages/
---
<div id="toc">
</div>

When using the [container based infrastructure](/user/workers/container-based-infrastructure/), there is a limitation on
the use of `sudo` without a password, as is required to install packages with `apt-get`.  In order to have Travis CI do
this on your behalf prior to `sudo` privileges being disabled, use the `addons.apt_packages` key, e.g.:

    addons:
      apt_packages:
      - cmake
      - time

The allowed packages are managed in a [whitelist](https://github.com/travis-ci/apt-package-whitelist), and any attempts
to install disallowed packages will result in a log message detailing the package approval process.
