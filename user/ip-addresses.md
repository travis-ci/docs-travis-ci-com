---
title: IP Addresses
layout: en

---

Knowing the IP addresses of the build machines Travis CI uses can be helpful
when you need them safelisted to access your internal resources. Since builds
run in a variety of different infrastructures, the IP ranges to safelist depend
on the infrastructure your builds are running on:

| Infrastructure                  | IP ranges                                                                                                                        |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------|
| Container-based (travis-ci.com) | `workers-nat-com-shared-2.aws-us-east-1.travisci.net` (`52.45.220.64/32` `52.54.40.118/32` `54.89.89.104/32` `54.82.137.203/32`) |
| Container-based (travis-ci.org) | `workers-nat-org-shared-2.aws-us-east-1.travisci.net` (`52.45.185.117/32` `52.54.31.11/32` `54.87.185.35/32` `54.87.141.246/32`) |
| OS X                            | `208.78.110.192/27`                                                                                                              |
| Sudo-enabled Linux              |  See notes below. <br><br>{{site.data.gce_ip_range}}                                                                            |

> **Note:** We do not have static public IP addresses available for jobs running on the
> sudo-enabled Linux infrastructure at this time.
>
> This list of IP addresses is obtained by [the process described by
> Google](https://cloud.google.com/compute/docs/faq#where_can_i_find_short_product_name_ip_ranges).
> We recommend using one of the other infrastructures if you need static IP
> addresses.

Note that these ranges can change in the future, and that the IP addresses used
for [notifications](/user/notifications) are different.

More details about our different infrastructures are available on the
[virtualization environments
page](/user/reference/overview/#Virtualization-environments).
