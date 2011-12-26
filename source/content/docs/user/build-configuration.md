---
title: Build Configuration
kind: content
---

## Configuring your build using .travis.yml

The `.travis.yml` file in the root of your repo allows you configure your builds. Travis CI will always look for the `.travis.yml` file that is contained in the tree specified by the git commit that Github has passed.

This configuration in one branch will not affect the build of another, separate branch. Also, Travis CI will build after <em>any</em> git push to your GitHub project unless you
instruct it to <a href="/docs/user/how-to-skip-a-build/">skip a build</a>. You can limit this behavior with configuration options.


### Build Lifecycle

By default, the worker performs the build as following:

 * Switch language runtime (for example, to Ruby 1.9.3 or PHP 5.4)
 * Clone project repository from GitHub
 * Run before_install scripts (if any)
 * cd to the clone directory, run dependencies installation command (default specific to project language)
 * Run *after_install* scripts (if any)
 * Run *before_script* scripts (if any)
 * Run test *script* command (default is specific to project language)
 * Run *after_script* scripts (if any)

The outcome of any of these commands indicates whether or not this build has failed or passed. The standard Unix **exit code of "0" means the build passed; everything else is treated as failure**.

With the exception of `git clone` command, all of the above steps can be tweaked with `.travis.yml`.



### Define custom build lifecycle commands

#### script

You can specify the main build command to run instead of the default

    script: "make it-rain"

The script can be any executable; it doesn't have to be `make`.
As a matter of fact the only requirement for the script is that it **should use an exit code 0 on success, any thing else is considered a build failure**.
Also practically it should output any important information to the console so that the results can be reviewed (in real time!) on the website.

If you want to run a script local to your repository, do it like this:

    script: ./script/ci/run_build.sh


#### before_script, after_script

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

#### install

If your project uses non-standard dependency management tools, you can override dependency installation command using `install` option:

    install: ant install-deps

As with other scripts, `install` command can be anything but has to exit with the 0 status in order to be considered successful.


#### before_install, after_install

You can also define scripts to be run before and after the dependency installation script:

    before_install: some_command
    after_install:  another_command

Both settings support multiple scripts, too:

    before_install:
      - before_command_1
      - before_command_2
    after_install:
      - after_command_1
      - after_command_2

These commands are commonly used to update git repository submodules and do similar tasks that need to be performed before
dependencies are installed.


### Choose runtime (Ruby, PHP, Node.js, etc) versions

One of the key features of Travis is the ease of running your test suite against multiple runtimes and versions.
Since Travis does not know what runtimes and versions your projects supports, they need to be specified in the `.travis.yml` file.
The option you use for that vary between languages. Here are some basic **.travis.yml** examples for various languages:

#### Clojure

Currently Clojure projects can only be tested against JDK 6. Clojure flagship build tool, Leiningen, supports testing
against multiple Clojure versions via <a href="https://github.com/maravillas/lein-multi">lein-multi plugin</a>. If you are interested in testing against multiple
Clojure releases, just use that plugin and it will work without special support on the Travis side.

Learn more about <a href="/docs/user/languages/clojure/">.travis.yml options for Clojure projects</a>

#### Erlang

Erlang projects specify OTP releases they need to be tested against using `otp_release` key:

    otp_release:
      - R14B02
      - R14B03
      - R14B04

Learn more about <a href="/docs/user/languages/erlang/">.travis.yml options for Erlang projects</a>

#### Node.js

Node.js projects specify OTP releases they need to be tested against using `node_js` key:

     node_js:
       - 0.4
       - 0.6

Learn more about <a href="/docs/user/languages/javascript-with-nodejs/">.travis.yml options for Node.js projects</a>

#### PHP

PHP projects specify OTP releases they need to be tested against using `phps` key:

    phps:
      - 5.3
      - 5.4

Learn more about <a href="/docs/user/languages/php/">.travis.yml options for PHP projects</a>

#### Ruby

Ruby projects specify OTP releases they need to be tested against using `rvm` key:

    rvm:
      - 1.8.7
      - 1.9.2
      - 1.9.3
      - jruby
      - rbx-18mode

Learn more about <a href="/docs/user/languages/ruby/">.travis.yml options for Ruby projects</a>

More information about provided Ruby versions and implementations is available <a href="/docs/user/ci-environment/">in a separate guide</a>.



### Set environment variables

To specify an environment variable:

    env: DB=postgres

Environment variables are useful for configuring build scripts. See the example in <a href="/docs/user/database-setup/#multiple-database-systems">Database setup</a>. One ENV variable is always set during your builds, `TRAVIS`. Use it to detect whether your test suite is running during CI.



### Specify branches to build

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



## Notifications

Travis CI can notify you about your build results through email, IRC and/or webhooks.

By default it will send emails to

* the commit author and committer
* the owner of the repository (for normal repositories)
* <em>all</em> public members of the organization owning the repository

And it will by default send emails when, on the given branch:

* a build was just broken or still is broken
* a previously broken build was just fixed

You can change this behaviour using the following options:


### Email notifications

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


### IRC notification

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


### Webhook notification

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



### The Build Matrix

When you combine the three main configuration options above, Travis CI will run your tests against a matrix of all possible combinations. Two key matrix dimensions are:

* Runtime to test against
* Environment variables with which you can configure your build scripts

Below is an example configuration for a rather big build matrix that expands to <strong>28&nbsp;individual</strong> builds.

Please take into account that Travis CI is an open source service and we rely on worker boxes provided by the community. So please only specify an as big matrix as you <em>actually need</em>.

    rvm:
      - 1.8.7 # (current default)
      - 1.9.2
      - 1.9.3
      - rbx-18mode
      - jruby
      - ruby-head
      - ree
    gemfile:
      - gemfiles/Gemfile.rails-2.3.x
      - gemfiles/Gemfile.rails-3.0.x
      - gemfiles/Gemfile.rails-3.1.x
      - gemfiles/Gemfile.rails-edge
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
      - rbx-18mode
    env:
      - FOO=foo BAR=bar
      - FOO=bar BAR=foo

With this configuration, only **4 individual builds** will be triggered:

1. Ruby 1.9.3 with `FOO=foo` and `BAR=bar`
2. Rubinius in 1.8 mode with `FOO=bar` and `BAR=foo`
