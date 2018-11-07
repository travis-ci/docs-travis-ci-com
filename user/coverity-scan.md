---
title: Using Coverity Scan with Travis CI
layout: en

---

[Coverity Scan](http://scan.coverity.com) is a free static code analysis tool for Java, C, C++, and C#. It analyzes every line of code and potential execution path and produces a list of potential code defects. By augmenting your CI flow with Coverity Scan, you'll gain further insight into the quality of your code, beyond that which is covered by your automated tests.

This addon leverages the Travis CI infrastructure to automatically run code analysis on your GitHub projects.

## What is static analysis?

Static analysis is a set of processes for finding source code defects and vulnerabilities.

In static analysis, the code under examination is not executed. As a result, test cases and specially designed input datasets are not required. Examination for defects and vulnerabilities is not limited to the lines of code that are run during some number of executions of the code, but can include all lines of code in the codebase.

Additionally, Coverity's implementation of static analysis can follow all the possible paths of execution through source code (including interprocedurally) and find defects and vulnerabilities caused by the conjunction of statements that are not errors independent of each other.

See more details about Coverity Scan in the [FAQ](https://scan.coverity.com/faq).

## Build Submission Frequency

It's probably overkill to run static analysis on each and every commit of your project. To increase availability of the free service to more projects, the addon is designed by default to run analysis on a per-branch basis. We recommend you create a branch named `coverity_scan`, which you can merge into whenever you would like to trigger analysis. See the [FAQ](https://scan.coverity.com/faq#frequency) for information about build submission frequency.

## OS X / macOS support

The Coverity Scan addon doesn't work on OS X/macOS versions with the SIP feature enabled i.e. on OS X El Capitan (10.11) and higher. Specifically on Travis CI, it currently only works on our Xcode 6.4 image (i.e. with `osx_image: xcode6.4`). However, it's possible to make it work with custom scripts or commands. Please reach out to [support@travis-ci.com](mailto:support@travis-ci.com) to learn how.

## Step-by-step Configuration

1. [Sign up](http://scan.coverity.com/users/sign_up) with Coverity Scan using your GitHub account if you haven't already.

2. If necessary, create a public repo on [GitHub](https://github.com) for your project.

3. If necessary, register for [Travis CI](https://travis-ci.org/) and configure your project by following the [Getting Tutorial](/user/tutorial/) guide.

4. Sign in to Scan, and then add your project. Be sure to add it as a [GitHub Project](https://scan.coverity.com/projects/new?tab=github).

5. (Optional) The first time you use Coverity Scan with your project, you may want to do a build on a development machine of your own to be sure everything completes properly. This is optional but it will ease any necessary debugging. Consult the Coverity Scan [download page](https://scan.coverity.com/download) for instructions.

6. From the Coverity Scan Dashboard, click `Project Settings`. Then, on the right, click the `Submit build` button.

7. Assuming the project is properly registered via GitHub, you'll see a tab for `Configure Travis CI`. Visit that panel.

8. On the Travis CI Configuration page, you'll see a sample `.travis-yml` file. It will have auto-generated several of the necessary project-specific fields, including the encrypted Coverity Scan token (necessary to upload results). Copy the configuration from there into your `.travis.yml` file, making the changes in the next steps.

9. Fill in `build_command_prepend` with any configuration commands that are necessary to prepare your project to be built. For example `build_command_prepend: ./configure`

10. Fill in `build_command` with the command to build your project. This will be supplied as an argument to the `cov-build` command. For example: `build_command: make`

11. Commit those changes to the `coverity_scan` branch.

12. Push the `coverity_scan` branch to GitHub. Wait a few moment for Travis CI to see the commit, and for it to begin the build.

13. Visit [Travis CI](https://travis-ci.org) directly, or by clicking the button on your `Project Settings` page, which will appear once the project is activated on Travis CI.

### travis.yml

From your project page on Coverity Scan, select the Travis CI tab. You'll see a snippet of YAML to be copied over to your `.travis-ci` file. Note that this is an example, and might require some tweaking for the build to run properly.

```yaml
env:
  global:
    # COVERITY_SCAN_TOKEN
    # ** specific to your project **
    - secure: "xxxx"

addons:
  coverity_scan:

    # GitHub project metadata
    # ** specific to your project **
    project:
      name: my_github/my_project
      version: 1.0
      description: My Project

    # Where email notification of build analysis results will be sent
    notification_email: scan_notifications@example.com

    # Commands to prepare for build_command
    # ** likely specific to your build **
    build_command_prepend: ./configure

    # The command that will be added as an argument to "cov-build" to compile your project for analysis,
    # ** likely specific to your build **
    build_command: make

    # Pattern to match selecting branches that will run analysis. We recommend leaving this set to 'coverity_scan'.
    # Take care in resource usage, and consider the build frequency allowances per
    #   https://scan.coverity.com/faq#frequency
    branch_pattern: coverity_scan
```
{: data-file=".travis.yml"}

The project settings should be self-explanatory, and should match the values for the project configuration on Coverity Scan. The `branch_pattern` is a regular expression for the branches on which you want to run Coverity Scan. Please refer to the [FAQ](https://scan.coverity.com/faq) regarding build submission limits before enabling additional branches. We recommend leaving this set to `coverity_scan`.

The COVERITY_SCAN_TOKEN is encrypted and is obtained by using the [Travis CI CLI](https://github.com/travis-ci/travis). Coverity Scan provides this information on your Project's Travis CI tab for convenience, but you may also run it manually (see [Encryption Keys](/user/encryption-keys/) for more information on encryption).

```bash
gem install travis
cd my_project
travis encrypt COVERITY_SCAN_TOKEN=project_token_from_coverity_scan
```

Then copy the resulting line as shown in the YAML example.

## Environment Variables

When defined, the following environment variables overrides their
corresponding configuration values in `.travis.yml`:

1. `COVERITY_SCAN_NOTIFICATION_EMAIL`
2. `COVERITY_SCAN_BUILD_COMMAND`
3. `COVERITY_SCAN_BUILD_COMMAND_PREPEND`
4. `COVERITY_SCAN_BRANCH_PATTERN`

## Execution

The next time you commit to the appropriate branch, the Coverity Scan build process will automatically run analysis and upload the results. Please note that this analysis takes the place of the normal CI run. You should merge the same changes to another branch to run your tests.

### Disabling the Subsequent Test Run

Due to the way that Travis CI addons operate, your standard script stage (i.e. your tests) will run after the Coverity Scan analysis completes. In order to avoid this, you can modify your `script` directive in `.travis.yml`.

The `COVERITY_SCAN_BRANCH` environment variable will be set to `1` when the Coverity Scan addon is in operation. Therefore, you might change your script from

```yaml
script: make
```
{: data-file=".travis.yml"}

to

```bash
script: if [ ${COVERITY_SCAN_BRANCH} != 1 ]; then make ; fi
```

Be sure to replace `make` with your standard CI build command.
