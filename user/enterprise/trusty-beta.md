---
title: Trusty Build Containers for Enterprise (beta)
layout: en_enterprise

---

> Note: This is a BETA feature. If you have any questions, suggestions, or run into any trouble, please email [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com?subject=Trusty%20Beta). We look forward to your feedback!
{: .beta}

## System Setup

**Platform Requirements**: To use the Trusty build containers, the Travis CI installation must be at 2.1.9 or higher. Please be sure to [upgrade](/user/enterprise/upgrading/), if needed, before getting started with this feature. 

**Worker Requirements**: While workers with the older Precise (Ubuntu 12.04) containers can co-exist with Trusty workers in an installation configuration, _Precise build containers and Trusty build containers must be on different instances_. To run both Precise and Trusty builds, at least two worker instances are required.

### Enabling the Trusty Beta Feature Flag

1. SSH into the platform machine
2. Run `travis console`
3. Then run `Travis::Features.enable_for_all(:template_selection); Travis::Features.enable_for_all(:multi_os)`
4. Type in `exit` to leave the console
5. Disconnect from the Travis Enterprise platform machine


## Installation on AWS
Spin up at least one additional AWS worker machine. Please note: DeviceMapper installer only supports the recommended c3.2xlarge machines due to the storage layout. Once this are ready, run:

`curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install/worker/trusty-devicemapper`

Next, run the following to complete the install:

`sudo bash /tmp/installer.sh --travis_enterprise_host="[travis.yourhost.com]" --travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]" --aws=true`

## Installation on Non-AWS

Start at least one additional worker machine and run:

`curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install/worker/trusty`

Next, run the following to complete the install:

`sudo bash /tmp/installer.sh --travis_enterprise_host="[travis.yourhost.com]" --travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]"`

There are two differences with the non-AWS installer. First, it uses AUFS instead of DeviceMapper and, second doesn't have strict storage device layout requirements which would otherwise be required for setting up the DeviceMapper volumes.

## Running builds on Trusty

To run builds on a worker with Trusty images, please add `dist: trusty` to your `.travis.yml`. If that key is not present in your project's `.travis.yml`, the build will routed to the Precise build environments instead. 
