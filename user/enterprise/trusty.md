---
title: Trusty Build Containers for Enterprise
layout: en_enterprise

---

## System Setup

**Platform Requirements**: To use the Trusty build containers, the Travis CI installation must be at 2.1.9 or higher. Please be sure to [upgrade](/user/enterprise/upgrading/), if needed, before getting started with this feature.

**Worker Requirements**: While workers with the older Precise (Ubuntu 12.04) containers can co-exist with Trusty workers in an installation configuration, _Precise build containers and Trusty build containers must be on different instances_. To run both Precise and Trusty builds, at least two worker instances are required.

### Enabling the Trusty Beta Feature Flag

1. SSH into the platform machine
2. Run `travis console`
3. Then run `Travis::Features.enable_for_all(:template_selection); Travis::Features.enable_for_all(:multi_os)`
4. Type in `exit` to leave the console
5. Disconnect from the Travis Enterprise platform machine


## Installation

Start at least one additional worker machine and run:

`curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install/worker/trusty`

Next, run the following to complete the install:

`sudo bash /tmp/installer.sh --travis_enterprise_host="[travis.yourhost.com]" --travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]"`

This installer uses Docker's `aufs` storage driver. If you have any questions or concerns, please [get in touch with us](mailto: enterprise@travis-ci.com?subject=Trusty%20Workers) to discuss alternatives.

## Running builds on Trusty

To run builds on a worker with Trusty images, please add `dist: trusty` to your `.travis.yml`. If that key is not present in your project's `.travis.yml`, the build will routed to the default (Precise) build environments instead.
