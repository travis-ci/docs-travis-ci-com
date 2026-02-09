---
title: Cron Jobs
layout: en

---



{{ site.data.snippets.cron_jobs }}


Configure cron jobs from the "Cron Jobs" settings tab on your Travis CI page.

![settings page with cron section](/images/cron-section.png "settings page with cron section")

{{ site.data.snippets.ghlimit }}

## Add Cron Jobs

Add Cron jobs by filling out the following fields and clicking the Add button
- **Branch** - Select the branch on which to run the build.
- **Interval** - Select how often to run the build: `daily`, `weekly`, or `monthly`.
- **Options** - Select between the option to `Always run` or `Do not run if there has been a build in the last 24h`.

![adding a cron job](/images/cron-adding.png "adding a cron job")

Confirm that the cron job is displayed in your settings tab:

![cron job created](/images/cron-created.png "cron job created")

## Skip Cron Jobs

Please note that cron jobs will run regardless and cannot be skipped even with [ci skip] in the latest commit message.

## Delete Cron Jobs

Click the small trash icon on the right-hand side of the page:

![deleting a cron job](/images/cron-deleting.png "deleting a cron job")

## Detect Builds Triggered by Cron

To check whether a build was triggered by cron, examine the `TRAVIS_EVENT_TYPE` environment variable to see if it has the value `cron`.

## Notifications

Cron job builds use the same [notification settings](https://docs.travis-ci.com/user/notifications/) as normal push builds.
