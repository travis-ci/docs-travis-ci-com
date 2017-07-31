---
title: Ubuntu Precise to Ubuntu Trusty Migration Guide
layout: en
---

Ubuntu Trusty 14.04 LTS is becoming the default Linux distribution instead of Ubuntu Precise 12.04 LTS on Travis CI. Here are the most common issues our customers ran into and how you can fix them.

> If you’d like to stay on Ubuntu Precise or need more time to set up your repository with Ubuntu Trusty, please explicitly set `dist: precise` in your .travis.yml file as soon as possible.


## APT Packages availability

Some of the APT Packages available in Ubuntu Precise are no longer available in Ubuntu Trusty. 

* The binary package [`rubygems` is no longer available in Ubuntu Trusty](https://launchpad.net/ubuntu/trusty/+package/rubygems) and you can replace it with the [`ruby`](https://packages.ubuntu.com/trusty/ruby) package.


## Need Help?

Please feel free to contact us via our [support](mailto:support@travis-ci.com?subject=Issues migrating my build to Trusty) email address, or create a [GitHub issue](https://github.com/travis-ci/travis-ci/issues/new?title=Issues migrating my build to Trusty&body=Hi everyone! **links to the build on Precise and Trusty).
