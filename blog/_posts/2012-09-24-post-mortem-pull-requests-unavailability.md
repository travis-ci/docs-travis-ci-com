---
title: Post-Mortem: Pull Request Unavailability
layout: post
permalink: blog/2012-09-24-post-mortem-pull-request-unavailability
created_at: Mon Sep 24 21:00:00 CEST 2012
author: Mathias Meyer
twitter: roidrage
---
As I'm sure you've noticed, it hasn't been a great week for our availability.

First up, we're sorry for having had yet another outage to report about. But
we'd like to keep you in the loop about what happened, why it happened, and what
we're going to do to make sure that it doesn't affect us like this again.

### What happened?

Last Wednesday, in the European afternoon, we started seeing an increased number
of errors hitting the GitHub API. We kept getting 403 errors hitting API
endpoints that used to work perfectly well before. The errors went away after a
while. We were left scratching our hands about this sudden anomaly, but things
were apparently running smoothly again after that.

On Thursday, things suddenly turned for the worse. Requests to the GitHub API
kept stalling incoming build requests entirely, and we'd see an abundance of 403
errors in our logs again. So we continued investigating.

At 8 pm CEST, things came to a grinding halt, and no build requests were
processed at all. We started investigating the cause, and bumped a lot of
corners on the way.

The main component that's scheduling and distributing builds, kept stalling on
us, no matter how we looked at it. Running on Heroku, we unfortunately didn't
have enough means to get a JVM stack trace of that component. The component runs
on JRuby, and Charles Nutter was very helpful and pointed us into several
directions.

First up, we saw timeouts in SSL connections, and specifically only when
fetching meta data about a pull request. So we kept investigating in this
direction and tried to find out why our internal timeouts didn't fire.

We ended up putting this component on external cloud capacity that we have
available thanks to [Bluebox](http://www.bluebox.net) (why we have this capacity
is a story to be told in a separate post). We deployed the component on JRuby
1.7.0-preview2 on a server we have physical access to.

So we were able to start debugging the issue further by inspecting thread dumps
and profiling the JVM using [VisualVM](http://visualvm.java.net). We still kept
running into the same issues, timeouts not being hit. But at least we were able
to more reliably get timeouts eventually.

At around 2:30 am CEST, things were looking up, and we left things running on
its own, on the new server. Queue processing seemed to go smoothly until we
started looking back into things the next morning to clean up things left over
from the night before.

We still noticed an inadequate number of 403 errors in our logs. Thanks to Wynn
from GitHub, we finally added code that allowed us to track what API endpoints
were being hit, and how our rate limit developed over time. That data is now
always attached to errors when we access the API, so we'll have a track record
of things going wrong.

We were still seeing stalling requests for pull requests, but we reduced the
timeouts so that they didn't affect the other build requests for too long.
Having these details in place we realized that we kept hitting the GitHub API
unauthenticated and therefore hit the default, IP-based rate limit of 6000
requests very quickly.

We added longer timeouts so we didn't hit the API as often, and started using
our OAuth client credentials, so that all requests count against our
application's rate limit instead of the IP-based one.

Things went back to normal again for a while, until Friday night. The timeouts
kept getting worse and worse until eventually, all requests that hit the pull
requests API were timing out on our end.

We finally pulled the plug at 2:00 am CEST on Saturday morning and disabled pull
request testing entirely, until we'd found out why we suddenly kept seeing these
timeouts. Things were then running smoothly until Monday morning, when that
component ran out of memory. We doubled the available amount and things have
been running smoothly since.

After investigating more, working together with the GitHub team, we found the
root cause of why things were stalling.

### Why did it happen?

When we get a pull request, we hit the GitHub API, an undocumented part no less,
to determine the merge state of a pull request. We only test pull requests that
are mergeable, so when a pull request is green to merge on GitHub, we will test
it as well. The reason is simple: we can't automatically test a pull request
when we already know that merging it would fail and require manual interaction.

To determine the status, we continuously poll the GitHub API. Until last week's
events, we hit the API every 0.1 seconds. Usually, an updated status wouldn't
take longer than a second.

Last week, that part suddenly took longer than 10 minutes, which triggered our
global timeout, but also meant that we could basically just accept six build
requests per hour. Processing requests is currently a serial process, working
through one request at a time.

You can start doing the math on this now. For 10 minutes, we'd hit the GitHub
API in 0.1 second intervals. If we requests take 100 ms, we're at 3000 requests
in just ten minutes. Two pull requests and our rate limit is gone. That meant
403 errors everywhere for the rest of the hour. After that, things started from
scratch, but we ran into a wall pretty quickly again.

As it happens, we had two timeouts in place. One that was 10 minutes, which was
implemented in
[gh](https://github.com/rkh/gh/blob/13a0dad7fadde7dcd79f181cb375ff125744efd5/lib/gh/merge_commit.rb#L68-77),
our own GitHub API client library, and another one was setup in the
aforementioned component, set to 60 seconds. We were quite baffled why the
smaller timeout that wrapped the bigger one didn't trigger.  Turns out, this is
an oddity in JRuby's implementation of the `Timeout` class.

On JRuby, if there's a nested timeout that has a longer timeout value than the
outer one wrapping it, the nested timeout will have precedence. This is not the
case on MRI, but happens reproducably on JRuby, both 1.6.7 and 1.7.0-preview2.
This is why pull requests kept stalling things for so long. The GitHub status of
a pull request never changed into a state we can handle, and we had a very long
timeout, wrapped by a smaller timeout, with the longer timeout having precedence
and causing things to stall for 10 minutes at a time.

Meanwhile, we hit the API so often, we ran into our rate limit immediately.

The initial steps we took was to lower the timeout of 10 minutes to just 180
seconds, and increasing the intervals between polls of the GitHub API. We also
use our OAuth credentials with every request to avoid running into the IP-based
timeout.

We also added a feature flip along the way that allows us to enable and disable
pull request builds quickly, should this situation come up again in the future.

Coming to the route cause of all of this, it was an unlikely set of
circumstances that hit at the most unexpected time, as they always do. An
increased delay of processing on an internal part of the GitHub API brought up
timeout issues that in turn brought things to a halt because we only process one
build process at a time, a cascading failure throughout the Travis system, if
you will.

No matter how you look at it, this was bound to happen eventually, and we're
very sorry that it did, and that we didn't notice the dangers in this part of
Travis sooner.

You don't simply rely on an external API to always work and respond in the way
you expect, and in a timely manner too. APIs tend to break every now and then,
they become unavailable temporarily, and they can change in unexpected ways.
We're at fault for not considering the implications of this sooner.

We want to make sure this doesn't happen again, or at least make sure that
increased API delays don't affect the overall system.

### What are we going to do about it?

While GitHub has fixed the issue on their end (thank you, guys!) we're still
left with things to clean up to make sure an problem like this doesn't cascade
through the entire Travis system again.

Apart from the decreased timeouts, increased intervals between polls, included
OAuth credentials to reduce the likelihood of running into rate limits, we're
adding exponential back-off to the gh code base to increase the interval with
every request we have to make for a single pull request.

Work as also started to pull processing build requests out of the hub component,
which currently carries a lot of responsibility. It's our priority to remove as
much of that responsibility from its runtime and break it out into smaller apps.

A while ago we wrote about our issues with log updates and the app we broke out
of the hub to deal with that. We're going to continue that trend, and build
request processing is the next step.

That component will allow parallel processing of build requests and will most
likely separate handling of pull requests from normal pushes, as both use very
different API endpoints.

To make sure that things don't just continue running when we see an increase in
API errors, we're going to track the errors in total and [trip a
circuit](https://en.wikipedia.org/wiki/Circuit_breaker_design_pattern) when
they reach a threshold.

We'll also make sure that failures hitting the API are retried later so that we
don't just give up on a single build. Your builds are important to us, and we
want to make sure we run every single one of them!

The new component uses [Celluloid](http://celluloid.io) under the hood, so we
get benefits like thread supervision, timeouts, exit handling of linked threads,
and very simple message passing to hook actors together.

We have these things lined up and are actually starting to roll them out rather
soon, but that doesn't make up for the lost builds unfortunately. We're sorry
about them, we'd have liked to make sure they at least stick around until issues
are resolved, but in this case, the issue was too big. Catching up on everything
that's in our queues after a weekend would've taken a very long time. It's why
we're looking into alternatives to VirtualBox that allow us to be a lot more
flexible when it comes to running builds.

Love, the Travis team!
