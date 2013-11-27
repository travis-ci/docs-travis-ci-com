---
title: Fast-Finish Builds with Allowed Failures
created_at: Wed 27 Nov 2013 12:40:00 EST
author: Aaron Hill
layout: post
permalink: blog/2013-11-27-fast-finishing-builds
---

For a while, Travis CI has supported [allowed failures](http://about.travis-ci.org/docs/user/build-configuration/#Rows-That-are-Allowed-To-Fail) in your build matrix -
jobs that are allowed to fail, without affecting the status of the entire build.

However, even if some of the items in your build matrix are allowed failures, Travis CI will still wait for them to finish before marking the build as finished.
Even if all of the other jobs are done, Travis CI won't mark the build as finished until the allowed failures are done, despite the fact that allowed failures won't ultimately affect the status of the build.

Today, we're happy to announce opt-in support for fast finishing on Travis CI. With fast finishing enabled, Travis CI will mark your build as finished as soon as one of two conditions are met:
The only remaining jobs are allowed to fail, or a job has already failed. In these cases, the status of the build can already be determined, so there's no need to wait around until the other jobs finish.

To enable fast finishing, add `fast_finish: true` to the `matrix` section of your `.travis.yml`, so it looks like this:

    matrix:
      fast_finish: true

For more information, check out [the docs](/docs/user/build-configuration)

This feature is immediately available for [open source](https://travis-ci.org/) and [private](https://travis-ci.com/) repositories.
