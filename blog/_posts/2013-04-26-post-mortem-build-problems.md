---
title: "Post Mortem: Recent Build Infrastructure Issues"
created_at: Fri 26 Apr 2013 16:00:00 CEST
author: Mathias Meyer
twitter: roidrage
permalink: blog/2013-04-26-post-mortem-build-infrastructure-issues
layout: post
---
Last week we've been having quite some trouble with our build infrastructure and with our API and parsing .travis.yml files, causing significant downtime and spurious errors on both platforms for open source and for private projects. We're sorry our users and customers have had to wait for their builds to run for several hours. While this didn't affect customers still running on our previous build setup, it still affected a lot of you.

I wanted to take some time to explain what happened and what we did to fix it.

## What happened?

Last Monday, April 15 around 20:15 UTC, we received customer reports of builds on their private projects not properly running. We looked into it right away and found that creating new VMs to run the tests on started failing for a majority of all requests.

We found that there were significant problems for the VMs to acquire IP addresses on their respective networks. The underlying IPv4 addresses weren't reclaimed by the system fast enough to keep up with our load of creating VMs. A set of blocks runs on a common subnet, which has only a maximum of 254 IP addresses available, commonly less than that, as it's a shared infrastructure.

We create around 30,000 VMs per day, the majority of them on travis-ci.org where they're much more short-lived. So when the infrastructure system can't reclaim them fast enough and there's not enough capacity available, creating new VMs will fail.

We tried a few mitigations, including reducing the number of concurrent VMs created, but nothing seemed to help. Unfortunately, we failed to realize the significance of these problems, and continued trying smaller things to get things running again.

It took us a while to recognize that we need to take all build capacity offline to allow for our infrastructure to recover, as a large backlog of VM creation jobs remained queued, waiting to be run, delaying any possible recovery.

We fully stopped all processes that were continuing to request new VMs and let the queues drain.

After about five hours of trying fixes without any success, we finally made the call to move a majority of the infrastructure to different subnets. At around 2:00 UTC, the move was done, and we brought most build capacity back online.

VM deployments started running again without any issues, and after half an hour of tailing the logs and watching for any more errors and not seeing any issues, we called it a night and went to sleep.

Unfortunately, in the meantime, issues on travis-ci.org started to pop up. We deployed a change earlier that night that would allow us to create VMs on an IPv6-only network, a change that would help us reduce the problems we saw that night.

Unfortunately not all of our infrastructure was yet fully prepared to run on IPv6 networks, so VMs started failing as well, with a backlog of build requests having increased over time.

There were some hosts that didn't have IPv6 addresses yet, and assigning them one fixed this particular issue and we could let builds run again.

There was a bug in our code that caused a lot of requeued builds (which we do when we fail to allocate a VM) to flood our system and hindered any new builds from being scheduled. To fix this we increased the parallel processing handling these particular messages, which in turn led to a lot of builds not finishing visibly, even though the underlying jobs finished. A race condition caused the build status to not be propagated properly. We're still investigating a proper fix for this particular issue.

When these issues got their temporary band-aids, builds were running again on travis-ci.org.

Meanwhile, on Tuesday afternoon, a lot of API requests hitting api.travis-ci.org started returning timeouts. There were a few database queries that caused significant delays, most notably the query fetching the currently running and queued jobs in the right sidebar. We had to remove the sidebar element temporarily to make sure that all the other requests were handled in time. We identified a few more slow-running queries and added indexes to speed them up. We have yet to add the sidebar back, but it's not forgotten.

On Wednesday night at around 22:30 UTC, we noticed VMs failing again on travis-ci.org and decided right away to reduce the available build capacity to make sure at least a minority of builds were able to run without failing. This unfortunately meant that a lot of builds were queuing up during our busiest hours of the days, but it was a call we had to make at the time.

We made the call to put all our efforts on moving our entire build setup to use IPv6 only, as the address space is significantly larger and the speed of reclaiming IP addresses matters a lot less.

We updated our code to request VMs with IPv6 addresses only, upgraded the underlying VM images and tested the code successfully on our staging systems within a few hours. In the afternoon, we were ready to deploy the change when we got reports of builds running on the wrong language platforms.

We suspected that there were issues fetching or parsing the .travis.yml files and started investigating in the logs. We had initial trouble locating the error, as our logs didn't show any errors. After investigating further, we found that requests fetching the .travis.yml failed with an unusual HTTP status for which our code wasn't prepared yet.

We prepared a fix in the library we use to talk to the GitHub API and deployed it. Within two hours we had the fix out and could start builds again. Unfortunately builds that were handled in the meantime couldn't be restarted as we currently don't fetch the config again when a build is restarted. These builds shouldn't have made it into the system in the first place, but we didn't treat this particular status code as an actual error, which would've caused the build request to be requeued and retried later.

After we confirmed that builds were running again and the correct configuration settings were used, we deployed the change that would switch travis-ci.org to use IPv6 only later that night. Meanwhile we moved another set of hosts on travis-ci.com to new subnets with more IPv4 addresses available until we could confidently deploy the IPv6 change there as well.

Both platforms are running on entirely separate build setups, which is also true for the underlying build infrastructure. We wanted to make the switch on travis-ci.com with the confidence that the IPv6 only setup worked well on the open source platform.

The IPv6 change was successful, and at around 22:00 UTC last Thursday, all of travis-ci.org was running against VMs talking to them only via IPv6. The VMs itself can still utilize IPv4 connections as the network allows for the IPv6 addresses to be NAT'ed for requests hitting IPv4 resources, most notably required for package and depdency mirrors.

On Friday, we found several builds that needed to be requeued or updated to reflect their overall status properly, but we could confirm that all VM deployments were successful, and we ran on full capacity again.

On Monday the 22nd, in the afternoon hours, we added more capacity to our travis-ci.com cluster in preparation of sunsetting our old build infrastructure entirely. Unfortunately the IPv4 address issues immediately started popping up. We immediately took down a portion of our build processors to reduce the impact, but VM deployments were still failing.

While we had planned to move travis-ci.com to IPv6 the next day, we decided to make an emergency switch to avoid any more significant downtime.

That switch was successfully deployed at 20:00 UTC, so we could turn on builds again.

Since then, our VM deployments haven't seen any significant issues. We're still investigating some problems getting particular services running on the IPv6 setup. 

## The mitigation

The major change required to reduce the address allocation issues is now deployed on both platforms, successfully so. This change will allow us to add more capacity more reliably and without having to worry about any more conflicts in the future.

We still have homework to do when it comes to throttling our own code when VM deployments fail. While this particular problem is unlikely to pop up again, VM creation can still fail due to other issues, and we're working on making the code handling that more resilient. It shouldn't continue hitting the underlying API and requesting more builds if a majority of requests are failing.

On top of that, our alerting didn't notify us soon enough of the increased number of failures. We're working on improving this, so we can catch the issues sooner.

Regarding the issue fetching the .travis.yml file, we've already improved the code to handle this particular status code better, but we need to look at different return codes from the GitHub API in more detail to decide which ones need to be assumed a failure and retried again later.

As for PostgreSQL, we're continuing to investigate slow queries so we can bring back the missing element in the sidebar with confidence.

It's been a rough week, and we're very sorry about these issues. We still have a lot of work to do to make sure both platforms can continue to grow and handle failure scenarios with a wider impact better than they currently do. There are a lot of moving parts in Travis CI, and the only right thing to do is assume failure and chaos, all the time.

Much love,

Mathias and the Travis team.
