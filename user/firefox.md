---
title: Firefox
layout: en
permalink: /user/firefox/
---

Our 64-bit Linux VMs include a version of Firefox.

While Firefox is not pre-installed on OS X images, you can use this addon to set it up for use
on your builds.

## Selecting a Firefox version

To install a specific version of Firefox, you can use the Firefox addon. The addon will download and install Firefox before running your build script.

For example, to install version 49.0 of Firefox, add the following at the top level of your `.travis.yml` file:

```yaml
addons:
  firefox: "49.0"
```

It is also possible to specify beta versions; e.g., `50.0b6`.

## Version aliases

In addition to specific version numbers, there are 6 special aliases you can use:

- [`latest`](https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US)
- [`latest-esr`](https://download.mozilla.org/?product=firefox-esr-latest&os=linux64&lang=en-US)
- [`latest-beta`](https://download.mozilla.org/?product=firefox-beta-latest&os=linux64&lang=en-US)
- [`latest-dev`](https://download.mozilla.org/?product=firefox-aurora-latest&os=linux64&lang=en-US)
- [`latest-nightly`](https://download.mozilla.org/?product=firefox-nightly-latest&os=linux64&lang=en-US)
- [`latest-unsigned`](https://tools.taskcluster.net/index/artifacts/#gecko.v2.mozilla-release.latest.firefox/gecko.v2.mozilla-release.latest.firefox.linux64-add-on-devel/)

The `latest-unsigned` binary is an unbranded build, suitable for [Add-ons/Extensions Signing](https://wiki.mozilla.org/Addons/Extension_Signing#Unbranded_Builds).

For more information visit the [Mozilla Wiki](https://wiki.mozilla.org/Firefox/Channels#Developer_Edition_.28aka_Aurora.29).
