---
title: Travis Pro - Frequently Asked Questions
layout: en
permalink: /user/travis-pro/
---

<div id="toc"></div>

Note: These issues are related to [Travis Pro](http://travis-ci.com), our hosted
continuous integration solution for private repositories.

## Can I use pull request testing on Travis Pro?

Yes, you can. It's enabled by default for all repositories set up on Travis CI. See
the [blog
post](http://blog.travis-ci.com/announcing-pull-request-support/)
accompanying the launch of pull requests for Travis CI.

## Who has access to the builds?

Access rights on Travis CI is based on the access rights on GitHub:

* Users that can access a repository on GitHub can see the build status and logs on Travis CI.
* Users that can push to a repository on GitHub can trigger, cancel and restart builds.
* Users that have admin access to a repository on GitHub can change enable/disable it on Travis CI and change its settings.

To keep the access rights up to date, we sync every user account approximately once every 24 hours with GitHub. You can use the "sync now" button on the profile page or `travis sync --pro` in the CLI to force a sync.

## Is it safe to give Travis CI access to my private code?

Security is our major concern when it comes to your source code. At Travis CI, we make sure our infrastructure is protected and secure so that your most valuable asset is safe and protected from unauthorized access.

You can find more information on this topic in our [Security Statement](https://billing.travis-ci.com/pages/security).

## How can I encrypt files that include sensitive data?

You can follow our guide for [encrypting files](/user/encrypting-files/).
