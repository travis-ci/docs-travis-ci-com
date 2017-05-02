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

Starting with version 57 for Linux and version 59 on the Mac, Google Chrome can be used in the "headless"
mode, which is suitable for driving browser-based tests using Selenium and other tools.
As of 2017-05-02, this means `stable` or `beta` on Linux builds, and `beta` for the Mac.

For example, on Linux

```yaml
dist: trusty
addons:
  chrome: stable
before_install:
  - # start your web application and listen on `localhost`
  - google-chrome-stable --headless --disable-gpu --remote-debugging-port=9222 http://localhost
  ⋮
```

On the Mac:

```yaml
language: objective-c
addons:
  chrome: beta
before_install:
  - # start your web application and listen on `localhost`
  - "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --headless --disable-gpu --remote-debugging-port=9222 http://localhost"
  ⋮
```

### Documentation

* [Headless Chromium documentation](https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md)
* [Getting Started with Headless Chrome](https://developers.google.com/web/updates/2017/04/headless-chrome)
