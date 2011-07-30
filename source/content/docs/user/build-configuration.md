---
title: Build Configuration
kind: article
layout: article
---

The `.travis.yml` file in the root of your repo allows you configure your builds. Travis CI will always look for the `.travis.yml` file that is contained in the tree specified by the git commit that Github has passed.

This configuration in one branch will not affect the build of another, separate branch. Also, Travis CI will build after <em>any</em> git push to your GitHub project, regardless of the branch and whether it has the configuration file or not. You can limit this behavior with configuration options.

By default, the worker performs the build as following:

    $ rvm use 1.8.7
    $ git clone git://github.com/YOUR/PROJECT.git
    $ bundle install --path vendor/bundle
    $ bundle exec rake

If your project is not using Bundler (no Gemfile), it will only run `rake`.

The outcome of this last command – the build script – indicates whether or not this build has failed or passed. The standard unix exit code of "0" means it passed; everything else is treated as failure.

With the exception of `git clone` command, all of the above steps can be tweaked with `.travis.yml`.

<h3>Choose a Ruby version</h3>

To specify the Ruby version to test against, use the `rvm` option:

    rvm: 1.9.2

<h3>Specify a Gemfile</h3>

You can specify a custom Gemfile name:

    gemfile: gemfiles/Gemfile.ci

Unless specified, the worker will look for a file named "Gemfile" in the root of your project.

You can also set <a href="http://gembundler.com/man/bundle-install.1.html">extra arguments</a> to be passed to `bundle install`:

    bundler_args: --binstubs

<h3>Set environment variables</h3>

To specify an environment variable:

    env: DB=postgres

Environment variables are useful for configuring build scripts. See the example in <a href="/docs/user/database-setup/#multiple-database-systems">Database setup</a>. One variable is always present during your builds, `TRAVIS`:

    if ENV['TRAVIS']
      # do something specific to continuous integration
    end

<h3>The build matrix</h3>

When you combine the three main configuration options above, Travis CI will run your tests against a matrix of all possible combinations. The 3 matrix dimensions are:

* `rvm` - Ruby interpreters to test against
* `gemfile` - different sets of dependencies to test against
* `env` - environment variables with which you can configure your build scripts

Below is an example configuration for a rather big build matrix that expands to <strong>32&nbsp;individual</strong> builds.

Please take into account that Travis CI is an open source service and we rely on worker boxes provided by the community. So please only specify an as big matrix as you <em>actually need</em>.

    rvm:
      - 1.8.6
      - 1.8.7 # (current default)
      - 1.9.2
      - rbx
      - rbx-2.0
      - ree
      - jruby
      - ruby-head
    gemfile:
      - gemfiles/Gemfile.rails-2.3.x
      - gemfiles/Gemfile.rails-3.0.x
    env:
      - ISOLATED=true
      - ISOLATED=false

<h3>Define a custom build script</h3>

You can specify the main build command to run instead of just `rake`:

    script: "bundle exec rake db:drop db:create db:migrate test"

The script can be any executable; it doesn't have to be `rake`, and it doesn't even have to start with `bundle exec` (it can bootstrap the bundle internally).

You can also define scripts to be run before and after the main script:

    before_script: some_command
    after_script:  another_command

Both settings support multiple scripts, too.

These scripts can be used to setup databases used for testing. For more information, see <a href="/docs/user/database-setup/">Database setup</a>.

<h3>Recipients of email & IRC notification</h3>

You can specify recipients that will be notified about build results.

    notifications:
      recipients:
        - one@example.com
        - other@example.com

You can also entirely turn off notifications like this:

    notifications:
      disabled: true

If you do not configure this then Travis CI will notify:

* for user repos: the commit author and the repository owner
* for repos owned by an organization: the commit author and <em>all</em> organization members

You can also specify notifications in an IRC channel:

    notifications:
      irc: "irc.freenode.org#travis"

<h3>Specify branches to build</h3>

You can either white- or blacklist branches that you want to be built:

    # blacklist
    branches:
      except:
        - legacy
        - experimental

    # whitelist
    branches:
      only:
        - master
        - stable

If you specify both, "except" will be ignored.
