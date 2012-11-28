---
title: Speeding Up Your Tests By Parallelizing Them
layout: post
created_at: Wed Nov 28 2012 17:00:00 CET
author: Mathias Meyer
twitter: roidrage
permalink: blog/2012-11-28-speeding-up-your-tests-by-parallelizing-them
---
In private projects, such as the ones our customers are running on [Travis
Pro](https://travis-ci.com), a large integration test suite is a common part of
the build process.

As these integration test suites tend to test more complex scenarios through the
entire stack, they also tend to be the slowest part, requiring multiple minutes
to run, sometimes even up to half an hour.

To speed up a test suite like that, you can break it up into several parts using
Travis’ [build
matrix](http://about.travis-ci.org/docs/user/build-configuration/#The-Build-Matrix)
feature.

Say you want to split up your unit tests and your integration tests into two
different build jobs. They’ll run in parallel and fully utilize the available
build capacity for your account.

Here's an example on how to utilize this feature in your .travis.yml:

    env:
      - TEST_SUITE=units
      - TEST_SUITE=integration

Then you change your script command to use the new environment variable to
determine the script to run.

    script: "bundle exec rake test:$TEST_SUITE"

Travis will determine the build matrix based on the environment variables and
schedule two builds to run.

The neat part about this setup is that the unit test suite is usually going to
be done before the integration test suite, giving you a faster visual feedback
on the basic test coverage.

Depending on the size and complexity of your test suite you can split it up even
further. You could separate different concerns for integration tests into
different subfolders and run them in separate stages of a build matrix.

    env:
      - TESTFOLDER=integration/user
      - TESTFOLDER=integration/shopping_cart
      - TESTFOLDER=integration/payments
      - TESTFOLDER=units

Then you can adjust your script command to run rspec for every subfolder:

    script: "bundle exec rspec $TESTFOLDER"

For instance, the Rails project uses the build matrix feature to create separate
jobs for every database to test against, and also to split up the tests by
concern. One set runs tests only for the railties, another one for actionpack,
actionmailer, activesupport, and a whole bunch of sets runs the activerecord
tests against multiple databases. See their [.travis.yml
file](https://github.com/rails/rails/blob/master/.travis.yml) for more examples.

