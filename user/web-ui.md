---
title: Web Interface
layout: en
---

This page lists settings that are only available in the Travis CI .com and .org web user interface.

<div id="toc"></div>

## Build only if .travis.yml is present

Limit builds to branches that contain `.travis.yml`. This is the default.

## Limit concurrent jobs

{{ site.data.snippets.concurrent_jobs }}

## Build pushed branches

If *ON*, builds will be run on branches that are not [explicitly excluded](/user/customizing-the-build/#Safelisting-or-blocklisting-branches) in your `.travis.yml`.

If *OFF* builds only run on branches that are [explicitly included](/user/customizing-the-build/#Safelisting-or-blocklisting-branches).

## Build pushed pull requests

If *ON*, builds will be run new [pull requests](/user/pull-requests/).

## Auto cancel branch builds

{{ site.data.snippets.auto_cancellation }}

## Auto cancel pull request builds

{{ site.data.snippets.auto_cancellation }}

## Environment variables

{{ site.data.snippets.environment_variables }}

More information on  [environment variables](/user/environment-variables/#Defining-Variables-in-Repository-Settings).

## Cron jobs

{{ site.data.snippets.cron_jobs }}

Check the full cron jobs docs for more information on [skipping and detecting cron jobs](/user/cron-jobs).

## Caches

More information on [caching](https://docs.travis-ci.com/user/caching).

## Trigger a custom build

Custom builds exist only on Travis CI and will not appear in your Git history.

> BETA Custom builds are a beta feature. Please provide feedback on [GitHub](https://github.com/travis-ci/beta-features/issues/27).
{: .beta}
