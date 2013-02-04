---
title: Engine Yard is awesome!
layout: post
created_at: Mon 04 Feb 16:00:00 CET
author: Piotr Sarnacki
twitter: drogus
permalink: blog/2013-02-04-engine-yard-is-awesome
---

As some of you may know I've been working on Travis CI for the last 3 months
[thanks to awesomeness of Engine Yard](http://about.travis-ci.org/blog/2012-10-22-engine-yard-sponsors-piotr-sarnacki-to-work-on-travis/).
I was a part of Engine Yard OSS Grant Program and you can read about the things
that I've been working on on [Engine Yard's blog](http://blog.engineyard.com/2012/travis-ci?eymktci=70170000000hHEC).

This pure awesomness does not end here, though. Recently Engine Yard extended
my participation in EY OSS Grant Program by 3 months! I can't be thankful enough
for that, so please help me and give them lots of internet hugs, thank them on
[twitter](https://twitter.com/engineyard) or check out their [products](https://www.engineyard.com/).
And I mean it, take a break from reading the post and do it now!

Since my last update I was working on travis artifacts, security improvements,
maintaining and extending our web client and helping Travis to work smoothly
with increasing number of requests (which included various kinds of optimizations).

There are a lot of things that we would like to do and it's sometimes hard to choose
wisely, but due to growing popularity some parts of Travis need refactoring and/or
architecture changes. With hands of wonderful Josh and Sven we already managed to greatly
improve the way we run your tests, but this is not enough. In the recent feature
we will be changing the way we manage handling secure environment variables to make
it more robust and secure.

Besides such refactorings I would also like to ship some new cool features.
One of such things is to improve the step of preparing a build to run, specifically
a way we validate `.travis.yml` and communicate any issues we find back to you.
Currently we don't do the best job there when we fail to configure the build and
you don't get any feedback about the reason.

The next thing, which I would like to give much more love is the usability of
displaying the logs. We are aware of the shortcomings of the current client in
this regard and we feel your pain! Logs are the first thing you look into when
a build fails and it's often hard to find information you need. Installation steps
can take a lot of space and if the log is really big, it can freeze the browser
for a few seconds. These and other things are going to change for better.

This is all extremely cool and it's going to happen, because of Engine Yard's
generousity. So if you haven't done this already and you care about Travis and
open source testing, please let them know how awesome they are!
