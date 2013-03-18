---
title: An Update on Travis Pro
author: Mathias Meyer
twitter: roidrage
created_at: Thu Mar 18 2013 16:00:00 CET
permalink: blog/2013-03-18-an-update-on-travis-pro
layout: post
---
It's been a while since our last update on Travis CI for private repositories,
our hosted product version of Travis CI.

We've launched into a private beta last July, and not only has a lot of time
passed since then, we've made some great progress.

In September we started moving the platform into a paid private beta mode, and
I'm happy to report that by now, we have more than 220 paying organizations
using the platform. On a daily basis, we're running close to 6000 builds.

While this may sound insignificant compared to the now more than 21000 builds we
run every day on our open source platform, test suites are usually a lot more
complex and long-running for private projects and products.

### What's been keeping us so long to go public?

To be able to open the platform for everyone, we had several things we wanted to
solve first. The good news is, we're almost there.

We rewrote our build process to be a lot more stable, we're in the process of
moving our build infrastructure away from VirtualBox, and we've deployed one of
the last outstanding fixes for us to have more reliable and scalable build log
processing.

In short, we wanted to have the greatest confidence in our system being able to
handle a much larger number of customers more easily than it did before.

We're slowly starting to move customer projects to our new infrastructure, and
once we're able to fully decommission our VirtualBox setup, it'll be a lot
easier for us to grow our infrastructure with the number of customers coming on
board.

### So how long until we go public?

Sorry that we're not in the position to give a specific date yet, but we're
frantically working on opening up the platform for everyone. Lots of folks are
waiting on our beta list, and we're sorry we've kept you waiting for so long.

If you signed up for our [beta list](http://travis-ci.com), you'll be hearing
from us soon!
