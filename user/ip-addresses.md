---
title: IP Addresses
layout: en
permalink: /user/ip-addresses/
---

For some it might be necessary to know the public IP addresses of build machines in order to whitelist them to access some internal resources. We run builds in a variety of different infrastructures, so which ones you use determines which IP ranges you need to whitelist.

Infrastructure | IP ranges
-------------- | ---------
Container-based (travis-ci.com) | `nat-com.aws-us-east-1.travisci.net` (`54.172.141.90/32`, `52.3.133.20/32` as of March 14th, 2016)
Container-based (travis-ci.org) | `nat-org.aws-us-east-1.travisci.net` (`52.0.240.122/32`, `52.22.60.255/32` as of March 14th, 2016)
OS X | `208.78.110.192/27`
Sudo-enabled Linux | N/A (see below)

If we need to add more capacity to the network stack of our container-based infrastructure, we might add more IP addresses

We do not have static public IP addresses available for jobs running on the sudo-enabled Linux infrastructure at this time. We recommend using one of the other infrastructures if you need static IP addresses.

Note that these ranges can change in the future.
