---
title: IP Addresses
layout: en
permalink: /user/ip-addresses/
---

Knowing the IP addresses of the build machines Travis CI uses can be helpful when you need them safelisted to access your internal resources. Since builds run in a variety of different infrastructures, the IP ranges to safelist depend on the infrastructure your builds are running on:

Infrastructure | IP ranges
-------------- | ---------
Container-based (travis-ci.com) | `nat-com.aws-us-east-1.travisci.net` (`54.172.141.90/32`, `52.3.133.20/32` as of March 14th, 2016)
Container-based (travis-ci.org) | `nat-org.aws-us-east-1.travisci.net` (`52.0.240.122/32`, `52.22.60.255/32` as of March 14th, 2016)
OS X | `208.78.110.192/27`
Sudo-enabled Linux | N/A (see below)

We do not have static public IP addresses available for jobs running on the sudo-enabled Linux infrastructure at this time. We recommend using one of the other infrastructures if you need static IP addresses.

Note that these ranges can change in the future.

More details about our different infrastructures are available on the [virtualization environments page](/user/ci-environment/#Virtualization-environments).
