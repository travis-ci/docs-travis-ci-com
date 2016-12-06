---
title: Cron Jobs
layout: en
permalink: /user/cron-jobs/
---

<div id="toc"></div>

Cron jobs run builds at regular scheduled intervals independently of whether any commits were pushed to the repository. When they run, cron jobs always fetch the most recent commit on a particular branch and build the project at that state. Cron jobs can run `daily`, `weekly` or `monthly`, which in practice means up to an hour after the selected time span, and they can also be [skipped](#Skipping-Cron-Jobs). Cron jobs cannot be set to run at specific times.

Cron job builds use the same notification settings as normal push builds.

If this feature is enabled for your repository, there is a "Cron Jobs" settings tab on your Travis CI page.

![settings page with cron section](/images/cron-section.png "settings page with cron section")

## Adding Cron Jobs

Select the branch to run the build on, how often to run the build, and whether to run the build if there was a build in the last 24 hours, then click "Add":

![adding a cron job](/images/cron-adding.png "adding a cron job")

Confirm that the cron job is displayed in your settings tab:

![cron job created](/images/cron-created.png "cron job created")

## Skipping Cron Jobs

Because cron jobs build the latest commit to a particular branch, if that commit message includes [`[ci skip]` or `[skip ci]`](/user/customizing-the-build/#Skipping-a-build) the cron job will skip that build.

## Deleting Cron Jobs

Click the small trash icon on the right hand side of the page:

![deleting a cron job](/images/cron-deleting.png "deleting a cron job")

## Detecting Builds Triggered by Cron

To check whether a build was triggered by cron, examine the `TRAVIS_EVENT_TYPE` environment variable to see if it has the value `cron`.
