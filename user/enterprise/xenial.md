---
title: Xenial Build Containers for Enterprise (beta)
layout: en_enterprise

---

## System Setup

**Platform Requirements**: To use the Xenial build containers, the Travis CI installation must be at 2.2.6 or higher. Please be sure to [upgrade](/user/enterprise/upgrading/), if needed, before getting started.

**Worker Requirements**:

We recommend using a machine with 8 vCPUs and 15 GB of memory and at least 40 GB of disk space. If you're using AWS, that will be their c4.2xlarge instance type. Also, you'll want to run Ubuntu 16.04 or later. Port 22 must be open for SSH during installation and operation.

> _Trusty and Xenial build containers must be on different instances_. To run both Trusty and Xenial builds, at least two worker instances are required.

## Differences from the Trusty Build Environment

[Third party apt-repositories are removed](https://docs.travis-ci.com/user/reference/xenial/#third-party-apt-repositories-removed) to help reduce risk of unrelated interference and allow for faster apt-get updates.

[Services disabled by default](https://docs.travis-ci.com/user/reference/xenial/#services-disabled-by-default) to speed up boot time and improve performance.

## Installation with Travis CI Enterprise 2.2.6 and later

On a new server, please run the commands below to install the Xenial build environment:

```bash
$ curl -sSL -o /tmp/installer.sh https://raw.githubusercontent.com/travis-ci/travis-enterprise-worker-installers/master/installer.sh

$ sudo bash /tmp/installer.sh \
--travis_enterprise_host="[travis.yourhost.com]" \
--travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]" \
--travis_build_images=xenial
```

## Restarting `travis-worker`

After installation, or when configuration changes are applied to the worker, restart the worker as follows:

```bash
$ sudo systemctl restart travis-worker
```

Worker configuration changes are applied on start.

## Running Builds in the Xenial Build Environment

To run a project's builds in the new Xenial build environment, please add a `dist: xenial` to your `.travis.yml` file.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
