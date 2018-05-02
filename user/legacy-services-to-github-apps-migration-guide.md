---
title: Legacy GitHub Services to GitHub Apps Migration Guide
layout: en
---

As of May 2, 2018 we are moving toward having repositories integrated via a GitHub App instead of GitHub Services which [will no longer be supported as of October 1, 2018](https://developer.github.com/changes/2018-04-25-github-services-deprecation). 

Here are two recipes that will show you how to migrate your private and open source repositories to the Travis CI GitHub App.

## How to migrate a private repository to GitHub Apps

Go to your profile page on travis-ci.com: [https://travis-ci.com/profile](https://travis-ci.com/profile).

![travis-ci.com profile page with legacy GitHub Services integration](/images/legacy-services-repo.png)

Click on the "Migrate to GitHub Apps" button.

You will be redirected on the Travis CI GitHub App page on GitHub.

![Travis CI GitHub App page](/images/github-app-page.png)

Type in and select the repositories that you want to migrate.

Click the "Approve & Install" button.

You'll be redirected on your Travis CI profile page and the migrated repositories will appear under the `GitHub Apps Integration` header.

![travis-ci.com profile page with GitHub App integration](/images/github-app-repo.png)
