---
title: Precise Build Containers for Enterprise
layout: en_enterprise
---

## System Setup

**Platform Requirements**: Precise Build Containers are supported for Travis CI Enterprise version 2.0 and higher. We recommend [Trusty Build Environments](/user/enterprise/trusty/) for Travis CI Enterprise 2.2+, as Trusty Build Environments are the default environment.

To Legacy workers as default on Travis CI Enterprise 2.2+, override the fault behavior in the Admin Dashboard at `https://your-domain.tld:8800/settings#override_default_dist_enable`

**Worker Requirements**:
The Legacy worker must be running Ubuntu 14.04 LTS as an underlying operating system. We recommend using AWS's `c3.2xlarge` as the instance type. Port 22 must be open for SSH during installation and operation.

In addition, _Precise build containers and Trusty build containers must be on different instances_. To run both Precise and Trusty builds, at least two worker instances are required.

## Precise (Legacy) Worker Installation

Once a worker instance is up and running, `travis-worker` can be installed as follows:

For instances on AWS, please run: 

```
curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install/worker/legacy

sudo bash /tmp/installer.sh \
--travis_enterprise_host="[travis.yourhost.com]" \
--travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token] \
--aws=true"
```

For non-AWS instances, please run:

```
curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install/worker/legacy

sudo bash /tmp/installer.sh \
--travis_enterprise_host="[travis.yourhost.com]" \
--travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]"
```

This installer uses Docker's `aufs` storage driver. If you have any questions or concerns, please [get in touch with us](mailto: enterprise@travis-ci.com?subject=Precise%20Workers) to discuss alternatives.

## Restarting `travis-worker`

After installation, or when configuration changes are applied to the worker, restart the worker as follows:

`sudo service travis-worker restart` 

Worker configuration changes are applied on start.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
