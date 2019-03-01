---
title: Trusty Build Containers for Enterprise
layout: en_enterprise

---

## System Setup

**Platform Requirements**: To use the Trusty build containers, the Travis CI installation must be at 2.1.9 or higher. Please be sure to [upgrade](/user/enterprise/upgrading/), if needed, before getting started.

**Worker Requirements**:

We recommend using a machine with 8 vCPUs and 15 GiB of memory and at least 40 GiB of disk space. If you're using AWS that will be their c4.2xlarge instance type. Also, you'll want to run Ubuntu 16.04 or later. Port 22 must be open for SSH during installation and operation.

> _Precise build containers and Trusty build containers must be on different instances_. To run both Precise and Trusty builds, at least two worker instances are required.

## Installation with Travis CI Enterprise 2.2+

Once a worker instance is up and running, `travis-worker` can be installed as follows:

```
curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install/worker

sudo bash /tmp/installer.sh \
--travis_enterprise_host="[travis.yourhost.com]" \
--travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]"
```

This installer uses Docker's `aufs` storage driver. If you have any questions or concerns, please [get in touch with us](mailto: enterprise@travis-ci.com?subject=Precise%20Workers) to discuss alternatives.


## Installation with Travis CI Enterprise 2.1.9+

The Travis CI Enterprise 2.1 series has the [Precise [Legacy]](/user/enterprise/precise) as it's default worker. However, starting with version 2.1.9+, it is possible to use Trusty build environments, assuming the feature flags are set. Otherwise, the installation process is very similar to the Enterprise 2.2 series.

### Enabling the Trusty Beta Feature Flag

1. SSH into the platform machine
2. Run `travis console`
3. Then run `Travis::Features.enable_for_all(:template_selection); Travis::Features.enable_for_all(:multi_os)`
4. Type in `exit` to leave the console
5. Disconnect from the Travis Enterprise platform machine

### Installation (Travis CI Enterprise 2.1.9+)

Once a worker instance is up and running, `travis-worker` can be installed as follows:

```
curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install/worker

sudo bash /tmp/installer.sh \
--travis_enterprise_host="[travis.yourhost.com]" \
--travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]"
```

This installer uses Docker's `aufs` storage driver. If you have any questions or concerns, please [get in touch with us](mailto: enterprise@travis-ci.com?subject=Precise%20Workers) to discuss alternatives.

### Running builds on Trusty on Travis CI Enterprise 2.1.9+

To run builds on a worker with Trusty images, please add `dist: trusty` to your `.travis.yml`. If that key is not present in your project's `.travis.yml`, the build will routed to the default (Precise) build environments instead.

## Restarting `travis-worker`

After installation, or when configuration changes are applied to the worker, restart the worker as follows:

`sudo service travis-worker restart`

Worker configuration changes are applied on start.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
