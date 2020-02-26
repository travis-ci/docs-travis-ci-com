---
title: Travis CI for Private Projects
layout: en

redirect_from:
  - /user/pricing/
  - /user/travis-pro/
---

Learn more about [Travis CI for private repositories](https://travis-ci.com), our hosted
continuous integration solution for private repositories.

## Does Travis CI for private repositories include a trial period?

Yes, of course! No need to put in your credit card details, the trial starts whenever you trigger your first build on [Travis CI for private repositories](https://travis-ci.com). It includes 100 trial builds for free and 2-concurrent-jobs.

When you're ready to start using Travis CI, head over to the [billing page](https://travis-ci.com/account/subscription) to add your billing details and end your trial.

## Can I use pull request testing on Travis CI for private repositories?

Yes, you can. It's enabled by default for all repositories set up on Travis CI. See
the [blog post](https://blog.travis-ci.com/announcing-pull-request-support/) accompanying the launch of pull requests for Travis CI.

## Who has access to the builds?

Access rights on Travis CI is based on the access rights on GitHub or Bitbucket:

- Users that can access a repository on GitHub or Bitbucket can see the build status and logs on Travis CI.
- Users that can push to a repository on GitHub or Bitbucket can trigger, cancel and restart builds, and change its settings.
- Users that have admin access to a repository on GitHub or Bitbucket can enable/disable it on Travis CI.

To keep the access rights up to date, we sync every user account approximately once every 24 hours with GitHub or Bitbucket. You can use the "Sync account" button on [the profile page](https://travis-ci.com/profile) or `travis sync --com` in the CLI to force a sync.

## Who has access to the billing details?

Access rights to the Travis CI [billing page](https://travis-ci.com/account/subscription) can be one of the following:

- **Open (default)**: anyone with admin access to at least one private repository belonging to the organization in GitHub or team in Bitbucket has access to the billing information in Travis CI.
- **Restricted**: for GitHub users access is limited to members of the organization having the _owner_ and/or _billing manager_ permissions in GitHub (see their [documentation about the _Permission levels for an organization_](https://help.github.com/articles/permission-levels-for-an-organization/)).
- **Restricted**: for Bitbucket users access is limited to members of the team having read and write permissions in Bitbucket (see their [documentation about _Grant repository access to users and groups_](https://confluence.atlassian.com/bitbucket/grant-repository-access-to-users-and-groups-221449716.html)).

You can change the access rights to **Restricted** (or back to **Open**) under the *Organizations* tab on [our Subscription page](https://travis-ci.com/account/subscription) as shown below:

![Billing access toggle](/images/admin_only_toggle.png "Billing access toggle")

## Is it safe to give Travis CI access to my private code?

Security is our major concern when it comes to your source code. At Travis CI, we make sure our infrastructure is protected and secure so that your most valuable asset is safe and protected from unauthorized access.

You can find more information on this topic in our [Security Statement](https://docs.travis-ci.com/legal/security/).

## How can I encrypt files that include sensitive data?

You can follow our guide for [encrypting files](/user/encrypting-files/).

## Why can't I find information on pricing on travis-ci.org?

Travis CI is, and always will be, free for open source projects.

For a list of plans and prices for private repositories, look at
[travis-ci.com/plans](https://travis-ci.com/plans) for not authorized users.
For a list of plans and prices for private repositories, look at
[travis-ci.com/subscription](https://travis-ci.com/account/subscription) for authorized users.

## How can I make a private repository public on GitHub?

If you have a private repository that you'd like to make public, follow the [instructions on
GitHub](https://help.github.com/articles/making-a-private-repository-public/).

If you're using the Travis CI [command line client](https://github.com/travis-ci/travis.rb#readme)
   reset the default endpoint to public:

   ```sh
   travis endpoint --org --set-default
   ```

## How can I make a public repository private on GitHub?

If you have a public repository that you'd like to make private, follow the [instructions on
GitHub](https://help.github.com/articles/making-a-public-repository-private/).

If you're using the Travis CI [command line client](https://github.com/travis-ci/travis.rb#readme)
   reset the default endpoint to private:

   ```sh
   travis endpoint --com --set-default
   ```
   
## How can I set the repository privacy status on Bitbucket?

If you want to set the privacy status for a Bitbucket repository, follow the [instructions on
Bitbucket](https://confluence.atlassian.com/bitbucket/make-a-repo-private-or-public-221449724.html).
