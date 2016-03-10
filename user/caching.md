---
title: Caching Dependencies and Directories
layout: en
permalink: /user/caching/
---

The features described here are currently **only available for private repositories on [travis-ci.com](https://travis-ci.com) and our new [container-based infrastructure](http://docs.travis-ci.com/user/workers/container-based-infrastructure/)**.

Note that [APT caching](#Caching-Ubuntu-packages) is not available for the container-based infrastructure.

These features are also still experimental, please [contact us](mailto:support@travis-ci.com?subject=Caching) with any questions, issues and feedback.

<div id="toc"></div>

## Cache content can be accessed by pull requests

Do note that cache content will be available to any build on the repository, including Pull Requests.
Do exercise caution not to put any sensitive information in the cache, lest malicious attacker may expose it.

## Caching directories (Bundler, dependencies)

With caches, Travis CI can persist directories between builds. This is especially useful for dependencies that need to be downloaded and/or compiled from source.

### Build phases

Travis CI attempts to upload cache after the script, but before either `after_success` or `after_failure` is
run.
Note that the failure to upload the cache does not mark the job a failure.

### Bundler

On Ruby and Objective-C projects, installing dependencies via [Bundler](http://bundler.io/) can make up a large portion of the build duration. Caching the bundle between builds drastically reduces the time a build takes to run.

The logic for fetching and storing the cache is [described below](#Fetching-and-storing-caches).

#### Enabling Bundler caching

<s>Bundler caching is automatically enabled for Ruby projects that include a Gemfile.lock.</s> *(Bundler caching is [not yet](https://github.com/travis-ci/travis-build/pull/148) enabled automatically)*

You can explicitly enable Bundler caching in your *.travis.yml*:

```yaml
language: ruby
cache: bundler
```

Whenever you update your bundle, Travis CI will also update the cache.

#### Determining the bundle path

Travis CI tries its best at determining the path bundler uses for storing dependencies.

If you have [custom Bundler arguments](/user/languages/ruby/#Custom-Bundler-arguments-and-Gemfile-locations), and these include the *--path* option, Travis CI will use that path. If *--path* is missing but *--deployment* is present, it will use *vendor/bundle*.

Otherwise it will automatically add the *--path* option. In this case it will either use the value of the environment variable *BUNDLE_PATH* or, if it is missing, *vendor/bundle*.

### CocoaPods

On Objective-C projects, installing dependencies via [CocoaPods](http://cocoapods.org) can take up a good portion of your build. Caching the compiled Pods between builds helps reduce this time.

#### Enabling CocoaPods caching

You can enable CocoaPods caching for your repository by adding this to your
*.travis.yml*:

```yaml
language: objective-c
cache: cocoapods
```

If you want to enable both Bundler caching and CocoaPods caching, you can list
them both:

```yaml
language: objective-c
cache:
  - bundler
  - cocoapods
```

Note that CocoaPods caching won't have any effect if you are already vendoring
the Pods directory in your Git repository.

#### Determining the Podfile path

By default, Travis CI will assume that your Podfile is in the root of the
repository. If this is not the case, you can specify where the Podfile is like
this:

```yaml
language: objective-c
podfile: path/to/Podfile
```

### pip cache

For caching `pip` files, use:

```yaml
language: python

cache: pip
```

caches `$HOME/.cache/pip`.


### ccache cache

For caching `ccache` files, use:

```yaml
language: c # or other C/C++ variants

cache: ccache
```

caches `$HOME/.ccache`, and adds `/usr/lib/ccache` to the front of `$PATH`.


### R package cache
For caching R pacakges, use:

```yaml
language: R

cache: packages
```

This caches `$HOME/R/Library`, and sets `R_LIB_USER=$HOME/R/Library` environment variable.

### Arbitrary directories

You can cache arbitrary directories, such as Gradle, Maven, Composer and npm cache directories, between builds by listing them in your `.travis.yml`:

```yaml
cache:
  directories:
  - .autoconf
  - $HOME/.m2
```

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

* Travis CI fetches the cache for every build, including feature branches and pull requests.
* There is one cache per branch and language version/ compiler version/ JDK version/  Gemfile location/ etc.
* Pull requests use the cache of the target of the pull request.
* If a branch does not have its own cache yet, it uses the master branch cache (unless it is a pull request, see above).
* Only modifications made to the cached directories from normal pushes are stored.

### `before_cache` phase

When using caches, it may be useful to run command just prior to uploading
the new cache archive.
For example, the dependency management utility may write log files into the directory
you are watching, and you would do well to ignore these.

For this purpose, you can use `before_cache` phase.

```yaml
cache:
  directories:
    - $HOME/.cache/pip
⋮
before_cache:
  - rm -f $HOME/.cache/pip/log/debug.log
```

Failures in this stage does not mark the job a failure.

### Clearing Caches

Sometimes you spoil your cache by storing bad data in one of the cached directories.

Caches can also become invalid if language runtimes change and the cache contains
native extensions.
(This often manifests as segmentation faults.)

You can access caches in one of the two ways.
Each method also gives you a means of deleting caches.

1. On the web https://travis-ci.com/OWNER/REPOSITORY/caches for private repositories
or https://travis-ci.org/OWNER/REPOSITORY/caches for public repositories,
which is accessible from the Settings
menu

    ![Image of cache UI](/images/caches-item.png)

2. With [command line client](https://github.com/travis-ci/travis#readme):

  [ ![travis cache --delete](/images/cli-cache.png) ](/images/cli-cache.png)
  <figcaption>Running <tt>travis cache --delete</tt> inside the project directory.</figcaption>

There is also a [corresponding API](https://api.travis-ci.com/#/repos/:owner_name/:name/caches) for clearing the cache.

## Caching Ubuntu packages

<div class="note-box">
This feature is available only for private repositories.
</div>

A network-local APT cache is available, allowing for more reliable download
speeds compared to the Ubuntu mirrors.

To enable APT caching, add the following to your .travis.yml:

```yaml
cache: apt
```

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

```yaml
cache:
- bundler
- apt
```

This does not when caching [arbitrary directories](#Arbitrary-directories). If you want to combine that with other caching modes, you will have to use a hash map:

```yaml
cache:
  bundler: true
  directories:
  - vendor/something
  - .autoconf
```

### Explicitly disabling caching

You can explicitly disable all caching by setting the `cache` option to `false` in your *.travis.yml*:

```yaml
cache: false
```

It is also possible to disable a single caching mode:

```yaml
cache:
  bundler: false
  apt: true
```

### Setting the timeout

Caching has a timeout set to 5 minutes by default. The timeout is there in order
to guard against any issues that may result in a stuck build. Such issues may be
caused by a network issue between worker servers and S3 or even by a cache being
to big to pack it and upload it in timely fashion. There are, however,
situations when you might want to set a bigger timeout, especially if you need
to cache large amount. In order to change the timeout you can use the `timeout`
property with a desired time in seconds:

```yaml
cache:
  timeout: 1000
```

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
