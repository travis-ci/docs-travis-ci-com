---
title: Solving the Puzzle of Scalable Log Processing
author: Mathias Meyer
twitter: roidrage
layout: post
created_at: Thu 08 Aug 2013 16:00:00 CEST
permalink: blog/2013-08-08-solving-the-puzzle-of-scalable-log-processing
---
![](http://s3itch.paperplanes.de/build_log.png)

Over the last year, Travis CI has been growing at a staggering rate. We went
from 8000 builds per day a year ago to more than 44000 daily builds today, both
public and private projects combined. Did I mention that <https://travis-ci.com>
went into private beta a year ago today? Crazy!

As we worked our way through the growth issues that would eventually turn into
scalability issues, one problem was standing out. It was an obvious scaling
problem, but we saved the proper solution for it until the end.

I'm talking about log processing.

This is the story of the problems we've had with it, how we implemented
temporary mitigations, and of the solution we implemented eventually.

### One process to log them all

<figure> <a href="http://www.flickr.com/photos/mari1008/448065754/"
title="traffic jam -B by mari_1008, on Flickr"><img
src="http://farm1.staticflickr.com/175/448065754_606f60d797.jpg" width="489"
height="329" alt="traffic jam -B"></a> </figure>

At the very core, log processing takes chunks of your build's output, sends them
to a processor which updates a database record and forwards the chunk to
[Pusher](https://pusher.com) to enable live updates when you're looking at a
build.

The earliest implementation of this feature updated a single column in the
database which contained the entire log as a string. A sample message
representing a log chunk looks pretty simple.

    {
      "job_id": 1243,
      "chunk": "$ bundle install"
    }

This way of handling logs worked for quite a while, but it had an obvious flaw:
it relied heavily on the ordering of messages received. When chunks for a single
build log arrived or would be processed out of order, the resulting log would be
garbled.

We were stuck with a single process that would pop chunks off the queue, store
and forward them. We had a scalability issue at our hands. As soon as we'd add
another process, there'd be a possibility of the chunks being processed out of
order. The more processes we'd add, the higher the likelihood for this to
happen.

With the database being our only bottleneck, with a single process we were stuck
processing around 30-40 messages per second, and the process would get
overloaded quickly. To give you a comparison, we're currently processing peaks
up to 200 messages per second.

We had some initial ideas on how to make it happen, but they had wider
consequences. They'd simplify logging quite significantly, but they'd affect all
parts of the application.

But before we get to that, we implemented a simple mitigation that at least
would allow us to hold out on this implementation for a bit longer.

Rather than go for full scalability, we went for a simpler sharding approach at
first.

### Sharded queues

<figure class="small right"> <a
href="http://www.flickr.com/photos/ajbrustein/6010471624/" title="Le Trafic by
AJ Brustein, on Flickr"><img
src="http://farm7.staticflickr.com/6005/6010471624_41121b3fc7.jpg" width="333"
height="500" alt="Le Trafic"></a> </figure>

We still had one process handling log chunks, but that process would reroute the
chunks internally to a group of threads based on the build job's ID. That way,
chunks for a single job were guaranteed to be in the right order.

The rerouting used RabbitMQ with a subset of queues to ensure that messages were
processed reliably and one at a time. The downside of this was increased latency
and increased traffic, as every message would be transmitted and received twice.

We could've gone for an approach where a pool of threads is used and they're
using in-process queues to coordinate with each other, but we went with the
approach that seemed simpler to use at the time.

Every partitioned queue had a single thread listen to it and process chunks in
an orderly fashion.

With this implementation, we were at least able to process a lot more messages
simultaneously, and it give us some room to grow before we got around to
implementing the full solution.

We were able to process up to 150 messages during peak hours with this
implementation, with a single process. There were limits, in particular
regarding the available memory, and we still didn't have any redundancy in our
log processing. Redundancy could only be achieved by adding more processes.

Eventually we started working on the full approach. The idea of this is rather
simple. In fact, it's so strikingly simple that it's mind-bending.

### Back to the future

<figure> <a href="http://www.flickr.com/photos/atwatervillage/842866223/"
title="Establishing Shot: The 405 by Atwater Village Newbie, on Flickr"><img
src="http://farm2.staticflickr.com/1262/842866223_8490f33410.jpg" width="500"
height="333" alt="Establishing Shot: The 405"></a> </figure>

We knew that logs for a single job could only come from a single process running
the build. Uniqueness of messages on the producer's end was pretty much
guaranteed.

To be able to scale out log processing, we had to assign some sort of number to
every chunk that would determine its place in the full build log.

Based on that number, the full log could be easily restored by collecting all
the chunks and assembling them whenever necessary, in the user interface, or
when requested by way of our API.

This is far from being a novel idea. In fact, in its written form it goes back
30 years to Leslie Lamport's paper on ["Time, Clocks and the Order of Events in
a Distributed
System"](http://research.microsoft.com/en-us/um/people/lamport/pubs/pubs.html#time-clocks).
A highly recommended read.

While Lamport's ideas are related to processes talking to each other and
restoring an order over time, they're easily applicable here. The logical clock
mentioned in the paper is our increment.

The producer knew exactly which chunk he's sending and where in the full build
log the chunk belongs. All it had to do was keep an increment on the chunks it's
already sent and keep incrementing it with every chunk sent. Rather than be out
of order, every chunk now had a clock assigned to it, which is included in the
message sent to RabbitMQ.

The log chunk now looks like this:

    {
      "job_id": 1243,
      "position": 102,
      "chunk": "$ bundle install"
    }

A small change with a big effect.

The log processing in turn got very simple. Insert a single row into the
database, storing the clock, the build job's ID and the log chunk rather than
update a full column of a single record.

That way, we could scale out log processing much easier. As order was now
determined at read time, when pulling the chunks out of the database, any number
of processes could read and process log chunks.

### The effects on other parts of Travis CI

Previously, our user interface could assume that all messages received were in
the correct order, so the JavaScript responsible for rendering the logs could
just append new chunks to the DOM.

With logs now potentially arriving out of order, we had to drop this assumption.
Whereas log processing got simpler, things got a bit more complicated in our
user interface.

Initially we followed a very simple approach. The UI kept track of the latest
version of the chunks currently displayed. If a new chunk came in with a higher
version than the one expected next, the code would buffer the chunk(s) and
render them out once the missing chunk had arrived.

To make sure chunks that went missing in the dark parts of the internet, after
some time the we'd render out the buffered chunks to make sure we don't block
log updates for this particular job.

This implementation was beautifully simple, but we wanted to see if we could
take it a step further.

The next incarnation, which is currently in production, assembled the log as the
chunks came in, rearranging the DOM where necessary, inserting out-of-order
chunks as they arrive.

There are ups and downs to this approach, and which one will make it eventually
is still in the cards.

Other parts, like our API, were adapted to the new approach in simple ways. When
a log was requested, all it has to do is to collect all the chunks and assemble
them in the right order.

### Too many chunks

Now, we process millions of chunks every day. One thing we wanted to avoid is
letting our database grow infinitely with this new approach.

To make up for that, we added a process that collects the log chunks and
assembles them into the full log stored in a single column after the build has
finished, removing the chunks after it's done.

But there was still a problem. Logs were taking up the majority of our database,
up to 80% of the entire storage. We added up to a gigabyte of new logs every
day, increasing the size of our database and increasing the amount it took to
create backups.

As is the nature of builds in a continuous integration system, the most
interesting builds are usually the most recent ones. People rarely look back at
the logs of older builds.

So we decided to purge logs out of the database as soon as they were assembled.
Instead of storing them locally, we push them to S3, where they're fetched from
in the user interface.

### The end result

<a href="https://metrics.librato.com"><img
src="http://s3itch.paperplanes.de/publishdeliver_20130807_202202.jpg"
width="600"/></a>

We finally pushed all the bits and pieces of this new implementation to both of
our platforms. It allowed us to easily process peaks of 200-300 log chunks per
second without breaking much of a sweat.

Did I mention that our [Heroku PostgreSQL](http://postgres.heroku.com) instance
is holding up on this incredibly well? We keep hammering it with more than 100
writes per second, yet it doesn't break much of a sweat.

We applied a very simple and proven idea to our log processing to ensure better
scalability and allowing us to add redundancy. It turns out that as you scale
out, simplification is an important factor.

In the meantime, we reimplemented to processing to an even simpler version that
uses [Sequel](http://sequel.rubyforge.org) instead of ActiveRecord to avoid any
unnecessary overhead in code. It also uses a more direct and less fluff approach
to send updates to Pusher.

It's allowed us to keep the 95th percentile of the time to process a single log
chunk below 50 milliseconds. Not an ideal time, but the important part is that
it's been pretty stable as we've added more log processors.

The number of alerts that were due to log processing backing up has decreased
significantly over the last couple of months. Queue age has oftentimes been our
biggest headache, and when log chunks queue up, they queue up fast. With 100
messages per second, it just takes a few minutes for 10,000 messages to pile up.

Our next barrier is very likely to be the database. We have plans to move log
processing to its own database, as most of what it's doing is very short-lived
and very focused on a single task.

Don't tell anyone, but rumor has it that Josh has been working on a Go
implementation that's ridiculously fast.

Here's to more scaling adventures!

PS: I'll be a [GOTO in Aarhus](http://gotocon.com/aarhus-2013/presentation/The%20Smallest%20Distributed%20System)
and [Erlang Factory in Berlin](https://www.erlang-factory.com/conference/Berlin2013/speakers/MathiasMeyer),
talking about the challenges we've had and still have turning Travis CI into a
reliable distributed system. You should come!
