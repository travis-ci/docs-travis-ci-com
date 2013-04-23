---
title: Our new VM setup for private project testing
created_at: Thu 2013 Apr 23 17:00:00 CEST
layout: post
author: Josh Kalderimis
twitter: j2h
permalink: blog/new-vm-setup-for-private-project-testing
---

At the end of January we announced our fantastic partnership with Blue Box who now host and run our Linux VM infrastructure for all open source test runs.

This new setup not only allows us to offer users 64 bit Ubuntu 12.04 VMs with 3 gigs of memory, but it also gives us the flexibility to offer other great features over time like other OS's and the choice of 32 or 64 bit archs.

Over the last month we have been running the new VM setup in parallel, with many customers providing invaluable feedback to us, helping us iron out any kinks they may of come across.

The new VM setup is based in Ashburn, in the heart of cloud country. Being closer to GitHub and services like RubyGems have helped improve builds times as well, for example, git clone is significantly faster and more reliable.

Today we are very happy to let all our Pro customers know that on the 29th of April we will be transitioning all private repositories to our private VM setup on Blue Box. This will start at 8am UTC/GMT and you should see no disruption of
service or downtime. We'll announce on [twitter](http://twitter.com/travisci), as well as our [status page](http://status.travis-ci.com), when we begin the transition and when it is completed.

If you would like to move your repository over to the new setup before the 29th, please email [support@travis-ci.com](mailto:support@travis-ci.com) and we will help move you over earlier.

There are three important changes which are good to be aware of as well as they may effect some builds.

1. All SSH connections to the VMs are now IPv6. This effects the current Cassandra setup, which we have a fix for and will be rolling out shortly.

2. FireFox has been updated to 19.0.2. This may effect your Selenium tests. We will be locking FireFox to 19.0.2 and providing an easy way to specify which FireFox you need in your test run, this will be announced in a blog post soon.

3. The use of 'sudo' should not be required for tasks like 'npm install', 'pip install' or 'gem install', removing the 'sudo' should make everything hum along nicely.

If you experience any issues, please email us at [support@travis-ci.com](mailto:support@travis-ci.com), or pop into our Campfire room, and we would be more than happy to help :)

Thanks to the awesome guys at Blue Box for working with us closely to make this possible!

Have a fantastic week,

Josh