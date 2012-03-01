---
title: How to setup and trigger the hook manually
layout: default
permalink: how-to-setup-and-trigger-the-hook-manually/
---

Sometimes you need to setup the service hook manually. Normally this should not be necessary as you should be able to [started simply flip the relevant switch](/docs/user/getting-started/) on the profile page.

However especially when setting up an repository hosted inside a github organization the hook needs to be setup manually. Simply access the given repositories admin panel on github. Then access the "service hooks" section.

The URL will look something like ``https://github.com/[your organization]/[your repository]/admin/hooks``.

As the list is very long you will need to scroll down and after clicking on "Travis" scroll back up. You will be presented with a form with 3 fields: Domain, User, Token.

You can leave the Domain empty. In the User field enter the github account you used to authenticate yourself on travis-ci.org. In the Token field paste the token as it is listed on the profile page on travis-ci.org.

When you click "Update Settings" the hook is setup and from now on pushes to this repository will trigger a build on travis-ci.org.

Clicking on "Test Hook" will trigger a build on your "master" branch without having to push. Note this will also work if you setup your hook via the switches on your profile page.
