---
title: Setting up Travis CI Enterprise with KOTS
layout: en_enterprise
redirect_from:
  - /user/enterprise/installation/
  - /user/enterprise/prerequisites/
  - /user/enterprise/install-on-xenial/

---

> Travis CI Enterprise works with your GitHub.com, GitHub Enterprise or Bitbucket setup.

## Prerequisites

  * A valid Travis CI Enterprise license or [trial license](https://enterprise.travis-ci.com/signup). 
  If you're interested in using [High Availability](/user/enterprise/high-availability/), 
  [please let us know](mailto:enterprise@travis-ci.com) so we can get your trial license configured.

  * At least two virtual machines on your private cloud that meet the [system requirements](#system-requirements)
  * The `secret` and `clientid` of a GitHub.com, GitHub Enterprise [OAuth application](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) 
  or Bitbucket [OAuth application]() configured with:

    - *Homepage URL* - `https://<your-travis-ci-enterprise-domain>`
    - *Authorization callback URL* - `https://<your-travis-ci-enterprise-domain>/api`
    +
    URLs must include https or http at the beginning and cannot have trailing slashes.

### System Requirements

The standard setup consists of the *Travis CI Enterprise
Platform* which hosts the web UI and related services, and one or more
*Worker hosts* which run the tests/jobs in isolated containers using LXC
and Docker.

Each dedicated host or hypervisor (VMWare, OpenStack using KVM, or EC2) should run **Ubuntu 16.04**, 
ideally using Linux 3.16 and have at least **16 gigs of RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c4.2xlarge** instance type for both **Platform** and **Worker**. 
We also recommend using an image that uses EBS for the root volume, as well as allocating 40 gigs of space to it.

For [high availability (HA)](/user/enterprise/high-availability/) configurations, you will also need:

* [Redis](https://redis.io/),
* [RabbitMQ](https://www.rabbitmq.com/)
* [Postgres](https://www.postgresql.org/)

You can also try services like [compose.com](https://compose.com/), if you would like these services hosted outside your organization.

## 1. Setting up Enterprise Platform virtual machine

The Travis CI Enterprise Platform handles licensing, coordinates worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed on it's own machine instance, separate from that of the Travis CI
Enterprise worker. 
We recommend using AWS' `c4.2xlarge` instance running
Ubuntu 16.04 LTS or later as the underlying operating system.
