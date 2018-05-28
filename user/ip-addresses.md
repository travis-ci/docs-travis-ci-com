---
title: IP Addresses
layout: en

---

Knowing the IP addresses of the build machines Travis CI uses can be helpful
when you need them safelisted to access your internal resources. Since builds
run in a variety of different infrastructures, the IP ranges to safelist depend
on the infrastructure your builds are running on.

| Infrastructure        |                NAT hostname                       | Current DNS                                                                            | Last recorded IPs |
| :-------------------- | :------------------------------------------------ | :------------------------------------------------------------------------------------- | :---------------- |
| OS X                  | {{ site.data.macstadium_ip_range['host'] }}       | [A recs](https://dnsjson.com/{{ site.data.macstadium_ip_range['host'] }}/A.json)       | `{{ site.data.macstadium_ip_range['ip_range'] | join: "` `" }}` |
| Container-based Linux | {{ site.data.linux_containers_ip_range['host'] }} | [A recs](https://dnsjson.com/{{ site.data.linux_containers_ip_range['host'] }}/A.json) | `{{ site.data.linux_containers_ip_range['ip_range'] | join: "`, `" }}` |
| Sudo-enabled Linux    | {{ site.data.gce_ip_range['host'] }}              | [A recs](https://dnsjson.com/{{ site.data.gce_ip_range['host'] }}/A.json)              | `{{ site.data.gce_ip_range['ip_range'] | join: "`, `" }}` |
| (all combined)        | {{ site.data.ip_range['host'] }}                  | [A recs](https://dnsjson.com/{{ site.data.ip_range['host'] }}/A.json)                  | (sum of all above) |
{: .ip-address-ranges}

Note that these ranges can change in the future, and the best way to keep an
updated safelist is to use the current A records for the **NAT hostname** shown
above, such as by using `dig`:

``` bash
dig +short nat.travisci.net | sort
```

or using a service like [dnsjson.com](https://dnsjson.com) to interact with
JSON:

``` bash
curl -s https://dnsjson.com/nat.travisci.net/A.json | jq '.results.records|sort'
```

Note that the IP addresses used for [notifications](/user/notifications) are
different.

More details about our different infrastructures are available on the
[virtualization environments
page](/user/reference/overview/#Virtualization-environments).
