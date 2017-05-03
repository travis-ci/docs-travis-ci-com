---
title: Building a Ruby Project
layout: en
permalink: /user/languages/ruby/
---

<div id="toc">
</div>

## What This Guide Covers

This guide covers build environment and configuration topics specific to Ruby
projects. Please make sure to read our [Getting
Started](/user/getting-started/) and [general build
configuration](/user/customizing-the-build/) guides first.

## Supported Ruby Versions and RVM

The Ruby VM provides recent versions of:

- Ruby: 2.2.0, 2.1.x, 2.0.0, 1.9.3, 1.9.2 and 1.8.7
- JRuby: 1.7.x (1.8 and 1.9 mode)
- Ruby Enterprise Edition: 1.8.7 2012.02

Pre-compiled versions are downloaded on demand from our [Ruby version cache](http://rubies.travis-ci.org).

Pre-compiled Rubinius versions are downloaded on demand from [binaries.rubini.us](http://rubies.travis-ci.org/rubinius). Older versions of
Ruby and JRuby are made available by [RVM](https://rvm.io/binaries/) and the [JRuby team](http://www.jruby.org/download).

Rubinius [no longer supports Precise](https://github.com/rubinius/rubinius/issues/3717).
Please use Trusty.

For exact version information, consult the "Build system information" section of
the build log.

### Choosing Ruby versions and implementations to test against

The Ruby environment on Travis CI uses [RVM](https://rvm.io/) to provide many
Ruby implementations and versions your projects can be tested against.

To specify them, use `rvm:` key in your `.travis.yml` file, for example:

```yaml
language: ruby
rvm:
  - 2.2
  - jruby
```

> Note that the `rvm:` key is only available in Ruby Build Environments, not in other
> images containing a ruby implementation.

As we upgrade both RVM and Rubies, aliases like `2.2` or `jruby` point to different exact versions, patch levels and so on.

For a full up-to-date list of provided Rubies, see our [CI
environment guide](/user/ci-environment/).

If you don't specify a version, Travis CI will use MRI 1.9.3 as the default.


### Using `.ruby-version`

If the ruby version is not specified by the `rvm` key as described above, Travis CI
will consult `.ruby-version` in the root of the repository and use the indicated
Ruby runtime.

### Choosing Rubies that aren't installed

While we pre-install some Rubies, you can install other versions by way of RVM's
binary installation feature.

As long as they're available as a binary for Ubuntu 12.04, you can specify
custom patchlevels.

```yaml
language: ruby
rvm:
  - 2.0.0-p247
```

Note that this binds you to potentially unsupported releases of Rubies. It also
extends your build time as downloading and installing a custom Ruby can add an
extra 60 seconds or more to your build.

### Rubinius

[Rubinius](http://rubini.us) releases frequent updates.
To test with Rubinius, add `rbx-X.Y.Z` to your `.travis.yml`, where X.Y.Z
specifies a Rubinius release.
Consult [http://rubies.travis-ci.org/rubinius](http://rubies.travis-ci.org/rubinius)
for the list of available releases.

Rubinius does not support Precise. Please use Trusty instead.

```yaml
language: ruby

dist: trusty

rvm:
  - rbx-3.69
```

Note that the syntax of `rbx-19mode` is not supported anymore.

Rubinius will be installed via a download currently.

### JRuby: C extensions are not supported

Please note that **C extensions are not supported in JRuby** on Travis CI. The
reason for doing so is to bring it to developers attention that their project
may have dependencies that should not be used on JRuby in production. Using C
extensions on JRuby is technically possible but is not a good idea performance
and stability-wise and we believe continuous integration services like Travis
CI should highlight it.

So if you want to run CI against JRuby, please check that your Gemfile takes
JRuby into account. Most of popular C extensions these days also have Java
implementations (json gem, nokogiri, eventmachine, bson gem) or Java
alternatives (like JDBC-based drivers for MySQL, PostgreSQL and so on).

### JRuby: Installation takes a long time on Standard and Trusty environments

In the [Standard and Trusty
environments](https://docs.travis-ci.com/user/ci-environment/#Virtualization-environments),
installing JRuby can take several minutes.
This is due to the lack of entropy in the build VM, which can be
eradicated by installing an entropy daemon such as
[HAVEGED](http://www.issihosts.com/haveged/).

You can use [the `apt`
addon](https://docs.travis-ci.com/user/installing-dependencies#Installing-Packages-with-the-APT-Addon)
as follows:

    language: ruby
    rvm: jruby-9.1.5.0
    sudo: required
    dist: trusty
    addons:
      apt:
        packages:
          - haveged

## Default Test Script

Travis CI runs `rake` by default to execute your tests. Please note that **you
need to add rake to your Gemfile** (adding it to the `:test` group should
be sufficient).

## Dependency Management

### Travis CI uses Bundler

Travis CI uses [Bundler](http://bundler.io/) to install your project's
dependencies.

The default command run by Travis CI is:

```bash
bundle install --jobs=3 --retry=3
```

Note that this is only run when we detect a Gemfile in the project's root
directory, or if the Gemfile specified via the build matrix exists.

If a Gemfile.lock exists in your project's root directory, we add the
`--deployment` flag.

If you want to use a different means of handling your Ruby project's
dependencies, you can override the `install` command.

```yaml
install: gem install rails
```

By default, gems are installed into vendor/bundle in your project's root
directory.

### Caching Bundler

Bundler installation can take a while, slowing down your build. You can tell
[Travis CI to cache the installed bundle](/user/caching/).

On your first build, we warm the cache. On the second one, we'll pull in the
cache, making `bundle install` only take seconds to run.

Note that this feature is currently only available for private projects.

### Speeding up your build by excluding non-essential dependencies

Lots of project include libraries like `ruby-debug`, `unicorn` or `newrelic_rpm`
in their default set of gems.

This slows down the installation process quite a lot, and commonly, those
libraries aren't needed when running your tests. This also includes libraries
that compile native code, slowing down the installation and overall test times
even more.

On top of that, libraries that implicitly pull in `ruby_core_source` or
`linecache19`, are bound to fail when Travis CI upgrades Ruby versions and
patchlevels.

The same is true for gems that you only need in production, like Unicorn, the
New Relic library, and the like.

You can speed up your installation process by moving these libraries to a
separate section in your Gemfile, e.g. `production`:

```
group :production do
  gem 'unicorn'
  gem 'newrelic_rpm'
end
```

Adjust your Bundler arguments to explicitly exclude this group:

```yaml
bundler_args: --without production
```

Enjoy a faster build, which is also less prone to compilation problems.

### Custom Bundler arguments and Gemfile locations

You can specify a custom Gemfile name:

```yaml
gemfile: gemfiles/Gemfile.ci
```

Unless specified, the worker will look for a file named "Gemfile" in the root of
your project.

You can also set [extra arguments](http://bundler.io/v1.3/man/bundle-install.1.html)
extra arguments to be passed to `bundle install`:

```yaml
bundler_args: --binstubs
```

You can also define a script to be run before 'bundle install':

```yaml
before_install: some_command
```

For example, to install and use the pre-release version of bundler:

```yaml
before_install: gem install bundler --pre
```

### Testing against multiple versions of dependencies

Many projects need to be tested against multiple versions of Rack, EventMachine,
HAML, Sinatra, Ruby on Rails,etc.

To test against multiple versions of dependencies:

1. Create a directory in your project's repository root where you will keep
   gemfiles (./gemfiles is a commonly used name)
2. Add one or more gemfiles to it
3. Instruct Travis CI to use those gemfiles using the *gemfile* option in your
   .travis.yml

For example, amqp gem is [tested against EventMachine 0.12.x and 1.0
pre-releases](https://github.com/ruby-amqp/amqp/blob/master/.travis.yml):

```yaml
gemfile:
  - Gemfile
  - gemfiles/eventmachine-pre
```

Thoughtbot's Paperclip is [tested against multiple ActiveRecord
versions](https://github.com/thoughtbot/paperclip/blob/master/.travis.yml):

```yaml
gemfile:
  - gemfiles/rails2.gemfile
  - gemfiles/rails3.gemfile
  - gemfiles/rails3_1.gemfile
```

An alternative to this is to use environment variables and make your test runner
use them. For example, [Sinatra is tested against multiple Tilt and Rack
versions](https://github.com/sinatra/sinatra/blob/master/.travis.yml):

```yaml
env:
  - "rack=1.3.4"
  - "rack=master"
  - "tilt=1.3.3"
  - "tilt=master"
```

ChefSpec is [tested against multiple Opscode Chef
versions](https://github.com/acrmp/chefspec/blob/master/.travis.yml):

```yaml
env:
  - CHEF_VERSION=0.9.18
  - CHEF_VERSION=0.10.2
  - CHEF_VERSION=0.10.4
```

The same technique is often applied to test against multiple databases, templating
engines, hosted service providers and so on.

### `$BUNDLE_GEMFILE` environment variable

When `gemfile` is thus defined *and* the file exists in the repository,
we define the environment variable `$BUNDLE_GEMFILE`, which `bundle install`
uses to resolve dependencies.

If you need to work with multiple Gemfiles within a single job, you would
need to override `$BUNDLE_GEMFILE` by passing `--gemfile=` flag:

```bash
bundle install --gemfile=my_gemfile
```

## Testing against multiple JDKs (JRuby)

It is possible to test projects against multiple JDKs, namely

- OpenJDK 7
- Oracle JDK 7
- Oracle JDK 8
- OpenJDK 6

To do so, use the `jdk` key in your `.travis.yml`, for example:

```yaml
jdk:
  - oraclejdk7
  - openjdk7
```

or all 4:

```yaml
jdk:
  - openjdk7
  - oraclejdk7
  - oraclejdk8
  - openjdk6
```

Each JDK you test against will create permutations with all other
configurations, so to avoid running tests for, say, CRuby 1.9.3 multiple times
you need to add some matrix excludes (described in our general [Build
Configuration guide](/user/customizing-the-build/)):

```yaml
language: ruby
rvm:
  - 1.9.2
  - jruby-18mode
  - jruby-19mode
  - jruby-head
jdk:
  - openjdk6
  - openjdk7
  - oraclejdk7
matrix:
  exclude:
    - rvm: 1.9.2
      jdk: openjdk6
    - rvm: 1.9.2
      jdk: openjdk7
    - rvm: 1.9.2
      jdk: oraclejdk7
```

For example, see
[travis-support](https://github.com/travis-ci/travis-support/blob/master/.travis.yml).

## Upgrading RubyGems

The RubyGems version installed on Travis CI's Ruby environment depends on what's
installed by the newest Bundler/RubyGems combination.

We try to keep it as up-to-date as possible.

Should you require the latest version of RubyGems, you can add the following to
your .travis.yml:

```yaml
before_install:
  - gem update --system
  - gem --version
```

If you need to downgrade to a specific version, you can use the following steps:

```yaml
before_install:
  - gem update --system 2.1.11
  - gem --version
```

Note that this will impact your overall test time, as additional network
downloads and installations are required.

## Build Matrix

For Ruby projects, `env`, `rvm`, `gemfile`, and `jdk` can be given as arrays to
construct a build matrix.
