---
title: Auto-Tailing Logs
author: Sven Fuchs
twitter: svenfuchs
created_at: Thu Sep 07 17:00:00 CEST 2012
permalink: blog/2012-09-07-auto-tailing-logs
layout: post
---
From the very [beginning](http://svenfuchs.com/2011/2/5/travis-a-distributed-build-server-tool-for-the-ruby-community)
one of Travis CI's most outstanding features was streaming logs from test runs
that happen on workers to the client application which runs in your browser.
It can be just mesmerizing to watch your tests run live on Travis CI:

![](https://img.skitch.com/20120907-n7fwf2whiint48udh7fts8nx1r.jpg)

Many repositories use a short [one-dot-per-test](http://travis-ci.org/#!/thoughtbot/paperclip/jobs/2369636)
style output so watching the logs while tests always worked great.  But many
other repositories use a
[much](http://travis-ci.org/#!/carlhuda/bundler/jobs/2369557)
[more](http://travis-ci.org/#!/php/php-src/builds/2360140)
[verbose](http://travis-ci.org/#!/rubygems/rubygems.org/jobs/2363074)
[log](http://travis-ci.org/#!/redis/redis-rb/jobs/2243620)
output so watching their logs live requires to continously scroll to the bottom
of the page as new log output comes in.

Thus, one of the most requested features has been a switch that would make the
page stick to the bottom of the log file.

Today we have shipped this feature. It still needs some polishing but it should
do its job so we thought we shouldn't hold it back. Watch the demo video
from our feature pull request:

<iframe width="420" height="315" src="http://www.youtube.com/embed/E2Xovffsfvo" frameborder="0" allowfullscreen></iframe>

... or simply head over to [Travis CI](http://travis-ci.org) and try it out.

Of course this feature is also available on [Travis CI Pro](http://travis-ci.com) starting today.

Cheers!
