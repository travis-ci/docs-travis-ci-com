---
title: Build lifecycle
layout: en
permalink: /user/essentials/build-lifecycle/
redirect_from:
  - /user/build-configuration/
  - /user/how-to-skip-a-build/
  - /user/repository-providers/
---

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
