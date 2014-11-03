---
title: Firefox
layout: en
permalink: firefox/
---

### Selecting a Firefox version

Our VMs come preinstalled with some recent version of Firefox, currently 31.0esr.

If you need a specific version to be installed, the Firefox addon
allows you to specify any version of Firefox and the binary will be downloaded
and installed before running your build script (as a part of the
`before_install` stage).

If you need version 17.0 of Firefox to be installed, add the following to your
.travis.yml file:

    addons:
      firefox: "17.0"

Please note that this downloads binaries that are only compatible with our
64-bit Linux VMs, so this won't work on our Mac VMs.

### Use of the addon on Docker workers

Note that the use of non-default version of Firefox requires `sudo`, and
is not allowed on [Docker workers](/user/workers/docker).