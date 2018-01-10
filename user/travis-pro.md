---
title: Travis CI for Private Projects
layout: en

redirect_from:
  - /user/pricing/
---

<div id="toc"></div>

Learn more about [Travis Pro](http://travis-ci.com), our hosted
continuous integration solution for private repositories.

## Does Travis Pro include a trial period?

Yes, of course! No need to put in your credit card details, the trial starts whenever you trigger your first build on [Travis Pro](http://travis-ci.com). It includes 100 trial builds for free and 2-concurrent-jobs.

When you're ready to start using Travis CI, head over to the [billing page](https://billing.travis-ci.com/) to add your billing details and end your trial.

## Can I use pull request testing on Travis Pro?

Yes, you can. It's enabled by default for all repositories set up on Travis CI. See
the [blog
post](http://blog.travis-ci.com/announcing-pull-request-support/)
accompanying the launch of pull requests for Travis CI.

## Who has access to the builds?

Access rights on Travis CI is based on the access rights on GitHub:

- Users that can access a repository on GitHub can see the build status and logs on Travis CI.
- Users that can push to a repository on GitHub can trigger, cancel and restart builds.
- Users that have admin access to a repository on GitHub can change enable/disable it on Travis CI and change its settings.

To keep the access rights up to date, we sync every user account approximately once every 24 hours with GitHub. You can use the "Sync account" button on [the profile page](https://travis-ci.com/profile) or `travis sync --pro` in the CLI to force a sync.

## Who has access to the billing details?

Access rights to the Travis CI [billing page](https://billing.travis-ci.com) can be one of the following:

- **Open (default)**: anyone with admin access to at least one repository belonging to the organization in GitHub has access to the billing information in Travis CI.
- **Restricted**: access is limited to members of the organization having the _owner_ and/or _billing manager_ permissions in GitHub (see their [documentation about the _Permission levels for an organization_](https://help.github.com/articles/permission-levels-for-an-organization/)).

You can change the access rights of an organization to **Restricted** (or back to **Open**) under the organization's tab on [our billing page](https://billing.travis-ci.com) as shown below:

![Billing access toggle](/images/admin_only_toggle.png "Billing access toggle")

## Is it safe to give Travis CI access to my private code?

Security is our major concern when it comes to your source code. At Travis CI, we make sure our infrastructure is protected and secure so that your most valuable asset is safe and protected from unauthorized access.

You can find more information on this topic in our [Security Statement](https://billing.travis-ci.com/pages/security).

## How can I encrypt files that include sensitive data?

You can follow our guide for [encrypting files](/user/encrypting-files/).

## Why can't I find information on pricing on [travis-ci.org](https://travis-ci.org)?

Travis CI is, and always will be, free for open source projects.

For a list of plans and prices for private repositories, look at
[travis-ci.com/plans](https://travis-ci.com/plans).

## How can I make a private repository public?

If you have a private repository that you'd like to make public, first
deactivate it on [Travis CI .com](https://travis-ci.com), change the repository
settings on GitHub, and resync your Travis CI account:

1. On [Travis CI .com](https://travis-ci.com) go to *Accounts*, and toggle the
   repository to *OFF*.

1. Follow the [instructions on
GitHub](https://help.github.com/articles/making-a-private-repository-public/) on
how to make a repository public.

2. On [Travis CI .org](https://travis-ci.org) go to *Accounts*, click *Sync
   Account*, then toggle the repository to *ON*.

5. If you're using the Travis CI [commmand line client](https://github.com/travis-ci/travis.rb#readme)
   reset the default endpoint to public:

   ```sh
   travis endpoint --org --set-default
   ```

## How can I make a public repository private?

If you have a public repository that you'd like to make private, first
deactivate it on [Travis CI .org](https://travis-ci.org), change the repository
settings on GitHub, and resync your Travis CI account:

1. On [Travis CI .org](https://travis-ci.org) go to *Accounts*, and toggle the
   repository to *OFF*.

1. Follow the [instructions on
GitHub](https://help.github.com/articles/making-a-public-repository-private/) on
how to make a repository public.

2. On [Travis CI .org](https://travis-ci.org) go to *Accounts*, click *Sync
   Account*, then toggle the repository to *ON*.

5. If you're using the Travis CI [commmand line client](https://github.com/travis-ci/travis.rb#readme)
   reset the default endpoint to private:

   ```sh
   travis endpoint --com --set-default
   ```
