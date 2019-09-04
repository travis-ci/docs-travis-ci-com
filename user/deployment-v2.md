---
title: Deployment (v2)
layout: en
---

> ALPHA This page documents deployments using the next major version dpl v2 which currently is in a preview release phase. Please see [the announcement blog post](https://blog.travis-ci.com/2019-08-27-deployment-tooling-dpl-v2-preview-release) on details about the release process. Documentation for dpl v1, the current default version, can be found [here](/user/deployment). {: alpha}

## Supported Providers

Continuous Deployment to the following providers is supported:

{% include deployments.html %}

To deploy to a custom or unsupported provider, use the [after-success build
step](/user/deployment/custom/) or [script provider](/user/deployment/script).

## Maturity Levels

In order to communicate the current development status and maturity of dpl's
support for a particular service, the respective provider is marked with one of
the following maturity levels, according to the given criteria:

* `dev` - the provider is in development (initial level)
* `alpha` - the provider is fully tested
* `beta` - the provider has been in alpha for at least a month and successful real-world production deployments have been observed
* `stable` - the provider has been in beta for at least two months and there are no open issues that qualify as critical (such as deployments failing, documented functionality broken, etc.)

Dpl v2 represents a major rewrite, so support for all providers has been
reset to `dev` or `alpha`, depending on the test status.

For all levels except `stable` a message will be printed to your build log
that informs you about the current status.

## Cleaning up the Git Working Directory

The previous version of dpl - our deployment integration tooling - used to
reset your working directory and delete all changes made during the build
using `git stash --all`. In order to keep changes one had to opt out using
`skip_cleanup: true`. This default turned out to be useful only for very few
providers and has been changed in dpl v2.

If you do need to clean up the working directory from any changes made during
the build process, please opt in to cleanup by adding the following to your
`.travis.yml` file:

```yaml
deploy:
  cleanup: true
```
{: data-file=".travis.yml"}

## Deploying to Multiple Providers

Deploying to multiple providers is possible by adding the different providers
to the `deploy` section as a list. For example, if you want to deploy to both
cloudControl and Heroku, your `deploy` section would look something like this:

```yaml
deploy:
  - provider: cloudcontrol
    email: "YOUR CLOUDCONTROL EMAIL"
    password: "YOUR CLOUDCONTROL PASSWORD"
    deployment: "APP_NAME/DEP_NAME"
  - provider: heroku
    api_key: "YOUR HEROKU API KEY"
```
{: data-file=".travis.yml"}

## Conditional Releases with `on:`

Set your build to deploy only in specific circumstances by configuring the `on:` key for any deployment provider.

```yaml
deploy:
  provider: s3
  access_key_id: "YOUR AWS ACCESS KEY"
  secret_access_key: "YOUR AWS SECRET KEY"
  bucket: "S3 Bucket"
  skip_cleanup: true
  on:
    branch: release
    condition: $MY_ENV = super_awesome
```
{: data-file=".travis.yml"}

When *all* conditions specified in the `on:` section are met, your build will deploy.

Use the following options to configure conditional deployment:

* `repo`: in the form `owner_name/repo_name`. Deploy only when the build occurs on a particular repository. For example:

   ```yaml
   deploy:
     provider: s3
     on:
       repo: travis-ci/dpl
   ```
   {: data-file=".travis.yml"}

* `branch`: name of the branch.
   If omitted, this defaults to the `app`-specific branch or `master`. If the branch name is not known ahead of time, you can specify
   `all_branches: true` *instead of* `branch: ` and use other conditions to control your deployment.

* `jdk`, `node`, `perl`, `php`, `python`, `ruby`, `scala`, `go`: for language runtimes that support multiple versions,
   you can limit the deployment to happen only on the job that matches a specific version.

* `condition`: deploy when *a single* bash condition evaluates to `true`. This must be a string value and is equivalent to `if [[ <condition> ]]; then <deploy>; fi`. For example, `$CC = gcc`.

* `tags` can be `true`, `false` or any other string:

    * `tags: true`: deployment is triggered if and only if `$TRAVIS_TAG` is set.
       Depending on your workflow, you may set `$TRAVIS_TAG` explicitly, even if this is
       a non-tag build when it was initiated. This causes the `branch` condition to be ignored.
    * `tags: false`: deployment is triggered if and only if `$TRAVIS_TAG` is empty.
       This also causes the `branch` condition to be ignored.
    * When `tags` is not set, or set to any other value, `$TRAVIS_TAG` is ignored, and the `branch` condition is considered, if it is set.

### Examples of Conditional Deployment

This example deploys to Appfog only from the `staging` branch when the test has run on Node.js version 0.11.

```yaml
language: node_js
deploy:
  provider: appfog
  user: ...
  api_key: ...
  on:
    branch: staging
    node_js: '0.11' # this should be quoted; otherwise, 0.10 would not work
```
{: data-file=".travis.yml"}

The next example deploys using a custom script `deploy.sh`, only for builds on the branches `staging` and `production`.

```yaml
deploy:
  provider: script
  script: deploy.sh
  on:
    all_branches: true
    condition: $TRAVIS_BRANCH =~ ^(staging|production)$
```
{: data-file=".travis.yml"}

The next example deploys using custom scripts `deploy_production.sh` and `deploy_staging.sh` depending on the branch that triggered the job.

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

The next example deploys to S3 only when `$CC` is set to `gcc`.

```yaml
deploy:
  provider: s3
  access_key_id: "YOUR AWS ACCESS KEY"
  secret_access_key: "YOUR AWS SECRET KEY"
  skip_cleanup: true
  bucket: "S3 Bucket"
  on:
    condition: "$CC = gcc"
```
{: data-file=".travis.yml"}

This example deploys to GitHub Releases when a tag is set and the Ruby version is 2.0.0.

```yaml
deploy:
  provider: releases
  api_key: "GITHUB OAUTH TOKEN"
  file: "FILE TO UPLOAD"
  skip_cleanup: true
  on:
    tags: true
    rvm: 2.0.0
```
{: data-file=".travis.yml"}

### Adding a deployment provider

We are working on adding support for other PaaS providers. If you host your application with a provider not listed here and you would like to have Travis CI automatically deploy your application, please [get in touch](mailto:support@travis-ci.com?subject:New%20deployment%20provider%20proposal).

If you contribute to or experiment with the [deploy tool](https://github.com/travis-ci/dpl), make sure you use the edge version from GitHub:

```yaml
deploy:
  provider: awesome-experimental-provider
  edge: true
```
{: data-file=".travis.yml"}

## Pull Requests

> Note that pull request builds skip the deployment step altogether.
