---
title: How to setup and trigger the hook manually
layout: en
permalink: how-to-setup-and-trigger-the-hook-manually/
---

Sometimes you need to setup the service hook manually. Normally this should not
be necessary as you should be able to [simply flip the relevant
switch](/docs/user/getting-started/) on the profile page. As of August 2nd, 2012
Travis synchronizes all of your repositories, including the ones of
organizations you have administrative access to. See the corresponding [blog
post](http://about.travis-ci.org/blog/2012-08-02-travis-now-syncs-your-repositories-automagically/)
for more details.

Should you still need to manually set up a build hook for Travis, you can go to
the service hooks page of a repository on GitHub. You'll find it in the
respective "Admin" section.

As the list is very long you will need to scroll down and after clicking on
"Travis" scroll back up. You will be presented with a form with three fields:
Domain, User, Token.

You can leave the Domain empty. In the User field enter the GitHub account you
used to authenticate yourself on travis-ci.org. In the Token field paste the
token as it is listed on the profile page on travis-ci.org.

When you click "Update Settings" the hook is setup and from now on pushes to
this repository will trigger a build on travis-ci.org.

Clicking on "Test Hook" will trigger a build on your "master" branch without
having to push. Note this will also work if you setup your hook via the switches
on your profile page.
