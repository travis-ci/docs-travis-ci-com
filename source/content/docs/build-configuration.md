---
title: Build Configuration
kind: article
layout: article
---

The `.travis.yml` file in the root of your repo allows you configure your builds. Travis CI will always look for the `.travis.yml` file that is contained in the SHA/commit that Github has passed.

Below are some of the configuration options and a brief explanation of what is achieved using them.

<h3>Specify a Ruby version</h3>

To specify a particular Ruby version to test against you can do:

    rvm: rbx

<h3>Specify a Gemfile</h3>

To specify a custom Gemfile variable you can do:

    gemfile: gemfiles/Gemfile.ci

<h3>Set an environment variable</h3>

To specify a single environment variable you can do:

    env: RAILS_ENV=test

<h3>Specify a build matrix</h3>

You can also combine the three configuration options above and configure Travis CI to run your tests against a matrix of various configurations. There are 3 matrix dimensions supported:

* `rvm` - specify Ruby versions to test against
* `gemfile` - specify different dependencies to test against
* `env` - specify different environment variables to be set, so you can configure various things in your build script based on this

Below is an example configuration for a rather big build matrix that expands to 32 individual builds.

Please take into account that Travis CI is an open source service and we need to rely on worker boxes provided by the community. So please only specify an as big matrix as you actually really need.

    rvm:
      - 1.8.7 # (current default)
      - 1.9.2
      - rbx
      - rbx-2.0
      - ree
      - jruby
      - ruby-head
      - 1.8.6
    gemfile:
      - gemfiles/Gemfile.rails-2.3.x
      - gemfiles/Gemfile.rails-3.0.x
    env:
      - ISOLATED=true
      - ISOLATED=false

<h3>Define a custom build script</h3>

Define how to run your tests (defaults to `bundle exec rake` or `rake` depending on whether you have a `Gemfile`).

    script: "bundle exec rake db:drop db:create db:migrate test"

<h3>Set bundler args</h3>

Define tasks to be completed before and after tests run. Will allow folding of content in the frontend view:

    before_script: command_1
    after_script:  command_2

Or:

    before_script:
      - command_1
      - command_2

    after_script:
      - command_3
      - command_4

<h3>Set bundler args</h3>

Pass arguments to `bundle install` (see <a href="http://gembundler.com/man/bundle-install.1.html">http://gembundler.com/man/bundle-install.1.html</a>)

    bundler_args: --binstubs

<h3>Configure recipients for email notification</h3>

You can specify recipients that will be notified about build results.

    notifications:
      recipients:
        - email-address-1
        - email-address-2

You can also entirely turn off notifications like this:

    notifications:
      disabled: true # Disable email notifications

If you do not configure this then Travis CI will notify:

* the commit author and the repository owner (for repositories owned by users)
* the commit author and all organization members (for repositories owned by organizations)

<h3>Specify branches to build</h3>

You can either white- or blacklist branches that you want to be build by using `only` or `except` keys. If you specify both, except will be ignored:

    branches:
      only:
        - master
      except:
        - legacy

