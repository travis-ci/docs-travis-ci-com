---
title: AWS CodeDeploy
layout: en
deploy: v2
provider: codedeploy
---

Travis CI can automatically upload your build to [AWS CodeDeploy](http://aws.amazon.com/documentation/codedeploy/) after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  - provider: s3
    # rest of S3 deployment for your app
    # ⋮
  - provider: codedeploy
    access_key_id: <encrypted access_key_id>
    secret_access_key: <encrypted secret_access_key>
    bucket: <bucket>
    key: <bucket_key>
    application: <app>
    deployment_group: <deployment_group>
```
{: data-file=".travis.yml"}

In this example, your code will be deployed to an existing CodeDeploy
application called `<app>` in AWS Region `us-east-1`.

A complete example can be found [here](https://github.com/travis-ci/cat-party/blob/master/.travis.yml).

{% include deploy/providers/codedeploy.md minimal=false %}

## Waiting for Deployments

By default, the build will continue immediately after triggering a CodeDeploy
deploy. To wait for the deploy to complete, use the `wait_until_deployed`
option:

```yaml
deploy:
  provider: codedeploy
  # ⋮
  wait_until_deployed: true
```
{: data-file=".travis.yml"}

Travis CI will wait for the deploy to complete, and log whether it succeeded.

## Bundle Types

The [bundleType](http://docs.aws.amazon.com/codedeploy/latest/APIReference/API_S3Location.html#CodeDeploy-Type-S3Location-bundleType)
of your application is inferred from the file extension of `key` set in your
`.travis.yml`.

If your `.travis.yml` contains both, and they do not match, set `bundle_type`
explicitly to the correct value.

## Specifying the AWS region

You can explicitly specify the AWS region to deploy to with the `region` option:

```yaml
deploy:
  provider: codedeploy
  # ⋮
  region: us-west-1
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
