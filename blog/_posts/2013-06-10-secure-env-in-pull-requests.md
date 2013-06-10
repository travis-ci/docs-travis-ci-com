---
title: Secure Environment Variables Now Available in Pull Requests
permalink: blog/2013-06-10-secure-env-in-pull-requests
created_at: Mon 10 Jun 2013 18:00:00 GMT
author: Piotr Sarnacki
twitter: drogus
layout: post
---

TL;DR: [Secure environment variables](http://about.travis-ci.org/docs/user/build-configuration/#Secure-environment-variables)
are enabled for pull requests as long as the origin of the pull request and the target repository are the same.

Secure environment variables have been available in Travis CI for quite some time now,
but there has been one thing which we always a litle annoying. Before today we were
disabling secure vars for every pull request. There was of course a good reason
for doing that, if we allow secure vars in a pull request an EVIL hacker
could submit a pull request with the `printenv` command, which would display
ALL of the ENV vars, including the ones, which you would like to keep secret!

The part, which was a bit annoying was the fact that some of the Pull
Requests are based on a branch from the same repository. This scenario is
pretty common, we use it extensively at Travis, as do many of our fantastic users. 
Even though I have access too all of the Travis CI repositories, I'll submit a pull request 
before pushing the changes to master, not just to get feedback from
our wonderful team, but also from Travis CI, which will run the build based on
merge commit and marking it as passing. But if a repository needs the secure env vars 
to run the full test suite, it reduces the value that a PR build provides.

Today I am happy to say that this has now been fixed! I deployed a set of changes which allows 
for the use of secure environment variables if a pull request's target repository
is the same as the source repository.

These changes were sponsored by the great folks at [Engine Yard](https://www.engineyard.com),
give them a big internet hug on [twitter](https://twitter.com/engineyard) if
you find this change useful!

Have an awesome week,

Piotr
