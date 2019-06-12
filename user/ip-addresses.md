---
title: IP Addresses
layout: en

---

Knowing the IP addresses of the build machines Travis CI uses can be helpful
when you need them safelisted to access your internal resources. Since builds
run in a variety of different infrastructures, the IP ranges to safelist depend
on the infrastructure your builds are running on.

| Infrastructure | NAT hostname                                | Current DNS                                                                      | Last recorded IPs                                               |
|:---------------|:--------------------------------------------|:---------------------------------------------------------------------------------|:----------------------------------------------------------------|
| OS X           | {{ site.data.macstadium_ip_range['host'] }} | [A recs](https://dnsjson.com/{{ site.data.macstadium_ip_range['host'] }}/A.json) | `{{ site.data.macstadium_ip_range['ip_range'] | join: "` `" }}` |
| Linux          | {{ site.data.gce_ip_range['host'] }}        | [A recs](https://dnsjson.com/{{ site.data.gce_ip_range['host'] }}/A.json)        | `{{ site.data.gce_ip_range['ip_range'] | join: "`, `" }}`       |
| Windows        | {{ site.data.gce_ip_range['host'] }}        | [A recs](https://dnsjson.com/{{ site.data.gce_ip_range['host'] }}/A.json)        | `{{ site.data.gce_ip_range['ip_range'] | join: "`, `" }}`       |
| (all combined) | {{ site.data.ip_range['host'] }}            | [A recs](https://dnsjson.com/{{ site.data.ip_range['host'] }}/A.json)            | (sum of all above)                                              |
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
page](/user/reference/overview/#virtualization-environments).

## Load balancing

Due to load balancing, connections from build machines to external resources are not guaranteed to come from the same IP address, even when sent from the same job.
This may cause them to [trigger security checks](https://docs.travis-ci.com/user/common-build-problems/#ftpsmtpother-protocol-does-not-work), especially when using protocols that utilize multiple connections like FTP and VPN.
If this occurs, reconfigure your servers to allow for connections from multiple IP addresses.

## Notification

We will announce changes to this set of IP addresses with a 24 hour notice period. We recommend you use the DNS record to keep track automatically, but if you require a manual notification, you can subscribe to the mailing list:

<!-- Begin Mailchimp Signup Form -->
<link href="//cdn-images.mailchimp.com/embedcode/classic-10_7.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#mc_embed_signup{background:#fff; clear:left; font:14px Helvetica,Arial,sans-serif; }
	/* Add your own Mailchimp form style overrides in your site stylesheet or in this style block.
	   We recommend moving this block and the preceding CSS link to the HEAD of your HTML file. */
</style>
<div id="mc_embed_signup">
<form action="https://travis-ci.us7.list-manage.com/subscribe/post?u=8ce724a4c9af4dace663cd39c&amp;id=8760e616bf" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
    <div id="mc_embed_signup_scroll">

<div class="mc-field-group">
	<label for="mce-EMAIL">Email Address </label>
	<input type="email" value="" name="EMAIL" class="required email" id="mce-EMAIL">
</div>
	<div id="mce-responses" class="clear">
		<div class="response" id="mce-error-response" style="display:none"></div>
		<div class="response" id="mce-success-response" style="display:none"></div>
	</div>    <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
    <div style="position: absolute; left: -5000px;" aria-hidden="true"><input type="text" name="b_8ce724a4c9af4dace663cd39c_8760e616bf" tabindex="-1" value=""></div>
    <div class="clear"><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div>
    </div>
</form>
</div>
<!--End mc_embed_signup-->
