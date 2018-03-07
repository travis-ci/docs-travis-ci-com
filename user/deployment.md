---
title: Deployment
layout: en
swiftypetags: 'skip_cleanup'
---

<div id="toc"></div>

## Supported Providers

Continuous Deployment to the following providers is supported:

{% include deployments.html %}

To deploy to a custom or unsupported provider, use the [after-success build
stage](/user/deployment/custom/) or [script provider](/user/deployment/script).

## Uploading Files and skip_cleanup

When deploying files to a provider, prevent Travis CI from resetting your
working directory and deleting all changes made during the build ( `git stash
--all`) by adding `skip_cleanup` to your `.travis.yml`:

```yaml
deploy:
  skip_cleanup: true
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

* `repo`: in the form `owner_name/repo_name`. Deploy only when the build occurs on a particular repository. For example

   ```yaml
   on:
     repo: travis-ci/dpl
   ```

* `branch`: name of the branch.
   If omitted, this defaults to the `app`-specific branch, or `master`. If the branch name is not known ahead of time, you can specify
   `all_branches: true` *instead of* `branch: ` and use other conditions to control your deployment.

* `jdk`, `node`, `perl`, `php`, `python`, `ruby`, `scala`, `go`: for    language runtimes that support multiple versions,
   you can limit the deployment to happen only on the job that matches a specific version.

* `condition`: deploy when *a single* bash condition evaluates to `true`. This must be a string value, and is equivalant to `if [[ <condition> ]]; then <deploy>; fi`. For example, `$CC = gcc`.

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
deploy:
  provider: appfog
  user: ...
  api_key: ...
  on:
    branch: staging
    node: '0.11' # this should be quoted; otherwise, 0.10 would not work
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

We are working on adding support for other PaaS providers. If you host your application with a provider not listed here and you would like to have Travis CI automatically deploy your application, please [get in touch](mailto:support@travis-ci.com).

If you contribute to or experiment with the [deploy tool](https://github.com/travis-ci/dpl) make sure you use the edge version from GitHub:

```yaml
deploy:
  provider: awesome-experimental-provider
  edge: true
```
{: data-file=".travis.yml"}

## Pull Requests

Note that pull request builds skip the deployment step altogether.
