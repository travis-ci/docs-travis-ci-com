---
title: Conditional Builds, Stages, and Jobs
layout: en
---

## Conditional Builds, Stages, and Jobs

You can filter out, and reject builds, stages, and jobs by specifying conditions in your build configuration (your `.travis.yml` file).

### Conditional Builds

Builds can be included or excluded by specifying a condition as follows:

```yaml
# require the branch name to be master
if: branch = master

# require the tag name to match a regular expression
if: tag =~ ^v1

# require the event type to be either `push` or `pull_request`
if: type IN (push, pull_request)
```

Build requests that are found to be excluded will not generate a build, but will be listed on the "Requests" tab.

### Conditional Stages

Stages can be included or excluded by specifying a condition in the `stages` section:

```yaml
stages:
  - name: deploy
    # require the branch name to be master
    if: branch = master

stages:
  - name: deploy
    # require the tag name to match a regular expression
    if: tag =~ ^v1

stages:
  - name: deploy
    # require the event type to be either `push` or `pull_request`
    if: type IN (push, pull_request)
```

At the moment, stages that are found to be excluded will be skipped silently (an improvement to this is on the roadmap, giving more explicit feedback on filtering).

### Conditional Jobs

Jobs can be included or excluded by specifying a condition on `jobs.include`:

```yaml
jobs:
  include:
    - # require the branch name to be master
      if: branch = master
      env: FOO=foo

jobs:
  include:
    - # require the tag name to match a regular expression
      if: tag =~ ^v1
      env: FOO=foo

jobs:
  include:
    - # require the event type to be either `push` or `pull_request`
      if: type IN (push, pull_request)
      env: FOO=foo
```

Jobs need to be listed explicitely, i.e., using `jobs.include` (or its alias `matrix.include`), in order to specify conditions for them. Jobs created via [matrix expansion](/user/customizing-the-build/#Build-Matrix) currently cannot have conditions.

At the moment, jobs that are found to be excluded will be skipped silently (an improvement to this is on the roadmap).

### Specifying conditions

The condition can be specified using a boolean language as follows:

```
(NOT [term] OR [term]) AND [term]
```

A term is defined as:

```
[left-hand-side] [operator] [right-hand-side]
```

All keywords (such as `AND`, `OR`, `NOT`, `IN`, `IS`, attributes, and functions) are case-insensitive.

#### Left hand side

The left hand side part can either be a known attribute or a function call.

Known attributes are:

* `type` (the current event type, known event types are: `push`, `pull_request`, `api`, `cron`)
* `repo` (the current repository slug `owner_name/name`)
* `branch` (the current branch name; for pull requests: the base branch name)
* `tag` (the current tag name)
* `sender` (the event sender's login name)
* `fork` (`true` or `false` depending if the repository is a fork)
* `head_repo` (for pull requests: the head repository slug `owner_name/name`)
* `head_branch` (for pull requests: the head repository branch name)

Known functions are:

* `env(FOO)` (the value of the environment variable `FOO`)

The function `env` currently only supports environment variables that are given in your build configuration (e.g. on `env` or `env.global`), not environment variables specified in your repository settings.

#### Right hand side

It is currently not possible to compare function calls. This means that if you try to evaluate something similar to:

`env(PRIOR_VERSION) != env(RELEASE_VERSION)`

where PRIOR_VERSION and RELEASE_VERSION are environment variables defined elsewhere in .travis.yml, the condition will be evaluated as true, even when it is false.

A work-around is to create a script which expresses the conditional test in reverse, and applies `travis_terminate` when the condition is false. This script can be called within the Deploy stage.
For instance, continuing with the above example, the Deploy stage would include:

```yaml
- stage: deploy
   if: attribute=value
   env:
    - PRIOR_VERSION=$(git describe --abbrev=0 --tags)
    - RELEASE_VERSION=$(grep to get version number)
   script:
    - "$PRIOR_VERSION" = "$RELEASE_VERSION" && travis_terminate || echo "Deploying latest version ..."

```

Since we want the build to deploy only when PRIOR_VERSION and RELEASE_VERSION are not equal, we test for equality and terminate if that is found to be true.

#### Equality and inequality

This matches a string literally:

```
branch = master
env(foo) = bar
sender != my-bot
```

#### Match

This matches a string using a regular expression:

```
branch =~ ^master$
env(foo) =~ ^bar$
```

#### Include

This matches against a set (array) of values:

```
branch IN (master, dev)
env(foo) IN (bar, baz)
```

#### Presence

This requires a value to be present or missing:

```
branch IS present
branch IS blank
env(foo) IS present
env(foo) IS blank
```

