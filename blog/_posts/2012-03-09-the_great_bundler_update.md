---
title: The Great Bundler 1.1 Upgrade
layout: post
created_at: Fri Mar 9 12:00:00 CET 2012
permalink: blog/the-great-bundler-1-1-upgrade
author: Michael Klishin
twitter: michaelklishin
---


# The Great Bundler 1.1 Upgrade

As you possibly have heard, Bundler 1.1 was released a few days ago and is no longer vaporware, huzzah!  We want to explain briefly how Travis CI will migrate to it, and how you can upgrade early if you want to.


## Key Improvements in Bundler 1.1

Bundler 1.0 is often criticized for being a tad slow. One of the reasons was due to the large number of requests Bundler 1.0 issues to rubygems.org to resolve the dependency graph. Bundler 1.1 uses a new and improved rubygems.org API to significantly reduce the number of network requests, and in some cases it can even avoid hitting the network altogether.


## Where We Are Today

Travis CI Ruby VMs have Bundler 1.0 preinstalled. If you have a small Gemfile then this should be perfectly fine for you, but if you have a larger more complicated Gemfile then your build might benefit from Bundler 1.1.

To update Bundler before dependencies are installed you can do:

    before_install:
      - gem install bundler

And thanks to virtual machine snapshotting these changes won't affect subsequent builds.


## Migrating to 1.1

On March 14th, 2012 we plan to update the Ruby VMs to use Bundler 1.1. If you experience any issues with Bundler 1.1 please report these to the Bundler team. 

If for some reason you want to continue using a previous Bundler version you can downgrade using the following technique: 

    before_install:
      - rvm @default,@global do gem uninstall bundler -v 1.1.0 -x
      - gem install bundle --version '~> 1.0.0'
      - bundle --version

Happy Friday!

The Travis CI Team
