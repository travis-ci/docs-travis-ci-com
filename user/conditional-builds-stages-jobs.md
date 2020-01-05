---
title: Conditional Builds, Stages and Jobs
layout: en
---

You can filter out and reject builds, stages and jobs by specifying conditions in your build configuration (your `.travis.yml` file).

You can find more information on the build config format in our [Travis CI Build Config Reference](https://config.travis-ci.com/ref/job/if/condition).

## Conditional Builds

You can configure Travis CI to only run builds when certain conditions are met. Any builds that do not meet these conditions are listed in the *Requests* tab of your repository, even though the actual build is not generated.

For example, this allows builds only to run on the `master` branch:

```yaml
# require the branch name to be master (note for PRs this is the base branch name)
if: branch = master
```
{: data-file=".travis.yml"}

Build requests that do not match the condition will not generate a build, but will be listed on the *Requests* tab.

## Conditional Stages

You can configure Travis CI to only include stages when certain conditions are met. Stages that do not match the given condition are silently skipped. For example, this allows the deploy stage to run only on the `master` branch:

```yaml
stages:
  - name: deploy
    # require the branch name to be master (note for PRs this is the base branch name)
    if: branch = master
```
{: data-file=".travis.yml"}

Stages that do not match the condition will be skipped silently.

## Conditional Jobs

You can configure Travis CI to only include jobs when certain conditions are met. For example, this includes the listed job only to build on the `master` branch:

```yaml
jobs:
  include:
    - # require the branch name to be master (note for PRs this is the base branch name)
      if: branch = master
      env: FOO=foo
```
{: data-file=".travis.yml"}

Jobs need to be listed explicitly, i.e., using `jobs.include` (or its alias `matrix.include`), in order to specify conditions for them. Jobs created via [matrix expansion](/user/customizing-the-build/#build-matrix) currently cannot have conditions, but they can be conditionally excluded (see [below](/#conditionally-excluding-jobs)).

> Jobs that do not match the condition will be skipped silently.

## Conditionally Excluding Jobs

You can configure Travis CI to exclude jobs when certain conditions are met. For example, this will create two jobs on all branches, but only one job (with the env var `ONE=one`) on the `master` branch:

```yaml
env:
  - ONE=one
  - TWO=two
jobs:
  exclude:
    - if: branch = master
      env: TWO=two
```
{: data-file=".travis.yml"}

## Conditionally Allowing Jobs to Fail

You can configure Travis CI to allow jobs to fail only when certain conditions are met. For example, this will allow the job with the env var `TWO=two` to fail when the build runs on the branch `dev`:

```yaml
env:
  - ONE=one
  - TWO=two
jobs:
  allow_failures:
    - if: branch = dev
      env: TWO=two
```
{: data-file=".travis.yml"}

## Specifying Conditions

Please see [Conditions](/user/conditions-v1) for examples and a specification of the conditions syntax.

## Testing Conditions

Conditions can be tested using the `travis-conditions` command. Learn how to
[test your conditions](/user/conditions-testing).
