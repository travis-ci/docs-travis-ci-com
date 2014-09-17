---
title: Customizing the Build
layout: en
permalink: customizing-the-build/
---

<div id="toc"></div>

Travis CI provides a default build environment and a default set of steps for specific programming languages.

But it's easy to customize these steps to your needs. You can override the default steps run for installing dependencies and running your build, you can patch configuration files, you can install custom Ubuntu packages.

All commands are run in the directory where your repository is checked out.

## Customizing the Installation Step

By default, we run familiar commands to install their respective dependencies. For instance, Java builds either use Maven or Gradle, depending on which build file is present in the repository. For Ruby projects, we use Bundler by default, but only if a Gemfile is present in the repository.

You can specify your own script to run to install whatever dependencies your project requires. Here's an example for your .travis.yml:

    install: ./install-dependencies.sh

You can also provide multiple steps, for instance to install a Ubuntu package as part of your build:

    install:
      - sudo apt-get update -qq
      - sudo apt-get install
      - bundle install --path vendor/bundle

When one of the steps fails, the build stops immediately and is marked as errored.

## Customizing the Build Step

The build step can be customized as well.

For Ruby projects, we run the `rake` command by default, the most common denominator for most Ruby projects.

You can overwrite the default, here's the excerpt from the .travis.yml:

    script: bundle exec thor build

You can specify multiple script commands as well:

    script:
      - bundle exec rake build
      - bundle exec rake builddoc

Other than the installation step, when one of the commands listed returns a non-zero exit code, the Travis CI build runs the subsequent commands as well, and accumulates the build result.

In the example above, if `bundle exec rake build` returns an exit code of 1, the following command `bundle exec rake builddoc` will still be run, but the build will result in a failure.

If your first step is to run unit tests, followed by integration tests, you may still want to see if the integration tests succeed when the unit tests fail.

You can change this behavior by using a little bit of shell magic to run all commands subsequently but still have the build fail when the first command returns a non-zero exit code. Here's the snipped for your .travis.yml

    script: bundle exec rake build && bundle exec rake builddoc

This example (note the `&&`) will fail immediately when `bundle exec rake build` fails.

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

## How does this work? (Or, why you should not use `exit` in build steps)

The steps specified in the build lifecycle are compiled into a single bash script and executed on the worker.

When overriding these steps, do not use `exit` shell built-in command.
Doing so will run the risk of terminating the build process without giving Travis a chance to
perform subsequent tasks.

Using `exit` inside a custom script which will be invoked from during a build, of course, is acceptable.
