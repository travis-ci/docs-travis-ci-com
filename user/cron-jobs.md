---
title: Cron Jobs
layout: en
permalink: /user/cron-jobs/
---

**Please note that cron jobs are not enabled by default. Set "Build pushes" to `on` in your settings, then ask us to unlock this feature for your repository:
[support@travis-ci.com](mailto:support@travis-ci.com?subject=Cron)**

<div id="toc"></div>

Cron jobs run builds at regular scheduled intervals independently of whether
any commits were pushed to the repository. They can run `daily`, `weekly` or `monthly`, which in practice means up to an hour after the selected time span. They cannot be set to run at specific times.

If this feature is enabled for your repository, there is a "Cron Jobs" settings
tab on your Travis CI page.

![settings page with cron section](/images/cron-section.png "settings page with cron section")

## Adding Cron Jobs

Select the branch to run the build on, how often to run the build, and whether to to run the build if there were commits since the last cron build, then click "Add":

![adding a cron job](/images/cron-adding.png "adding a cron job")

Confirm that the cron job is displayed in your settings tab:

![cron job created](/images/cron-created.png "cron job created")

## Deleting Cron Jobs

Click the small trash icon on the right hand side of the page:

![deleting a cron job](/images/cron-deleting.png "deleting a cron job")

## Detecting Builds Triggered by Cron

To check whether a build was triggered by cron, examine the `TRAVIS_EVENT_TYPE` environment variable to see if it has the value `cron`.
