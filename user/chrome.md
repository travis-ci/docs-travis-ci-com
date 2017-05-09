---
title: Google Chrome
layout: en
permalink: /user/chrome/
---

The Google Chrome addon allows Travis CI builds to install Google Chrome at run time.

It requires Trusty or later (Linux), or the Mac.

## Selecting a Chrome version

You can choose the version of Chrome to be installed with either `stable` or `beta`.
The exact numeric version of Chrome would depend on Google's release schedule.

```yaml
addons:
  chrome: stable
```

## Headless mode

You can use Google Chrome in [headless mode](/user/gui-and-headless-browsers/#Using-Chrome-addon-in-the-headless-mode).
