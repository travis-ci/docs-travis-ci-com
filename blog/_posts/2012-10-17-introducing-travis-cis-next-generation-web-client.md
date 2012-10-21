---
title: "Introducing Travis CI's next generation web client"
created_at: Mon Oct 17 01:30:00 PDT 2012
layout: post
author: Sven Fuchs
twitter: svenfuchs
permalink: blog/2012-10-17-introducing-travis-cis-next-generation-web-client
---

If you think about Travis CI, the web client is the face of the project. You
look at it a lot.

The "live" nature of our UI, updating the repository timeline as new builds
come in, streaming the logs to the browser while a test suite is being run,
updating job queue etc. has always been a great asset for Travis CI.

People just love it:

[![](http://s3itch.svenfuchs.com/tweet_steveklabnik-20121017-000845.jpg)](http://twitter.com/steveklabnik/status/254714874251325440)

... and the "Mac OS X style desktop application" metaphor has proven to work
quite well over time.

At the same time we are all aware of the issues that our client had over the
last months, especially since traffic on Travis CI has exploded.

We are now running about 10,000 builds a day for nearly 25,000 repositories and
our old client could just not hold up with that. Especially in situations where
our queues had run full and other, seemingly "unrelated" issues occured and the
whole client just stalled on Chrome.

On top of the scalability issues our codebase made it pretty hard to fix things
and add new features. Instead one had to fight with really old library versions
that could not be upgraded easily, a ton of work-arounds and even things like a
slow asset compilation pipeline.

Even though the client as such was still great, people became increasingly
unhappy with the issues it started to show. And rightfully so. We felt just
the same!

So today we&rsquo;re really happy to announce Travis CI&rsquo;s next generation
web client.


## The next generation web client

The new Travis CI web client is a complete reimplementation of the proven
feature set of the last version. Development started [4 months ago](https://github.com/travis-ci/travis-web/commit/a3f629bd0d54c99450fb41e366c78f4e8f1a7783)
and a huge amount of work has been put into it over the last months.

It is currently running on
[https://next.travis-ci.org](https://next.travis-ci.org) and we will keep the
old version running on [http://travis-ci.org](http://travis-ci.org) for a short
while until the new one has proven under higher load and remaining issues are
hashed out.

### New features

With this new version  our main goal was to reimplement the same, well known
and battle tested functionality that the old client had, but make it based
on the latest versions of ember and ember-data, improve its performance,
overall stability and usability.

We are very happy that this goal has been achieved. The new client feels
much more snappy and performs quite well even in situations where our queues
see lots of traffic and start backing up.

Still, we also were able to put in some goodies and new features:

#### No more hashbang URLs, finally

We have never been very religious about this but there always were good
arguments that made us want to move away from the hashbang URLs that Travis CI
has started with (and frankly, worked great despite using them).

With the move to the new, shiny Ember router and the new api endpoint there
was no reason to stick with them and we changed our URL scheme to plain,
simple (and some would say "non-broken") URLs:

![](http://s3itch.svenfuchs.com/no_hashbang_urls-20121017-001420.jpg)

#### Requeue builds button

This is probably one of the most requested features recently: a way to
re-trigger a build through our UI. This will come in handy if you have a build
that stalled or misbehaved for some reason and you want to re-run it:

![](http://s3itch.svenfuchs.com/rebuild-button-20121017-001533.jpg)

#### Flash messages

If you use that feature you will also notice that we also finally have a
generic way of displaying flash messages:

![](http://s3itch.svenfuchs.com/flash-20121017-001607.jpg)

This yet has to be used for other interactive features such as turning
service hooks on/off and synchronizing data from GitHub.

### Design details

We have also put in a significant amount of attention to further iterate on
the look and feel.

Especially when running on smaller screens the old client was not really great
to use. We have now tweaked font sizes, widths and margins and made good use of
css media queries to respond to different screen sizes gracefully.

Even though this can still be improved (especially for very small screens, we
will happily accept pull requests) we believe it&rsquo;s a huge improvement:

![](http://s3itch.svenfuchs.com/left-sidebar-scaling-20121017-001639.jpg)

#### Other design touches

The profile page (now renamed to "Accounts") got a complete overhaul:

![](http://s3itch.svenfuchs.com/account-hooks-20121017-001727.jpg)

If you&rsquo;re into CSS then you might notice that the service hooks on/off
switch is done entirely in CSS without using any images.

The somewhat weird behaving and flickering feature that displayed repository
descriptions when mousing over a repository entry in the left sidebar has been
replaced by an "Info" button which reveals all repository descriptions:

![](http://s3itch.svenfuchs.com/repo-info-20121017-004218.jpg)

Also, we have ressurected the long buried selection indicator for the
repository list on the left as well as the accounts list on your profile page.
And one can now expand and collapse all workers in the right sidebar with one
click:

![](http://s3itch.svenfuchs.com/list-indicator-expand-workers-20121017-001806.jpg)

And finally there&rsquo;s a more generic way to display popups:

![](http://s3itch.svenfuchs.com/popup-20121017-001956.jpg)


## Thank you, Ember.js!

The new client is built on top of the latest version of
[Ember.js](http://emberjs.com), instead of the pre-alpha Ember version that
actually still was called Sproutcore 2.0 at that time. It uses the much faster
and lighter [Ember Data](https://github.com/emberjs/data) for storage, instead
of the old and very, very crufty Sproutcore Datastore. And it uses the new,
shiny Ember Router, not our own port of the old Sproutcore router.

All the improvements that have gone into the underlying Ember libraries
combined with the removal of hackish workarounds on our side make up for
tremendous improvements not only in terms of speed and stability, but also ease
of development and way more consistent code everywhere.

We would not have been able to ship this new client without the terrific help
of the Ember.js core team, most importantly
[Yehuda Katz](https://github.com/wycats)
[Tom Dale](https://github.com/tomdale)
[Peter Wagenet](https://github.com/wagenet)
[Paul Chavard](https://github.com/tchak), as well as
[Adam Hawkins](https://github.com/twinturbo) who helped us come up with a
solid and fast implementation of our [asset compilation pipeline](https://github.com/travis-ci/travis-web/blob/master/AssetFile).
Thank you so much, guys :)






