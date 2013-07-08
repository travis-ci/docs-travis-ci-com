---
title: Operating Your Site with Hubot
author: Mathias Meyer
twitter: roidrage
created_at: Mon 8 Jul 2013 16:00:00 CEST
layout: post
permalink: 2013-07-08-operating-your-site-with-hubot
---
![](http://s3itch.paperplanes.de/Travis_CI_Status_20130708_114543.jpg)

While we're still a pretty small team, we heavily rely on Campfire for our daily
work and for communicating. Adding [Hubot](https://hubot.github.com) to the mix
was only natural.

While Hubot is great for the pug bombs alone, we drew some more inspiration from
GitHub's daily workflow, in particular for the operational part of Travis CI.

For some context, I'd recommend you watch these talks by [Mark
Imbriaco](http://vimeo.com/67178303) and [Jesse
Newland](http://vimeo.com/67178160). They're from Monitorama in Boston (did you
know Monitorama is coming to [Berlin in September 2013](http://monitorama.eu)?
You should come!), and give a good overview on how they're using Hubot to do all
kinds of crazy things for operations at GitHub. My thanks to both of them for
the inspiration!

While we're not fully there yet, after Monitorama I set out to tackle two
things to improve on our operations. For one, I wanted to have a seamless
integration of pushing incident updates to our [status
page](http://status.travis-ci.com). Next, I wanted to have integration for our
pager service.

Let's have a look at how this works out.

### Status updates

We're using the fine services from [StatusPage.io](http://statuspage.io) for our
status page. I heckled them early on to throw an API our way so we can integrate
it with Hubot. They were kind enough to ship one very shortly after, and we were
off!

The integration allows for a few very simple commands. It allows you to update
the status of specific components, for instance to set the status of our
component "Build Processing" to a degraded state, all that's required is the
command `/status Build Processing degraded`.

Whenever a component is in a non-operational state, a status message should go
along with it to explain what's going on.

Here's an example from a recent outage where our build processing was having
issues because of problems with the infrastructure handling our private cloud
setup. We noticed an increasing amount of errors and updated our status page
right away.

![](http://s3itch.paperplanes.de/open_incident_20130708_110403.png)

The incident immediately pops up on our status page and on the [Twitter feed for
our system status](https://twitter.com/traviscistatus) (you should follow this
guy, he'll keep you up-to-date!).

During an outage we send updates to the page with the '/status update' command.
Same for resolving an issue when the site has recovered from the incident.

![](http://s3itch.paperplanes.de/Screenshot_20130708_110800.png)

You may wonder why we're going through the trouble of building the scripts and
integrating them rather than go through the beautiful web app that's powering
StatusPage.io.

Switching contexts is expensive, even more so during an outage. We're a small
team, and the more we can focus on communication and handling the incident, the
less context-switching is required.

### Handling Alerts

When handling alerts, reducing context-switching is again relevant. We're using
[OpsGenie](http://opsgenie.com), and opening the website or even just pulling out your phone to go
through the menus to acknowledge an alert steals away focus from the issue at
hand.

OpsGenie recently added pager notifications to Campfire, which is very handy for
us. We used to have our own alerting, but the OpsGenie integration is a lot
better, as it includes links to the alerts.

We have escalation procedures in place that start out with a push notification,
then send a txt message and finally do a voice call if there's no response. A
repsonse is simply acknowledging an alert to signal that you're looking into it.

Surely this can be done from within Campfire too? Of course it can!

Here's an example of an alert coming in from OpsGenie.

![](http://s3itch.paperplanes.de/Screenshot_20130708_112723.png)

As you can see, we were already deploying a first mitigation fix when the alert
came in.

In quite a few occasions we have multiple alerts coming in. There's one that
notifies us when a build hasn't started in a while, and another one following
when no builds has finished recently.

So we needed an easy way to acknowledge any open alerts without worrying too
much about details.

![](http://s3itch.paperplanes.de/Screenshot_20130708_113158.png)

A single command acknowledges all open and unacknowledged alerts.

My thanks for [Eric Lindvall](http://twitter.com/lindvall) for the inspiration,
it works out beautifully in practice.

Our Hubot scripts for OpsGenie also include means to list open alerts and to close
them directly. We're working to add more things, in particular to handle the
on-call schedule from within Campfire.

### Moustached Hubot

In the spirit of Travis CI, we open sourced our [Hubot integrations for
StatusPage.io and OpsGenie](https://github.com/travis-ci/moustached-hubot). It's
a continuous effort, and we're working on adding more of our essential services
to the mix.
