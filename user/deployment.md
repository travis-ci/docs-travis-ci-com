---
title: Deployment
layout: en
swiftypetags: 'skip_cleanup'
---

### Supported Providers

Continuous Deployment to the following providers is supported:

{% include deployments.html %}

To deploy to a custom or unsupported provider, use the [after-success build
stage](/user/deployment/custom/) or [script provider](/user/deployment/script).

### Uploading Files

When deploying files to a provider, prevent Travis CI from resetting your
working directory and deleting all changes made during the build ( `git stash
--all`) by adding `skip_cleanup` to your `.travis.yml`:

```yaml
deploy:
  skip_cleanup: true
```
{: data-file=".travis.yml"}

### Deploying to Multiple Providers

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

### Conditional Releases with `on:`

Deployment can be controlled by setting the `on:` for each deployment provider.

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

When all conditions specified in the `on:` section are met, deployment for this
provider will be performed.

Common options are:

1. **`repo`** Slug of your repository (in form: `owner_name/repo_name`, e.g., `travis-ci/dpl`).

2. **`branch`** Name of the branch. If omitted, this defaults to the `app`-specific branch, or `master`. If the branch name is not known ahead of time, you can specify
   `all_branches: true` *instead of* `branch: **` and use other conditions to control your deployment.

3. **`jdk`**, **`node`**, **`perl`**, **`php`**, **`python`**, **`ruby`**, **`scala`**, **`go`**: For language runtimes that support multiple versions,
   you can limit the deployment to happen only on the job that matches the desired version.

4. **`condition`**: You may set bash condition with this option.
   This must be a string value, which will be pasted into a bash expression of the form
   `if [[ <condition> ]]; then <deploy>; fi`
   It can be complex, but there can be only one. For example, `$CC = gcc`.

5. **`tags`**: When set to `true`, the application is deployed when a tag is applied to the commit. This causes the `branch` condition to be ignored.

#### Examples of Conditional Releases using `on:`

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

### Adding a Provider

We are working on adding support for other PaaS providers. If you host your application with a provider not listed here and you would like to have Travis CI automatically deploy your application, please [get in touch](mailto:support@travis-ci.com).

If you contribute to or experiment with the [deploy tool](https://github.com/travis-ci/dpl) make sure you use the edge version from GitHub:

```yaml
deploy:
  provider: awesome-experimental-provider
  edge: true
```
{: data-file=".travis.yml"}

### Pull Requests

Note that pull request builds skip the deployment step altogether.
