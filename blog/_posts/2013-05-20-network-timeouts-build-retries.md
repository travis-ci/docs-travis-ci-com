---
title: On Network Timeouts and Build Retries
author: Mathias Meyer
twitter: roidrage
created_at: Mon 20 May 2013 16:00 CEST
layout: post
permalink: blog/2013-05-20-network-timeouts-build-retries
---
Since our move to our new infrastructure setup, we've seen spurious errors come
up in builds on Travis CI. They mostly made themselves known by way of network
timeouts installing dependencies from rubygems.org, npmjs.org, or simply cloning
from GitHub. They seemed to happen randomly, but we do know they happened way
too frequently for us to ignore them.

We started investigating, first looking at rubygems.org, because most of the
error reports we initially received came from people using Bundler. The problems
manifested themselves as connection timeouts when trying to install specific
gems. This error came up in random spots, but mostly after installing a few
gems, stopping right in the middle of the full bundle.

Talking to the fine people running rubygems.org, there were indications that
this potentially was an SSL problem on their end which needs to be improved. We
started looking into alternatives to using rubygems.org directly, namely running
our own gems proxy that redirects directly to the gems stored on S3, taking load
of rubygems.org, potentially reducing overall congestion and increasing chances
of successful bundles.

### Our Initial Remedy Attempts

The setup isn't yet working, as there are some hurdles involved, in particular
given that we want to avoid people having to put our Bundler source in their
Gemfiles. Also, the rubygems package now installs its own SSL certificates and
does strict checks based on them. We're still working on this solution, but we
do have some ideas on how to transparently implement it.

We also started looking into adding Bundler retries to Bundler when installing
packages. We're working on turning this into a patch that could hopefully make
it into Bundler.

We got a bit more sceptical that this is just an issue with RubyGems after we
got an increasing number of reports of failures even when using HTTP instead of
HTTPS, when cloning from GitHub, installing libraries from npmjs.org, or even
doing DNS lookups.

It started to look like more general network problems we're dealing with. 

### We Have to go Deeper

We brought up this issue with our infrastructure team and started investigating
deeper in our stack. We couldn't find any evidence of exhausting our network address
translation setup initially, which was our first suspect.

There were indications that a network link got exhausted. This has some
plausibility as we run up to 350 builds at the same time, pulling in lots of
data from different sources.

Unfortunately, we haven't found the deeper cause yet. The link in question will
be replaced soon, so we'll see if that helps reduce the problems. Additionally
we'll spice up the network monitoring so we can monitor the overall usage
of our links and our systems better.

### Introducing Retries

As we have yet to find the causes for these issues, we decided to take immediate
steps to reduce the impact on your builds and to avoid increasing amounts of
builds ending up in an error state because of problems on our end. This leads to
a very frustrating Travis CI experience, and we're sorry that it took us a bit
longer to realize that there needs to be an immediate fix for this problem.

Over the weekend we rolled out a little feature that [retries certain
steps](https://github.com/travis-ci/travis-build/pull/104) of
the build process should they fail initially. This currently includes
installation steps like `bundle install`, `npm install`, and so on.

All our default commands for the `install` step are tried three times. This adds
a bit more noise to the logs but it's commonly a quick thing to rerun as these
tools are smart enough to just reuse what they already installed and to continue
working through the list of things they have yet to install.

![](http://s3itch.paperplanes.de/bundler_retries_20130520_160526.jpg)

This catches a big part of the timeouts, as subsequent runs are a lot more
likely to succeed. It has the downside of retrying on other problems as well,
but we deemed that an appropriate tradeoff until we're coming up with better
solutions, e.g. looking at the return codes of the tools.

The upshot is that when the command succeeds the second time, the entire set
will be folded away neatly so it doesn't clutter the logs visually.

We're also adding this to git clones as well, it's being deployed this very minute.

### Retrying Your Own Commands

If you're doing any custom installation of things from external resources, for
instance to install Ubuntu packages, you can use this functionality as well.
It's exported as a shell function in the build script.

Instead of running `sudo apt-get install something`, make it `travis_retry sudo
apt-get install something`.

### Moving Forward

We'll be installing better monitoring for our network layer, will add more
diagnostic information to our logs so we can pinpoint any potential problems
better and we'll look into a more fine-grained way to determine if an
installation failed because of timeouts or for other reasons.

We're sorry for the bad experience you've been having on Travis due to these
errors. The retries should reduce the overall impact of the timeouts for the
time being, but we'll work on reducing them coming up overall.

If you're still seeing strange build timeouts or other errors that look
spurious, please [let us know](https://github.com/travis-ci/travis-ci/issues/new)!
