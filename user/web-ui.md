---
title: Web Interface
layout: en

---

This page lists settings that are only available in the Travis CI .com and .org web user interface.

## Build only if .travis.yml is present

## Limit concurrent jobs

{{ site.data.snippets.concurrent_jobs }}

## Build pushed branches

If *ON*, builds will be run on branches that are not [explcitiy excluded](/user/customizing-the-build/#Safelisting-or-blocklisting-branches) in your `.travis.yml`.

If *OFF* builds only run on branches that are [explcitiy included](/user/customizing-the-build/#Safelisting-or-blocklisting-branches).

## Build pushed pull requests

If *ON*, builds will be run new [pull requests](/user/pull-requests/).

## Auto cancel branch builds

{{ site.data.snippets.auto_cancellation }}

## Auto cancel pull request builds

{{ site.data.snippets.auto_cancellation }}

## Environment variables

## Cron jobs

## Caches

## Trigger a custom build
