---
title: Customizing the Build
layout: en
permalink: /user/customizing-the-build/
redirect_from:
  - /user/build-configuration/
  - /user/build-lifecycle/
  - /user/how-to-skip-a-build/
---

<div id="toc"></div>

Travis CI provides a default build environment and a default set of steps for each programming language. You can customize any step in this process in `.travis.yml`.  Travis CI uses `.travis.yml` file in the root of your repository to learn about your project and how you want your builds to be executed. `.travis.yml` can be
very minimalistic or have a lot of customization in it. A few examples of what
kind of information your `.travis.yml` file may have:

* What programming language your project uses
* What commands or scripts you want to be executed before each build (for example, to install or clone your project's dependencies)
* What command is used to run your test suite
* Emails, Campfire and IRC rooms to notify about build failures

## The Build Lifecycle

A build on Travis CI is made up of two steps:

1. **install**: install any dependencies required
2. **script**: run the build script

You can run custom commands before the installation step (`before_install`), and before (`before_script`) or after (`after_script`) the script step.

In a `before_install` step, you can install additional dependencies required by your project such as Ubuntu packages or custom services.

You can perform additional steps when your build succeeds or fails using  the `after_success` (such as building documentation, or deploying to a custom server) or `after_failure` (such as uploading log files) options. In both `after_failure` and `after_success`, you can access the build result using the `$TRAVIS_TEST_RESULT` environment variable.

The complete build lifecycle, including three optional deployment steps and after checking out the git repository and changing to the repository directory, is:

1. `before_install`
2. `install`
3. `before_script`
4. `script`
5. `after_success` or `after_failure`
6. OPTIONAL `before_deploy`
7. OPTIONAL `deploy`
8. OPTIONAL `after_deploy`
9. `after_script`


## Customizing the Installation Step

The default dependency installation commands depend on the project language. For instance, Java builds either use Maven or Gradle, depending on which build file is present in the repository. Ruby projects use Bundler when a Gemfile is present in the repository.

You can specify your own script to run to install whatever dependencies your project requires in `.travis.yml`:

    install: ./install-dependencies.sh

> When using custom scripts they should be executable (for example, using `chmod +x`) and contain a valid shebang line such as `/usr/bin/env sh`, `/usr/bin/env ruby`, or `/usr/bin/env python`.

You can also provide multiple steps, for instance to install both ruby and node dependencies:

    install:
      - bundle install --path vendor/bundle
      - npm install

When one of the steps fails, the build stops immediately and is marked as [errored](#Breaking-the-Build).

### Skipping the Installation Step

You can skip the installation step entirely by adding the following to your `.travis.yml`:

	install: true

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

### Note on $?

Each command in `script` is processed by a special bash function.
This function manipulates `$?` to produce logs suitable for display.
Consequently, you should not rely on the value of `$?` in `script` section to
alter the build behavior.
See [this GitHub issue](https://github.com/travis-ci/travis-ci/issues/3771)
for a more technical discussion.

## Breaking the Build

If any of the commands in the first four stages of the build lifecycle return a non-zero exit code, the build is broken:

* If `before_install`, `install` or `before_script` return a non-zero exit code,
the build is **errored** and stops immediately.
* If `script` returns a non-zero exit code, the build is **failed**, but continues to run before being marked as **failed**.

The `after_success`, `after_failure`, `after_script` and subsequent stages do not affect the the build result.

## Deploying your Code

An optional phase in the build lifecycle is deployment. This step can't be
overridden, but is defined by using one of our continuous deployment providers
to deploy code to Heroku, Engine Yard, or a different supported platform.

When deploying files to a provider, prevent Travis CI from resetting your
working directory and deleting all changes made during the build ( `git stash
--all`) by adding `skip_cleanup` to your `.travis.yml`:

	deploy:
		skip_cleanup: true

You can run steps before a deploy by using the `before_deploy` phase. A non-zero exit code in this command will mark the build as **errored**.

If there are any steps you'd like to run after the deployment, you can use the `after_deploy` phase.

## Specifying Runtime Versions

One of the key features of Travis CI is the ease of running your test suite against multiple runtimes and versions. Specify what languages and runtimes to run your test suite against in the `.travis.yml` file:

{% include languages.html %}

## Installing Packages Using apt

If your dependencies need native libraries to be available, you can use **passwordless sudo to install them**:

```yml
before_install:
	- sudo apt-get update -qq
	- sudo apt-get install -qq [packages list]
```

> Note that this feature is not available for builds that are running on [Container-based workers](/user/ci-environment/#Virtualization-environments).
> Look into [using the `apt` plug-in](/user/apt/) instead.

All virtual machines are snapshotted and returned to their intial state after each build.

### Using 3rd-party PPAs

If you need a native dependency that is not available from the official Ubuntu repositories, there might be a [3rd-party PPAs](https://launchpad.net/ubuntu/+ppas) that you can use.

## Installing a Second Programming language

If you need to install a second programming language in your current build environment, for example installing a more recent version of Ruby than the default version present in all build environments you can do so in the `before_install` stage of the build:

```yml
before_install:
   - rvm install 2.1.5
```

You can also use other installation methods such as `apt-get`.

## Build Timeouts

Because it is very common for test suites or build scripts to hang, Travis CI has specific time limits for each job. If a script or test suite takes longer than 50 minutes (or 120 minutes on travis-ci.com), or if there is not log output for 10 minutes, it is terminated, and a message is written to the build log.

Some common reasons why builds might hang:

* Waiting for keyboard input or other kind of human interaction
* Concurrency issues (deadlocks, livelocks and so on)
* Installation of native extensions that take very long time to compile

> There is no timeout for a build; a build will run as long as all the jobs do as long as each job does not timeout.

## Limiting Concurrent Builds

The maximum number of concurrent builds depends on the total system load, but
one situation in which you might want to set a particular limit is:

* if your build depends on an external resource and might run into a race
  condition with concurrent builds.

You can set the maximum number of concurrent builds in the settings pane for
each repository.  

![Settings -> Limit concurrent builds](/images/screenshots/concurrent-builds-how-to.png)

Or using the command line client:

	$ travis settings maximum_number_of_builds --set 1




## Building Specific Branches

Travis CI uses the `.travis.yml` file from the branch specified by the git commit that triggers the build. You can tell Travis to build multiple branches using blacklists or whitelists.

### Whitelisting or blacklisting branches

Specify which branches to build using a whitelist, or blacklist branches that you do not want to be built:

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

If you specify both, `only` takes precedence over `except`. By default, `gh-pages` branch is not built unless you add it to the whitelist.

> Note that for historical reasons `.travis.yml` needs to be present *on all active branches* of your project.

### Using regular expressions ###

You can use regular expressions to whitelist or blacklist branches:

    branches:
      only:
        - master
        - /^deploy-.*$/

Any name surrounded with `/` in the list of branches is treated as a regular expression and can contain any quantifiers, anchors or character classes supported by [Ruby regular expressions](http://www.ruby-doc.org/core-1.9.3/Regexp.html).

Options that are specified after the last `/` (e.g., `i` for case insensitive matching) are not supported but can be given inline instead.  For example, `/^(?i:deploy)-.*$/` matches `Deploy-2014-06-01` and other
branches and tags that start with `deploy-` in any combination of cases.

## Skipping a build

If you don't want to run a build for a particular commit, because all you are
changing is the README for example, add `[ci skip]` to the git commit message.

Commits that have `[ci skip]` anywhere in the commit messages are ignored by
Travis CI.

## Build Matrix

When you combine the three main configuration options of *Runtime*, *Environment* and *Exclusions/Inclusions* you have a matrix of all possible combinations.

Below is an example configuration for a build matrix that expands to *56 individual (7 * 4 * 2)* builds.

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

> Please take into account that Travis CI is an open source service and we rely on worker boxes provided by the community. So please only specify as big a matrix as you *actually need*.

### Excluding Builds

If the builds you want to exclude from the matrix share the same matrix
parameters, you can specify only those and omit the varying parts.

Suppose you have:

```yml
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
```

This results in a 3×3×4 build matrix. To exclude all jobs which have `rvm` value `2.0.0` *and*
`gemfile` value `Gemfile`, you can write:

```yml
matrix:
	exclude:
	- rvm: 2.0.0
		gemfile: Gemfile
```

Which is equivalent to:

```yml
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
```

### Explicity Including Builds

It is also possible to include entries into the matrix with `matrix.include`:

    matrix:
      include:
        - rvm: ruby-head
          gemfile: gemfiles/Gemfile.rails-3.2.x
          env: ISOLATED=false

This adds a particular job to the build matrix which has already been populated.

This is useful if you want to only test the latest version of a dependency together with the latest version of the runtime.

You can use this method to create a job matrix containing only specific combinations.
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

creates a build matrix with 3 jobs, which runs test suite for each version
of Python.

### Rows that are Allowed to Fail

You can define rows that are allowed to fail in the build matrix. Allowed
failures are items in your build matrix that are allowed to fail without causing
the entire build to fail. This lets you add in experimental and
preparatory builds to test against versions or configurations that you are not
ready to officially support.

Define allowed failures in the build matrix as key/value pairs:

    matrix:
      allow_failures:
        - rvm: 1.9.3

### Fast Finishing

If some rows in the build matrix that are allowed to fail, the build won't be marked as finished until they have completed.

To set the build to finish as soon as possible, add `fast_finish: true` to the `matrix` section of your `.travis.yml` like this:

    matrix:
      fast_finish: true

Now, a build will finish as soon as a job has failed, or when the only jobs left allow failures.


## Implementing Complex Build Steps

If you have a complex build environment that is hard to configure in the `.travis.yml`, consider moving the steps into a separate shell script.
The script can be a part of your repository and can easily be called from the `.travis.yml`.

Consider a scenario where you want to run more complex test scenarios, but only for builds that aren't coming from pull requests. A shell script might be:

```sh
#!/bin/bash
set -ev
bundle exec rake:units
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
	bundle exec rake test:integration
fi
```

Note the `set -ev` at the top. The `-e` flag causes the script to exit as soon as one command returns a non-zero exit code. This can be handy if you want whatever script you have to exit early. It also helps in complex installation scripts where one failed command wouldn't otherwise cause the installation to fail.

The `-v` flag makes the shell print all lines in the script before executing them, which helps identify which steps failed.

Assuming the script above is stored as `scripts/run-tests.sh` in your repository, and with the right permissions too (run `chmod ugo+x scripts/run-tests.sh` before checking it in), you can call it from your `.travis.yml`:

    script: ./scripts/run-tests.sh

### How does this work? (Or, why you should not use `exit` in build steps)

The steps specified in the build lifecycle are compiled into a single bash script and executed on the worker.

When overriding these steps, do not use `exit` shell built-in command.
Doing so will run the risk of terminating the build process without giving Travis a chance to
perform subsequent tasks.

Using `exit` inside a custom script which will be invoked from during a build is fine.

## Custom Hostnames

If your build requires setting up custom hostnames, you can specify a single host or a
list of them in your .travis.yml. Travis CI will automatically setup the
hostnames in `/etc/hosts` for both IPv4 and IPv6.

    addons:
      hosts:
        - travis.dev
        - joshkalderimis.com


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

    https://github.com/someuser/somelibrary.git

Otherwise, Travis CI builders won't be able to clone your project because they don't have your private SSH key.
