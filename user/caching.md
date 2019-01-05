---
title: Caching Dependencies and Directories
layout: en

---

<div id="toc"></div>

Travis CI can cache content that does not often change, to speed up your build process.
**To use the caching feature**, in your repository settings, set *Build branch updates* to
*ON*.

* Travis CI fetches the cache for every build, including branches and pull requests.
* If a branch does not have its own cache, Travis CI fetches the cache of the repository's default branch.
* There is one cache per branch and language version/ compiler version/ JDK version/  Gemfile location/ etc.
* Only modifications made to the cached directories from normal pushes are stored.

> Please note that cache content is available to any build on the repository, including Pull Requests, so make sure you do not put any sensitive information in the cache.

> When creating the cache, symbolic links are not followed.
> Consider caching the normal files and directories instead.

## Caching directories (Bundler, dependencies)

Caches lets Travis CI store directories between builds, which is useful for storing
dependencies that take longer to compile or download.

Note that if a third party project, such as Bundler, changes the location where they store dependencies you might need to specify the [directory manually](#Arbitrary-directories) instead of using that particular [caching shortcut](#Bundler). Please [contact us](mailto:support@travis-ci.com?subject=Caching) with any questions, issues or feedback.

### Build phases

Travis CI uploads the cache after the `script` phase of the build, but before
either `after_success` or `after_failure`.

> Failure to upload the cache does *not* mark the job as failed.

### Bundler

On Ruby and Objective-C projects, installing dependencies via [Bundler](http://bundler.io/) can make up a large portion of the build duration. Caching the bundle between builds drastically reduces the time a build takes to run.

#### Enabling Bundler caching

To enable Bundler caching in your `.travis.yml`:

```yaml
language: ruby
cache: bundler
```
{: data-file=".travis.yml"}

Whenever you update your bundle, Travis CI will also update the cache.

#### Determining the bundle path

Travis CI tries its best at determining the path bundler uses for storing dependencies.

If you have [custom Bundler arguments](/user/languages/ruby/#Custom-Bundler-arguments-and-Gemfile-locations), and these include the `--path` option, Travis CI will use that path. If `--path` is missing but `--deployment` is present, it will use `vendor/bundle`.

Otherwise it will automatically add the `--path` option. In this case it will either use the value of the environment variable `BUNDLE_PATH` or, if it is missing, `vendor/bundle`.

#### Caching and overriding `install` step

Overriding the `install` step may cause the directive `cache: bundler` to miss the directory.
In this case, observe where Bundler is installing the gems, and cache that directory using
[cache.directories](#Arbitrary-directories).

#### Cleaning up bundle

When you use

```yaml
cache: bundler
```
{: data-file=".travis.yml"}

The command `bundle clean` is executed before the cache is uploaded.

In the cases where this is not desirable, you can use specify the [arbitrary directories](#Arbitrary-directories)
to get around it.
See [this GitHub issue](https://github.com/travis-ci/travis-ci/issues/2518) for more information.

### cache RVM Ruby version for non Ruby projects

There are projects using machines not based on Ruby but having some Ruby executions. For example, a NodeJS application that has a Ruby functional test suite.

For these cases installing a version of ruby with `rvm install 2.3.1` may take more than 3 minutes. For these cases you can cache the ruby installation.

```yaml
 cache:
    directories:
     - /home/travis/.rvm/
```

### CocoaPods

On Objective-C projects, installing dependencies via [CocoaPods](http://cocoapods.org) can take up a good portion of your build. Caching the compiled Pods between builds helps reduce this time.

#### Enabling CocoaPods caching

You can enable CocoaPods caching for your repository by adding this to your
*.travis.yml*:

```yaml
language: objective-c
cache: cocoapods
```
{: data-file=".travis.yml"}

If you want to enable both Bundler caching and CocoaPods caching, you can list
them both:

```yaml
language: objective-c
cache:
  - bundler
  - cocoapods
```
{: data-file=".travis.yml"}

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
{: data-file=".travis.yml"}

### yarn cache

For caching with `yarn`, use:

```yaml
language: node_js

node_js: '6' # or another

cache: yarn
```
{: data-file=".travis.yml"}

This caches `$HOME/.cache/yarn`.

### pip cache

For caching `pip` files, use:

```yaml
language: python

cache: pip
```
{: data-file=".travis.yml"}

caches `$HOME/.cache/pip`.

### ccache cache

If you are using `ccache`, use:

```yaml
language: c # or other C/C++ variants

cache: ccache
```
{: data-file=".travis.yml"}

to cache `$HOME/.ccache` and automatically add `/usr/lib/ccache` to your `$PATH`.

#### ccache on OS X

ccache is not installed on OS X environments but you can install it by adding

```yaml
install:
  - brew install ccache
  - export PATH="/usr/local/opt/ccache/libexec:$PATH"
```
{: data-file=".travis.yml"}

> Note that this creates wrappers around your default gcc and g++ compilers.

### R package cache

For caching R packages, use:

```yaml
language: R

cache: packages
```
{: data-file=".travis.yml"}

This caches `$HOME/R/Library`, and sets `R_LIB_USER=$HOME/R/Library` environment variable.

### Rust Cargo cache

For caching Cargo packages, use:

```yaml
language: rust

cache: cargo
```
{: data-file=".travis.yml"}

This caches `$HOME/.cargo` and `$TRAVIS_BUILD_DIR/target`.

### Arbitrary directories

You can cache arbitrary directories, such as Gradle, Maven, Composer and npm cache directories, between builds by listing them in your `.travis.yml`:

```yaml
cache:
  directories:
  - .autoconf
  - $HOME/.m2
```
{: data-file=".travis.yml"}

As you can see, you can use environment variables as part of the directory path.  After possible variable expansion, paths that

- do **not** start with a `/` are relative to `$TRAVIS_BUILD_DIR`.
- start with a `/` are absolute.

Please be aware that the `travis` user needs to have write permissions to this directory.

## Things not to cache

The cache's purpose is to make installing language-specific dependencies easy
and fast, so everything related to tools like Bundler, pip, Composer, npm,
Gradle, Maven, is what should go into the cache.

Large files that are quick to install but slow to download do not benefit from caching, as they take as long to download from the cache as from the original source:

- Android SDKs
- Debian packages
- JDK packages
- Compiled binaries
- Docker images

Docker images are not cached, because we provision a brand new virtual machine for every build.

## Fetching and storing caches

- Travis CI fetches the cache for every build, including branches and pull requests.
- There is one cache per branch and language version / compiler version / JDK version / Gemfile location, etc.
- If a branch does not have its own cache, Travis CI fetches the default branch cache.
- Only modifications made to the cached directories from normal pushes are stored.

### Pull request builds and caches

Pull request builds check the following cache locations in order, using the first one present:

- The pull request cache.
- The pull request target branch cache.
- The repository default branch cache.

If none of the previous locations contain a valid cache, the build continues without a cache.

After the first pull request build is run, it creates a new pull request cache.

Some important things to note about caching for pull requests:

* If a repository has *Build branch updates* set to *OFF*, neither the target branch nor the master branch can ever be cached.
* If the cache on the master branch is old, for example in a workflow where most work happens on branches, the less useful the cache will be.
* If a pull request is using a cache but you don't want it to, you need to clear **both** the pull request cache **and** the cache of the target branch.

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
{: data-file=".travis.yml"}

Failure in this phase does not mark the job as failed.

### Clearing Caches

Sometimes you spoil your cache by storing bad data in one of the cached directories, or your cache can become invalid when language runtimes change.

Use one of the following ways to access your cache and delete it if necessary:

- The settings page of your repository on <https://travis-ci.com>

    ![Image of cache UI](/images/caches-item.png)

- The [command line client](https://github.com/travis-ci/travis#readme)

    ![travis cache --delete](/images/cli-cache.png)

- The [API](https://api.travis-ci.com/#/repos/:owner_name/:name/caches)

## Configuration

### Enabling multiple caching features

When you want to enable multiple caching features and the language supports them, you can list them as an array:

```yaml
language: objective-c
cache:
- bundler
- cocoapods
```
{: data-file=".travis.yml"}

This does not work when caching [arbitrary directories](#Arbitrary-directories),
or when any of the directives is not supported by the language.

If you want to combine that with other caching modes, use a hash map.
Here is an example of a Ruby repository caching Node.js modules:

```yaml
language: ruby
cache:
  bundler: true
  directories:
  - node_modules # NPM packages
```
{: data-file=".travis.yml"}

This is another example; a Rust repository caching cargo and Ruby gems:

```yaml
language: rust
cache:
  cargo: true
  directories:
    - vendor/bundle
install:
  - bundle install --deployment # to cache vendor/bundle
```
{: data-file=".travis.yml"}

### Explicitly disabling caching

You can explicitly disable all caching by setting the `cache` option to `false` in your *.travis.yml*:

```yaml
cache: false
```
{: data-file=".travis.yml"}

It is also possible to disable a single caching mode:

```yaml
language: objective-c
cache:
  bundler: false
  cocoapods: true
```
{: data-file=".travis.yml"}

### Setting the timeout

Caching has a timeout set to 3 minutes by default. The timeout is there in order
to guard against any issues that may result in a stuck build. Such issues may be
caused by a network issue between worker servers and S3 or even by a cache being
too big to pack and upload in timely fashion. There are, however,
situations when you might want to set a bigger timeout, especially if you need
to cache a large amount. In order to change the timeout you can use the `timeout`
property with a desired time in seconds:

```yaml
cache:
  timeout: 1000
```
{: data-file=".travis.yml"}

## Caches and build matrices

When you have multiple jobs in a [build matrix](/user/customizing-the-build/#Build-Matrix),
some characteristics of each job are used to identify the cache each of the
jobs should use.

These factors are:

1. OS name (currently, `linux` or `osx`)
2. OS distribution (for Linux, `precise` or `trusty`)
3. OS X image name (e.g., `xcode7.2`)
4. Names and values of visible environment variables set in `.travis.yml` or Settings panel
5. Language runtime version (for the language specified in the `language` key) if applicable
6. For Bundler-aware jobs, the name of the `Gemfile` used

If these characteristics are shared by more than one job in a build matrix,
they will share the same URL on the network.
This could corrupt the cache, or the cache may contain files that are not
usable in all jobs using it.
In this case, we advise you to add a defining public environment variable
name; e.g.,

```
CACHE_NAME=JOB1
```

to `.travis.yml`.

Note that when considering environment variables, the values must match *exactly*,
including spaces.
For example, with

```yaml
env:
  - FOO=1 BAR=2
  - FOO=1  BAR=2
  - BAR=2 FOO=1
```

each of the three jobs will use its own cache.

## Caches and read permissions

When caching [custom files and directories](/user/caching/#Arbitrary-directories),
ensure that the locations you specify are readable and writable by the user.

If they are not, the caching utility reports errors when it
invokes `tar` to create the cache archive.

For example:

```
FAILED: tar -Pzcf /Users/travis/.casher/push.tgz /path/to/unreadable/directory

tar: /path/to/unreadable/directory: Cannot stat: No such file or directory
```

## How does caching work?

Travis CI saves an archive of all the directories listed in the configuration and uploads
it to a storage provider, using a secure and protected URL, ensuring security and privacy of
the uploaded archives.

Note that this makes our cache not network-local, it is still bound to network
bandwidth and DNS resolutions. That impacts what you can and should store
in the cache. If you store archives larger than a few hundred megabytes in the
cache, it is unlikely that you'll see a big speed improvement.

Before the build, we check if a cached archive exists. If it does, we download it and unpack it to the specified locations.

After the build we check for changes in the directory, create a new archive with those changes, and upload it to the remote storage.

The upload is currently part of the build cycle, but we're looking into improving
that to happen outside of the build, giving faster build feedback.
