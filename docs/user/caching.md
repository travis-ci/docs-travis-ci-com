---
title: Caching
layout: en
permalink: caching/
---

***The features described here are currently only available for private repositories. These features are also still experimental, please [contact us](mailto:support@travis-ci.com?subject=Caching) with any questions, issues and feedback.***

<div id="toc"></div>

## Caching directories

Travis CI can persist directories between builds. This is especially useful for dependencies that need to be downloaded and/or compiled from source.

### Bundler

On Ruby projects, installing dependencies via [Bundler](http://bundler.io/) can make up a large portion of the build duration. Caching the bundle between builds drastically reduces the time a build takes to run.

The logic for fetching and storing the cache is [described below](#Fetching-and-storing-caches).

#### Enabling Bundler caching

<s>Bundler caching is automatically enabled for Ruby projects that include a Gemfile.lock.</s> *([not yet](https://github.com/travis-ci/travis-build/pull/148) enabled)*

You can also explicitly enable it in your *.travis.yml*:

    language: ruby
    cache: bundler

Whenever you update your bundle, Travis CI will also update the cache.

#### Determining the bundle path

Travis CI tries its best at determining the path bundler uses for storing dependencies.

If you have [custom Bundler arguments](/docs/user/languages/ruby/#Custom-Bundler-arguments-and-Gemfile-locations), and these include the *--path* option, Travis CI will use that path. If *--path* is missing but *--deployment* is present, it will use *vendor/bundle*.

Otherwise it will automatically add the *--path* option. In this case it will either use the value of the environment variable *BUNDLE_PATH* or, if it is missing, *vendor/bundle*.

#### With a custom install step

Bundler caching will not automatically work if you override the install step. You can instead use the [arbitrary directory caching method](#Arbitrary-directories) described below:

    language: ruby
    install: bundle install --without development --deployment
    cache:
      directories:
      - vendor/bundle

In the above example, you could also omit the install step and instead define [bundler_args](/docs/user/languages/ruby/#Custom-Bundler-arguments-and-Gemfile-locations):

    language: ruby
    bundler_args: --without development --deployment
    cache: bundler

### Arbitrary directories

You can cache arbitrary directories between builds by listing them in your *.travis.yml*:

    cache:
      directories:
      - .autoconf
      - $HOME/.m2

As you can see, it is also possible to use environment variables in the directories.

The logic for fetching and storing the cache is [described below](#Fetching-and-storing-caches).

### Fetching and storing caches

* We fetch the repo's cache on every build, including feature branches and pull requests.
* There is one cache per repository and language version/compiler version/JDK version/Gemfile location/etc.
* All branches use the same cache.
* Only modifications made to the cached directories from normal pushes to the master branch are stored.

This logic works very well if branches do not modify the cache at all or modifying the cache is generally cheaper than creating it from scratch. Newly created branches can thus instantly use the cache from master without polluting it for other branches.

### Clearing Caches

Sometimes you ruin your cache by storing bad data in one of the cached directories. We are working on adding an API endpoint and option in the web interface for forcefully clearing a project's cache. In the mean time, please [shoot us an email](mailto:support@travis-ci.com) and we'll happily clear it for you.

## Caching HTTP requests

We have an HTTP proxy in place that can cache certain requests for you.

### APT

You can turn on HTTP caching for APT in your `.travis.yml`:

    before_install: sudo apt-get install cowsay
    script: cowsay moo
    cache: apt

This will proxy and cache HTTP calls made by the `apt-get install` step.

## Configuration

### Enabling multiple caching features

When you want to enable multiple caching features, you can list them as an array:

    cache:
    - bundler
    - apt

This does not when caching [arbitrary directories](#Arbitrary-directories). If you want to combine that with other caching modes, you will have to use a hash map:

    cache:
      bundler: true
      directories:
      - vendor/something
      - .autoconf

### Explicitly disabling caching

You can explicitly disable all caching by setting the `cache` option to `false` in your *.travis.yml*:

    cache: false

It is also possible to disable a single caching mode:

    cache:
      bundler: false
      apt: true
