---
title: Ubuntu Trusty to Ubuntu Xenial Migration Guide
layout: en
---

As of August, 13th 2019, we've switched the default Linux distribution on Travis CI from Ubuntu Trusty 14.04 LTS to
Ubuntu Xenial 16.04. Here are the most common issues our customers ran into and how you can fix them.

> If you’d like to stay on Ubuntu Trusty or need more time to set up your repository with Ubuntu Trusty, 
please explicitly set `dist: trusty` in your .travis.yml file as soon as possible.

## What does this mean for your projects?

Repositories without an explicit `dist: YAML` key in their `.travis.yml` file will be routed to Xenial instead of Trusty.

Repositories without an explicit operating system `os:` key in their `travis.yml` file will use Linux Ubuntu Xenial 16.04.

There are three important changes to take into account when updating to Xenial from our Trusty build environment:

### 1. Services support

Services like [MySQL or PostgreSQL](https://docs.travis-ci.com/user/database-setup/) are not started by default. To start any service, such as MySQL, add it to the services key in your config:

```
  services:
    - mysql
```

### 2. Third-party APT sources

Sources from third-party APT repositories have been removed. During the Xenial image provision, third-party APT repositories are used to pre-install services like `redis-server`. These packages are available during build time, but to reduce the risk of sporadic `apt-get update` failures, the repositories are removed after the packages are installed.

For example, to update the `git-lfs` version, you’d need to explicitly specify the source in your config:

You can find the full list of sources that have been used and to install packages and then were removed [here](https://docs.travis-ci.com/user/reference/xenial#third-party-apt-repositories-removed).

```
addons:
  apt:
    sources:
    	- github-git-lfs-xenial
    packages:
    	- git-lfs
```

### 3. Headless browser testing

To use headless browser testing, you now start `xvfb` via the services key, like this:

```
services:
  - xvfb
```

> If you had configured `xvfb` manually in your trusty builds, please replace it with the services key above, which is also easier to maintain!

## To recap!

The default build environment is Ubuntu Xenial 16.04. You can identify if your repository is now running on Xenial by checking your build log, under Operating System Details like:

![OS details](/images/2019-04-15-xenial-build-log.png)

Jobs run on Xenial, display Operating System Details, Description: Ubuntu 16.04.5 LTS
You can find the specific versions of what’s pre-installed in the [Xenial Reference docs](/user/reference/xenial/).

> If your build depends on  a different Ubuntu distribution like Ubuntu Trusty 14.04, you can explicitly specify `dist: trusty` to ensure your build will use it.


## Need Help?

Please feel free to contact us via our [support](mailto:support@travis-ci.com?subject=Issues%20migrating%20my%20build%20to%20Xenial) email address, or create a [forum topic](https://travis-ci.community/c/environments/xenial).
