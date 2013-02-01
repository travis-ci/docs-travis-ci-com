---
title: On Yesterday's Log Unavailability
author: Mathias Meyer
twitter: roidrage
created_at: Thu Sep 05 13:00:00 CEST 2012
permalink: blog/2012-09-05-on-yesterdays-log-outage
layout: post
---
We've been having issues serving build log updates on time on [Travis
CI](http://travis-ci.org). First up, we apologize for this issue, especially
given that it's not the first time it happened. We had a similar issue last
Thursday, where our log updates queue got clogged up to 25000 messages and only
slowly caught up, very slowly.

Yesterday, we had a similar issue, only this time, the queue stalled until more
than 100000 messages were stuck and not being processed. Therefore, most build
logs from yesterday remained empty.

In general, we've had multiple occasions where log processing just couldn't keep
up with the incoming number of messages.

### What happened?

In an effort to improve log processing in general, we put a new component in
place yesterday that was supposed to improve log processing by parallelizing the
log updates. Unfortunately things didn't go as expected and the queues started
to fill up.

After investigating the metrics we have in place we found that the issue was
that parallelization wasn't in effect, so we fixed this issue and finally log
processing caught up. The 100000-ish messages were processed in less than an
hour.

Here's a graph outlining what happened in the log processing and how things
evolved when we finally found and fixed the issue:

![log processing graph](http://s3itch.paperplanes.de/Metric_%E2%80%93_Librato_Metrics-20120906-130435.png)

For most of the day, processing got stuck at around 700 messages per minute.
Given that we get a few hundred more than that every minute, backed-up queues
are a very likely thing to happen. At around 18:25, we deployed a fix that made
sure parallelization works properly, and at around 18:40, we ramped up
parallel processing even more so that we ended up processing 4000 messages per
minute at peak times.

### Technicalities

After last week's incidents we decided to take measures to improve the log
processing performance in general. Until last week, our hub component was
processing all log updates, and all of them in just one thread per build platform
(PHP, Ruby, Erlang/Java/Node.js, Rails).

At peak times we get about 1000 log updates per minute, which doesn't look like
a lot, but it's quite a bit for a single thread that does lots of database
updates.

As a first step we moved log processing into a [separate
application](https://github.com/travis-ci/travis-logs). Multiple threads work
through the log messages as they come in, therefore speeding up the processing.
Jobs are partitioned by their key, so we make sure that log ordering is still
consistent. It's still not perfect because a) it's not distributed yet and b)
jobs with a lot of log output can still clog up a single processor thread's
queue.

We weren't sure if this would affect our database load at all, but luckily, even
with nine threads, there was no noteworthy increase in database response time.
Thanks to our graphs in [Librato Metrics](http://metrics.librato.com), we could
keep a close eye on any variance in the mean and 95th percentile.

### The Future

We've been thinking a lot about how we can improve the processing of logs in
general. Currently, the entire log is stored in one field in the database,
constantly being updated. The downside is that on every update, in the worst 
case, the column has to be read to be updated again.

To avoid that, we'll be splitting up the logs into chunks and store only these
chunks. Every message gets timestamped and a chunk identifier based on the
position in the log. Based on that information, we can reassemble the logs
from all chunks to display in the user interface while the build is running.

With timestamps and chunk identifiers we can ensure in all parts of the app that
the order of log handling corresponds to the order of the log output on our
build systems.

When the build is done, we can assemble all chunks and archive the log on an
external storage like S3.

Again, our apologies for the log unavailability. We're taking things step by
step to make sure it doesn't happen again!
