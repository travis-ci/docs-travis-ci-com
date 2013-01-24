---
title: "Quality of Service"
created_at: Fri Jan 25 10:00:00 NZDT 2013
layout: post
author: Josh Kalderimis
twitter: j2h
permalink: blog/2013-01-25-the-worker-gets-a-revamp
---

Some big Travis changes in the mist
===================================

**HAPPY FRIDAY!**

For the past 6+ months we've been working hard on a bunch of changes related to how your tests are run. This includes everything from the stability of the VMs, to the services we install on the VMs, and, not forgetting, _how we run your test suite._

Travis is broken up into various small apps, each with a very focused responsibility. One of these apps is called [Travis Worker](https://github.com/travis-ci/travis-worker) and its responsibility is to manage a virtual machine (VM), get a Job from our queue (using RabbitMQ), run the build/job, and report the logs chunks and final job state.

This might sound like a big responsibilty, and it is, but there is another piece to the worker puzzle, and that is Travis Build. [Travis Build](https://github.com/travis-ci/travis-build)'s responsibility is to know how to run a build for a particular language. For example, a Ruby project uses [Bundler](http://gembundler.com/) for dependency management, while Node uses [npm](https://npmjs.org/). And of course, these defaults are configurable and overridable.

Timeouts and Stalls
-------------------

As much as we love Travis Worker and Travis Build, things aren't always pain free. If you've been using Travis for any period of time you would have possibly come across two annoying bugs, the dreaded [VMFatalError](https://travis-ci.org/westoque/phantomjs.rb/builds/3614255), and the [stalled job](https://travis-ci.org/rootpy/rootpy/jobs/3606285/#L31) (which also includes false timeouts). These issues are an awful and frustrating experience for our users, and no easier for us. I would go as far to say that every time a VM explodes or a timeout fails a test incorrectly, a German looses his lederhosen.

<figure class="small right">
  [ ![The Travis Team in Lederhosen](http://mudskipperbeerlife.files.wordpress.com/2011/09/lederhosen.jpg) ](http://mudskipperbeerlife.wordpress.com/tag/lederhosen/)
  <figcaption>The Travis Team in Lederhosen</figcaption>
</figure>

Fixing these issues have not been easy as there were three prime culprits, each being as hard to exonerate as the other:

  1. [VirtualBox](https://www.virtualbox.org/)
  
  2. SSH
  
  3. [net-ssh-shell](https://github.com/mitchellh/net-ssh-shell/)

VirtualBox was definitely at fault for the VM explosions, that was easy, but it was also a possible candidate for the VM stalls as we postulated that it was interferring with the SSH connection causing it to hang, or that the [network card might be causing issues](https://github.com/mitchellh/vagrant/issues/391). 

SSH was also a logical explanation as maybe the connection was flickering and (maybe) net-ssh was trying to be forgiving when it should have just exploded and raised connection errors.

And latestly there was net-ssh-shell. Maybe we should explain how this works a little.

Since the dawn of Travis, the Worker has been using a Ruby gem called net-ssh-shell to help run your tests. This gem works around the issue of SSH not allowing you to run multiple commands after each other while also preserving the environment. net-ssh-shell effectivly starts an echoless shell and then pipes in commands via STDIN while capturing the output (STDOUT) and listening for a little code it adds to figure out when the command has finished and what the exit code is. You can see the main code at work [here](https://github.com/mitchellh/net-ssh-shell/blob/master/lib/net/ssh/shell/process.rb#L44-46).

This has worked great, but it's also a bit of a hack which isn't 100% realibale. All you need is for net-ssh-shell to miss a little bit of output, or for another process on the VM to print to STDOUT at the same time, mixing up the code it is waiting for, and you end up with a stalled job.

At the end of the day there is no single reason we can pinpoint and be sure of when it comes to false timeouts, it is highly likely a mixture of technologies and libraries used contributes to the problem, and it is highly likely componded by Travis code.

So what have we been doing about it?
------------------------------------

**How we run your tests**

About a month ago our amazing [Sven](http://twitter.com/svenfuchs) had an idea, he thought it was a bit crazy at first so coded it mostly as an experiment, but it was such a super smart idea we just had to use it as soon as possible. Mind blowingly smart!

<figure class="small right">
  [ ![Spend 5 minutes with Sven and this is what happens to you!](http://www.reactiongifs.com/wp-content/uploads/2011/09/mind_blown.gif) ](http://www.reactiongifs.com/wp-content/uploads/2011/09/mind_blown.gif)
  <figcaption>Spend 5 minutes with Sven and this is what happens to you!</figcaption>
</figure>

Instead of us running command after command using net-ssh-shell, we now create a shell script which includes all the commands we need to run, upload that to the VM, and then excute it! Boom! This means we now only need to run one command, capture the output and exit code, and all covered by the standard SSH spec. Even better, we now have a script you can run locally on a Linux or Mac machine to replicate exactly what we do!

Welcome to the new Travis Build, which can be found on the [sf-compile-sh](https://github.com/travis-ci/travis-build/tree/sf-compile-sh) branch (for the meantime). You can read about it more [here](https://github.com/travis-ci/travis-build/pull/60), which also includes links to example build scripts we generate.


**What we run your tests on**

VirtualBox has got us very far. It was great for development, had some fantastic features like snapshots and immutable disk images, and had some great tools built around it like [Vagrant](http://www.vagrantup.com/).

As we grew from one worker box to our current 24, maintenance of the VMs became a pain. Updating a worker took up to an hour as each VM on the host had to be provisioned and primed for use. Also, because of how VirtualBox works, we had to plan for how many Ruby boxes we would run, or how many Perl/Python/PHP (PPP) or JVM boxes we needed. To make a long story short, we could not easily dynamically decide what builds a host box could or would run. 

And of course there are the API isuses and VirtualBox specific errors, like trying to shut down VMs which looked liked they were shutting down but were actually stuck. Initially we implemented a crud 'kill -9' trick which would detect this error and then, well, shell out and kill the VM process using it's process id, which  seemed to work for a while, but was not fool proof by any means. In fact, it was mearly a band aid around a more complicated issue of 'what does the future architecture of Travis look like?'

The great thing is we finally have the answer to this question, and are very happy to say we now know what our next-gen architecture will look like. In fact, we have been testing it with the Rails and Spree queues, and since a week ago, the JVM queue. And over the next week or two we will be moving all queues to this new setup.

And don't worry [Travis Pro customers](http://about.travis-ci.org/blog/2012-10-25-the-travis-plans/), we have been running a beta setup for a small set of customers too and it is working beautifully!

So what is this new setup you ask?

We will save most of these details for a later blog post after we've ironed out some of the bugs, but we will be partnering with a server hosting provider in the States who will be running a private cloud for us. This private cloud, backed with SSDs, will allow us to offer the awesome users of Travis greater resource allocations (3gigs of ram, double what we currently offer), and we are also looking at offering users the ability to pick your VM type, like the ability to test on 32bit Ubuntu AS WELL AS 64bit.

This is a huge maintenance relief for us as we can now focus on Travis features instead of having to maintain servers. We also pledge to update VMs more often so you have the latest and greatest services available for you to test against!

But wait, there's more!
----------------------

While we were at it we decided to add two often requested features to this new code base, these being **an 'errored' build state**, and **better, more flexible time outs**.

From now on, if any command before your actual tests are run fails we will mark your [test run as errored](https://travis-ci.org/Feldspar/feldspar-compiler/builds/4277473). For example, if `bundle install` or `apt-get install a-missing-lib` fails then you job is 'errored' not 'failed' . Even better, we also mark your PRs with this state if they fail due to reasons other than failing tests!

<figure class="small right">
  [ ![Did someone say "errors in pull requests"?](http://s3itch.paperplanes.de/pull_request-20130124-152203.png) ](http://s3itch.paperplanes.de/pull_request-20130124-152203.png)
  <figcaption>Errors in Pull Requests!</figcaption>
</figure>

The fine grained timeouts we've been using for the past year and a half were good, but they became restrictive for some. Restricting how long your app spends installing dependecies is annoying, especially when your test run might only take a fraction of the time. Instead we are now moving to a global 50 minute job timeout, and if no log output has been received in 5 minutes then we cancel the job. Why 5 minutes you say? We have found that not having log output from a job run points towards either a stalled test suite, or stalled process. A good example of this is some jobs start a background webserver but sometimes forget to stop it, causing the job to sit and wait. And of course, we mark these timeouts as errors as well!

So where to from here?
----------------------

Although we have made a lot of headway, we still have a long way to go. For example, starting a VM incurs a startup cost of around 30-40 seconds, sometimes greater depending on load. We need to prestart VMs and have them waiting in a pool. We also need to remove the notion of defined queues, eg. having 30 VMs for Ruby builds and 30 for PPP means if the Ruby queue is empty and the PPP queue is knee deep in jobs, we should be dynamically allocating capacity where and when needed!

So please be patient with us over the next couple of weeks as we roll out these changes and more. If you experience any issues please report them to our GitHub issues page on [travis-ci/travis-ci](https://github.com/travis-ci/travis-ci/issues?direction=desc&labels=feature-request&sort=updated&state=open). And, as always, free feel to drop by our IRC room (#travis on freenode) if you have any questions, comments, or advice :)

I want to finish off by saying **sorry** to everyone using Travis and who've had to put up with these issues. We are very sorry for the delay in getting these issues fixed, and hope that the awesome we have planned for you brings great smiles to your face and a sparkle to your heart :)

Have a fantastic weekend,

The Travis Team.