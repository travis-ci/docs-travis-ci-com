---
title: OpenShift Deployment
layout: en
deploy: v2
provider: openshift
---

Travis CI can automatically deploy to [OpenShift](https://www.openshift.com/) after a successful build.

{% include deploy/providers/openshift.md %}

## Specifying the application name

By default, your repository name will be used as the application name.

You can set a different application name using the `app` option:

```yaml
deploy:
  provider: openshift
  # ⋮
  app: <app_name>
```
{: data-file=".travis.yml"}

### Deploying branches to different projects

In order to choose projects based on the current branch use separate deploy
configurations:

```yaml
deploy:
  - provider: openshift
    # ⋮
    project: <project-1>
    on:
      branch: master
  - provider: openshift
    # ⋮
    project: <project-2>
    on:
      branch: staging
```
{: data-file=".travis.yml"}

Or using YAML references:

```yaml
deploy:
  - &deploy
    provider: openshift
    # ⋮
    project: <project-1>
    on:
      branch: master
  - <<: *deploy
    project: <project-2>
    on:
      branch: staging
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
