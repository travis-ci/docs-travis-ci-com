---
title: The New Build System is Live
created_at: Wed Jan 30 2013 16:00:00 CET
permalink: blog/2013-01-30-new-build-system-is-live
author: Mathias Meyer
twitter: roidrage
layout: post
---
As of today, all of Travis CI, both for open source and private projects, is
running on our new build system!

This is good news, as we've outlined recently, as this new build system and the
way it's now used is a lot more stable compared to our old one. You can read up on
all the details in [last week's blog
post](http://about.travis-ci.org/blog/2013-01-25-the-worker-gets-a-revamp/).

After we did a test run on <http://travis-ci.org> we switched over all build
machines and eventually upgraded <http://travis-ci.com> as well, along with a
much-needed upgrade to the build environment. This change was deployed this
morning and should decrease the number of stalled builds or spurious timeouts.

If you've been plagued by those, we're sorry! Things should be running a lot
better now.

We've been ironing out some bugs since then, and we're still working on fixing
any remaining glitches. So if you find something that's odd or suddenly
different, [please shoot us an email](mailto:support@travis-ci.com)!

We have more awesome things in the works to improve the build environment. Stay
tuned for the next announcement!
