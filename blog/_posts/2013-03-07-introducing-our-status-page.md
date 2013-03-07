---
title: Introducing Our Status Page
author: Mathias Meyer
twitter: roidrage
created_at: Thu Mar 7 2013 18:00:00 CET
permalink: blog/2013-03-07-introducing-our-status-page
layout: post
---
"All Systems Operational!" is the kind of thing everyone loves to see and hear.
Unfortunately failure is always lurking around the corner. During our outages in
the past, we lacked a public facing way to inform our users and customers about
potential issues on the platform, both for open source and private projects.

In short, we lacked a status page. We're sorry for holding off on shipping one
for so long, but the good news is, we finally have one in place.

If you hop over to <http://status.travis-ci.com> you'll be greeted by our
friendly mascot and the current state of all relevant parts of Travis CI,
together with the latest incidents and their resolutions.

![](https://f.cloud.github.com/assets/2208/232754/e63e7312-873f-11e2-8e6c-558f62ea413c.png)

The status updates are also connected to our Twitter account, so any incidents
will be posted there as well. We'll publish notifications for both platforms
there to avoid the confusion of having two status pages for each separately.

The status page also supports updates notifications via email, so you can sign
up to be notified via email when an issue comes up. Note that you'll get
notifications for both platforms, which may or may not be relevant to you
depending on which ones you're using.

We're using a hosted service for this service, courtesy of the fine folks at
<http://statuspage.io>.
