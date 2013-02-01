---
title: HipChat Notifications
created_at: Thu Sep 27 10:00:00 CEST 2012 
layout: post
author: Mathias Meyer
twitter: roidrage
permalink: blog/2012-09-27-hipchat-notifications
---
Deep in the bowels of the [Travis code
base](https://github.com/travis-ci/travis-core/blob/master/lib/travis/task/hipchat.rb),
it remained hidden for two months before we finally decided to bring it up to the light 
and write a blog post about it: HipChat build notifications!

<img width="570" src="http://s3itch.paperplanes.de/skitched-20120927-102551.png"/>

Just add the following line to your `.travis.yml`, and Bob's your uncle:

    notifications:
      hipchat: [api token]@[room name]

HipChat has something nice going for it: you can set the background of a
particular message. So we can set the background to green or red depending on
the build status. Neat!

Needless to say, this feature is available on both Travis platforms, [open
source](http://travis-ci.org) and [for private
repositories](http://travis-ci.com).
