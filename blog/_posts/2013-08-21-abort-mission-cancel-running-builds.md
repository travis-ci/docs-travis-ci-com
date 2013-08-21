---
title: "Abort the Mission: Cancel Running Builds"
author: Mathias Meyer
twitter: roidrage
created_at: Wed 21 Aug 2013 16:00:00 CEST
layout: post
permalink: blog/2013-08-21-abort-mission-cancel-running-builds
---
One of the biggest [feature
requests](https://github.com/travis-ci/travis-ci/issues/763) we've received over
the past year (if not longer), and in particular as we've increased the runtime
we allocate to your builds, is the ability to cancel a build.

Whether you accidentally broke something that you already know has been fixed in
later commits, or you want to discard builds that are queued up but that you
know will fail, or you have potentially failing builds holding up your build
queue.

The great news we have for you today is that **you can now cancel these
builds.**

This feature is available for jobs that are already running and for jobs that
are queued up to run.

When you go to a specific job or a build (yup, you can even cancel all jobs of a
single build in one go!), you'll find a new option to cancel the build or the
job.

![](http://s3itch.paperplanes.de/cancel_build_20130821_153811.jpg)

You can do the same from the command line using our
[travis](https://github.com/travis-ci/travis) command line tool.

![](http://s3itch.paperplanes.de/Screenshot_20130821_154058.jpg)

Needless to say that this feature is instantly available for open source
projects and on <https://travis-ci.com>.

Happy shipping!
