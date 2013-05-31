---
title: An Update on Infrastructure Changes
layout: post
created_at: Thu 13 Dec 2012 16:00:00 CET
author: Mathias Meyer
twitter: roidrage
permalink: blog/2012-12-13-an-update-on-infrastructure-changes
---
We've had our share of issues over the last few months, and it's time we give 
you an update on what we've been doing about them.

The most important bit up front is that we're breaking Travis down into more and
more small apps. We traditionally had one big component, called the hub, which
took care of pretty much everything: incoming build requests, processing builds,
processing build logs, processing notifications, synchronizing users with
GitHub.

As Travis grew, this single component broke our neck left and right. So we
decided to take it apart into several smaller apps, all with a strict focus on a
single concern. Let's go through them one by one.

### Logs

We made improvements to logs by breaking it out of the hub entirely. Processing
them runs in parallel so we can make sure we can keep up with the increasing log
volume.

To give you perspective, [travis-ci.org](http://travis-ci.org) handles about
1500 log updates per minute during peak hours, while
[travis-ci.com](http://travis-ci.com) has to handle 2500. In situations where our
log processing has temporarily backed up, it handled 4000 updates per minute.
While that only boils down to ~66 writes per second, our current data
model is bound to break down eventually as we scale up, as too much data needs
to be written with each write.

Needless to say, we're far from done with improving log processing. They tend to
be the biggest factor in the data Travis processes. They also take up the vast
majority of data we store.

Even our current design doesn't yet fully allow us to scale out horizontally.

Logs are currently kept in a single attribute per build job, which is far from
optimal. While we can do a good amount of writes there per second, we want to
move to a setup where we only keep log chunks around.

By breaking up logs as we store them, we remove the need for temporal ordering,
which is our biggest breaking point right now in log processing. We rely on the
order of the log messages to be processed, and that's the bane for any
distributed system as it grows and needs to scale up. By removing that need we
can process logs in parallel regardless of the order in which messages arrive.
The write process leaves reassembling and vacuuming log chunks into full log
files to other processes, making sure that it gets the highest throughput
possible when storing them.

Fixing this is highest on our list of things to tackle next, and we'll keep you
posted.

### Notifications

Build notifications like email, Campfire, IRC, etc. have been moved to their
own, isolated app. It has no contact with our main database at all anymore, it
just handles payloads and triggers the notifications that notify you of build
results.

This app is called [travis-tasks](https://github.com/travis-ci/travis-tasks) and
was our first app to run on [Sidekiq](http://sidekiq.org), a multi-threaded
replacement for [Resque](https://github.com/defunkt/resque) based on
[Celluloid](http://celluloid.io).

As notifications are exclusively bound by I/O, it makes a lot of sense to allow
them to run multi-threaded.

Currently travis-tasks is still bound by a shared Redis instance, something
we're considering improving in the future, to decouple it even more from the
other apps.

### Build Requests and User Sync

Handling build requests is also mostly a matter of I/O, as we fetch data from
GitHub and create builds in the database. Same is true for user sync, a part of
Travis that has been rather unstable before introducing this component, aptly
called gatekeeper.

Both parts of Travis now also run on Sidekiq, which allows us to not only run a
lot more build requests in parallel, across multiple processes, it also allows
us to make use of some of Sidekiq's neat features, like [retries with exponential
back-off](https://github.com/mperham/sidekiq/wiki/Error-Handling).

Should a build request temporarily fail because a glitch in the GitHub API,
Sidekiq tries again a few seconds later, expanding the interval between retries
over time. It's a very handy feature for our use case.

Even if there's a prolonged issue with the GitHub API, we can make sure that we
don't lose any build requests because of it.

### Postgres

Both Travis platforms are now running off a pair of [Heroku Postgres
Fugu](http://postgres.heroku.com) instances, with a master and a follower each,
allowing us to do emergency failovers if necessary. We had to make use of this
neat feature a few times unfortunately, as we hit a Postgres bug whose root cause
has yet to be fully determined.

As Travis grew, the write latencies on the smaller instances were suboptimal,
slowing down log processing and accessing the data.

On the new instances, our write latencies are commonly around 20-50ms in the
95th percentile, which is pretty good for our use case currently.

### Lots of little apps!

The future of Travis' architecture is in lots of smaller apps, that's for
sure. Breaking out separate concerns into their own apps has the benefit of
being able to improve, grow and scale them independent of each other. While we
still have lots of work to do there, but the recent changes have shown us the
direction we're heading into.

Another big hurdle we had along the way was managing dependencies, so we started
grouping our core dependencies by concern so that we can start breaking that
apart into smaller dependencies based on concerns instead of layers.

All of the above apps are now running on JRuby 1.7. Being able to process things
in parallel is a big benefit for us, and JRuby's native threading is a natural
fit there. Thanks to [Heroku's](http://heroku.com) easy application deployment model,
we've been able to iterate on this and set up new apps quickly.

Travis is still growing, and making sure both platforms are running as smoothly
as possible is our biggest priority. It's still a lot of work, so please bear
with us.

We have other infrastructure changes planned, but more on those in another blog
post.
