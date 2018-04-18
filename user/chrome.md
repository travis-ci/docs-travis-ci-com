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

In that case, you may see an error message like this:

```
30 11 2017 13:35:42.245:ERROR [launcher]: Cannot start Chrome
  [4315:4315:1130/133541.781662:FATAL:setuid_sandbox_host.cc(157)] The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now. You need to make sure that /opt/google/chrome/chrome-sandbox is owned by root and has mode 4755.
```

To use Chrome in the container-based environment, pass the `--no-sandbox` flag to the `chrome` executable.

The method to accomplish this varies from one testing framework to another.
For example, with [the customlauncher plugin for Karma](https://github.com/karma-runner/karma-chrome-launcher), you would add it to the `flags` array:

```javascript
module.exports = function(config) {
  config.set({
    browsers: ['Chrome', 'ChromeHeadless', 'ChromeHeadlessNoSandbox'],

    // you can define custom flags
    customLaunchers: {
      ChromeHeadlessNoSandbox: {
        base: 'ChromeHeadless',
        flags: ['--no-sandbox']
      }
    }
  })
}
```

Please consult your tool's documentation for further details on how to add the `--no-sandbox` flag.
