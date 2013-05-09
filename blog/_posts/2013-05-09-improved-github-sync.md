---
title: Improved GitHub Sync
permalink: blog/2013-05-09-improved-github-sync
created_at: Wed 09 May 2013 10:00:00 GMT
author: Josh Kalderimis
twitter: j2h
layout: post
---

Travis and GitHub love each other, from login to service hooks to marking pull requests as passing or failing, seamless GitHub integration is what makes the Travis experience so awesome.

But sometimes we are left playing catch up when it comes to permission syncing and repository listings. Having to hit the 'sync now' button on your profile page just so Travis knows of your new repositories is not uncommon, and sometimes easy to forget.

Today everything got a bit simpler for both [travis-ci.org][travis-ci-org] and [travis-ci.com][travis-ci-com] users with the introduction of _DAILY_ syncs with GitHub!

Using [Sidekiq][sidekiq], an awesome background processing library from [Mike Perham][mike-perham], we schedule syncs for all users over a 24 hour period. For both Travis for open source and Travis for private projects we sync around 1,400 users per hour (around 34,000 users total), with a typical user sync (user info, orgs, repositories, and memberships/permissions) taking anywhere between 30 seconds to several minutes depending on how many orgs and repositories a user might have access to.

We are not done with sync, we have a lot to improve and are working on making sure what you see on GitHub is also what you see on Travis. 

Lots of jumping High-5's

The Travis Team

[travis-ci-org]: https://travis-ci.org
[travis-ci-com]: https://travis-ci.com
[sidekiq]: http://sidekiq.org
[mike-perham]: https://twitter.com/mperham
