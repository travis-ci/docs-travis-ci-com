---
title: New Build Emails
author: Mathias Meyer
twitter: roidrage
created_at: Wed 20 Nov 2013 18:00:00 CET
layout: post
permalink: /blog/2013-11-20-new-build-emails
---
Build emails are our most important means of communicating with our users. For
the longest time, these notifications have been very straight to the point and
in your face, especially when a build fails.

They've been lacking a bit more context as well to figure out what went wrong
and who pushed the commit.

We're sending up to 14.000 of these emails per day, so we wanted to improve
their overall appearance and usefulness. The latter is still a work in progress,
but we're moving in the right direction.

Thanks to [Jessica Allen](https://twitter.com/jessikaspacekat), we made a big step towards improving our communication
on broken builds.

As you've probably noticed, we pushed these out a few weeks ago, but we still
would like to take the opportunity to talk about them and to thank Jessica for
her awesome work!

Here's how our build emails look now:

![](http://s3itch.paperplanes.de/buildsuccess_20131115_160120.jpg)

We included the Avatar that's configured on GitHub, and condensed the amount of
information shown overall. The red is dialed down to not scream at you when you
open the email.

Same for the green build emails. Let's face it, everyone loves getting these,
but we made the red more subtle too:

![](http://s3itch.paperplanes.de/buildfailed_20131115_155653.jpg)

We have a lot of ideas on how to improve the emails in the future, and how to
make them more useful to get see more immediately what's been broken, stay
tuned!

Thank you, Jessica!
