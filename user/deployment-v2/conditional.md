---
title: Conditional Deployments
layout: en
deploy: v2
---

Set your build to deploy only in specific circumstances by using the `on`
option for any deployment provider.

```yaml
deploy:
  provider: <provider>
  # ⋮
  on:
    branch: release
    condition: $MY_ENV = value
```
{: data-file=".travis.yml"}

If *all* conditions specified in the `on` section are met, your build will deploy.

The following conditions are available:

### Repo

To deploy only when the build occurs on a particular repository, add `repo` in the form `owner_name/repo_name`:

```yaml
deploy:
  provider: <provider>
  # ⋮
  on:
    repo: travis-ci/dpl
```
{: data-file=".travis.yml"}

### Branch

By default, deployments will only happen on the `master` branch. You can overwrite this by using the `branch` and `all_branches` options.

For example, to deploy on the `production` branch only use:

```yaml
deploy:
  provider: <provider>
  # ⋮
  on:
    branch: production
```
{: data-file=".travis.yml"}

In order to deploy from all branches:

```yaml
deploy:
  provider: <provider>
  # ⋮
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

### Condition

You can specify a single Bash `condition` that needs to evaluate to `true` in
order for the deployment to happen.

This must be a string value that will be wrapped into `if [[ <condition> ]]; then <deploy>; fi`.

For example, in order to only deploy if `$CC` is `gcc` use:

```yaml
deploy:
  provider: s3
  # ⋮
  on:
    condition: $CC = gcc
```
{: data-file=".travis.yml"}

### Tag

You can specify whether or not to deploy on tag builds using the option `tags`.
If set to to `true` the deployment will only happen on tag builds, if set to
`false` it will not happen on tag builds.

For example, in order to deploy on tag builds only:

```yaml
deploy:
  provider: <provider>
  # ⋮
  on:
    tags: true
```
{: data-file=".travis.yml"}

* `tags` can be `true`, `false` or any other string:

This will check if the environment variable `$TRAVIS_TAG` is set. Depending on
your workflow, you may set `$TRAVIS_TAG` explicitly, even if this is a non-tag
build when it was initiated.

Setting `tags` to `true` causes the `branch` condition to be ignored, otherwise
`$TRAVIS_TAG` is ignored, and the `branch` condition is considered.

### Examples for conditional deployments

This deploys using a custom script `deploy.sh`, only for builds on the branches
`staging` and `production`.

```yaml
deploy:
  provider: script
  script: deploy.sh
  on:
    all_branches: true
    condition: $TRAVIS_BRANCH =~ ^(staging|production)$
```
{: data-file=".travis.yml"}

This deploys using custom scripts `deploy_production.sh` and
`deploy_staging.sh` depending on the branch that triggered the job.

```yaml
deploy:
  - provider: script
    script: deploy_production.sh
    on:
      branch: production
  - provider: script
    script: deploy_staging.sh
    on:
      branch: staging
```
{: data-file=".travis.yml"}

This deploys to S3 only when `$CC` is set to `gcc`.

```yaml
deploy:
  provider: s3
  access_key_id: <encrypted access_key_id>
  secret_access_key: <encrypted secret_access_key>
  bucket: <bucket>
  on:
    condition: $CC = gcc
```
{: data-file=".travis.yml"}
