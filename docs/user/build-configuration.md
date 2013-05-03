---
title: Configuring your Travis CI build with .travis.yml
layout: en
permalink: build-configuration/
---

<div id="toc"></div>

### What This Guide Covers

This guide covers build environment and configuration topics that are common to
all projects hosted on travis-ci.org, regardless of the technology. We recommend
you start with the [Getting Started](/docs/user/getting-started/) guide and read
this guide top to bottom before moving on to [build
notifications](/docs/user/notifications/) and [language-specific guides](/docs).

## .travis.yml file: what it is and how it is used

Travis CI uses `.travis.yml` file in the root of your repository to learn about
your project and how you want your builds to be executed. `.travis.yml` can be
very minimalistic or have a lot of customization in it. A few examples of what
kind of information your `.travis.yml` file may have:

* What programming language your project uses
* What commands or scripts you want to be executed before each build (for example, to install or clone your project's dependencies)
* What command is used to run your test suite
* Emails, Campfire and IRC rooms to notify about build failures

and so on.

At the very minimum, Travis CI needs to know what builder it should use for your
project: Ruby, Clojure, PHP or something else. For everything else, there are
reasonable defaults.

## Build Lifecycle

By default, the worker performs the build as following:

* Switch language runtime (for example, to Ruby 1.9.3 or PHP 5.4)
* Clone project repository from GitHub
* Run *before_install* scripts (if any)
* cd to the clone directory, run dependencies installation command (default specific to project language)
* Run *before_script* scripts (if any)
* Run test *script* command (default is specific to project language). It must use exit code 0 on success and any code on failure.
* Run *after_success/after_failure* scripts (if any)
* Run *after_script* scripts (if any)

The outcome of any of these commands (except after_success, after_failure or after_scripts) indicates whether or not this build has failed or passed. The standard Unix **exit code of "0" means the build passed; everything else is treated as failure**.

Test result is exported to `TRAVIS_TEST_RESULT`, which you can use in commands run in `after_script` commands.

With the exception of cloning project repository and changing directory to it, all of the above steps can be tweaked with `.travis.yml`.

### Travis CI Preserves No State Between Builds

Travis CI uses virtual machine snapshotting to make sure no state is left between builds. If you modify CI environment by writing something to a data store, creating files or installing a package via apt, it won't affect subsequent builds.

## Define custom build lifecycle commands

### Overview

Travis CI runs all commands over SSH in isolated virtual machines. Commands that modify SSH session state are "sticky" and persist throughout the build.
For example, if you `cd` into a particular directory, all the following commands will be executed from it. This may be used for good (e.g. building subprojects one
after another) or affect tools like `rake` or `mvn` that may be looking for files in the current directory.



### script

You can specify the main build command to run instead of the default

    script: "make it-rain"

The script can be any executable; it doesn't have to be `make`. As a matter of fact the only requirement for the script is that it **should use an exit code 0 on success, any thing else is considered a build failure**. Also practically it should output any important information to the console so that the results can be reviewed (in real time!) on the website.

If you want to run a script local to your repository, do it like this:

    script: ./script/ci/run_build.sh

In this case, the script should be made executable (for example, using `chmod +x`) and contain a valid shebang line
(`/usr/bin/env sh`, `/usr/bin/env ruby`, `/usr/bin/env python` and so on).

### before_script, after_script

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

These scripts can, for example, be used to setup databases or other build setup tasks. 
For more information about database setup see [Database setup](/docs/user/database-setup/).

### install

If your project uses non-standard dependency management tools, you can override dependency installation command using `install` option:

    install: ant install-deps

As with other scripts, `install` command can be anything but has to exit with the 0 status in order to be considered successful.

### before_install

You can also define scripts to be run before and after the dependency installation script:

    before_install: some_command

Both settings support multiple scripts, too:

    before_install:
      - before_command_1
      - before_command_2

`before_install` is commonly used to update git repository submodules and do similar tasks that need to be performed before dependencies are installed.

### On Native Dependencies

If your project has native dependencies (for example, libxml or libffi) or needs tools [Travis CI Environment](/docs/user/ci-environment/) does not provide,
you can install packages via apt and even use 3rd-party apt repositories and PPAs. For more see dedicated sections later in this guide.


### Updating Git Submodules

If your project uses Git submodules, use the following technique to clone them before dependencies installation:

    before_install:
      - git submodule update --init --recursive

This will include nested submodules (submodules of submodules), in case there are any.


### Use Public URLs For Submodules

If your project uses Git submodules, make sure you use public Git URLs. For example, on GitHub, instead of

    git@github.com:someuser/somelibrary.git

use

    git://github.com/someuser/somelibrary.git

Otherwise, Travis CI builders won't be able to clone your project because they don't have your private SSH key.

## Choose runtime (Ruby, PHP, Node.js, etc) versions

One of the key features of Travis is the ease of running your test suite against multiple runtimes and versions. Since Travis does not know what runtimes and versions your projects supports, they need to be specified in the `.travis.yml` file. The option you use for that varies between languages. Here are some basic **.travis.yml** examples for various languages:

### Clojure

Currently Clojure projects can be tested against Oracle JDK 7, OpenJDK 7 and OpenJDK 6. Clojure flagship build tool, Leiningen, supports testing against multiple Clojure versions:

* In Leiningen 1.x, via [lein-multi plugin](https://github.com/maravillas/lein-multi)
* In upcoming Leiningen 2.0, via Leiningen Profiles

If you are interested in testing against multiple Clojure releases, just use these Leiningen features and it will work without special support on the Travis side.

Learn more in our [Clojure guide](/docs/user/languages/clojure/).

### Erlang

Erlang projects specify releases they need to be tested against using `otp_release` key:

    otp_release:
      - R14B03
      - R14B04
      - R15B01

Learn more about [.travis.yml options for Erlang projects](/docs/user/languages/erlang/).

### Groovy

Groovy projects can be currently tested against Oracle JDK 7, OpenJDK 7 and OpenJDK 6. Support for multiple JDKs will be added eventually.

Learn more in our [Groovy guide](/docs/user/languages/groovy/).

### Java

Java projects can be currently tested against Oracle JDK 7, OpenJDK 7 and OpenJDK 6. Support for multiple JDKs will be added eventually.

Learn more in our [Java guide](/docs/user/languages/java/).


### Node.js

Node.js projects specify releases they need to be tested against using `node_js` key:

     node_js:
       - "0.4"
       - "0.6"

Learn more about [.travis.yml options for Node.js projects](/docs/user/languages/javascript-with-nodejs/).

### Perl

Perl projects specify Perls they need to be tested against using `perl` key:

    perl:
      - "5.14"
      - "5.12"

Learn more about [.travis.yml options for Perl projects](/docs/user/languages/perl/).

### PHP

PHP projects specify releases they need to be tested against using `php` key:

    php:
      - "5.4"
      - "5.3"

Learn more about [.travis.yml options for PHP projects](/docs/user/languages/php/).

### Python

Python projects specify Python versions they need to be tested against using `python` key:

    python:
      - "2.7"
      - "2.6"
      - "3.2"

Learn more about [.travis.yml options for Python projects](/docs/user/languages/python/).

### Ruby

Ruby projects specify releases they need to be tested against using `rvm` key:

    rvm:
      - "1.9.3"
      - "1.9.2"
      - jruby-19mode
      - rbx-19mode
      - jruby-18mode
      - "1.8.7"

Learn more about [.travis.yml options for Ruby projects](/docs/user/languages/ruby/).

### Scala

Scala projects specify releases they need to be tested against using `scala` key:

    scala:
      - "2.9.2"
      - "2.8.2"

Travis CI relies on SBT's support for running tests against multiple Scala versions.

Learn more in our [Scala guide](/docs/user/languages/scala/).

## Set environment variables

To specify an environment variable:

    env: DB=postgres

Environment variables are useful for configuring build scripts. See the example in [Database setup](/docs/user/database-setup/#multiple-database-systems). One ENV variable is always set during your builds, `TRAVIS`. Use it to detect whether your test suite is running during CI.

You can specify more than one environment variable per item in the `env` array:

    rvm:
      - 1.9.3
      - rbx-18mode
    env:
      - FOO=foo BAR=bar
      - FOO=bar BAR=foo

With this configuration, **4 individual builds** will be triggered:

1. Ruby 1.9.3 with `FOO=foo` and `BAR=bar`
2. Ruby 1.9.3 with `FOO=bar` and `BAR=foo`
3. Rubinius in 1.8 mode with `FOO=foo` and `BAR=bar`
4. Rubinius in 1.8 mode with `FOO=bar` and `BAR=foo`

Note that environment variable values may need quoting. For example, if they have asterisks (`*`) in them:

    env:
      - PACKAGE_VERSION="1.0.*"

## Installing Packages Using apt

If your dependencies need native libraries to be available, **you can use passwordless sudo to install them** with

    before_install:
     - sudo apt-get update -qq
     - sudo apt-get install -qq [packages list]

The reason why travis-ci.org can afford to provide passwordless sudo is that virtual machines your test suite is executed in are
snapshotted and rolled back to their pristine state after each build.

Please note that passwordless sudo availability does not mean that you need to use sudo for (most of) other operations.
It also does not mean that Travis CI builders execute operations as root.

### Using 3rd-party PPAs

If you need a native dependency that is not available from the official Ubuntu repositories, possibly there are [3rd-party PPAs](https://launchpad.net/ubuntu/+ppas)
(personal package archives) that you can use: they need to provide packages for 32-bit Ubuntu 12.04.

More on PPAs [in this article](http://www.makeuseof.com/tag/ubuntu-ppa-technology-explained/), search for [available PPAs on Launchpad](https://launchpad.net/ubuntu/+ppas).


## Build Timeouts

Because it is very common to see test suites or before scripts to hang up, Travis CI has hard time limits. If a script or test suite takes longer to run, the build will be forcefully terminated and you will see a message about this in your build log.

With our current timeouts, a build will be terminated if it's still running
after 50 minutes, or if there hasn't been any log output in 10 minutes.

Some common reasons why test suites may hang up:

* Waiting for keyboard input or other kind of human interaction
* Concurrency issues (deadlocks, livelocks and so on)
* Installation of native extensions that take very long time to compile

## Specify branches to build

### .travis.yml and multiple branches

Travis will always look for the `.travis.yml` file that is contained in the branch specified by the git commit that GitHub has passed to us. This configuration in one branch will not affect the build of another, separate branch. Also, Travis CI will build after *any* git push to your GitHub project unless you instruct it to [skip a build](/docs/user/how-to-skip-a-build/). You can limit this behavior with configuration options.

### White- or blacklisting branches

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

If you specify both, "except" will be ignored. Please note that currently (for historical reasons), `.travis.yml` needs to be present *on all active branches* of your project.

Note that the `gh-pages` branch will not be built unless you add it to the whitelist (`branches.only`).

### Using regular expressions ###

You can use regular expressions to white- or blacklist branches:

    branches:
      only:
        - master
        - /^deploy-.*$/

Any name surrounded with `/` in the list of branches is treated as a regular expression and can contain all kinds of quantifiers, anchors, and character classes [supported](http://www.ruby-doc.org/core-1.9.3/Regexp.html) by Ruby.

Options that are usually specified after the last `/` (e.g., `i` for case insensitive matching) are not supported at the moment.

## The Build Matrix

When you combine the three main configuration options above, Travis CI will run your tests against a matrix of all possible combinations. Three key matrix dimensions are:

* Runtime to test against
* Environment variables with which you can configure your build scripts
* Exclusions, inclusions and allowed failures

Below is an example configuration for a rather big build matrix that expands to **56 individual** builds.

Please take into account that Travis CI is an open source service and we rely on worker boxes provided by the community. So please only specify an as big matrix as you *actually need*.

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

It is also possible to include entries into the matrix:

    matrix:
      include:
        - rvm: ruby-head
          gemfile: gemfiles/Gemfile.rails-3.2.x
          env: ISOLATED=false

This is useful if you want to, say, only test the latest version of a
dependency together with the latest version of the runtime.

### Environment variables

Sometimes you may want to use env variables that are global to the matrix, i.e. they're inserted into each matrix row. That may include keys, tokens, URIs or other data that is needed for every build. In such cases, instead of manually adding such keys to each env line in matrix, you can use `global` and `matrix` keys to differentiate between those two cases. For example:

    env:
      global:
        - CAMPFIRE_TOKEN=abc123
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false

Such configuration will generate matrix with 2 following env rows:

    USE_NETWORK=true CAMPFIRE_TOKEN=abc123 TIMEOUT=1000
    USE_NETWORK=false CAMPFIRE_TOKEN=abc123 TIMEOUT=1000

### Secure environment variables

In the last example I used a token as one of the environment variables. However, it's not very wise to put your private tokens in the publicly available file. Travis supports environment variables encryption to handle this case and allows you to keep configuration public, while keeping parts of it private. Example configuration with secure environment variables looks something like:

    env:
      global:
        - secure: <encrypted string here>
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false
        - secure: <you can also put encrypted vars inside matrix>

You can encrypt environment variables using public key attached to your repository. The simplest way to do that is to use travis gem:

    gem install travis
    cd my_project
    travis encrypt MY_SECRET_ENV=super_secret

Please note that secure env variables are not available for pull requests. This is done due to the security risk of exposing such information in submitted code. Everyone can submit a pull request and if an unencrypted variable is available there, it could be easily displayed.

You can also automatically add it to your `.travis.yml`:

    travis encrypt MY_SECRET_ENV=super_secret --add env.matrix

To make the usage of secure environment variables easier, we expose info on their availability and info about the type of this build:

* `TRAVIS_SECURE_ENV_VARS` is set to "true" or "false" depending on the availability of environment variables
* `TRAVIS_PULL_REQUEST` is set to "true" or "false" depending on this build being pull request or not

Please also note that keys used for encryption and decryption are tied to the repository. If you fork a project and add it to travis, it will have different pair of keys than the original.

### Rows That are Allowed To Fail

You can also define rows that are allowed to fail in the build matrix. Allowed
failures are items in your build matrix that are allowed to fail without causing
the entire build to be shown as failed. This lets you add in experimental and
preparatory builds to test against versions or configurations that you are not
ready to officially support.

Allowed failures must be a list of key/value pairs representing entries in your
build matrix.

You can define allowed failures in the build matrix as follows:

    matrix:
      allow_failures:
        - rvm: 1.9.3
