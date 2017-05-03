---
title: Speeding up the build
layout: en
permalink: /user/speeding-up-the-build/
---

Travis CI implements a few optimizations which help to speed up your build,
like in memory filesystem for DB's files, but there is a range of things
that can be done to improve build times even more.

## Parallelizing your builds across virtual machines

To speed up a test suite, you can break it up into several parts using
Travis CI's [build
matrix](/user/customizing-the-build/#Build-Matrix)
feature.

Say you want to split up your unit tests and your integration tests into two
different build jobs. They’ll run in parallel and fully utilize the available
build capacity for your account.

Here's an example on how to utilize this feature in your .travis.yml:

```yaml
env:
  - TEST_SUITE=units
  - TEST_SUITE=integration
```

Then you change your script command to use the new environment variable to
determine the script to run.

```yaml
script: "bundle exec rake test:$TEST_SUITE"
```

Travis CI will determine the build matrix based on the environment variables and
schedule two builds to run.

The neat part about this setup is that the unit test suite is usually going to
be done before the integration test suite, giving you a faster visual feedback
on the basic test coverage.

Depending on the size and complexity of your test suite you can split it up even
further. You could separate different concerns for integration tests into
different subfolders and run them in separate stages of a build matrix.

```yaml
env:
  - TESTFOLDER=integration/user
  - TESTFOLDER=integration/shopping_cart
  - TESTFOLDER=integration/payments
  - TESTFOLDER=units
```

Then you can adjust your script command to run rspec for every subfolder:

```yaml
script: "bundle exec rspec $TESTFOLDER"
```

For instance, the Rails project uses the build matrix feature to create separate
jobs for every database to test against, and also to split up the tests by
concern. One set runs tests only for the railties, another one for actionpack,
actionmailer, activesupport, and a whole bunch of sets runs the activerecord
tests against multiple databases. See their [.travis.yml
file](https://github.com/rails/rails/blob/master/.travis.yml) for more examples.

Note that during the trial on <https://travis-ci.com> for private repositories, you only have
one concurrent build available, so you'll unlikely be seeing improvements until you're
signed up for a paid subscription.

## Parallelizing your build on one virtual machine

Parallelizing the test suite on one virtual machine depends on the language and test runner:

- For Ruby and RSpec use the [parallel_tests](https://github.com/grosser/parallel_tests)
- For Java, use the built in feature [to run tests in parallel
  using JUnit](http://incodewetrustinc.blogspot.com/2009/07/run-your-junit-tests-in-parallel-with.html).

To give you an idea of the speedup are we talking about, I've tried running tests in parallel on `travis-core` and I was able to see a drop from about 26 minutes to about 19 minutes across 4 jobs.

## Parallelizing RSpec, Cucumber and Minitest on multiple VMs

If you want to parallel tests for RSpec, Cucumber or Minitest on multiple VMs to get faster feedback from CI then you can try [knapsack](https://github.com/ArturT/knapsack) gem. It will split tests across virtual machines and make sure that tests will run comparable time on each VM (each job will take similar time). You can use our matrix feature to set up knapsack.

### RSpec parallelization example

```yaml
script: "bundle exec rake knapsack:rspec"
env:
  global:
    - MY_GLOBAL_VAR=123
    - CI_NODE_TOTAL=2
  matrix:
    - CI_NODE_INDEX=0
    - CI_NODE_INDEX=1
```

Such configuration will generate matrix with 2 following ENV rows:

```
MY_GLOBAL_VAR=123 CI_NODE_TOTAL=2 CI_NODE_INDEX=0
MY_GLOBAL_VAR=123 CI_NODE_TOTAL=2 CI_NODE_INDEX=1
```

### Cucumber parallelization example

```yaml
script: "bundle exec rake knapsack:cucumber"
env:
  global:
    - CI_NODE_TOTAL=2
  matrix:
    - CI_NODE_INDEX=0
    - CI_NODE_INDEX=1
```

### Minitest parallelization example

```yaml
script: "bundle exec rake knapsack:minitest"
env:
  global:
    - CI_NODE_TOTAL=2
  matrix:
    - CI_NODE_INDEX=0
    - CI_NODE_INDEX=1
```

### RSpec, Cucumber and Minitest parallelization example

If you want to parallelize test suite for RSpec, Cucumber and Minitest at the same time then define script in `.travis.yml` this way:

```yaml
script:
  - "bundle exec rake knapsack:rspec"
  - "bundle exec rake knapsack:cucumber"
  - "bundle exec rake knapsack:minitest"
```

You can find more examples in [knapsack docs](https://github.com/ArturT/knapsack#info-for-travis-users).

## Caching the dependencies

Installing the dependencies for a project can take quite some time for bigger projects. In
order to make it faster, you may try caching the dependencies.

You can either use our [built-in caching](/user/caching/) or roll your own on S3. If you
want to roll your own and you use Ruby with Bundler, check out [the great WAD project](https://github.com/Fingertips/WAD).
For other languages, you can use s3 tools directly to upload and download the dependencies.

## Environment-specific ways to speed up your build

In addition to the optimizations implemented by Travis, there are also
several environment-specific ways you may consider increasing the speed of
your tests.

### PHP optimizations

PHP VM images on travis-ci.org provide several PHP versions which include
XDebug. The XDebug extension is useful if you wish to generate code coverage
reports in your Travis builds, but it has been shown to have a negative effect
upon performance.

You may wish to consider
[disabling the PHP XDebug extension](/user/languages/php#Disabling-preinstalled-PHP-extensions) for your
builds if:

- you are not generating code coverage reports in your Travis tests; or
- you are testing on PHP 7.0 or above and are able to use the [PHP Debugger (phpdbg)](http://phpdbg.com/)
  which may be faster.

#### Using phpdbg example

```yaml
before_script:
  - phpenv config-rm xdebug.ini
  - composer install

script:
  - phpdbg -qrr phpunit
```

### Makefile optimization

If your makefile build consists of independent parts that can be safely
parallelized, you can [run multiple recipes
simultaneously](https://www.gnu.org/software/make/manual/html_node/Parallel.html).
See [Virtualization
environments](/user/ci-environment/#Virtualization-environments) to determine
how many CPUs an environment normally has and set the `make` job parameter to a
similar number (or slightly higher if your build frequently waits on disk I/O).
Note that doing this will cause concurrent recipe output to become interleaved.

#### Makefile parallelization example

```yaml
env:
  global:
    - MAKEFLAGS="-j 2"
```
