---
title: Caching Dependencies and Directories
layout: en
permalink: /user/caching/
---

These features are also still experimental, please [contact us](mailto:support@travis-ci.com?subject=Caching) with any questions, issues and feedback.

<div id="toc"></div>

## Cache content can be accessed by pull requests

Do note that cache content will be available to any build on the repository, including Pull Requests.
Do exercise caution not to put any sensitive information in the cache, lest a malicious attacker potentially exposes it.

## Caching directories (Bundler, dependencies)

With caches, Travis CI can persist directories between builds. This is especially useful for dependencies that need to be downloaded and/or compiled from source.

### Build phases

Travis CI attempts to upload cache after `script`, but before either `after_success` or `after_failure` is
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
For caching R packages, use:

```yaml
language: R

cache: packages
```

This caches `$HOME/R/Library`, and sets `R_LIB_USER=$HOME/R/Library` environment variable.

### Rust Cargo cache
For caching Cargo packages, use:

```yaml
language: rust

cache: cargo
```

This caches `$HOME/.cargo` and `$TRAVIS_BUILD_DIR/target`.

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

Large files that are quick to install but slow to download do not benefit from caching, as they take as long to download from the cache as from the original source:

* Android SDKs
* Debian packages
* JDK packages
* Compiled binaries

## Fetching and storing caches

* Travis CI fetches the cache for every build, including branches and pull requests.
* There is one cache per branch and language version/ compiler version/ JDK version/  Gemfile location/ etc.
* If a branch does not have its own cache, Travis CI fetches the master branch cache.
* Only modifications made to the cached directories from normal pushes are stored.

### Pull request builds and caches

Pull request builds check the following cache locations in order, using the first one present:

* The pull request cache.
* The pull request target branch cache.
* The repository default branch cache.

If none of the previous locations contain a valid cache, the build creates a new pull request cache after the build.

> Note that if a repository has "build pushes" set to "off", neither the target branch nor the master branch can ever be cached.

### before_cache phase

When using caches, it may be useful to run a command just before uploading
the new cache archive.

For example, the dependency management utility may write log files into the directory you are caching and you do not want them to affect the cache. Use the `before_cache` phase to delete the log files:

```yaml
cache:
  directories:
    - $HOME/.cache/pip
before_cache:
  - rm -f $HOME/.cache/pip/log/debug.log
```

Failure in this phase does not mark the job as failed.

### Clearing Caches

Sometimes you spoil your cache by storing bad data in one of the cached directories, or your cache can become invalid when language runtimes change.

Use one of the following ways to access your cache and delete it if necessary:

* The settings page of your repository on [https://travis-ci.org](https://travis-ci.org) (or .com if you're using a private repository)

    ![Image of cache UI](/images/caches-item.png)

* The [command line client](https://github.com/travis-ci/travis#readme)

  [ ![travis cache --delete](/images/cli-cache.png) ](/images/cli-cache.png)
  <figcaption>Running <tt>travis cache --delete</tt> inside the project directory.</figcaption>

* The [API](https://api.travis-ci.com/#/repos/:owner_name/:name/caches)

## Configuration

### Enabling multiple caching features

When you want to enable multiple caching features, you can list them as an array:

```yaml
cache:
- bundler
- pip
```

This does not work when caching [arbitrary directories](#Arbitrary-directories). If you want to combine that with other caching modes, you will have to use a hash map:

```yaml
cache:
  bundler: true
  directories:
  - node_modules # NPM packages
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
  pip: true
```

### Setting the timeout

Caching has a timeout set to 3 minutes by default. The timeout is there in order
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

## Caches and build matrices

When you have multiple jobs in a [build matrix](/user/customizing-the-build/#Build-Matrix),
some characteristics of each job are used to identify the cache each of the
jobs should use.

These factors are:

1. OS name (currently, `linux` or `osx`)
1. OS distribution (for Linux, `precise` or `trusty`)
1. OS X image name (e.g., `xcode7.2`)
1. Names and values of visible environment variables set in `.travis.yml` or Settings panel
1. Language runtime version (for the language specified in the `language` key) if applicable
1. For Bundler-aware jobs, the name of the `Gemfile` used

If these characteristics are shared by more than one job in a build matrix,
they will share the same URL on the network.
This could corrupt the cache, or the cache may contain files that are not
usable in all jobs using it.
In this case, we advise you to add a defining public environment variable
name; e.g.,

    CACHE_NAME=JOB1

to `.travis.yml`.

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
