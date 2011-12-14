---
title: Build Configuration
kind: content
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

More information about provided Ruby versions and implementations is available <a href="/docs/user/ci-environment/">in a separate guide</a>.

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

Below is an example configuration for a rather big build matrix that expands to <strong>28&nbsp;individual</strong> builds.

Please take into account that Travis CI is an open source service and we rely on worker boxes provided by the community. So please only specify an as big matrix as you <em>actually need</em>.

    rvm:
      - 1.8.7 # (current default)
      - 1.9.2
      - 1.9.3
      - rbx-2.0
      - jruby
      - ruby-head
      - ree
    gemfile:
      - gemfiles/Gemfile.rails-2.3.x
      - gemfiles/Gemfile.rails-3.0.x
    env:
      - ISOLATED=true
      - ISOLATED=false

You can also define exclusions to the build matrix:

    matrix:
      exclude:
        - rvm: 1.8.7
          gemfile: gemfiles/Gemfile.rails-2.3.x
          env: ISOLATED=true
        - rvm: jruby
          gemfile: gemfiles/Gemfile.rails-2.3.x
          env: ISOLATED=true

Only exact matches will be excluded.

You can specify more than one environment variable per item in the `env` array:

    rvm:
      - 1.9.3
      - rbx-2.0
    env:
      - FOO=foo BAR=bar
      - FOO=bar BAR=foo

With this configuration, only **4 individual builds** will be triggered:

1. Ruby 1.9.3 with `FOO=foo` and `BAR=bar`
1. Rubinius 2.0 with `FOO=bar` and `BAR=foo`


<h3>Define custom build scripts</h3>

You can specify the main build command to run instead of just `rake`:

    script: "bundle exec rake db:drop db:create db:migrate test"

The script can be any executable; it doesn't have to be `rake`, and it doesn't even have to start with `bundle exec` (it can bootstrap the bundle internally).
As a matter of fact the only requirement for the script is that it should use an exit code 0 on success, any thing else is considered a build failure.
Also practically it should output any important information to the console so that the results can be reviewed (in real time!) on the website.

You can also define scripts to be run before and after the main script:

    before_script: some_command
    after_script:  another_command

Both settings support multiple scripts, too:

    before_script:
      - before_command_1
      - before_command_2
    after_script:
      - after_command_1
      - after_command_2

These scripts can, e.g., be used to setup databases or other build setup tasks. For more information about database setup see <a href="/docs/user/database-setup/">Database setup</a>.

**NOTE: If you need to use `cd`, either use a separate shell script or `sh -c` as demonstrated:**

    before_script:
      - "sh -c 'cd spec/dummy && rake db:migrate'"

This is necessary because every command is executed via wrapper that kills hanging commands when they time out.


You can also define a script to be run before 'bundle install':

    before_install: some_command

For example, to use the pre-release version of bundler:

    before_install: gem install bundler --pre


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


<h2>Notifications</h2>

Travis CI can notify you about your build results through email, IRC and/or webhooks.

By default it will send emails to

* the commit author and committer
* the owner of the repository (for normal repositories)
* <em>all</em> public members of the organization owning the repository

And it will by default send emails when, on the given branch:

* a build was just broken or still is broken
* a previously broken build was just fixed

You can change this behaviour using the following options:


<h3>Email notifications</h3>

You can specify recipients that will be notified about build results like so:

    notifications:
      email:
        - one@example.com
        - other@example.com

And you can entirely turn off email notifications:

    notifications:
      email: false

Also, you can specify when you want to get notified:

    notifications:
      email:
        on_success: [always|never|change] # default: change
        on_failure: [always|never|change] # default: always

`always` and `never` obviously mean that you want email notifications to be sent always or never. `change` means that you will get them when the build status changes on the given branch.


<h3>IRC notification</h3>

You can also specify notifications sent to an IRC channel:

    notifications:
      irc: "irc.freenode.org#travis"

Or multiple channels:

    notifications:
      irc:
        - "irc.freenode.org#travis"
        - "irc.freenode.org#some-other-channel"

Just as with other notification types you can specify when IRC notifications will be sent:

    notifications:
      irc:
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always


<h3>Webhook notification</h3>

You can define webhooks to be notified about build results the same way:

    notifications:
      webhooks: http://your-domain.com/notifications

Or multiple channels:

    notifications:
      webhooks:
        - http://your-domain.com/notifications
        - http://another-domain.com/notifications

Just as with other notification types you can specify when IRC notifications will be sent:

    notifications:
      webhooks:
        on_success: [always|never|change] # default: always
        on_failure: [always|never|change] # default: always

Here is an example payload of what will be `POST`ed to your webhook URLs: https://gist.github.com/1225015

