---
title: Engine Yard is awesome!
layout: post
created_at: Mon 4 Feb 16:00:00 CET
author: Piotr Sarnacki
twitter: drogus
permalink: blog/2013-02-04-engine-yard-is-awesome
---

As some of you may know I've been working on Travis CI for the last 3 months
[thanks to awesomeness of Engine Yard](http://about.travis-ci.org/blog/2012-10-22-engine-yard-sponsors-piotr-sarnacki-to-work-on-travis/).
You can read about the things that I've been working on on
[Engine Yard's blog](http://blog.engineyard.com/2012/travis-ci?eymktci=70170000000hHEC).

This pure awesomness does not end here, though. Recently Engine Yard extended
my participation in EY OSS Grant Program by 3 months! I can't be thankful
enough for that, so please help me and give them lots of internet hugs,
<a href="https://twitter.com/share" class="twitter-share-button" data-text="Thank you @engineyard!">thank them on twitter</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
or check out their [products](https://www.engineyard.com/). And I mean it, take a break from
reading the post and do it now!

Since my last update I've been working on support for artifacts, security
improvements, maintaining and extending our web client and helping Travis CI to
work smoothly with the increasing number of requests (which included various
kinds of optimizations).

There are a lot of things that we would like to do and it's sometimes hard to
choose wisely, but due to growing popularity some parts of Travis CI need
refactoring and/or architecture changes. With the hands of the wonderful Josh
and Sven we already managed to greatly improve the way we run your tests, but
this is not enough. In the recent feature we will be changing the way we manage
handling secure environment variables to make it more robust and secure.

Besides such refactorings I would also like to ship some new cool features.
One of the things is to improve the steps in preparing a build to run, specifically a way
we validate your `.travis.yml` file and communicate issues back to you.  E.g.
we currently don't do the best job there when we fail to configure the build
and you don't get any feedback about that or what specifically you can do to
fix the issue.

The next thing which I would like to give much more love is the usability of
displaying your build logs on the web UI. We are aware of the shortcomings of
the current client there and we feel your pain! Logs are the first thing you
look at when a build fails and it's often hard to find the piece of information
that you need. E.g. installation steps can take a lot of space and if the log
is really long it even can freeze the browser for a second or longer. We have
some ideas how to improve this situation and I hope to work on them soon.

This is all extremely cool and it's going to happen because of Engine Yard's
generosity. So, if you haven't done this already and you care about Travis and
open source testing, please let them know
 <a href="https://twitter.com/share" class="twitter-share-button" data-text="Thank you @engineyard!">how awesome they are</a>!
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>!


