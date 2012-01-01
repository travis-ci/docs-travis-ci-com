---
title: Building a Ruby Project
kind: content
---

## What This Guide Covers

This guide covers build environment and configuration topics specific to Ruby projects. Please make sure to read our [general build configuration guide](/docs/user/build-configuration/) first.

## Choosing Ruby versions/implementations to test against

Ruby workers on travis-ci.org use [RVM](https://rvm.beginrescueend.com/) to provide many Ruby versions/implementations your projects can be tested against.
To specify them, use `rvm:` key in your `.travis.yml` file, for example:

    language: ruby
    rvm:
      - 1.8.7
      - 1.9.2
      - 1.9.3
      - jruby
      - rbx-18mode

A more extensive example:

    language: ruby
    rvm:
      - 1.8.7
      - 1.9.2
      - 1.9.3
      - jruby
      - rbx-18mode
      - rbx-19mode
      - ruby-head
      - ree


As time goes, new releases come out and we upgrade both RVM and Rubies, aliases like `1.9.3` or `jruby` will float and point to different
exact versions, patch levels and so on. For full up-to-date list of provided Rubies, see our [CI environment guide](/docs/user/ci-environment/).



### Rubinius: 1.8 and 1.9 modes, periodic upgrades

travis-ci.org Ruby workers have two installations of Rubinius, in 1.8 and 1.9 modes, respectively. Their RVM alias names are

      - rbx-18mode
      - rbx-19mode

Both are built from the [2.0.testing branch](https://github.com/rubinius/rubinius/tree/2.0.testing) Rubinius team updates for us when they feel master becomes stable enough. This means that
typically Rubinius is upgraded every 1-3 weeks.


### C extensions support is disabled for JRuby

Please note that **C extensions are disabled for JRuby** on travis-ci.org. The reason for doing so is to bring it to developers attention
that their project may have dependencies that should not be used on JRuby in production. Using C extensions on JRuby is technically possible
but is not a good idea performance and stability-wise and we believe continuous integration services like Travis should highlight it.

So if you want to run CI against JRuby, please check that your Gemfile takes JRuby into account. Most of popular C extensions these days also have Java implementations
(jsom gem, nokogiri, eventmachine, bson gem) or Java alternatives (like JDBC-based drivers for MySQL, PostgreSQL and so on).




## Default Test Script

Travis will use [Bundler](http://gembundler.com/) to install your project's dependencies and run `rake` by default to execute your tests.
Pleasen note that **you need to add rake to your Gemfile** (adding it to just `:test` group should be sufficient).


## Dependency Management

### Travis uses Bundler

Travis uses [Bundler](http://gembundler.com/) to install your project's dependencies. It is possible to override this behavior and there are project
that use RVM gemset import feature but the majority of Ruby projects hosted on Travis use Bundler.


### Exclude non-essential gems like ruby-debug from your Gemfile

We ask Ruby project maintainers to exclude ruby-debug from being installed on travis-ci.org. Consider the following:
a project that installs ruby-debug, tests against 6 Ruby versions/implementations and does 3 pushes a day. Given that
linecache, one of the ruby-debug dependencies, takes 2 minutes to install in our CI VMs, this results in

    3 * 6 * 2 = 36 minutes of time per day per project

And, of course, nobody will really use ruby-debug in CI environments. To exlude ruby-debug and other gems that are
non-essential for your test suite, move them to a separate gem group (for example, :development) and [exclude it
using *bundler_args* in your .travis.yml](https://github.com/ruby-amqp/amqp/blob/master/.travis.yml#L2) like [amqp gem](https://github.com/ruby-amqp/amqp) does.

Time is better spent testing your project against more Ruby versions/implementations and more versions of libraries you depend on than
compiling linecache over and over.


### Custom Bundler arguments and Gemfile locations

You can specify a custom Gemfile name:

    gemfile: gemfiles/Gemfile.ci

Unless specified, the worker will look for a file named "Gemfile" in the root of your project.

You can also set <a href="http://gembundler.com/man/bundle-install.1.html">extra arguments</a> to be passed to `bundle install`:

    bundler_args: --binstubs


You can also define a script to be run before 'bundle install':

    before_install: some_command

For example, to install and use the pre-release version of bundler:

    before_install: gem install bundler --pre



### Testing against multiple versions of dependencies (Ruby on Rails, EventMachine, etc)

Many projects need to be tested against multiple versions of Rack, EventMachine, HAML, Sinatra, Ruby on Rails, you name it. It is easy
with Travis CI. What you have to do is this:

 * Create a directory in your project's repository root where you will keep gemfiles (./gemfiles is a commonly used name)
 * Add one or more gemfiles to it
 * Instruct Travis CI to use those gemfiles using the *gemfile* option in your .travis.yml

For example, amqp gem is [tested against EventMachine 0.12.x and 1.0 pre-releases](https://github.com/ruby-amqp/amqp/blob/master/.travis.yml):

    gemfile:
      - Gemfile
      - gemfiles/eventmachine-pre

Thoughtbot's Paperclip is [tested against multiple ActiveRecord versions](https://github.com/thoughtbot/paperclip/blob/master/.travis.yml):

    gemfile:
      - gemfiles/rails2.gemfile
      - gemfiles/rails3.gemfile
      - gemfiles/rails3_1.gemfile

An alternative to this is to use environment variables and make your test runner use them. For example, [Sinatra is tested against multiple
Tilt and Rack versions](https://github.com/sinatra/sinatra/blob/master/.travis.yml):

    env:
      - "rack=1.3.4"
      - "rack=master"
      - "tilt=1.3.3"
      - "tilt=master"

ChefSpec is [tested against multiple Opscode Chef versions](https://github.com/acrmp/chefspec/blob/master/.travis.yml):

    env:
      - CHEF_VERSION=0.9.18
      - CHEF_VERSION=0.10.2
      - CHEF_VERSION=0.10.4

Same technique is often applied to test against multiple databases, templating engines, [hosted] service providers and so on.


