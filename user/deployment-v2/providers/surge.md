---
title: Surge.sh Deployment
layout: en
deploy: v2
provider: surge
---

Travis CI can deploy to [Surge.sh](https://surge.sh/) after a successful build.

{% include deploy/providers/surge.md %}

# Specifying a project directory

By default it is assumed that the repository root contains the files to deploy.

In order to specify a different project directory use the option `project`:

```yaml
deploy:
  provider: surge
  # ⋮
  project: ./static
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
