---
title: The Lifecycle of a Travis CI Build
permalink: build-lifecycle/
layout: en
---
Travis CI defines a couple of sensible defaults for all first class languages.

While you can use them, you have full control over every single step of the build, and you can customize them to your liking in your project's `.travis.yml`.

We'll cover a build's lifecycle and give an overview of where you can hook into.

<div id="toc"/></div>

### The Build Lifecycle

A build on Travis CI follows two simple steps: first, install any dependencies required, then run a script that effectively runs the build or the tests.

In Travis CI lingo, these steps are called `install` and `script`, respectively.

For a Ruby project, these steps default to running `bundle install` first, and then run `rake`, the build tool of choice for most Ruby projects. Here's a simple example of how this would look in a .travis.yml:

    install: bundle install
    script: bundle exec rake

Each step in the build's lifecycle gives you the means to hook in and run your own commands.

You can run steps before or after the installation step, and before or after the script step.

They're called `before_install`, `before_script` and `after_script`, respectively.

In a `before_install` step, you can install additional dependencies required by your project, Ubuntu packages for instance, or custom services, downloaded and installed from the internet.

When your build has either succeeded or failed, you can hook into that event by way of the `after_success` or `after_failure` options.

A common task for `after_success` is to generate documentation, or to upload a build artifact  to S3 for later use. You can also use this step to deploy your code to your staging or production servers, assuming you're using a means of deployment not yet supported by our built-in tooling.

`after_failure` can be used in similar ways, for example to upload any log files that could help debugging a failure to S3.

In both `after_failure` and `after_success`, you can access the build result using the `$TRAVIS_TEST_RESULT` environment variable.

The complete lifecycle is as follows:

1. `before_install`
2. `install`
3. `before_script`
4. `script`
5. `after_success` or `after_failure`
6. `after_script`

### Breaking the Build

If any of the commands in the first four stages above returns a non-zero exit code, Travis CI considers the build to be broken.

When any of the steps in the `before_install` or `install` stages fails with a non-zero exit code, the build will be marked as **errored**.

When any of the steps in the `before_script`, `script` or `after_script` stages fails with a non-zero exit code, the build will be marked as **failed**.

Please note that the `script` section has different semantics than the other
steps. When a step defined in `script` fails, the build doesn't end right away,
it continues to run the remaining steps before it fails the build.

Currently, neither the `after_success` nor `after_failure` have any influence on the build result. We have plans to change this behaviour.

### Deployment

An optional phase in the build lifecycle is deployment.

This step can't be overridden, but is defined by using one of our continuous deployment providers to deploy code to Heroku, Engine Yard, or a different supported platform.

If there are any steps you'd like to run after the deployment, you can use the `after_deploy` phase.

### Customizing Build Steps

You can override any of the existing steps or add new ones. Our [guide on customizing your build](/user/customizing-the-build) covers these topics.
