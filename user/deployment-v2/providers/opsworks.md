---
title: AWS OpsWorks Deployment
layout: en
deploy: v2
provider: opsworks
---

Travis CI can automatically deploy your [AWS OpsWorks](https://aws.amazon.com/en/opsworks/) application after a successful build.

{% capture content %}
  You can obtain your AWS Access Key Id and your AWS Secret Access Key from
  [here](https://console.aws.amazon.com/iam/home?#security_credential).

  `region` defaults to `us-east-1`. If your application is located in a different
  region you will see an error `Unable to find app`.
{% endcapture %}

{% include deploy/providers/opsworks.md content=content %}

### Migrate the Database

If you want to migrate your rails database on travis to AWS OpsWorks, add the `migrate` option:

```yaml
deploy:
  provider: opsworks
  # ⋮
  migrate: true
```
{: data-file=".travis.yml"}

### Waiting for Deployments

By default, the build will continue immediately after triggering an OpsWorks
deploy. To wait for the deploy to complete, use the `wait_until_deployed`
option:

```yaml
deploy:
  provider: opsworks
  # ⋮
  wait_until_deployed: true
```
{: data-file=".travis.yml"}

Travis CI will wait up to 10 minutes for the deploy to complete, and log
whether it succeeded.

### Updating App Settings after successful Deployments

By default the deploy from Travis CI triggers a deployment on OpsWorks but does
not touch any other configuration. To also update the revision in App Settings
use the `update_app_on_success` option. In addition you have to set the
`wait_until_deployed` option:

```yaml
deploy:
  provider: opsworks
  # ⋮
  wait-until-deployed: true
  update-app-on-success: true
```
{: data-file=".travis.yml"}

Travis CI will wait until the deployment returns successful and only then
update the revision in App Settings.

{% include deploy/shared.md %}
