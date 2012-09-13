---
title: An Update on the Site's Availability
author: Mathias Meyer
twitter: roidrage
created_at: Thu Sep 13 2012 21:00:00 CEST
permalink: blog/2012-09-13-an-update-on-the-sites-availability
---
As I'm sure you've noticed, Travis CI wasn't doing its best recently. The site
kept being unavailable in unregular intervals. We're sorry for these
unavailabilities, and we wanted to keep you in the loop of what has happened and
what we've done about it. Or rather, what we're still doing about it.

The only part really affected by the unavailabilities was the web site. The rest
of the app hummed along rather nicely. So we could isolate the problem already
to that part of the app.

### What happened?

While we don't have enough monitoring data available yet for our PostgreSQL
instance, the fine folks at Heroku gave us enough clues to figure out that the
database is part of the problem.

The Travis CI database now exceeds 40 GB of data. That doesn't sound like a lot,
but when running on a comparably small PostgreSQL/EC2 instance, things start to
break.

We now run around 10,000 builds per day for more than 20,000 active open source
projects. That's a pretty staggering number, and we're seeing the effects of the
size Travis has grown to left and right. Which is to say: things break much more
easily right now, and we're working hard on improving these things, breaking out
smaller apps, loosening up responsibilities, and simplifying.

Long story short, on Tuesday we took down the database and upgraded to the next
biggest instance, giving us more memory and a few more cores. The downtime took
longer than expected, because PostgreSQL took longer to restore from the
archives than we thought.

After we started things back up slowly, the site was immediately hit with
unavailability again, leaving requests hanging for very long.

This is the most embarrassing but at the same time rather crazy part: Travis has
been running off three Unicorn processes until now. I know, right?

We made a rookie mistake of not properly looking at the request queue. Granted,
we didn't see anything in our NewRelic metrics, that would've pointed to the
problem. But that's no excuse. We increased the number of dynos to serve the
site, et voila. Speed!

The site is now pushing a larger amount of traffic while the database response
times remain pretty much unchanged. We've seen speedups in some parts, but
overall, the performance remains the same, but we can more reliably serve a
bigger amount of requests.

It might not have been the last database upgrade though. The Heroku Data team
has suggested we upgrade to at least a 64bit instance, and at some point, that's
what we'll be doing.

The parts of Travis that didn't touch the database hummed along nicely too, by
the way. We still accepted commits and pull requests from GitHub, queued them,
and worked through the backlog once things normalized.

We'll work on getting more metrics out of PostgreSQL into our dashboards, in
particular the cache hits and slow queries overall so we can keep a much better
eye on this side of the app.

### What next?

We're still working on several issues, now that this is out of the way. A big
part of the traffic that Travis is serving are the build status images.

In the future, these images are more likely to be served by a combination of
cached build statuses and a CDN behind it.

The current frontend is a bit wonky. Folks using Chrome have been noticing that
in particular, and we're sorry for that. Sven and
[Piotr](https://twitter.com/drogus) have been working on a new client that puts
these issues to rest and makes for a much more resilient and speedy user
interface overall. You can [try it out](http://travis-ember.herokuapp.com)
yourself. It's still a work in progress, and you can contribute or open issues
on the [repository](https://github.com/travis-ci/travis-ember).

One part of the problems with the user interface could be seen when there were
lots of builds waiting in the queue. That dragged the performance down quite
significantly, so we had to remove some parts that made things really slow.
We're looking into ways of bringing them back, but we had to make a call to
improve the overall performance, at least until we find ways to speed things up.

Meanwhile, Konstantin has been working on breaking out the [API for
Travis](https://github.com/travis-ci/travis-api). The new client will talk
exclusively to this new API.

We have other parts where we're actively working on getting things more stable.
VirtualBox is another one of them, but that deserves an entire post all on its
own.

We'll keep you posted when more bad or good things happen!
