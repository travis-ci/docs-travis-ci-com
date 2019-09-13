---
title: Engine Yard Deployment
layout: en
deploy: v2
provider: engineyard
---

Travis CI can automatically deploy your [Engine Yard](https://www.engineyard.com/) application after a successful build.

{% capture content %}
  The Engine Yard API token can be obtained [here](https://cloud.engineyard.com/cli).
{% endcapture %}

{% include deploy/providers/engineyard.md content=content %}

### Application or Environment to deploy

By default, the application name will be inferred from your repository name.

You can explicitly set the name via the **app** option:

```yaml
deploy:
  provider: engineyard
  # ⋮
  app: <app-name>
```
{: data-file=".travis.yml"}

### Deploying branches to different apps or environments

In order to choose apps or environments based on the current branch use
separate deploy configurations:

```yaml
deploy:
  - provider: engineyard
    # ⋮
    env: production
    on:
      branch: master
  - provider: engineyard
    # ⋮
    env: staging
    on:
      branch: staging
```
{: data-file=".travis.yml"}

Or using YAML references:

```yaml
deploy:
  - &deploy
    provider: engineyard
    # ⋮
    env: production
    on:
      branch: master
  - <<: *deploy
    env: staging
    on:
      branch: staging
```
{: data-file=".travis.yml"}

### Running migrations

You can trigger migrations by using the migrate option:

```yaml
deploy:
  provider: engineyard
  # ⋮
  migrate: rake db:migrate
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
