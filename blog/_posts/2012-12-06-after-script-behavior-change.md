---
title: Changes in after_script behavior
layout: post
permalink: blog/after_script_behavior_changes
author: Piotr Sarnacki
twitter: drogus
created_at: Fri 6 Dec 2012
---

TL;DR We're changing the `after_script` command to run regardless of the test result,
previously it was run only on success.

## What exactly will change?

Previously, if you specified `after_script` commands they were run right after
the `script` commands (i.e. your test suite) and only if the `script` commands
were successful (ie. returned 0).  This made it virtually the same as the
`after_success` command. Futhermore, there was no way to run commands both on
success and failure without specifying them twice in the success and failure
stages.

In order to simplify things, we changed `after_script` to run at the very end,
i.e. after the `after_success` and `after_failure` stages. `after_script` will
be run no matter what was returned from the previous commands. We will also
export a `TRAVIS_TEST_RESULT` env variable, which contain the test result
returned from running the tests in `script`.

## When will the change be deployed?

We plan to deploy this change early next week.

## How to fix my .travis.yml?

If commands that you execute in the `after_script` stage do care about the
result of your tests and are not required to be run before `after_success`
command, you probably don't need to change anything and your tests should run
just fine.

If you rely on the fact that a failure in the `after_script` phase, fails the
entire test, you should move, you should move such commands to the `script`
phase.

For example, the following:

    script:
      - rake
    after_script:
      - build_something_important

should be changed to:

    script:
      - rake
      - build_something_important

If you don't want for those commands to fail the test then move them to the
`after_success` phase.
