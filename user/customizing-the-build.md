---
title: Customizing the Build
layout: en
permalink: /user/customizing-the-build/
redirect_from: /user/mytest
---

<!-- rework this whole thing then delete build config and build lifecycle ? -->

<div id="toc"></div>

Travis CI provides a default build environment and a default set of steps for each programming language. You can customize any step in this process in `.travis.yml`.  Travis CI uses `.travis.yml` file in the root of your repository to learn about your project and how you want your builds to be executed. `.travis.yml` can be
very minimalistic or have a lot of customization in it. A few examples of what
kind of information your `.travis.yml` file may have:

* What programming language your project uses
* What commands or scripts you want to be executed before each build (for example, to install or clone your project's dependencies)
* What command is used to run your test suite
* Emails, Campfire and IRC rooms to notify about build failures

## The Build Lifecycle

A build on Travis CI follows two simple steps:

1. **install**: install any dependencies required
2. **script**: run the build script

You can run custom commands before the installation step (`before_install`), and before (`before_script`) or after (`after_script`) the script step.

In a `before_install` step, you can install additional dependencies required by your project such as Ubuntu packages or custom services.

You can perform additional steps when your build succeeds or fails using  the `after_success` (such as building documentation, or deploying to a custom server) or `after_failure` (such as uploading log files) options. In both `after_failure` and `after_success`, you can access the build result using the `$TRAVIS_TEST_RESULT` environment variable.

The complete build lifecycle, including three optional deployment steps and after checking out the git repository and changing the the repository directory, is:

1. `before_install`
2. `install`
3. `before_script`
4. `script`
5. `after_success` or `after_failure`
6. `after_script`
7. OPTIONAL `before_deployment`
8. OPTIONAL `deployment`
9. OPTIONAL `after_deployment`


## Customizing the Installation Step

The default dependency installation commands depend on the project language. For instance, Java builds either use Maven or Gradle, depending on which build file is present in the repository. Ruby projects use Bundler when a Gemfile is present in the repository.

You can specify your own script to run to install whatever dependencies your project requires in `.travis.yml`:

    install: ./install-dependencies.sh

> When using custom scripts they should be executable (for example, using `chmod +x`) and contain a valid shebang line such as `/usr/bin/env sh`, `/usr/bin/env ruby`, or `/usr/bin/env python`. 

You can also provide multiple steps, for instance to install a Ubuntu package as part of your build:

    install:
      - sudo apt-get update -qq
      - sudo apt-get install
      - bundle install --path vendor/bundle

When one of the steps fails, the build stops immediately and is [marked as errored](#Breaking-the-Build).

## Customizing the Build Step

The default build command depends on the project language. Ruby projects use `rake`, the common denominator for most Ruby projects.

You can overwrite the default build step in `.travis.yml`:

    script: bundle exec thor build

You can specify multiple script commands as well:

    script:
      - bundle exec rake build
      - bundle exec rake builddoc

When one of the build commands returns a non-zero exit code, the Travis CI build runs the subsequent commands as well, and accumulates the build result.

In the example above, if `bundle exec rake build` returns an exit code of 1, the following command `bundle exec rake builddoc` is still run, but the build will result in a failure.

If your first step is to run unit tests, followed by integration tests, you may still want to see if the integration tests succeed when the unit tests fail.

You can change this behavior by using a little bit of shell magic to run all commands subsequently but still have the build fail when the first command returns a non-zero exit code. Here's the snippet for your `.travis.yml`

    script: bundle exec rake build && bundle exec rake builddoc

This example (note the `&&`) fails immediately when `bundle exec rake build` fails.

## Breaking the Build

If any of the commands in the first four stages returns a non-zero exit code, Travis CI considers the build to be broken.

When any of the steps in the `before_install`, `install` or `before_script` stages fails with a non-zero exit code, the build is marked as **errored**.

When any of the steps in the  `script` stage fails with a non-zero exit code, the build is marked as **failed**.

> Note that the `script` section has different semantics to the other
steps. When a step defined in `script` fails, the build doesn't end right away,
it continues to run the remaining steps before it fails the build.

Currently, neither the `after_success` nor `after_failure` have any influence on the build result. We have plans to change this behaviour.

## Deployment

An optional phase in the build lifecycle is deployment. This step can't be overridden, but is defined by using one of our continuous deployment providers to deploy code to Heroku, Engine Yard, or a different supported platform.

You can run steps before a deploy by using the `before_deploy` phase. A non-zero exit code in this command will mark the build as **errored**.

If there are any steps you'd like to run after the deployment, you can use the `after_deploy` phase.

## Build FAQ

### Travis CI Preserves No State Between Builds

Travis CI uses virtual machine snapshotting to make sure no state is left between builds. If you modify CI environment by writing something to a data store, creating files or installing a package via apt, it won't affect subsequent builds.

### SSH

Travis CI runs all commands over SSH in isolated virtual machines. Commands that modify SSH session state are "sticky" and persist throughout the build.
For example, if you `cd` into a particular directory, all the following commands will be executed from it. This may be used for good (e.g. building subprojects one
after another) or affect tools like `rake` or `mvn` that may be looking for files in the current directory.

### Git Submodules

Travis CI automatically initializes and updates submodules when there's a `.gitmodules` file in the root of the repository.

This can be turned off by setting:

    git:
      submodules: false

If your project requires some specific option for your Git submodules which Travis CI does not support out of the box, then you can turn the automatic integration off and use the `before_install` hook to initializes and update them.

For example:

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

One of the key features of Travis CI is the ease of running your test suite against multiple runtimes and versions. Since Travis CI does not know what runtimes and versions your projects supports, they need to be specified in the `.travis.yml` file. The option you use for that varies among languages. Here are some basic **.travis.yml** examples for various languages:


### Clojure

Currently Clojure projects can be tested against Oracle JDK 8, Oracle JDK 7, OpenJDK 7 and OpenJDK 6. Clojure flagship build tool, Leiningen, supports testing against multiple Clojure versions:

* In Leiningen 1.x, via [lein-multi plugin](https://github.com/maravillas/lein-multi)
* In upcoming Leiningen 2.0, via Leiningen Profiles

If you are interested in testing against multiple Clojure releases, you can use these Leiningen features and it will work without special support on the Travis CI side.

Learn more in our [Clojure guide](/user/languages/clojure/).

### Erlang

Erlang projects specify releases they need to be tested against using `otp_release` key:

    otp_release:
      - R14B03
      - R14B04
      - R15B01

Learn more about [.travis.yml options for Erlang projects](/user/languages/erlang/).

### Groovy

Groovy projects can be currently tested against Oracle JDK 8, Oracle JDK 7, OpenJDK 7 and OpenJDK 6.

Learn more in our [Groovy guide](/user/languages/groovy/).

### Java

Java projects can be currently tested against Oracle JDK 8, Oracle JDK 7, OpenJDK 7 and OpenJDK 6.

Learn more in our [Java guide](/user/languages/java/).


### Node.js

Node.js projects specify releases they need to be tested against using `node_js` key:

     node_js:
       - "0.4"
       - "0.6"

Learn more about [.travis.yml options for Node.js projects](/user/languages/javascript-with-nodejs/).

### Perl

Perl projects specify Perls they need to be tested against using `perl` key:

    perl:
      - "5.14"
      - "5.12"

Learn more about [.travis.yml options for Perl projects](/user/languages/perl/).

### PHP

PHP projects specify releases they need to be tested against using `php` key:

    php:
      - "5.4"
      - "5.3"

Learn more about [.travis.yml options for PHP projects](/user/languages/php/).

### Python

Python projects specify Python versions they need to be tested against using `python` key:

    python:
      - "2.7"
      - "2.6"
      - "3.2"

Learn more about [.travis.yml options for Python projects](/user/languages/python/).

### Ruby

Ruby projects specify releases they need to be tested against using `rvm` key:

    rvm:
      - "1.9.3"
      - "1.9.2"
      - jruby-19mode
      - rbx
      - jruby-18mode
      - "1.8.7"

Learn more about [.travis.yml options for Ruby projects](/user/languages/ruby/).

### Scala

Scala projects specify releases they need to be tested against using `scala` key:

    scala:
      - "2.11.0-M4"
      - "2.10.2"
      - "2.9.2"

Travis CI relies on sbt's support for running tests against multiple Scala versions.

Learn more in our [Scala guide](/user/languages/scala/).

## Installing Packages Using apt

<div class="note-box">
Note that this feature is not available for builds that are running on the <a href="/user/workers/container-based-infrastructure">container-based workers</a>.
</div>

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
(personal package archives) that you can use: they need to provide packages for 64-bit Ubuntu 12.04.

More on PPAs [in this article](http://www.makeuseof.com/tag/ubuntu-ppa-technology-explained/), search for [available PPAs on Launchpad](https://launchpad.net/ubuntu/+ppas).


## Job Timeouts

Because it is very common to see test suites or before scripts to hang up, Travis CI has hard time limits. If a script or test suite takes longer to run, the job will be forcefully terminated and you will see a message about this in your build log.

With our current timeouts, a job will be terminated if it's still running
after 50 minutes (120 minutes on travis-ci.com), or if there hasn't been any log output in 10 minutes.

Some common reasons why test suites may hang up:

* Waiting for keyboard input or other kind of human interaction
* Concurrency issues (deadlocks, livelocks and so on)
* Installation of native extensions that take very long time to compile

There is no such timeout for a build; a build will run as long as all the jobs do.

## Specify branches to build

### .travis.yml and multiple branches

Travis CI will always look for the `.travis.yml` file that is contained in the branch specified by the git commit that GitHub has passed to us. This configuration in one branch will not affect the build of another, separate branch. Also, Travis CI will build after *any* git push to your GitHub project unless you instruct it to [skip a build](/user/how-to-skip-a-build/). You can limit this behavior with configuration options.

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
However, such options can be given inline instead.
For example, `/^(?i:deploy)-.*$/` matches `Deploy-2014-06-01` and other
branches and tags that start with `deploy-` in any combination of cases.

## The Build Matrix

When you combine the three main configuration options above, Travis CI will run your tests against a matrix of all possible combinations. Three key matrix dimensions are:

* Runtime to test against
* Environment variables with which you can configure your build scripts
* Exclusions, inclusions and allowed failures

Below is an example configuration for a rather big build matrix that expands to **56 individual** builds.

Please take into account that Travis CI is an open source service and we rely on worker boxes provided by the community. So please only specify an as big matrix as you *actually need*.

    rvm:
      - 1.8.7
      - 1.9.2
      - 1.9.3
      - rbx-2
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

### Excluding jobs with a shorthand

If the builds you want to exclude from the matrix share the same matrix
parameters, you can only specify those, and omit the varying parts.

Suppose you have:

    language: ruby
    rvm:
      - 1.9.3
      - 2.0.0
      - 2.1.0
    env:
      - DB=mongodb
      - DB=redis
      - DB=mysql
    gemfile:
      - Gemfile
      - gemfiles/rails4.gemfile
      - gemfiles/rails31.gemfile
      - gemfiles/rails32.gemfile

This results in a 3×3×4 build matrix.
In order to exclude all jobs which have `rvm` value `2.0.0` and
`gemfile` value `Gemfile`, you can write:

    matrix:
      exclude:
        - rvm: 2.0.0
          gemfile: Gemfile

Which is equivalent to:

    matrix:
      exclude:
        - rvm: 2.0.0
          gemfile: Gemfile
          env: DB=mongodb
        - rvm: 2.0.0
          gemfile: Gemfile
          env: DB=redis
        - rvm: 2.0.0
          gemfile: Gemfile
          env: DB=mysql

### Explicit inclusion of jobs into the build matrix

It is also possible to include entries into the matrix with `matrix.include`:

    matrix:
      include:
        - rvm: ruby-head
          gemfile: gemfiles/Gemfile.rails-3.2.x
          env: ISOLATED=false

This will add the indicated job to the build matrix which has already
been built by the matrix dimensions explained above.

This is useful if you want to, say, only test the latest version of a
dependency together with the latest version of the runtime.

You can use this method to create a job matrix precisely from scratch.
For example,

    language: python
    matrix:
      include:
        - python: "2.7"
          env: TEST_SUITE=suite_2_7
        - python: "3.3"
          env: TEST_SUITE=suite_3_3
        - python: "pypy"
          env: TEST_SUITE=suite_pypy
    script: ./test.py $TEST_SUITE

will create a build matrix with 3 jobs, which runs test suite for each version
of Python.

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

### Fast finishing

If you've defined some rows in the build matrix that are allowed to fail, you might notice that the entire build won't be marked as finished until they have completed.
Or, a build won't be marked as failed until all of the jobs have finished, even if one has already failed.
You may want the build to finish as soon as possible.
To enable this, add `fast_finish: true` to the `matrix` section of your `.travis.yml` like this:

    matrix:
      fast_finish: true

Now, a build will finish as soon as a job has failed, or when the only jobs left allow failures.


## Implementing Complex Build Steps

For some builds and test runs, a more complex build environment is needed than what Travis CI's default setup offers. Complex dependencies are required, configuration files need to be patch, extra services need to be started.

These scenarios can lead to complex .travis.yml files, which may not be desirable, as they're harder to verify in our build environment and can potentially lead to YAML parsing errors, as some shell syntax features collide with YAML syntax.

Should your build require more than just a few steps to set up or run, consider moving the steps into a separate shell script. The script can be a part of your repository and can easily be called from the .travis.yml.

Consider a simple scenario where you want to run more complex test scenarios, but only for builds that aren't coming from pull requests. You could structure this script like so:

    #!/bin/bash
    set -ev
    bundle exec rake:units
    if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
      bundle exec rake test:integration
    fi

Note the `set -ev` at the top. The `-e` flag causes the script to exit as soon as one command returns a non-zero exit code. This can be handy if you want whatever script you have to exit early. It also helps in complex installation scripts where one failed command wouldn't otherwise cause the installation to fail.

The `-v` flag makes the shell print all lines in the script before executing them, which helps identify which steps failed.

Assuming the script above is stored as `scripts/run-tests.sh` in your repository, and with the right permissions too (run `chmod ugo+x scripts/run-tests.sh` before checking it in), you can call it from your .travis.yml:

    script: ./scripts/run-tests.sh

On top of reducing complexity of your build configuration, using scripts for your builds instead of building complex scenarios in your .travis.yml gives you more flexibility to figure out which steps should fail the build.

### How does this work? (Or, why you should not use `exit` in build steps)

The steps specified in the build lifecycle are compiled into a single bash script and executed on the worker.

When overriding these steps, do not use `exit` shell built-in command.
Doing so will run the risk of terminating the build process without giving Travis a chance to
perform subsequent tasks.

Using `exit` inside a custom script which will be invoked from during a build, of course, is acceptable.
