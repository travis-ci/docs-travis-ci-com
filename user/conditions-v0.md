---
title: Conditions v0 (deprecated)
layout: en
---

> This page documents conditions v0, which is deprecated in favor of the [new
> version v1](/user/conditions-v1). If you need to use v0 please opt in by
> adding `conditions: v0` to your .travis.yml file.

Conditions can be used to filter out, and reject builds, stages, and jobs by
specifying conditions in your build configuration (your `.travis.yml` file).
See [Conditional Builds, Stages, and Jobs](/user/conditional-builds-stages-jobs)
for details.

## Specifying conditions

The condition can be specified using a boolean language as follows:

```
(NOT [term] OR [term]) AND [term]
```

A term is defined as:

```
[left-hand-side] [operator] [right-hand-side]
```

All keywords (such as `AND`, `OR`, `NOT`, `IN`, `IS`, attributes, and
functions) are case-insensitive.

### Left hand side

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

The function `env` currently only supports environment variables that are given
in your build configuration (e.g. on `env` or `env.global`), not environment
variables specified in your repository settings.

### Right hand side

It is currently not possible to compare function calls. This means that if you
try to evaluate something similar to:

`env(PRIOR_VERSION) != env(RELEASE_VERSION)`

where `PRIOR_VERSION` and `RELEASE_VERSION` are environment variables defined
elsewhere in .travis.yml, the condition will be evaluated as true, even when it
is false.

The best way to handle the behavior that comparison of function calls always evaluates to true is to create a script which expresses the conditional test in reverse, and applies `travis_terminate` when the condition is false. This
script can be called within the Deploy stage.  For instance, continuing with
the above example, the Deploy stage would include:

```yaml
- stage: deploy
   if: attribute=value
   env:
    - PRIOR_VERSION=$(git describe --abbrev=0 --tags)
    - RELEASE_VERSION=$(grep to get version number)
   script:
    - "$PRIOR_VERSION" = "$RELEASE_VERSION" && travis_terminate || echo "Deploying latest version ..."

```

Since we want the build to deploy only when `PRIOR_VERSION` and `RELEASE_VERSION`
are not equal, we test for equality and terminate if that is found to be true.

### Equality and inequality

This matches a string literally:

```
branch = master
env(foo) = bar
sender != my-bot
```

### Match

This matches a string using a regular expression:

```
branch =~ ^master$
env(foo) =~ ^bar$
```

### Include

This matches against a set (array) of values:

```
branch IN (master, dev)
env(foo) IN (bar, baz)
```

### Presence

This requires a value to be present or missing:

```
branch IS present
branch IS blank
env(foo) IS present
env(foo) IS blank
```

