---
title: Focal Build Containers for Enterprise (beta)
layout: en_enterprise

---

## System Setup

**Platform Requirements**: To use the Focal build containers, the Travis CI Enterprise (TCIE) installation must be at version 3.0 or higher. 
Please be sure to [install TCIE 3.x](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise), if needed, before getting started.

**Worker Requirements**:

We recommend using a **compute optimized** machine with 8 vCPUs and ~16 GB of memory and at least 60 GB of disk space. Also, you'll want to run Ubuntu 20.04 or later. Port 22 must be open for SSH during installation and operation.

> A single worker machine can only be used together with one build environment. If you would like to setup additional build environments (such as Xenial or Focal), please provision an additional machine. 

## Third party apt repositories and services disabled by default

[Third party apt-repositories are removed](https://docs.travis-ci.com/user/reference/focal/#third-party-apt-repositories-removed) to help reduce risk of unrelated interference and allow for faster apt-get updates.

[Services disabled by default](https://docs.travis-ci.com/user/reference/focal/#services-disabled-by-default) to speed up boot time and improve performance.

## Installation with Travis CI Enterprise 3.0 and later

On a new server, please run the commands below to install the Focal build environment:

```bash
$ curl -sSL -o /tmp/installer.sh https://raw.githubusercontent.com/travis-ci/travis-enterprise-worker-installers/master/installer.sh

$ sudo bash /tmp/installer.sh \
--travis_enterprise_host="[travis.yourhost.com]" \
--travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]" \
--travis_build_images=focal
```

## Restarting `travis-worker`

After installation, or when configuration changes are applied to the worker, restart the worker as follows:

```bash
$ sudo systemctl restart travis-worker
```

Worker configuration changes are applied on start.

## Running Builds in the Focal Build Environment

To run a project's builds in the new Focal build environment, please add a `dist: focal` to your `.travis.yml` file.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
