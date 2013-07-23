---
title: 3 Essential Preparation Steps for a Successful Maintenance
created_at: Tue 23 Jul 2013 16:00:00 CEST
author: Mathias Meyer
layout: post
twitter: roidrage
permalink: blog/2013-07-23-3-essential-preparation-steps-for-a-successful-maintenance
---
We all love shipping code to production fast and with zero downtime.

But while most changes require no downtime to be deployed, there are production
changes that require for the entire site, or at least parts of it, to be taken
offline for maintenance.

Some database migrations are bigger than others, some component changes are
not as fluent as others. For instance, we've had to switch our RabbitMQ instance
several times.

Unless it was an emergency maintenance, we found that there are some steps that
are essential to prepare for an upcoming maintenance, to make sure it's going as
smooth as possible.

### 1. Announce the Maintenance

It's important to give your customer notice to prepare for the upcoming
disruption. The more bound your customers' daily workflow is to your product,
the more important it is to give enough notice for them to prepare for your site
to be not available.

To reduce the impact of bigger maintenances, we tend to move them to the
weekends, if at all possible.

It pays to have a status page for this and a feed your customers can subscribe
to. For a bonus, include the notice prominently in your application. We use
[StatusPage.io](http://statuspage.io) for this purpose, and we have an internal
broadcast system which we use to notify our customers of upcoming disruptions.

Make sure to give updates as the maintenance progresses, in particular if it
extends the expected window of downtime.

This is a matter of operational transparency, and a courtesy to your customers.

### 2. Prepare a Maintenance Checklist

![](http://s3itch.paperplanes.de/rabbitmqmigration_20130722_094810.jpg)

As the maintenance window approaches, sit down and think about all the steps
involved for a successful migration. While this doesn't need to be an exhaustive
lists, it's good to have as many steps as possible in here.

Include steps to prepare maintenance, to carry it out, and to verify that it was
successful.

It will not only give you a book to play by, it will give you time to think
about every single step and its potential side effects. It also allows you to
prepare scripts for steps that lend themselves nicely to be automated during the
maintenance window.

Thinking about and preparing for all these details gives you confidence for the
task ahead.

I found this to be one of the most important steps to prepare for a maintenance.

### 3. Find a Maintenance Buddy

Just like handling outages, it's handy to have another person around. It gives a
sense of security, and it gives you someone to sanity check every step of the
maintenance with.

On top of that, you can work on the tasks in parallel.

While preparation is key, execution is where the rubber hits the road. Having
someone around who can interact with customers, update the status page and run
validation commands is very handy.

### After the Maintenance: Follow up with a Post-Mortem

Not every maintenance window goes as planned. There may by hiccups, things that
have unexpected side effects, and things that go downright wrong and cause an
extended downtime.

It's important to follow up a problematic maintenance with an internal
post-mortem. It doesn't always have to be a public one. We use internal GitHub
issues for this purpose.

It's more important for your team to learn from what went wrong and improve
code, infrastructure and procedures accordingly to reduce the risk of it
happening again in the future.
