---
title: Legacy GitHub Services to GitHub Apps Migration Guide
layout: en
---

As of May 2, 2018 we are moving toward having repositories integrated via a GitHub App instead of GitHub Services which [will no longer be supported by GitHub as of January 31st, 2018](https://developer.github.com/v3/guides/replacing-github-services/#deprecation-timeline).

The following guide shows you how to migrate your private repository to the Travis CI GitHub App.

## How to migrate a private repository to GitHub Apps

Go to your repositories page on travis-ci.com: [https://travis-ci.com/account/repositories](https://travis-ci.com/account/repositories).

Click on the "Activate & Migrate on GitHub Apps" or "Manage on GitHub" button.

![Travis CI GitHub App page](/images/migrate/legacy-services-migration-github-apps.png)

You will be redirected on the Travis CI GitHub App page on GitHub, with the repositories that were already active at `travis-ci.com` pre-selected.

![Travis CI GitHub App page](/images/migrate/github-app-page.png)

If you'd like to activate all your current and future repositories so that they can start building by adding a `.travis.yml` file, select "All repositories".

After that, click the "Approve & Install" button.

You'll be redirected to your Travis CI profile page and the migrated repositories will appear under the `GitHub Apps Integration` header.

![travis-ci.com profile page with GitHub App integration](/images/migrate/github-app-repo.png)

## Migrating more than 50 private Repositories
