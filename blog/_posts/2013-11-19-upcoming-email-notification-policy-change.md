---
title: "Upcoming Email Notification Policy Change"
created_at: Tue 19 Nov 2013 09:48:43 EST
author: Hiro Asari
twitter: hiro_asari
layout: post
permalink: blog/2013-11-19-upcoming-email-notification-policy-change
---

We send about 14,000 notification emails every day.
We understand that these emails are critical for you
in order to stay on top of the projects' status.
It is important that our notifications are meaningful and helpful.

When we change the notification policy, therefore, it is paramount that
we keep you informed about the change well in advance.

*Note* This change affects only the builds triggered by pushes
to the repository.
The builds initiated by pull requests are not affected.

## Current policy
The current policy is to notify owners of the repository, as well as
the committer and the author of the commit we test.

These email addresses were taken from the commit itself.

This resulted in some unwanted email; for example,
the author of a commit we test can receive email from us
when the build occurred on a fork of a repository over which
she has no control.

## New policy
The new policy will be as follows:

1. If the commit occurs on the [default branch](https://help.github.com/articles/setting-the-default-branch),
then the owners of the repository will be notified.
2. If the commit occurs on a non-default branch, the author and the
committer of the commit who are also owners of the repository will be
notified.

We will use email address on our databse.

## Effective date
This new policy is scheduled to go into effect for
both [Travis CI](https://travis-ci.org) and
[Travis Pro](https://travis-ci.com) next Wednesday, November 27, 2013.

We know that patch authors of popular repositories were overwhelmed by
our notifications.
For this, we apologize.
This new policy will reduce the noise.
So, continue to be awesome and send your awesome patches to any project
you want without fear of spam from us!