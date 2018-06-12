---
title: Conditional Builds, Stages, and Jobs
layout: en
---

## Conditional Builds, Stages, and Jobs

You can filter out, and reject builds, stages, and jobs by specifying conditions in your build configuration (your `.travis.yml` file).

### Conditional Builds

Builds can be rejected by specifying a condition as follows:

```yaml
# require the branch name to be master (note for PRs this is the base branch name)
if: branch = master
```

Build requests that do not match the condition will not generate a build, but will be listed on the Requests tab.

### Conditional Stages

Stages can be filtered out by specifying a condition in the `stages` section:

```yaml
stages:
  - name: deploy
    # require the branch name to be master (note for PRs this is the base branch name)
    if: branch = master
```

Stages that do not match the condition will be skipped silently.

### Conditional Jobs

Jobs can be filtered out by specifying a condition on `jobs.include`:

```yaml
jobs:
  include:
    - # require the branch name to be master (note for PRs this is the base branch name)
      if: branch = master
      env: FOO=foo
```

Jobs need to be listed explicitly, i.e., using `jobs.include` (or its alias `matrix.include`), in order to specify conditions for them. Jobs created via [matrix expansion](/user/customizing-the-build/#Build-Matrix) currently cannot have conditions.

Jobs that do not match the condition will be skipped silently.

### Specifying conditions

Please see [Conditions](/user/conditions-v1) for examples, and a specification of the conditions syntax.
