---
title: "Open Source on travis-ci.com"
layout: en

---

On May 2nd, 2018 Travis CI announced that open source projects will be joining private projects on **travis-ci.com**!



This means you can manage public and private repositories from one domain, allocate additional concurrency to either open source or private projects, and have a more consistent experience between types of projects.

We are implementing these changes with GitHub Apps, which provides a tighter integration with GitHub and finer control over repository and subscription ownership and permissions. New or migrated repositories building on `travis-ci.com` will have access to the features offered with the GitHub Apps-based Integration.

## What to Expect

This is a significant development for Travis CI, and will mean some changes to how repository and user management happen during the transition, and afterward. New open source user accounts and repositories will be able to use `travis-ci.com` right away, while existing user accounts and repositories will be migrated over time.

## Features of the GitHub Apps Integration

GitHub-Apps based integration introduces a number of benefits as over our Legacy Webhooks integration:
 * We will no longer add deploy keys to repositories when they are activated on Travis CI
 * Projects will be cloned with a shorter-lived OAuth token
 * Our GitHub App requires far less permissions than our OAuth application
 * Ownership of organization repositories is always tied to the organization which owns the project

## New User Accounts

Please sign up at [travis-ci.com](https://www.travis-ci.com), regardless of whether you plan to test open source or private projects. Welcome aboard!

## Existing User Accounts

Current users will keep both their `travis-ci.com` and `travis-ci.org` accounts at first. We recommend users of `travis-ci.org` activate any [new repositories](#New-Repositories) on `travis-ci.com`. If you have not signed up on [travis-ci.com](https://www.travis-ci.com) when you want to activate a new repository, please sign up there first.

## New Repositories

New repositories should be activated on [travis-ci.com](https://www.travis-ci.com) for both open source and private repositories. You will also have the option to subscribe open source projects for more concurrency immediately, rather than needing to contact support first.

## Existing Open Source Repositories on travis-ci.org

Open source projects and their build history will continue to run on `travis-ci.org` for now.

However, open source repositories will be migrated to travis-ci.com gradually. The migration was planned to start at the end of Q2 2018, but has been pushed back. We will announce a new date as soon as we are able. You will receive an email when the migration for a repository is complete. This is an opt-in process: to have a repository migrated over, it must first be activated on `travis-ci.com`. 

Currently, open source repositories that were private in any time in their history may be added to `travis-ci.com`. The option to migrate to `travis-ci.com` for active open source repositories that were always open source will come soon.

Repositories may also be migrated without their build history or build settings (including environment variables) immediately. Please contact support [support@travis-ci.com](mailto:support@travis-ci.com?Subject=Open%20Source%20on%20travis-ci.com%20-%20Repository%20Migration) and include "Repository Migration" somewhere in the subject line, and the name of the repository in your email.

## Existing Private Repositories on travis-ci.com

There will be no changes to your private repositories -- private projects will continue to run on `travis-ci.com` as before.

## Contact Support

If you have an questions, please email please contact [support@travis-ci.com](mailto:support@travis-ci.com?Subject=Open%20Source%20on%20travis-ci.com). We're looking forward to helping!
