---
title: State of the Mac Builds
created_at: Fri 27 Sep 2013 06:00:00
author: Henrik Hodne
twitter: henrikhodne
layout: post
permalink: blog/2013-09-27-state-of-the-mac-builds
---

Hello everyone! It's been almost half a year since we [shipped Mac, iOS and RubyMotion testing](/blog/introducing-mac-ios-rubymotion-testing/) (time really flies, doesn't it?). Since then we've had almost 30,000 Mac builds on travis-ci.org and nearly 13,000 Mac builds on travis-ci.com.

I'd like to take a moment to address some of the instability we've been having lately, and what we're doing to improve. On September 24th we started noticing issues with our Mac infrastructure, causing delays in Mac and iOS builds. We had noticed earlier that sometimes the VMs get stuck in a suspended state, which causes us to be unable to boot new VMs. Fortunately, fixing this is very easy, but does require manual intervention on our end.

We've seen this very issue show up more often lately, and while we haven't found the exact cause of the issue, we're working with our infrastructure provider to pin-point it. In the meantime, we're going to be adding better monitoring and alerting for the Mac infrastructure, which up until now has been lacking and causing us to be unable to discover issues early on.

Unrelated to this issue, we will be having some downtime for the Mac infrastructure tomorrow, September 28th 2013 at [5:30 PM CEST](http://everytimezone.com/#2013-9-28,210,6bj). Our infrastructure provider is moving to a different data center, which means we'll have to take the Mac builders offline when they are being moved. We expect the move to take no longer than two hours. We'll stop accepting new Mac builds at 5:30 PM and then let the existing ones finish until 6:00 PM, at which point we'll take the workers offline and begin the move.

We are also working on getting the VMs' version of Mac OS X updated so we can install Xcode 5 and allow building iOS 7 projects. Stay tuned!
