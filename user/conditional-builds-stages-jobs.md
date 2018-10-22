---
title: Conditional Builds, Stages, and Jobs
layout: en
---

You can filter out, and reject builds, stages, and jobs by specifying conditions in your build configuration (your `.travis.yml` file).

* [Comprehensive reference](https://docs.travis-ci.com/user/conditions-v1)

## Conditional Builds

Configure Travis CI to only trigger builds when certain conditions are met, such as only building the master branch. Any potential builds that do not meet these conditions are listed in the Requests tab of your repository, even though the actual build is not generated.

```yaml
# require the branch name to be master (note for PRs this is the base branch name)
if: branch = master
```

Build requests that do not match the condition will not generate a build, but will be listed on the Requests tab.

## Conditional Stages

Configure Travis CI to only include stages when certain conditions are met, such as only including the stage on the master branch. Stages that do not match the given condition are silently skipped.

```yaml
stages:
  - name: deploy
    # require the branch name to be master (note for PRs this is the base branch name)
    if: branch = master
```

Stages that do not match the condition will be skipped silently.

## Conditional Jobs

Configure Travis CI to only include jobs when certain conditions are met, such as only including a job on the master branch. Jobs that do not match the given condition are silently skipped.

```yaml
jobs:
  include:
    - # require the branch name to be master (note for PRs this is the base branch name)
      if: branch = master
      env: FOO=foo
```

Jobs need to be listed explicitly, i.e., using `jobs.include` (or its alias `matrix.include`), in order to specify conditions for them. Jobs created via [matrix expansion](/user/customizing-the-build/#Build-Matrix) currently cannot have conditions.

Jobs that do not match the condition will be skipped silently.

## Specifying Conditions

Please see [Conditions](/user/conditions-v1) for examples, and a specification of the conditions syntax.

## Testing Conditions

Conditions can be tested using the `travis-conditions` command. Learn how to
[test your conditions](/user/conditions-testing).
