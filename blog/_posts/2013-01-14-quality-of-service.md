---
title: "Quality of Service"
created_at: Tue Jan 14 15:25:00 NZDT 2013
layout: post
author: Philip Arndt
twitter: parndt
permalink: blog/2013-01-14-quality-of-service
---

Sometimes it can appear like Travis CI was only built to run continuous integration for a single project because that project has completely "filled up the queue" and your builds appear to be scheduled very far down the list.

![Busy Queue](/images/qos.001.jpg)

We're delighted to say that this is not the case due to some quality of service measures we implemented back when Travis CI was much younger.

Fortunately, when someone decides to push a lot of commits to one or many different projects and use up lots of places in the queue, Travis CI will only allow them to use up 5 worker slots at any one time. This is implemented at an owner level and not a project level which means that one user, or one organisaton, can't push commits for multiple projects and use all the workers; the rest of their jobs will enter the queue.

We're also working hard on a new VM setup which will result in more effective use of our existing queuing and available VMs to reduce the time that everyone spends waiting for build jobs to be run.  After all, we want you to receive your build results as soon as possible to keep you happy!
