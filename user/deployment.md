---
title: Deployment
layout: en
permalink: /user/deployment/
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

	deploy:
		skip_cleanup: true


### Deploying to Multiple Providers

Deploying to multiple providers is possible by adding the different providers
to the `deploy` section as a list. For example, if you want to deploy to both
cloudControl and Heroku, your `deploy` section would look something like this:

    deploy:
      - provider: cloudcontrol
        email: "YOUR CLOUDCONTROL EMAIL"
        password: "YOUR CLOUDCONTROL PASSWORD"
        deployment: "APP_NAME/DEP_NAME"
      - provider: heroku
        api_key "YOUR HEROKU API KEY"

### Conditional Releases with `on:`

Deployment can be controlled by setting the `on:` for each deployment provider.

    deploy:
      provider: s3
      access_key_id: "YOUR AWS ACCESS KEY"
      secret_access_key: "YOUR AWS SECRET KEY"
      bucket: "S3 Bucket"
      skip_cleanup: true
      on:
        branch: release
        condition: $MY_ENV = super_awesome

When all conditions specified in the `on:` section are met, deployment for this
provider will be performed.

Common options are:

1. **`repo`** Name of the repository, along with the owner (e.g., `travis-ci/dpl`).

1. **`branch`** Name of the branch. If omitted, this defaults to the `app`-specific branch, or `master`. If the branch name is not known ahead of time, you can specify
  `all_branches: true` _instead of_ `branch: **` and use other conditions to control your deployment.

1. **`jdk`**, **`node`**, **`perl`**, **`php`**, **`python`**, **`ruby`**, **`scala`**, **`go`**: For language runtimes that support multiple versions,
  you can limit the deployment to happen only on the job that matches the desired version.

1. **`condition`**: You may set bash condition with this option.
This must be a string value, which will be pasted into a bash expression of the form
`if [[ <condition> ]]; then <deploy>; fi`
It can be complex, but there can be only one. For example, `$CC = gcc`.

1. **`tags`**: When set to `true`, the application is deployed when a tag is applied to the commit. This causes the `branch` condition to be ignored.

#### Examples of Conditional Releases using `on:`

This example deploys to Nodejistu only from the `staging` branch when the test has run on Node.js version 0.11.

    deploy:
      provider: appfog
      user: ...
      api_key: ...
      on:
        branch: staging
        node: '0.11' # this should be quoted; otherwise, 0.10 would not work

The next example deploys to S3 only when `$CC` is set to `gcc`.

    deploy:
      provider: s3
      access_key_id: "YOUR AWS ACCESS KEY"
      secret_access_key: "YOUR AWS SECRET KEY"
      skip_cleanup: true
      bucket: "S3 Bucket"
      on:
        condition: "$CC = gcc"

This example deploys to GitHub Releases when a tag is set and the Ruby version is 2.0.0.

    deploy:
      provider: releases
      api-key: "GITHUB OAUTH TOKEN"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true
        rvm: 2.0.0

### Adding a Provider

We are working on adding support for other PaaS providers. If you host your application with a provider not listed here and you would like to have Travis CI automatically deploy your application, please [get in touch](mailto:support@travis-ci.com).

If you contribute to or experiment with the [deploy tool](https://github.com/travis-ci/dpl) make sure you use the edge version from GitHub:

    deploy:
      provider: awesome-experimental-provider
      edge: true

### Pull Requests

Note that pull request builds skip deployment step altogether.
