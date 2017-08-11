---
title: Ubuntu Precise to Ubuntu Trusty Migration Guide
layout: en
---

As of July, 18th 2017, we're switching the default Linux distribution on Travis CI from Ubuntu Precise 12.04 LTS to
Ubuntu Trusty 14.04 LTS. Here are the most common issues our customers ran into and how you can fix them.

> If you’d like to stay on Ubuntu Precise or need more time to set up your repository with Ubuntu Trusty, please explicitly set `dist: precise` in your .travis.yml file as soon as possible.


## APT Packages availability

Some of the APT Packages available in Ubuntu Precise are no longer available in Ubuntu Trusty.

* The binary package [`rubygems` is no longer available in Ubuntu Trusty](https://launchpad.net/ubuntu/trusty/+package/rubygems) and you can replace it with the [`ruby`](https://packages.ubuntu.com/trusty/ruby) package.

## Oracle JDK 7 availability

Oracle JDK 7 (i.e. `jdk: oraclejdk7`) is unfortunately no longer available in Ubuntu Trusty. The current workarounds are the following:

  1. If it's an option for you, Open JDK 7 is still available. You can use it in your builds by adding the following in your .travis.yml file: `jdk: openjdk7`
  1. Stay on Ubuntu Precise by explicitly setting `dist: precise` in your .travis.yml file.


## Need Help?

Please feel free to contact us via our [support](mailto:support@travis-ci.com?subject=Issues%20migrating%20my%20build%20to%20Trusty) email address, or create a [GitHub issue](https://github.com/travis-ci/travis-ci/issues/new?title=Issues%20migrating%20my%20build%20to%20Trusty&body=Hi%20everyone!%20**links%20to%20the%20build%20on%20Precise%20and%20Trusty).
