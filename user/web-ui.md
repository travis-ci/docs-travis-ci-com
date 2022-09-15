---
title: Web Interface
layout: en
---

This page lists settings that are only available in the Travis CI .com web user interface.



## Limit concurrent jobs

{{ site.data.snippets.concurrent_jobs }}

## Build pushed branches

If *ON*, builds will be run on branches that are not [explicitly excluded](/user/customizing-the-build/#safelisting-or-blocklisting-branches) in your `.travis.yml`.

If *OFF*, builds won't run on pushed commits on branches.

## Build pushed pull requests

If *ON*, builds will be run on new [pull requests](/user/pull-requests/).

## User Management

Simple 'trigger build' control. Allow or prevent users with appropriate access to the repository to trigger a build for the repository. By default, all synchronized users with access to the repository are allowed to trigger a build.

## Share encrypted variables with forks

In the case of a fork-to-base pull request:

* If this setting is ON, the encrypted environment variables will be available to the forked repository, which means that builds in the forked repository will have access to the encrypted environment variables from the base repository. This may be a less secure approach yet allows for a collaboration using forks and Pull Requests (PRs).
* If this setting is OFF and the build relies on any encrypted environment variable, the PR from fork to base repository will fail. This secures your base repository encrypted environmental variables by putting a constraint on accessing them from forks.

Read more: [Pull Requests and security restrictions](/user/pull-requests#pull-requests-and-security-restrictions)

## Share SSH Keys with forks

In the case of a fork-to-base pull request:

* If this setting is ON, the custom SSH keys from the base repository will be available to the forked repository, which means that the build in the forked repository will be able to use the custom SSH keys from the base repository. Consider setting to ON if your collaboration model requires working with Pull Requests (PRs) from forked repositories or there are dependencies defined, which rely on SSH key from base repository.
* If this setting is OFF and the build is relying on custom SSH keys i.e. for fetching some additional dependencies, it will fail with a no access error.

Read more: [Pull Requests and security restrictions](/user/pull-requests#pull-requests-and-security-restrictions)

## Auto cancel branch builds

{{ site.data.snippets.auto_cancellation }}

## Auto cancel pull request builds

{{ site.data.snippets.auto_cancellation }}

## Environment variables

{{ site.data.snippets.environment_variables }}

More information on  [environment variables](/user/environment-variables/#defining-variables-in-repository-settings).

## Cron jobs

{{ site.data.snippets.cron_jobs }}

Check the full cron jobs docs for more information on [skipping and detecting cron jobs](/user/cron-jobs).

## Caches

More information on [caching](/user/caching).

## Trigger a custom build

Custom builds exist only on Travis CI and will not appear in your Git history.

> BETA Custom builds are a beta feature. Please provide feedback on [GitHub](https://github.com/travis-ci/beta-features/issues/27).
{: .beta}
