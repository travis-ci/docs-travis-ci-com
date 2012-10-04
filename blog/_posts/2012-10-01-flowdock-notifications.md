---
title: Flowdock Notifications
created_at: Mon Oct 01 01:30:00 PDT 2012
layout: post
author: Phil Cohen
twitter: phlipper
permalink: blog/2012-10-01-flowdock-notifications
---
_A HUGE thanks to Phil Cohen ([@phlipper](http://twitter.com/phlipper)) for writing this guest post and adding this awesome feature!_

I love platforms that enable collaboration and streamline workflows.
[Travis](http://travis-ci.org) is a great platform for seamless testing and
collaborative development (and what's not to love about an organization who
[shows so much love in return](http://cloud.phlippers.net/image/0Y0w1u2F0j2c/travis-love-certification.jpg)?!).

[Flowdock](https://www.flowdock.com/) is a fantastic platform for
communicating and coordinating with teams, and has an amazingly simple and
flexible [set of APIs](https://www.flowdock.com/api) for enabling custom
integrations.

I couldn't sleep the other night, so I scratched an itch and integrated the two!

Just add the following line to your `.travis.yml` to get in the flow:

    notifications:
      flowdock: [api token]

You may notify multiple flows by using a comma-separated string or an array in
the configuration.

Flowdock has nice support for build notifications, setting the message icon
based on the build status. You'll know immediately whether the build has been
broken or fixed, as well as who the villain or hero is. Neat!

<img style="width: 550px; height: 300px" src="http://cloud.phlippers.net/image/3i3s2C1v3m3C/travis-flowdock-fail.png"/>
<img style="width: 550px; height: 225px" src="http://cloud.phlippers.net/image/0l1H0o2D1C2E/travis-flowdock-ok.png"/>

This feature is available on both Travis platforms, [open
source](http://travis-ci.org) and [for private
repositories](http://travis-ci.com).
