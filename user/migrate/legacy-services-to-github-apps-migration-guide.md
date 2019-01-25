---
title: Legacy GitHub Services to GitHub Apps Migration Guide
layout: en
redirect_from:
  - user/travis-migrate-to-apps-gem-guide/
  - user/legacy-services-to-github-apps-migration-guide/
---

As of May 2, 2018 we are moving toward having repositories integrated via a GitHub App instead of GitHub Services which [will no longer be supported by GitHub as of January 31st, 2018](https://developer.github.com/v3/guides/replacing-github-services/#deprecation-timeline).

> *Note:* While this process is ongoing, we have been migrating from GitHub services to webhooks on the https://travis-ci.org enabled repositories. The closure of GitHub services *will not affect your repositories even if you are currently on .org*.

The following guide shows you how to migrate your private repository to the Travis CI GitHub App.

## Migrating private repositories to GitHub Apps

Go to your repositories page on travis-ci.com: [https://travis-ci.com/account/repositories](https://travis-ci.com/account/repositories).

Click on the **"Activate & Migrate"** button.

![Travis CI GitHub App page](/images/migrate/legacy-services-migration-github-apps.png)

You will be redirected on the Travis CI GitHub App page on GitHub, with the repositories that were already active at `travis-ci.com` pre-selected.

![Travis CI GitHub App page](/images/migrate/github-app-page.png)

If you'd like to activate all your current and future repositories, choose **"All repositories"** so that your projects start building as soon as they're configured with a `.travis.yml` file."

After that, click the **"Approve & Install"** button.

You'll be redirected to your Travis CI profile page and the migrated repositories will appear under the **_GitHub Apps Integration_** header.

![travis-ci.com profile page with GitHub App integration](/images/migrate/github-app-repo.png)

### Migrating more than 50 private repositories

If your organization has more than **50 active repositories** to migrate to the GitHub Apps integration, check how to use the [travis_migrate_to_apps gem](/user/migrate/travis-migrate-to-apps-gem-guide/).

## Migrating and activating all repositories

If your organization would like to migrate all current repositories using webhooks and setup future repositories to use GitHub Apps, please go to GitHub to [Install the Travis CI GitHub App here](https://github.com/apps/travis-ci/installations/new), choose your organization and then, select **All repositories**.
