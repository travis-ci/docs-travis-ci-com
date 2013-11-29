---
title: PostgreSQL 9.2 and 9.3 Now Available on Travis CI!
created_at: Fri 29 Nov 2013 16:15:00 CET
author: Mathias Meyer
twitter: roidrage
permalink: blog/2013-11-29-postgresql-92-93-now-available
layout: post
---
<figure class="right small">
  <img src="http://s3itch.paperplanes.de/postgresql_20131128_110016.jpg"/>
</figure>

[PostgreSQL](http://postgresql.org) is a fast-moving database beast. We're big
fans and very [happy users of it ourselves](https://postgres.heroku.com), with
Travis CI running on a total of eight database servers.

For the longest time, all we had to offer to our users and customers was the
standard 9.1 distribution that comes with Ubuntu 12.04. But since then,
PostgreSQL has moved on, bringing more and more feature goodies with every
release.

[Release 9.2](http://www.postgresql.org/docs/9.2/static/release-9-2.html)
brought the new JSON data type and support to fetch data directly from indexes
(very relevant to us too), and
[9.3](http://www.postgresql.org/docs/9.3/static/release-9-3.html) brought
materialized views, even more goodness for JSON data types and greatly improved
shared memory requirements along the way.

Being able to test against newer versions of PostgreSQL then, was long overdue!

Today we're happy to ship support for three different versions, 9.1, 9.2 and
9.3, all pulled directly from [PostgreSQL's APT
repository](http://www.postgresql.org/download/linux/ubuntu/).

How can you start testing against different PostgreSQL versions on Travis CI?

We added a new addon for this. To test your project against 9.3, add this to
your .travis.yml

    addons:
      postgresql: 9.3

You can pick one of 9.1, 9.2 or 9.3 as a version number. The right version will
already be up and running when your test run starts!

A big thank you to [Gilles Cornu](https://github.com/gildegoma) for the hard
work he's put into this feature!

PostgreSQL 9.2 and 9.3 are available for [open source](https://travis-ci.org)
and [private repositories](https://travis-ci.com) today!
