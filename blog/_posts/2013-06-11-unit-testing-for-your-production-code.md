---
title: Unit Testing Your Production Code With Metrics And Logs
author: Mathias Meyer
twitter: roidrage
created_at: Mon 11 Jun 2013 18:00:00 CEST
layout: post
permalink: blog/2013-06-11-unit-testing-your-production-code
---
Travis CI and continuous integration are all about making sure your code is
fulfilling the expectations set against it by way of your tests, whether
they be unit tests, functional tests, or integration tests.

Moving into the realm of continuous delivery though, you get to a simple
question: How can you ensure that your code does what it's expected to do when
running in production?

When code runs in production, it doesn't have the protection of a clean
environment like your tests do. It's suddenly exposed to the harsh reality of
life in production and therefore to random influences and emerging situations,
like network timeouts, slow disks, errors in third-party APIs.

As you ship code more often to production, you need to ensure that your code is
doing what's expected of it. You need automated ways of collecting data and you
need automated ways to make them easy to analyze.

You need metrics, and you need logs.

### Metrics: The What

Metrics allow you to slap a number on anything, to measure how often something
is run, how long it's taking, how much memory a process is consuming, how long a
page took to render, how long a database query took, how many external API calls
have failed, how many errors your application has been raising, how many failed
logins you've had on your site.

In short, anything that moves. Anything that's indicative of potential problems
on the site or that'll help you investigate when problems occur. Rest assured,
they will occur.

Metrics allow you to stay up-to-date on what's going on inside of your
application, but on a numerical level. Depending on the tools you use, you'll
also get nice ways to visualize the data you collect over time.

Here's a list of things that we're tracking in a normal workflow of a build in
Travis CI:

- Request times accessing the GitHub API to fetch the .travis.yml
- The number of GitHub notifications we handle that get turned into a build
- The number of builds that are run as trial builds on <http://travisci.com>
- The time it takes from a build being created until it's scheduled to run
- The number of currently running builds
- The time since the last build was started
- The time since the last build has finished
- The time it took for the build environment to boot
- The number of email notifications we send

This is just a sample, but there's a lot going on in Travis CI. Here's an
example, the number of builds currently running on <http://travis-ci.org>.

![](http://s3itch.paperplanes.de/activebuilds_20130611_125954.png)

What's more important, it's very easy to add new metrics and have them be
collected in our collection system. We use [Librato Metrics](http://librato.com)
to store and visualize our data, and we're using Eric Lindvall's excellent
[metriks library](https://github.com/eric/metriks).

Making it easy for developers to add and visualize new metrics is just as
important as enabling developers to build and continuously grow a test suite.
The easier it is for someone to add a new metric and see it pop up somewhere,
the more likely the buy-in from your team to get started.

#### I don't have any metrics, get me started!

With a legacy code base (one that doesn't have any metrics) similar ideas apply
as to how to sneak tests into projects that don't have any yet.

You start small and simple by adding metrics to the parts of the code you're
currently working on. You can gradually work your way up, that's how the Travis
CI code base got instrumented over time.

For instance, if you added a new feature that sends password reminders to users.
You can start tracking how many you're sending by adding a single line to your
code.

    def send_password_reminder(user)
      Metriks.meter('password_reminders').mark
      UserMailer.password_reminder(user).deliver
    end

This tracks how many you send. You can keep going and instrument the sending
itself. Most of the time, when sending emails, some external resource is
involved. Whether you're talking to an API (think Mandrill, Postmark, et. al.)
or using SMTP directly, there's network overhead worth measuring.

    def send_password_reminder(user)
      Metriks.timer('password_reminders').time do
        UserMailer.password_reminder(user).deliver
      end
    end

Lots of libraries exist to instruments for all kinds of languages and
frameworks. Most of them have been inspired in one way or the other by Coda
Hale's [metrics](https://github.com/codahale/metrics) library, and the talk it's
based on, ["Metrics, Metrics
Everywhere"](http://pivotallabs.com/139-metrics-metrics-everywhere/). The talk
gives a great introduction on the types of metrics that you can use to
instrument your code, why you should instrument, and how that improves the
transparency and visibility of what your application is doing.

The upshot of well-put metrics and accessible visualization is that you can put
them up on a dashboard to increase visibility for everyone in the company, for
everyone with a stake in the product.

### Logs: The Why and the How

Where metrics tell you all about what's going on, logs are the true soul of your
application. Metrics only give you a numeric representation of what happened, logs
tell you (ideally) why things happened. They're your audit trail of steps your
application took to execute a specific task.

While metrics can be easily unified using a common library, for logs that's much
harder to do. We're using part automated logs that give a simple audit trail and
part literal log output to determine what happened.

It can be tempting to try and make logging for your application generic. This
works for quite a few things (tracing method calls, [HTTP request
details](https://github.com/roidrage/lograge)).

The important thing to remember is, when there's an incident that requires
investigation, there's a person looking at the logs, trying to make sense of
what happened and why.

Logging is the art of not saying too much, but also saying enough that an
investigation can be done by a human. Just like adding metrics, it's an
evolutionary process, there's no one right way to do it and to find the spots in
your application that need to log meaningful data.

For instance, the part of our apps that handles trials for <http://travisci.com>
logs statements about trials that have expired, trials that have started and all
that. On top of that we track metrics, but they're anonymous, they have no
relation to the account the trial is running for.

Once you've started logging, you need a place to aggregate them for simple
search. There are services to help you get started, we're using
[Papertrail](http://papertrailapp.com) for this very purpose. It's wonderfully
simple to hook it up to your Heroku apps and start logging.

### Measure Everything, Log Anything!

To make sure that you can continuously ship code to production and to have
confidence in what your application doing when running, logs and metrics are
your first steps to more transparency and visibility.

While there's no one way to integrate them, there are certainly a lot of options
to get you started. Combined with a healthy test suite, both allow you to build
and ship your code with confidence.

{% include newsletter.html %}
