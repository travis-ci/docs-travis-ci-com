---
title: "Builds Atom Feed Now Available"
created_at: Wed 04 Dec 2013 06:54:47 EST
author: Hiro Asari
twitter: hiro_asari
layout: post
permalink: blog/2013-12-04-builds-atom-feed-now-available
---
There are many ways to stay up-to-date with your projects' build
results; you can visit [the web site](https://travis-ci.org), or
write your own client by using our [API](https://api.travis-ci.org/docs/).
We have recently added another.
You can now subscribe to the Atom feed with your favorite
news reader!

![](/images/atom_feed_view.png)

# How to subscribe
To subscribe to the feed, point your
favorite Atom Reader to the Atom feed URL:

    https://api.travis-ci.org/repos/travis-ci/travis-core/builds.atom

You can substitute `travis-ci` and `travis-core` to the repository owner
and name of the repository you would like to subscribe to.

![](/images/atom_feed_add.png)

Alternatively, you can also send the HTTP `Accept: application/atom+xml`
header to the above URL with or without the `.atom` extension.
(If you do not pass this header, you will get the JSON-formatted data
without the extension.)

With [cURL](http://curl.haxx.se/), you can run:

    curl -H "Accept: application/atom+xml" https://api.travis-ci.org/repos/travis-ci/travis-core/builds

# Availability
The Atom feed is available now on both
[Travis](https://travis-ci.org) and
[Travis Pro](https://travis-ci.com).

Enjoy!
