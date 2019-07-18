---
title: "Open Source on travis-ci.com"
layout: en

redirect_from:
  - /user/open-source-on-travis-ci-com/
---

On <time datetime="2018-05-02">May 2nd, 2018</time> Travis CI announced that open source projects will be joining private projects on **travis-ci.com**!

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

Please sign up at [travis-ci.com], regardless of whether you plan to test open source or private projects. Welcome aboard!

## Existing User Accounts

Current users will keep both their `travis-ci.com` and `travis-ci.org` accounts at first. We recommend users of `travis-ci.org` activate any [new repositories](#new-repositories) on `travis-ci.com`. If you have not signed up on [travis-ci.com] when you want to activate a new repository, please sign up there first.

## New Repositories

New repositories should be activated on [travis-ci.com] for both open source and private repositories. You will also have the option to subscribe open source projects for more concurrency immediately, rather than needing to contact support first.

## Existing Open Source Repositories on travis-ci.org

Open source projects and their build history will continue to run on `travis-ci.org` at this time.

However, you can be included  in the closed beta testing to start migrating your open source repositories to `travis-ci.com`.

 1. To have any public repository migrated over, it must be first activated on [travis-ci.com] using GitHub Apps.

 2. Head over to [travis-ci.org] and in [your account page](https://travis-ci.org/account/repositories), subscribe to be part of the beta to migrate your Open Source repositories.

   ![Select "Sign up for the beta" in your account page and add organizations](/images/migrate/sign-up-for-the-beta-to-migrate.png)

 3. Once your account is ready to migrate, you'll receive a confirmation email.

 4. Check out what the beta testing includes on this [open source to travis-ci.com migration guide](/user/migrate/open-source-repository-migration).

## Existing Private Repositories on `travis-ci.com`

There will be no changes to your private repositories. Private projects will continue to run on `travis-ci.com` as before.

However, we'd recommend you activating your private repositories via GitHub Apps to start getting the most of this new integration.

Keep reading at [the legacy services to GitHub Apps guide for private repositories](/user/migrate/legacy-services-to-github-apps-migration-guide).

## Contact Support

If you have any questions, please email please contact [support@travis-ci.com](mailto:support@travis-ci.com?Subject=Open%20Source%20on%20travis-ci.com). We're looking forward to helping!


[travis-ci.com]: https://www.travis-ci.com
[travis-ci.org]: https://www.travis-ci.org
