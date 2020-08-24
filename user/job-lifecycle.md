---
title: Job Lifecycle
layout: en
redirect_from:
  - /user/build-lifecycle/
---

Travis CI provides a default build environment and a default set of phases for each programming language. A virtual machine is created with the build environment for your job, your repository is cloned into it, optional addons are installed and then your build phases are run.

Keep reading to see how you can customize any phase in this process, via your `.travis.yml` and have a look at the [Travis CI Build Config Reference](https://config.travis-ci.com/).

## The Build

The `.travis.yml` file describes the build process. A *build* in Travis CI is a sequence of [stages](/user/build-stages). Each *stage* consists of jobs run in parallel. 

## The Job Lifecycle

Each *job* is a sequence of [phases](../for-beginners/#builds-jobs-stages-and-phases). The *main phases* are:

1. `install` - install any dependencies required
2. `script` - run the build script

Travis CI can run custom commands in the phases:
1. `before_install` - before the install phase
1. `before_script` - before the script phase
1. `after_script` - after the script phase.
1. `after_success` - when the build *succeeds* (e.g. building documentation), the result is in `TRAVIS_TEST_RESULT` environment variable
1. `after_failure` - when the build *fails* (e.g. uploading log files), the result is in `TRAVIS_TEST_RESULT` environment variable

There are three optional *deployment phases*.

The complete sequence of phases of a job is the lifecycle. The steps are:

1. OPTIONAL Install [`apt addons`](/user/installing-dependencies/#installing-packages-with-the-apt-addon)
1. OPTIONAL Install [`cache components`](/user/caching)
1. `before_install`
1. `install`
1. `before_script`
1. `script`
1. OPTIONAL `before_cache` (if and only if caching is effective)
1. `after_success` or `after_failure`
1. OPTIONAL `before_deploy` (if and only if deployment is active)
1. OPTIONAL `deploy`
1. OPTIONAL `after_deploy` (if and only if deployment is active)
1. `after_script`

> A *build* can be composed of many jobs.


## Customizing the Installation Phase

The default dependency installation commands depend on the project language.
For instance, Java builds either use Maven or Gradle, depending on which build file is present in the repository. Ruby projects use Bundler when a Gemfile is present in the repository.

You can specify your own script to install your project dependencies:

```yaml
install: ./install-dependencies.sh
```
{: data-file=".travis.yml"}

> When using custom scripts, they should be executable (for example, using `chmod +x`) and contain a valid shebang line such as `/usr/bin/env sh`, `/usr/bin/env ruby`, or `/usr/bin/env python`.

You can also provide multiple steps, for instance to install both ruby and node dependencies:

```yaml
install:
  - bundle install --path vendor/bundle
  - npm install
```
{: data-file=".travis.yml"}

When one of the steps in the install fails, the build stops immediately and is marked as [errored](#breaking-the-build).

You can also use `apt-get` or `snap` to [install dependencies](/user/installing-dependencies/)

### Skipping the Installation Phase

Skip the installation step entirely by adding the following to your `.travis.yml`:

```yaml
install: skip
```
{: data-file=".travis.yml"}

## Customizing the Build Phase

The default build command depends on the project language. Ruby projects use `rake`, the common denominator for most Ruby projects.

You can overwrite the default build step in `.travis.yml`:

```yaml
script: bundle exec thor build
```
{: data-file=".travis.yml"}

You can specify multiple script commands as well:

```yaml
script:
- bundle exec rake build
- bundle exec rake builddoc
```
{: data-file=".travis.yml"}

When one of the build commands returns a non-zero exit code, the Travis CI build runs the subsequent commands as well and accumulates the build result.

In the example above, if `bundle exec rake build` returns an exit code of 1, the following command `bundle exec rake builddoc` is still run, but the build will result in a failure.

If your first step is to run unit tests, followed by integration tests, you may still want to see if the integration tests succeed when the unit tests fail.

You can change this behavior by using a little bit of shell magic to run all commands subsequently but still have the build fail when the first command returns a non-zero exit code. Here's the snippet for your `.travis.yml`

```yaml
script: bundle exec rake build && bundle exec rake builddoc
```
{: data-file=".travis.yml"}

This example (note the `&&`) fails immediately when `bundle exec rake build` fails.

### Note on $?

Each command in `script` is processed by a special bash function.
This function manipulates `$?` to produce logs suitable for display.
Consequently, you should not rely on the value of `$?` in `script` section to
alter the build behavior.
See [this GitHub issue](https://github.com/travis-ci/travis-ci/issues/3771)
for a more technical discussion.

### Complex Build Commands

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

> Note the `set -ev` at the top. The `-e` flag causes the script to exit as soon as one command returns a non-zero exit code. This can be handy if you want whatever script you have to exit early. It also helps in complex installation scripts where one failed command wouldn't otherwise cause the installation to fail.

The `-v` flag makes the shell print all lines in the script before executing them, which helps identify which steps failed.

To run that script from your `.travis.yml`:

1. Save it in your repository as `scripts/run-tests.sh`.
2. Make it executable by running `chmod ugo+x scripts/run-tests.sh`.
3. Commit it to your repository.
4. Add it to your `.travis.yml`:
    ```yaml
    script: ./scripts/run-tests.sh
    ```
    {: data-file=".travis.yml"}

#### How does this work? (Or, why you should not use `exit` in build steps)

The steps specified in the job lifecycle are compiled into a single bash script and executed on the worker.

When overriding these steps, do not use `exit` shell built-in command.
Doing so will run the risk of terminating the build process without giving Travis a chance to
perform subsequent tasks.

> Using `exit` inside a custom script is safe. If an error is indicated the task will be mark as failed.

## Breaking the Build

If any of the commands in the first four phases of the job lifecycle return a non-zero exit code, the build is broken:

- If `before_install`, `install` or `before_script` returns a non-zero exit code,
  the build is **errored** and stops immediately.
- If `script` returns a non-zero exit code, the build is **failed**, but continues to run before being marked as **failed**.

The exit code of `after_success`, `after_failure`, `after_script`, `after_deploy` and subsequent stages do not affect the build result.
However, if one of these stages times out, the build is marked as **failed**.

## Deploying your Code

An optional phase in the job lifecycle is deployment.
This phase is defined by using one of our continuous deployment providers to deploy code to Heroku, Amazon, or a different supported platform.
The deploy steps are skipped, if the build is broken.

When deploying files to a provider, prevent Travis CI from resetting your
working directory and deleting all changes made during the build ( `git stash
--all`) by adding `skip_cleanup` to your `.travis.yml`:

```yaml
deploy:
  skip_cleanup: true
```
{: data-file=".travis.yml"}

You can run commands before a deploy by using the `before_deploy` phase. A non-zero exit code in this phase will mark the build as **errored**.

If there are any steps you'd like to run after the deployment, you can use the `after_deploy` phase. 

> Note that `after_deploy` does not affect the status of the build.

> Note that `before_deploy` and `after_deploy` are run before and after every deploy provider, so they will run multiple times, if there are multiple providers.
