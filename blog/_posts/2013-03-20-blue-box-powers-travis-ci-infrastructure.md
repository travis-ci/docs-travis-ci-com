---
title: Blue Box Powers Travis CI's Next Generation Infrastructure
created_at: Wed Mar 18:00 CET 2013
layout: post
author: Mathias Meyer
twitter: roidrage
permalink: blog/2013-blue-box-powers-travis-ci-infrastructure
---
We have some great news for you today: Last weekend we finally switched all
builds on <http://travis-ci.org> to our new build infrastructure. This setup not
only gives you more processing power (1.5 cores per build) and twice as much
memory (3 GB), it runs in container-virtualized hardware and directly off SSDs.
It's also a 64bit platform with the option of supporting 32bit environments as
well!

![](/images/bluebox.png)

All this has been made possible by our amazing partner, [Blue
Box](https://bluebox.net), who have provided us with a customized private cloud
setup, tailored specifically for our needs as a hosted continuous integration
platform.

This new platform allows us to do many things a lot better than with our
previous, manually managed VirtualBox setup. We can easily add more capacity as
we grow (and boy, we've grown a lot over the last months!), and we can provision
updates to our build environments a lot faster than before, allowing us to
provision new language releases, framework updates and service additions much
quicker than before.

We're pretty psyched about this new partnership, it's great news for the open
source community as we can follow the build demand a lot better than before and
update the build environment much faster too. We can also leave the
infrastructure management parts in the amazing hands of the Blue Box team and
focus on shipping new features.

You should give Blue Box a nice high five next time you meet someone from their
awesome team. They're amazing folks to work with, and we're looking forward to
working closely with them to push Travis CI forward!

<figure class="small right">
  <a href="/images/blueboxteam.png"><img src="/images/blueboxteam-small.png"/></a>
</figure>

We're in the process of rolling this out for our customers on
<http://travis-ci.com> as well, stay tuned!

Make sure to read the official [press release](https://bluebox.net/press-releases/travis-ci) too!

Thanks Blue Box, you're awesome!
