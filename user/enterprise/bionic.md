---
title: Bionic Build Containers for Enterprise
layout: en_enterprise

---

## System Setup

**Platform Requirements**: To use the Bionic build containers, the Travis CI installation must be at 2.2.6 or higher. Please be sure to [upgrade TCIE 2.x](/user/enterprise/upgrading/) or [install TCIE 3.x](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise), if needed, before getting started.

**Worker Requirements**:

We recommend using a **compute optimized** machine with 8 vCPUs and ~16 GB of memory, and at least 60 GB of disk space. Also, we suggest to run Ubuntu 18.04 or later. Port 22 must be open for SSH during installation and operation.

> A single worker machine can only be used together with one build environment. If you would like to setup additional build environments (such as Xenial or Focal), please provision an additional machine. 

## Third party apt repositories and services disabled by default

[Third party apt-repositories are removed](https://docs.travis-ci.com/user/reference/bionic/#third-party-apt-repositories-removed) to help reduce risk of unrelated interference and allow for faster apt-get updates.

[Services disabled by default](https://docs.travis-ci.com/user/reference/bionic/#services-disabled-by-default) to speed up boot time and improve performance.

## Installation with Travis CI Enterprise 2.2.6 and later

To install the Bionic build environment on a new server, run the commands below:

```bash
$ curl -sSL -o /tmp/installer.sh https://raw.githubusercontent.com/travis-ci/travis-enterprise-worker-installers/master/installer.sh

$ sudo bash /tmp/installer.sh \
--travis_enterprise_host="[travis.yourhost.com]" \
--travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]" \
--travis_build_images=bionic
```

## Restarting `travis-worker`

After installation, or when configuration changes are applied to the worker, restart the worker as follows:

```bash
$ sudo systemctl restart travis-worker
```

Worker configuration changes are applied on start.

## Running Builds in the Bionic Build Environment

To run a project's builds in the new Bionic build environment, please add a `dist: bionic` to your `.travis.yml` file.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
