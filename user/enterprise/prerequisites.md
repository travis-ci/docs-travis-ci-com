---
title: Enterprise System Prerequisites
layout: en

---

<div id="toc"></div>

## Licensing

To register for a 30 day trial please visit [our signup page](https://enterprise.travis-
ci.com/signup). Please email [enterprise@travis-ci.com](mailto:enterprise
@travis-ci.com) for more information on pricing.

Getting started guides can be found [in the Travis CI docs](/)

## System Requirements Prerequisites
 * Two dedicated hosts or hypervisors (VMWare, OpenStack using KVM, or EC2) with
  **Ubuntu 14.04** installed
 * A Travis CI Enterprise license file
 * A GitHub Enterprise OAuth app

**Note: We recommend using Linux 3.16**

## Host Machines Specs

The standard setup consists of two hosts, the Travis CI Enterprise
Platform which hosts the web UI and related services, and one or more
Worker hosts which run the tests/jobs in isolated containers using LXC
and Docker.

If you are using EC2 we recommend the **c3.2xlarge** instance types.

For other setups we recommend hosts with 16 gigs of RAM and 8 CPUs.

## Register a GitHub OAuth App

Travis CI Enterprise talks to GitHub Enterprise via OAuth. You will need
to create an OAuth app on your GitHub Enterprise that Travis CI
Enterprise can connect to.

The OAuth app registered will use the domain name pointing to your
Platform host for the Homepage URL (e.g.
https://travis-ci.your-domain.com). Append /api to this for the
Authorization callback URL (e.g. https://travis-ci.your-domain.com/api).
