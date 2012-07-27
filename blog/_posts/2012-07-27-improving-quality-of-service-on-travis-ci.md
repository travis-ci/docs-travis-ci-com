---
title: "Improving the Quality of Service on Travis CI"
layout: post
created_at: thu jul 28 15:55:26 cest 2012
permalink: blog/2012-07-27-improving-the-quality-of-service-on-travis-ci
author: Mathias Meyer
twitter: roidrage
---
The growth of Travis CI has been tremendous over the last year. We've seen lots
of projects adopt it as their continuous integration platform, and we couldn't
be more thrilled about that.

Along the way, we discovered pain points in the Travis architecture and in the
way the platform handles fairness in builds. Big projects with big build
matrices tend to cause our queues to clog up and make other projects wait until
they're fully done.

With bigger projects tending to have longer builds, that caused a bit of worry
with lots of smaller projects that had to wait in the queue for the bigger
projects to build.

We've been pondering for quite a while how we could solve this problem and
introduce more fairness into the system, allowing smaller projects to build
quickly and giving all projects a fair share of build resources on Travis CI.

We're introducing a limit on the number of concurrent builds that every project
can run on Travis CI. So far, we've immediately queued a project's entire build
matrix onto our queue, ready to be picked up by a worker. That's one of the
basic reasons why big projects with big matrices tend to make smaller projects
wait. It's a first-in-first-out queue, so they'll patiently wait until all of
the builds are done and it's their turn.

With the new logic in place, one project can run five concurrent builds. As soon
as one is done we'll automatically push the next. If we have capacity and a
project still has five builds running we'll push another project on the worker
queue. That way, we ensure that a certain level of fairness allows all projects
to build as quickly as possible while making sure that a small number of
projects can't fill up the queues for everyone.

We're aware that this might cause builds for projects with bigger build matrices
to take a bit longer, but we think the overall fairness introduced by this
change makes Travis a place that's evenly shared by the community.

We'll be watching how that change works out in production, and fine tune the
number of concurrent builds if necessary. The number five is something we chose
based on the overall fairness and the build capacity we have available but it's
not written in stone.

### Technicalities

Now that we've looked at the fairness side of things, let's look at the
technical side of things.

So far, we've pushed builds immediately onto our RabbitMQ queue as they come in.
This had the advantage that they'd be popped off in the order they arrived in
Travis, and we wouldn't have to worry about scheduling.

But it also meant that our queues would be the single source of truth about what
needs to be built next, which in turn introduces a single point of failure and
pushed state into the message broker.

Instead of pushing a job immediately on the queue, it's now only stored in the
database. A job is now scheduled based on the heartbeats we receive from a
worker. If a worker signals that he has build capacity, and we find a build
that's ready for the worker's language queue, it gets pushed and built. Within
that logic we embedded the limit on concurrent builds along the way. If a
project has reached its limit, another one that's available gets pushed instead.

All this has the benefit that we're starting to move into a direction where
Travis is agnostic to the message transport used between the system's
components. We could use ZeroMQ or simple HTTP instead, because we're doing
simple inter-process communication instead of relying on the ordered nature of
AMQP, because exact order is not important anymore.

We have several areas in Travis where order is still important currently, but we
already have ideas on how to tackle them. We'll keep you posted on the technical
details!

### The Bottom Line

Introducing a quality of service level to Travis CI doesn't only introduce a
predictable level of fairness into the community platform. It's also the
groundwork for Travis Pro, where we put a limit on and will charge based on the
number of concurrent builds for an organization.
