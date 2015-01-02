---
title: Caching Dependencies and Directories
layout: en
permalink: /user/caching/
---

The features described here are currently **only available for private repositories on [travis-ci.com](https://travis-ci.com) and our new [container-based infrastructure](http://docs.travis-ci.com/user/workers/container-based-infrastructure/)**. These features are also still experimental, please [contact us](mailto:support@travis-ci.com?subject=Caching) with any questions, issues and feedback.

Also note that caching is only avaiable in the Linux build environment at this time, so caching is not available for Objective-C builds.

<div id="toc"></div>

## Caching directories (Bundler, dependencies)

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

If you have [custom Bundler arguments](/user/languages/ruby/#Custom-Bundler-arguments-and-Gemfile-locations), and these include the *--path* option, Travis CI will use that path. If *--path* is missing but *--deployment* is present, it will use *vendor/bundle*.

Otherwise it will automatically add the *--path* option. In this case it will either use the value of the environment variable *BUNDLE_PATH* or, if it is missing, *vendor/bundle*.

#### With a custom install step

Bundler caching will not automatically work if you override the install step. You can instead use the [arbitrary directory caching method](#Arbitrary-directories) described below:

    language: ruby
    install: bundle install --without development --deployment --jobs=3 --retry=3
    cache:
      directories:
        - vendor/bundle

In the above example, you could also omit the install step and instead define [bundler_args](/user/languages/ruby/#Custom-Bundler-arguments-and-Gemfile-locations):

    language: ruby
    bundler_args: --without development --deployment --jobs=3 --retry=3
    cache: bundler

### CocoaPods

On Objective-C projects, installing dependencies via [CocoaPods](http://cocoapods.org) can take up a good portion of your build. Caching the compiled Pods between builds helps reduce this time.

#### Enabling CocoaPods caching

You can enable CocoaPods caching for your repository by adding this to your
*.travis.yml*:

    language: objective-c
    cache: cocoapods

If you want to enable both Bundler caching and CocoaPods caching, you can list
them both:

    language: objective-c
    cache:
      - bundler
      - cocoapods

Note that CocoaPods caching won't have any effect if you are already vendoring
the Pods directory in your Git repository.

#### Determining the Podfile path

By default, Travis CI will assume that your Podfile is in the root of the
repository. If this is not the case, you can specify where the Podfile is like
this:

    language: objective-c
    podfile: path/to/Podfile

#### With a custom install step

CocoaPods caching will not automatically work if you override the install step.
You can instead use the [arbitrary directory caching
method](#Arbitrary-directories) described below:

    language: objective-c
    install: bundle exec pod install
    cache:
      directories:
        - path/to/Pods

### Arbitrary directories

You can cache arbitrary directories between builds by listing them in your *.travis.yml*:

    cache:
      directories:
        - .autoconf
        - $HOME/.m2

As you can see, it is also possible to use environment variables in the directories.

The logic for fetching and storing the cache is [described below](#Fetching-and-storing-caches).

### Things not to cache

The cache's purpose is to make installing language-specific dependencies easy
and fast, so everything related to tools like Bundler, pip, Composer, npm,
Gradle, Maven, is what should go into the cache.

For other things, the cache won't be an improvement. Installing them usually
takes only short amounts of time, but downloading them will be the same speed
when pulled from the cache as it will be from their original source. You
possibly won't see a speedup putting them into the cache.

Things like:

* Android SDKs
* Debian packages
* JDK packages
* Compiled binaries

Anything that's commonly not changing is better suited for something like our APT
caching proxy. Please shoot us an [email](mailto:support@travis-ci.com) and
we'll see about adding your custom source to our cache.

### Fetching and storing caches

* We fetch the repo's cache on every build, including feature branches and pull requests.
* There is one cache per branch and language version/compiler version/JDK version/Gemfile location/etc.
* If a branch does not have its own cache yet, it will fetch the master branch cache.
* Only modifications made to the cached directories from normal pushes are stored.

Currently Pull Requests will use the cache of the branch they are supposed to be merged into.

### Clearing Caches

Sometimes you spoil your cache by storing bad data in one of the cached directories.

Caches can also become invalid if language runtimes change and the cache contains
native extensions.
(This often manifests as segmentation faults.)

Currently it is not possible to clear the cache via the web interface, but you can use our [command line client](https://github.com/travis-ci/travis#readme) to [clear the cache](https://github.com/travis-ci/travis#cache):

<figure>
  [ ![travis cache --delete](/images/cli-cache.png) ](/images/cli-cache.png)
  <figcaption>Running <tt>travis cache --delete</tt> inside the project directory.</figcaption>
</figure>

There is also a [corresponding API](https://api.travis-ci.com/#/repos/:owner_name/:name/caches) for clearing the cache.

## Caching Ubuntu packages

A network-local APT cache is available, allowing for more reliable download
speeds compared to the Ubuntu mirrors.

To enable APT caching, add the following to your .travis.yml:

    cache: apt

Subsequently, all Ubuntu packages will be downloaded by way of our
cache or added to the cache for future use.

The package repositories are currently limited to a pre-selected set. If you
need to install packages from a repository not available in the list below,
[please shoot us an email](mailto:support@travis-ci.com?subject=Please add this
APT repository), and we'll add it for you.

- ppa.launchpad.net
- apt.postgresql.org
- apt.basho.com
- www.rabbitmq.com
- downloads-distro.mongodb.org
- download.oracle.com
- archive.cloudera.com
- packages.erlang-solutions.com
- repo.varnish-cache.org
- packages.ros.org
- dl.hhvm.com
- dev.mysql.com
- llvm.org
- repo.percona.com
- packages.elasticsearch.org
- debian.neo4j.org
- packages.osrfoundation.org
- dl.google.com

The standard Ubuntu repositories are included by default.

Caching Ubuntu packages will soon be enabled by default, but we're still
beta-testing the new cache until it is.

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

## How does the caching work?

The caching tars up all the directories listed in the configuration and uploads
them to S3, using a secure and protected URL, ensuring security and privacy of
the uploaded archives.

Note that this makes our cache not network-local, it's still bound to network
bandwidth and DNS resolutions for S3. That impacts what you can and should store
in the cache. If you store archives larger than a few hundred megabytes in the
cache, it's unlikely that you'll see a big speed improvement.

Before the build, we check if a cached archive exists. If it does, we pull it
down and unpack it to the specified locations.

After the build we check for changes in the directory, create a new archive and
upload the updated archive back to S3.

The upload is currently part of the build cycle, but we're looking into improving
that to happen outside of the build, giving faster build feedback.
