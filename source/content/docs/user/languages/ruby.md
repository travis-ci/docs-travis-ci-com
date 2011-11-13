---
title: Building a Ruby Project
kind: content
---

Travis was originally intended for just Ruby, so things should Just
Work! You do not need to specify language in your .travis.yml file.

Travis will use Bundler to install your project's dependencies and run `rake` to run your tests.
Pleasen note that you need to add rake to your Gemfile.



### Overriding script, before_install, before_script and friends

See <a href="/docs/user/build-configuration/">Build configuration</a> to learn about *before_install*, *before_script*, branches configuration, email notification
configuration and so on.


### Exclude non-essential gems like ruby-debug

We ask Ruby project maintainers to exclude ruby-debug from being installed on travis-ci.org. Consider the following:
a project that installs ruby-debug, tests against 6 Ruby versions/implementations and does 3 pushes a day. Given that
linecache, one of the ruby-debug dependencies, takes 2 minutes to install in our CI VMs, this results in

    3 * 6 * 2 = 36 minutes of time per day per project

And, of course, nobody will really use ruby-debug in CI environments. To exlude ruby-debug and other gems that are
non-essential for your test suite, move them to a separate gem group (for example, :development) and [exclude it
using *bundler_args* in your .travis.yml](https://github.com/ruby-amqp/amqp/blob/master/.travis.yml#L2) like [amqp gem](https://github.com/ruby-amqp/amqp) does.

Time is better spent testing your project against more Ruby versions/implementations and more versions of libraries you depend on than
compiling linecache over and over.


### Testing against multiple versions of dependencies (Ruby on Rails, EventMachine, etc)

Many projects need to be tested against multiple versions of Rack, EventMachine, HAML, Sinatra, Ruby on Rails, you name it. It is easy
with Travis CI. What you have to do is this:

 * Create a directory in your project's repository root where you will keep gemfiles (./gemfiles is a commonly used name)
 * Add one or more gemfiles to it
 * Instruct Travis CI to use those gemfiles using *gemfiles* option in your .travis.yml

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


### Provided Ruby Versions

Here's a list of all of the Ruby versions supported by Travis. 1.8.7 is
the default.

- 1.8.7
- 1.9.2
- 1.9.3
- jruby
- rbx-18mode (Rubinius 2.0.testing branch in Ruby 1.8 mode)
- rbx-19mode (Rubinius 2.0.testing branch in Ruby 1.9 mode)
- ree
- ruby-head

[Ruby 1.8.6 and 1.9.1 are no longer provided on travis-ci.org](https://twitter.com/travisci/status/114926454122364928).
More information about provided Ruby versions and implementations is available <a href="/docs/user/ci-environment/">in a separate guide</a>.
