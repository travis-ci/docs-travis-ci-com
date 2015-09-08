---
title: Firefox
layout: en
permalink: /user/firefox/
---

### Selecting a Firefox version

Our VMs come preinstalled with some recent version of Firefox, currently 31.0esr.

If you need a specific version to be installed, the Firefox addon
allows you to specify any version of Firefox and the binary will be downloaded
and installed before running your build script (as a part of the
`before_install` stage).

If you need version 39.0 of Firefox to be installed, for example,
add the following to your `.travis.yml` file:

    addons:
      firefox: "39.0"

### `latest` aliases

In addition, there are 3 special aliases
[`latest`](http://releases.mozilla.org/pub/firefox/releases/latest/linux-x86_64/en-US/),
[`latest-esr`](http://releases.mozilla.org/pub/firefox/releases/latest-esr/linux-x86_64/en-US/), and
[`latest-beta`](http://releases.mozilla.org/pub/firefox/releases/latest-beta/linux-x86_64/en-US/).

### Linux only

Please note that this downloads binaries that are only compatible with our
64-bit Linux VMs, so this won't work on our Mac VMs.
