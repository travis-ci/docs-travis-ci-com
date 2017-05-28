---
title: Google Chrome
layout: en
permalink: /user/chrome/
---

The Google Chrome addon allows Travis CI builds to install Google Chrome at run time. To use the addon you need to be running builds on either the [Trusty build environment](/user/trusty-ci-environment/) or the [OSX build environment](/user/osx-ci-environment/).

## Selecting a Chrome version

You can install the `stable`  or the `beta` version of Chrome but you can't select a specific numeric version.

```yaml
addons:
  chrome: stable
```

## Headless mode

You can use Google Chrome in [headless mode](/user/gui-and-headless-browsers/#Using-the-Chrome-addon-in-the-headless-mode).
