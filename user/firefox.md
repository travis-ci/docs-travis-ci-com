---
title: Firefox
layout: en
permalink: /user/firefox/
---

Our 64-bit Linux VMs include a recent version of Firefox, currently 31.0esr.

## Selecting a Firefox version

To install a specific version of Firefox, use the Firefox addon to download and  install before running your build script (as part of the `before_install` stage).

For example, to install version 39.0 of Firefox, add the following to your `.travis.yml` file:

    addons:
      firefox: "39.0"

## Version aliases

In addition to specific version numbers, there are 3 special aliases you can use:

* [`latest`](https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US)
* [`latest-esr`](https://download.mozilla.org/?product=firefox-esr-latest&os=linux64&lang=en-US)
* [`latest-beta`](https://download.mozilla.org/?product=firefox-beta-latest&os=linux64&lang=en-US)
