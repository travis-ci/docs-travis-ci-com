---
title: Speeding up the build
layout: en
permalink: speeding-up-the-build/
---

Travis CI implements a few optimizations which help to speed up your build,
like in memory filesystem for DB's files, but there is a range of things
that can be done to improve build times even more.

## Parallelizing your builds across virtual machines

To speed up a test suite, you can break it up into several parts using
Travis’ [build
matrix](/user/build-configuration/#The-Build-Matrix)
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

## Paralellizing your build on one VM

Travis CI VMs run on 1.5 virtual cores. This is not exactly a concurrency, which allows
to parallelize a lot, but it can give a nice speedup depending on your use case.

Parallelizing the test suite on one VM depends on the language and test runner,
which you use, so you will have to research your options. At Travis CI we use
mainly Ruby and RSpec, which means that we can use [parallel_tests](https://github.com/grosser/parallel_tests)
gem. If you use Java, you may use the built in feature [to run tests in parallel
using JUnit](http://incodewetrustinc.blogspot.com/2009/07/run-your-junit-tests-in-parallel-with.html).

To give you an idea of what speedup are we talking about, I've tried running tests in parallel
on `travis-core` and I was able to see a drop from about 26 minutes to about 19 minutes across 4
jobs.

## Caching the dependencies

Installing the dependencies for a project can take quite some time for bigger projects. In
order to make it faster, you may try caching the dependencies.

You can either use our [built-in caching](/user/caching/) or roll your own on S3. If you
want to roll your own and you use Ruby with Bundler, check out [the great WAD project](https://github.com/Fingertips/WAD).
For other languages, you can use s3 tools directly to upload and download the dependencies.
