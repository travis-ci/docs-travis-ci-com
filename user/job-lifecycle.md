---
title: Job Lifecycle
layout: en
redirect_from:
  - /user/build-lifecycle/
---

Travis CI provides a default build environment and a default set of phases for each programming language. It creates a virtual machine with the build environment for your job, clones your repository into it, installs optional add-ons, and runs your build phases as specified.

Custom [build stages](user/build-stages) will probably be used later for more complex build definitions. Understanding how each job goes through the job lifecycle phases is important, as you may use these to customize your build definitions.

In this section, learn the job lifecycle process and how to customize any phase of the build process. 

> **Note:** Before continuing, ensure you understand our basic terminology. See our [core concepts documentation](/user/for-beginners/#build-jobs-stages-and-phases) and have a look at the [Travis CI Build Config Reference](https://config.travis-ci.com/) for more information.

## Job Lifecycle Phases

The ‘.travis.yml’ file describes the build process for Travis CI. A *build* in Travis CI consists of at least one unnamed stage or a sequence of [stages](/user/build-stages/). Each *stage* consists of one or more *jobs* running parallel inside the stage.

![Build, Stages, and Jobs Diagram](/user/images/Build-stages-jobs.png)

Each *job* is a sequence of *phases*, which are sequential steps that form a job. The following table shows the main phases that users can add to jobs. 

| **Pre-Install Phase (Optional)** | **Install Phase** | **Script Phase** | **Deploy Phase (Optional)** |
|---|---|---|---|
| Travis CI can run these optional commands in this phase:<br>- [`apt addons`](/user/installing-dependencies/#installing-packages-with-the-apt-addon)<br>- `before_cache` (if and only if caching is effective)<br>- [`cache components`](/user/caching/) | Travis CI can run the following custom commands in this main phase:<br>- `install`: installs any dependencies required.<br>  - `before_install`: before the install phase.<br>  - `before_script`: before the script phase.<br>  - `after_script`: after the script phase.<br>  - `after_success`: when the build *succeeds* (e.g., building documentation), the result is in the `TRAVIS_TEST_RESULT` environment variable.<br>  - `after_failure`: when the build *fails* (e.g., uploading log files), the result is in the `TRAVIS_TEST_RESULT` environment variable. | Travis CI can run the following custom commands in this main phase:<br>- `script`: run the build script.<br>  - `before_install`: before the install phase.<br>  - `before_script`: before the script phase.<br>  - `after_script`: after the script phase.<br>  - `after_success`: when the build *succeeds* (e.g., building documentation), the result is in the `TRAVIS_TEST_RESULT` environment variable.<br>  - `after_failure`: when the build *fails* (e.g., uploading log files), the result is in the `TRAVIS_TEST_RESULT` environment variable. | Travis CI can run custom commands in the phases:<br>- `deploy`: optional deployment phase.<br>- `before_deploy`: (if and only if deployment is active)<br>- `after_deploy`: (if and only if deployment is active) |

 > **Note**: A *build* can be composed of many jobs.

The following is an example of the complete sequence of phases of a job lifecycle. 

```yaml
`apt addons:`  //optional
`cache components:` //optional
`before_install:`
`install:`
`before_script:`
`script:`
`before_cache:` //optional (if and only if caching is effective)
`after_success` or `after_failure`
`before_deploy:` //optional (if and only if deployment is active)
`deploy:` //optional
`after_deploy:` //optional (if and only if deployment is active)
`after_script:`
```
{: data-file=".travis.yml"}


## Customize the Installation Phase

The default dependency installation commands depend on the chosen project language.
For instance, *Java* builds use Maven or Gradle, depending on which build file is in the repository. *Ruby* projects use Bundler when a Gemfile is in the repository.

Install your project dependencies by specifying a script as follows:

```yaml
install: ./install-dependencies.sh
```
{: data-file=".travis.yml"}

> When using custom scripts, they should be executable (for example, using `chmod +x`) and contain a valid shebang line such as `/usr/bin/env sh`, `/usr/bin/env ruby`, or `/usr/bin/env python`.

You can also provide multiple steps, for instance, to install both ruby and node dependencies and update your file as shown below:

```yaml
install:
  - bundle install --path vendor/bundle
  - npm install
```
{: data-file=".travis.yml"}

If a step fails during installation, the build stops immediately and is marked as [errored](#breaking-the-build).


You can also use `apt-get` or `snap` to [install dependencies](/user/installing-dependencies/)

### Skip the Installation Phase

Skip the installation step entirely by adding the following to your `.travis.yml` file:

```yaml
install: skip
```
{: data-file=".travis.yml"}

## Customize the Build Phase

The default build command depends on the project language. *Ruby* projects use `rake`, the common denominator for most *Ruby* projects.

You can overwrite the default build step in `.travis.yml` as follows:

```yaml
script: bundle exec thor build
```
{: data-file=".travis.yml"}

Or, specify multiple script commands as shown below:

```yaml
script:
- bundle exec rake build
- bundle exec rake builddoc
```
{: data-file=".travis.yml"}

When one of the build commands returns a non-zero exit code, the Travis CI build runs the subsequent commands and accumulates the build result.

In the example above, if `bundle exec rake build` returns an exit code of “1”. Thus, the following command, `bundle exec rake build doc,` still runs, but the build will fail.

If your first step is to run unit tests, followed by integration tests, you may still want to see if the integration tests succeed when the unit tests fail.

Change this behavior by using shell magic to run all commands subsequently, but the build still fails when the first command returns a non-zero exit code. Here's the snippet for your `.travis.yml` file:

```yaml
script: bundle exec rake build && bundle exec rake builddoc
```
{: data-file=".travis.yml"}

The example above fails immediately when `bundle exec rake build` fails. Note the `&&`

### Use the $? Command

Each command in `script` is processed by a special bash function. This function manipulates the `$?` command to produce logs suitable for display. Consequently, you should not rely on the value of `$?` in the `script` section to alter the build behavior.

See this [GitHub issue](https://github.com/travis-ci/travis-ci/issues/3771)
for a more technical discussion.

### Complex Build Commands

If you have a complex build environment that is hard to configure in the `.travis.yml` file, consider moving the steps into a separate shell script.

The script can be a part of your repository and can easily be called from the `.travis.yml` file.

Consider a scenario where you want to run more complex test scenarios but only for builds that aren't coming from pull requests. In such case, a shell script might look like the following:

```bash
#!/bin/bash
set -ev
bundle exec rake:units
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  bundle exec rake test:integration
fi
```
{: data-file=".bash"}

> Note the `set -ev` at the top. The `-e` flag causes the script to exit once one command returns a non-zero exit code. This is handy if you want a script to exit early. It also helps in complex installation scripts where one failed command wouldn't cause the installation to fail.

The `-v` flag makes the shell print all lines in the script before executing them, which helps identify which steps failed.

Follow these steps to run that script from your `.travis.yml` file:

1. Save it in your repository as `scripts/run-tests.sh`.
2. Make it executable by running `chmod ugo+x scripts/run-tests.sh`.
3. Commit it to your repository.
4. Add it to your `.travis.yml` file:
    ```yaml
    script: ./scripts/run-tests.sh
    ```
    {: data-file=".travis.yml"}

#### Use the exit Command 

After specifying the steps in the job lifecycle, these are compiled into a single bash script and executed on the worker.

If you need to override the specified steps, do not use the `exit` shell built-in command. Doing so risks terminating the build process without allowing Travis to perform the subsequent tasks.

In contrast, using the `exit` command inside a custom script is safe. If an error is indicated, the task will be marked as failed.

## Breaking the Build

The build is considered broken when one or more of its jobs complete with a state that is not passed.

The build is broken if any of the commands in the first four phases of the job lifecycle return a non-zero exit code.

The following are common build problem scenarios: 
- If `before_install`, `install`, or `before_script` returns a non-zero exit code,
  Then the build is **errored** and stops immediately.
- If `script` returns a non-zero exit code, the build results in **failed**, but continues running before being marked as **failed**.

The exit code of `after_success`, `after_failure`, `after_script`, `after_deploy`, and subsequent stages do not affect the build result. However, if one of these stages times out, the build is marked as **failed**.

To troubleshoot more common issues, see our [Common Builds Problems](/user/common-build-problems/) documentation.

## Code Deployment

Deployment is an optional phase in the job lifecycle. It is defined by using one of our continuous deployment providers to deploy code to Heroku, Amazon, or a different supported platform.

If the build is broken, the deploy steps are skipped.

When deploying files to a provider, prevent Travis CI from resetting your
working directory and deleting all changes made during the build ( `git stash --all`) by adding a `skip_cleanup` command to your `.travis.yml` file:

```yaml
deploy:
  skip_cleanup: true
```
{: data-file=".travis.yml"}

The `before_deploy` phase allows you to run commands before deployment. A non-zero exit code in this phase will mark the build as **errored**.

You can use the `after_deploy` phase to run any steps after the deployment.

> Note that `after_deploy` does not affect the build's status.

> **Note:** The `before_deploy` and `after_deploy` phases run before and after every deploy provider, so they run multiple times if numerous providers exist.
