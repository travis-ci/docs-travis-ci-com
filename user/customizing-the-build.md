---
title: Customizing the Build
layout: en
permalink: /user/customizing-the-build/
redirect_from:
  - /user/build-configuration/
  - /user/build-lifecycle/
  - /user/how-to-skip-a-build/
  - /user/repository-providers/
---

<div id="toc"></div>

Travis CI provides a default build environment and a default set of steps for each programming language. You can customize any step in this process in `.travis.yml`.  Travis CI uses `.travis.yml` file in the root of your repository to learn about your project and how you want your builds to be executed. `.travis.yml` can be
very minimalistic or have a lot of customization in it. A few examples of what
kind of information your `.travis.yml` file may have:

- What programming language your project uses
- What commands or scripts you want to be executed before each build (for example, to install or clone your project's dependencies)
- What command is used to run your test suite
- Emails, Campfire and IRC rooms to notify about build failures

## The Build Lifecycle

A build on Travis CI is made up of two steps:

1. **install**: install any dependencies required
2. **script**: run the build script

You can run custom commands before the installation step (`before_install`), and before (`before_script`) or after (`after_script`) the script step.

In a `before_install` step, you can install additional dependencies required by your project such as Ubuntu packages or custom services.

You can perform additional steps when your build succeeds or fails using  the `after_success` (such as building documentation, or deploying to a custom server) or `after_failure` (such as uploading log files) options. In both `after_failure` and `after_success`, you can access the build result using the `$TRAVIS_TEST_RESULT` environment variable.

The complete build lifecycle, including three optional deployment steps and after checking out the git repository and changing to the repository directory, is:

1. OPTIONAL Install [`apt addons`](/user/installing-dependencies/#Installing-Packages-with-the-APT-Addon)
1. OPTIONAL Install [`cache components`](/user/caching)
1. `before_install`
1. `install`
1. `before_script`
1. `script`
1. OPTIONAL `before_cache` (for cleaning up cache)
1. `after_success` or `after_failure`
1. OPTIONAL `before_deploy`
1. OPTIONAL `deploy`
1. OPTIONAL `after_deploy`
1. `after_script`

## Customizing the Installation Step

The default dependency installation commands depend on the project language. For instance, Java builds either use Maven or Gradle, depending on which build file is present in the repository. Ruby projects use Bundler when a Gemfile is present in the repository.

You can specify your own script to run to install whatever dependencies your project requires in `.travis.yml`:

```yaml
install: ./install-dependencies.sh
```

> When using custom scripts they should be executable (for example, using `chmod +x`) and contain a valid shebang line such as `/usr/bin/env sh`, `/usr/bin/env ruby`, or `/usr/bin/env python`.

You can also provide multiple steps, for instance to install both ruby and node dependencies:

```yaml
install:
  - bundle install --path vendor/bundle
  - npm install
```

When one of the steps fails, the build stops immediately and is marked as [errored](#Breaking-the-Build).

### Skipping the Installation Step

You can skip the installation step entirely by adding the following to your `.travis.yml`:

```yaml
install: true
```

## Customizing the Build Step

The default build command depends on the project language. Ruby projects use `rake`, the common denominator for most Ruby projects.

You can overwrite the default build step in `.travis.yml`:

```yaml
script: bundle exec thor build
```

You can specify multiple script commands as well:

```yaml
script:
- bundle exec rake build
- bundle exec rake builddoc
```

When one of the build commands returns a non-zero exit code, the Travis CI build runs the subsequent commands as well, and accumulates the build result.

In the example above, if `bundle exec rake build` returns an exit code of 1, the following command `bundle exec rake builddoc` is still run, but the build will result in a failure.

If your first step is to run unit tests, followed by integration tests, you may still want to see if the integration tests succeed when the unit tests fail.

You can change this behavior by using a little bit of shell magic to run all commands subsequently but still have the build fail when the first command returns a non-zero exit code. Here's the snippet for your `.travis.yml`

```yaml
script: bundle exec rake build && bundle exec rake builddoc
```

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

- If `before_install`, `install` or `before_script` return a non-zero exit code,
  the build is **errored** and stops immediately.
- If `script` returns a non-zero exit code, the build is **failed**, but continues to run before being marked as **failed**.

The exit code of `after_success`, `after_failure`, `after_script` and subsequent stages do not affect the build result.
However, if one of these stages times out, the build is marked as a failure.

## Deploying your Code

An optional phase in the build lifecycle is deployment. This step can't be
overridden, but is defined by using one of our continuous deployment providers
to deploy code to Heroku, Engine Yard, or a different supported platform.

When deploying files to a provider, prevent Travis CI from resetting your
working directory and deleting all changes made during the build ( `git stash
--all`) by adding `skip_cleanup` to your `.travis.yml`:

```yml
deploy:
  skip_cleanup: true
```

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
> Look into [using the `apt` plug-in](/user/installing-dependencies/#Installing-Packages-on-Container-Based-Infrastructure) instead.

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

It is very common for test suites or build scripts to hang.
Travis CI has specific time limits for each job, and will stop the build and add an error message to the build log in the following situations:

- A job takes longer than 50 minutes on travis-ci.org
- A job takes longer than 120 minutes on travis-ci.com
- A job takes longer than 50 minutes on OSX infrastructure or travis-ci.org or travis-ci.com
- A job produces no log output for 10 minutes

Some common reasons why builds might hang:

- Waiting for keyboard input or other kind of human interaction
- Concurrency issues (deadlocks, livelocks and so on)
- Installation of native extensions that take very long time to compile

> There is no timeout for a build; a build will run as long as all the jobs do as long as each job does not timeout.

## Limiting Concurrent Builds

The maximum number of concurrent builds depends on the total system load, but
one situation in which you might want to set a particular limit is:

- if your build depends on an external resource and might run into a race
  condition with concurrent builds.

You can set the maximum number of concurrent builds in the settings pane for
each repository.

![Settings -> Limit concurrent builds](/images/screenshots/concurrent-builds-how-to.png)

Or using the command line client:

```bash
$ travis settings maximum_number_of_builds --set 1
```

## Building only the latest commit

If you are only interested in building the most recent commit on each branch you can use this new feature to automatically cancel older builds in the queue that are *not yet running*.

The *Auto Cancellation Setting* is in the Settings tab of each repository, and you can enable it separately for:

* *pushes* - which build your branch and appear in the *Build History* tab of your repository.

* *pull requests* - which build the future merge result of your feature branch against its target and appear in the *Pull Requests* tab of your repository.

![Auto cancellation setting](/images/autocancellation.png "Auto cancellation setting")

For example, in the following screenshot, we pushed commit `ca31c2b` to the branch `MdA-fix-notice` while builds #226 and #227 were queued. With the auto cancellation feature on, the builds #226 and #227 were automatically cancelled:  

![Auto cancellation example](/images/autocancellation-example.png "Auto cancellation example")


## Git Clone Depth

Travis CI clones repositories to a depth of 50 commits, which is only really useful if you are performing git operations.

> Please note that if you use a depth of 1 and have a queue of jobs, Travis CI won't build commits that are in the queue when you push a new commit.

You can set the [clone depth](http://git-scm.com/docs/git-clone) in `.travis.yml`:

```yaml
git:
  depth: 3
```

## Git Submodules

Travis CI clones git submodules by default, to avoid this set:

```yaml
git:
  submodules: false
```

## Git LFS Skip Smudge

You can disable the download of LFS objects when cloning ([`git lfs smudge
--skip`](https://github.com/git-lfs/git-lfs/blob/master/docs/man/git-lfs-smudge.1.ronn))
by setting the following in `.travis.yml`:

``` yml
git:
  lfs_skip_smudge: true
```

## Building Specific Branches

Travis CI uses the `.travis.yml` file from the branch containing the git commit that triggers the build. Include branches using a safelist, or exclude them using a blocklist.

### Safelisting or blocklisting branches

Specify which branches to build using a safelist, or blocklist branches that you do not want to be built:

```yml
# blocklist
branches:
  except:
  - legacy
  - experimental

# safelist
branches:
  only:
  - master
  - stable
```

> Note that safelisting also prevents tagged commits from being built. If you consistently tag your builds in the format `v1.3` you can safelist them all with [regular expressions](#Using-regular-expressions), for example `/^v\d+\.\d+(\.\d+)?(-\S*)?$/`.

If you use both a safelist and a blocklist, the safelist takes precedence. By default, the `gh-pages` branch is not built unless you add it to the safelist.

To build _all_ branches:

    branches:
      only:
        - gh-pages
        - /.*/

> Note that for historical reasons `.travis.yml` needs to be present *on all active branches* of your project.

### Using regular expressions

You can use regular expressions to safelist or blocklist branches:

```yaml
branches:
  only:
  - master
  - /^deploy-.*$/
```

Any name surrounded with `/` in the list of branches is treated as a regular expression and can contain any quantifiers, anchors or character classes supported by [Ruby regular expressions](http://www.ruby-doc.org/core-1.9.3/Regexp.html).

Options that are specified after the last `/` (e.g., `i` for case insensitive matching) are not supported but can be given inline instead.  For example, `/^(?i:deploy)-.*$/` matches `Deploy-2014-06-01` and other
branches and tags that start with `deploy-` in any combination of cases.

## Skipping a build

If you don't want to run a build for a particular commit for any reason, add `[ci skip]` or `[skip ci]` to the git commit message.

Commits that have `[ci skip]` or `[skip ci]` anywhere in the commit messages are ignored by Travis CI.

## Build Matrix

When you combine the three main configuration options of *Runtime*, *Environment* and *Exclusions/Inclusions* you have a matrix of all possible combinations.

Below is an example configuration for a build matrix that expands to *56 individual (7 * 4 * 2)* jobs.

```yaml
rvm:
  - 1.9.3
  - 2.0.0
  - 2.2
  - ruby-head
  - jruby
  - rbx-2
  - ree
gemfile:
  - gemfiles/Gemfile.rails-2.3.x
  - gemfiles/Gemfile.rails-3.0.x
  - gemfiles/Gemfile.rails-3.1.x
  - gemfiles/Gemfile.rails-edge
env:
  - ISOLATED=true
  - ISOLATED=false
```

You can also define exclusions to the build matrix:

```yaml
matrix:
  exclude:
  - rvm: 1.9.3
    gemfile: gemfiles/Gemfile.rails-2.3.x
    env: ISOLATED=true
  - rvm: jruby
    gemfile: gemfiles/Gemfile.rails-2.3.x
    env: ISOLATED=true
```

> All build matrixes are currently limited to a maximum of **200 jobs** for both private and public repositories. If you are on an open-source plan, please remember that Travis CI provides this service free of charge to the community. So please only specify the matrix you *actually need*.

### Excluding Jobs

If the jobs you want to exclude from the build matrix share the same matrix
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

### Explicitly Including Jobs

It is also possible to include entries into the matrix with `matrix.include`:

```yaml
matrix:
  include:
  - rvm: ruby-head
    gemfile: gemfiles/Gemfile.rails-3.2.x
    env: ISOLATED=false
```

This adds a particular job to the build matrix which has already been populated.

This is useful if you want to only test the latest version of a dependency together with the latest version of the runtime.

You can use this method to create a build matrix containing only specific combinations.
For example,

```yaml
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
```

creates a build matrix with 3 jobs, which runs test suite for each version
of Python.

#### Explicitly Included Jobs need complete definitions

When including jobs, it is important to ensure that each job defines a unique value
to any matrix dimension that the matrix defines.

For example, with a 3-job Python build matrix, each job in `matrix.include` must also
have the `python` value defined:

```yaml
language: python
python:
  - '3.5'
  - '3.4'
  - '2.7'
matrix:
  include:
    - python: '3.5'
      env: EXTRA_TESTS=true
    - python: '3.4'
      env: EXTRA_TESTS=true
script: env $EXTRA_TESTS ./test.py $TEST_SUITE
```

### Rows that are Allowed to Fail

You can define rows that are allowed to fail in the build matrix. Allowed
failures are items in your build matrix that are allowed to fail without causing
the entire build to fail. This lets you add in experimental and
preparatory builds to test against versions or configurations that you are not
ready to officially support.

Define allowed failures in the build matrix as key/value pairs:

```yaml
matrix:
  allow_failures:
  - rvm: 1.9.3
```

#### Matching Jobs with `allow_failures`

When matching jobs against the definitions given in `allow_failures`, _all_
conditions in `allow_failures` must be met exactly, and
all the keys in `allow_failures` element must exist in the
top level of the build matrix (i.e., not in `matrix.include`).

##### `allow_failures` Examples

Consider

```yaml
language: ruby

rvm:
- 2.0.0
- 2.1.6

env:
  global:
  - SECRET_VAR1=SECRET1
  matrix:
  - SECRET_VAR2=SECRET2

matrix:
  allow_failures:
    - env: SECRET_VAR1=SECRET1 SECRET_VAR2=SECRET2
```

Here, no job is allowed to fail because no job has the `env` value
`SECRET_VAR1=SECRET1 SECRET_VAR2=SECRET2`.

Next,

```yaml
language: php
php:
- 5.6
- 7.0
env: # important!
matrix:
  include:
  - php: 7.0
    env: KEY=VALUE
  allow_failures:
  - php: 7.0
    env: KEY=VALUE
```

Without the top-level `env`, no job will be allowed to fail.

### Fast Finishing

If some rows in the build matrix are allowed to fail, the build won't be marked as finished until they have completed.

To mark the build as finished as soon as possible, add `fast_finish: true` to the `matrix` section of your `.travis.yml` like this:

```yaml
matrix:
  fast_finish: true
```

Now, the build result will be determined as soon as all the required jobs finish, based on these results, while the rest of the `allow_failures` jobs continue to run.

## Implementing Complex Build Steps

If you have a complex build environment that is hard to configure in the `.travis.yml`, consider moving the steps into a separate shell script.
The script can be a part of your repository and can easily be called from the `.travis.yml`.

Consider a scenario where you want to run more complex test scenarios, but only for builds that aren't coming from pull requests. A shell script might be:

```bash
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

```
script: ./scripts/run-tests.sh
```

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

```yaml
addons:
  hosts:
  - travis.dev
  - joshkalderimis.com
```

## What repository providers or version control systems can I use?

Build and test your open source projects hosted on GitHub on [travis-ci.org](https://travis-ci.org/).

Build and test your private repositories hosted on GitHub on [travis-ci.com](https://travis-ci.com/).

Travis CI currently does not support git repositories hosted on Bitbucket or GitLab, or other version control systems such as Mercurial.

## Troubleshooting

Check out the list of [common build problems](/user/common-build-problems/).
