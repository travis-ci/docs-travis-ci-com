---
title: Travis Pro Builds Update
layout: en
permalink: travis-pro-builds-update/
---
#### We have some awesome upgrades in the works, and we'd like you to know about them!

As you may have noticed, our build stability on Travis CI hasn't been up to par.
**We're very sorry** if you've been impacted by stalled builds, unexpected build
timeouts or other spurious error messages. We've been feeling your pain, and
we've been furiously working on improving the situation.

#### New VMs, More Memory, More Bits!

The first part of our new setup is moving away from VirtualBox. Our new
infrastructure is running on a private cloud setup (more details on this soon),
which gives us more flexibility and requires a lot less maintenance on our end.

The immediate benefit to you, our customer, is that these images are running on
**64-bit systems** and that we're effectively doubling the amount of available
memory. You'll now have **3 GB memory** available.

#### Improved and Much More Stable Build System

Along the way, we've **revamped our build system** to be a lot stabler and much
less prone to timeouts, stalls, even including improved error detection. You can
read all the details
[here](http://blog.travis-ci.com/2013-01-25-the-worker-gets-a-revamp/),
but suffice it to say: it's been running pretty smoothly for the past couple of
weeks.

#### What Now?

We're adding build capacity to our new cluster this week, which allows us to
move over a majority of our customers for Ruby-based projects. We want to be
careful not to impact your builds, so before we enable the new environment for
everyone, we want to gradually move over customers.

If you would like to be one of the first to try it out, please [get in
touch](mailto:support@travis-ci.com) and let us know, and we'll make it happen!

We'll be beta-testing this setup for a little while longer, eventually switching
over everyone soon. If you run into a build oddity, please [shoot us an
email](mailto:support@travis-ci.com)!

Meanwhile, we're working on rolling out the same new build system to the current
VirtualBox setup, so that even if they will still be running for a while, the
chance of stalling builds or commands timing out will be reduced greatly.
