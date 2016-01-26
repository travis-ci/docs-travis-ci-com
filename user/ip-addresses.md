---
title: IP Addresses
layout: en
permalink: /user/ip-addresses/
---

For some it might be necessary to know the public IP addresses of build machines in order to whitelist them to access some internal resources. We run builds in a variety of different infrastructures, so which one you use determines which IP range you need to whitelist.

For jobs running on the container-based infrastructure, the ranges are `54.172.141.90/32` and `52.3.133.20/32` for travis-ci.com (private repositories), and `52.0.240.122/32` and `52.22.60.255/32` for travis-ci.org (public repositories).

For jobs running on our Mac infrastructure, the ranges are 208.78.110.192/27.

For jobs runing on the Linux infrastructure with sudo enabled, we currently do not have static public IP addresses available. We recommend using one of the other infrastructures if you need static IP addresses.

Please do note that these ranges can change in the future.
