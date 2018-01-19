---
title: Google Chrome
layout: en

---

The Google Chrome addon allows Travis CI builds to install Google Chrome at run time. To use the addon you need to be running builds on either the [Trusty build environment](/user/reference/trusty/) or the [OS X build environment](/user/reference/osx/).

## Selecting a Chrome version

You can install the `stable`  or the `beta` version of Chrome but you can't select a specific numeric version.

```yaml
sudo: required
addons:
  chrome: stable
```
{: data-file=".travis.yml"}

## Headless mode

You can use Google Chrome in [headless mode](/user/gui-and-headless-browsers/#Using-the-Chrome-addon-in-the-headless-mode).

## Sandboxing

For security reasons, Google Chrome is unable to provide sandboxing when it is running in the
[container-based environment](https://docs.travis-ci.com/user/reference/overview/#Virtualization-environments).

To use Chrome in the container-based environment, pass `--no-sandbox` when invoking the `chrome` command.

```yaml
sudo: false
addons:
  chrome: stable
script:
  - chrome --no-sandbox
```
{: data-file=".travis.yml"}
