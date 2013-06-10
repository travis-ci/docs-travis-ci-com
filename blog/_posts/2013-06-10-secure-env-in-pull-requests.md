---
title: Secure env vars in pull requests
permalink: blog/2013-06-10-secure-env-in-pull-requests
created_at: Mon 10 Jun 2013 18:00:00 GMT
author: Piotr Sarnacki
twitter: drogus
layout: post
---

TL;DR: [Secure environment variables](http://about.travis-ci.org/docs/user/build-configuration/#Secure-environment-variables)
are enabled for pull requests as long as the origin of pull request and a target repository are the same.

Secure environment variables are available in Travis CI for quite some time already,
but there was one thing which was not optimal in our setup. Until today we were
disabling secure vars for every pull request. There is of course a good reason
for doing that, if we let using secure vars in a pull request, an evil hacker
could just submit pull request with `printenv` command, which would display
all of the ENV vars, including the ones, which you would like to keep secret.

The part, which's not optimal here, was the fact that some of the pull
requests are based on a branch in the same repository. Such scenario is
pretty common, we use it extensively in Travis, too. Even though I have access
too all of the Travis CI repositories, I will submit a pull request before
pushing the changes to master, just to get feedback - both from
our wonderful team and from Travis CI, which will run the build based on
merge commit. If a repository needs secure env vars to run full test suite,
a PR build was not that valuable.

To fix this, I deployed a set of changes today, which allow to use
secure environment variables if a pull request's target repository
is the same as the source repository.

This changes were sponsored by the great folks at [Engine Yard](https://www.engineyard.com),
give them a big internet hug on [twitter](https://twitter.com/engineyard) if
you find this change useful!
