---
title: Speed Up Your Builds: Cache Your Dependencies
created_at: Thu 5 Dec 2013 17:00:00 CET
author: Mathias Meyer
twitter: roidrage
permalink: blog/2013-12-05-speed-up-your-builds-cache-your-dependencies
layout: post
---
A large amount of time of a normal build is spent installing dependencies, be it
Ubuntu packages or simply running `bundle install` or `npm install` on a normal
project. On an average Rails project, this can take a few minutes to succeed
unfortunately.

This is dreadful to watch and it takes precious time that should rather be spent
running the build. We've seen some great initiatives from customers to cache
bundles, like [bundle_cache](https://github.com/data-axle/bundle_cache)
(inspired by our friends at [Kisko Labs](http://kiskolabs.com)) and
[WAD](https://github.com/Fingertips/WAD) from the fine folks at
[Fingertips](http://www.fngtps.com).

But in the end, it became clear that we need to offer something that's built-in,
automatically caching our customers' bundles without requiring major changes to
their build configuration.

<figure class="right smaller"> <img
src="http://s3.amazonaws.com/rapgenius/img122.jpg"/> </figure>

Today, we're officially announcing **built-in caching for dependencies**.

While it integrates nicely with Bundler already, you can also use it to cache
Node packages, Composer directories, or Python PIP installations. Heck, you can
even use it to speed up the asset pipeline's temporary test cache, to speed up
builds even more.

Plus, caching an entire bundle of dependencies has the benefit of reducing the
impact of outages of dependency mirrors.

To give you an idea of the impact of this simple yet efficient way of speeding
up builds, we've had customers report **saving a total of half an hour or more**
on their builds with bigger build matrixes.

On our billing app, it shaved off four minutes, cutting the build time down to
one minute.

How can you enable it for your private projects?

If you'd like us to cache your Bundler directory, simply add the following to
your .travis.yml:

    cache: bundler

If you want to add the asset pipeline's compilation cache, you can specify the
directories to cache as well:

    cache: bundler: true directories:
        - tmp/assets/cache/test/sprockets

For a Node.js project, simply specify the `node_modules` directory:

    cache: directories:
        - node_modules

The specified paths are relative to the build directory.

### Cache Rules Everything Around Me

We're working on getting more language-specific caching methods included, and
on getting common dependency mirrors closer to our infrastructure,
as we already did with a [network-local APT
cache](http://about.travis-ci.org/docs/user/caching/#Caching-Ubuntu-packages).
    
Bundler 1.5 has great features upcoming, including [Gem Source
Mirrors](http://bundler.io/v1.5/bundle_config.html#gem-source-mirrors), which
we're looking into utilizing to increase the reliability of installing RubyGems.

Stay tuned, and happy caching!

For all the gory details on caching, see our [docs](/docs/user/caching/). Note
that this feature is currently only [**available for private
repositories**](https://travis-ci.com).

We've open source the tool we're using to cache dependencies is [open
source](https://github.com/travis-ci/casher)!
