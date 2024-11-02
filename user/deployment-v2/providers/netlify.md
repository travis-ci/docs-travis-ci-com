---
title: Netlify Drop Deployment
layout: en
deploy: v2
provider: bitballoon
---

Travis CI can automatically deploy files to [Netlify Drop](https://app.netlify.com/drop)
after a successful build.

{% include deploy/providers/netlify.md %}

## Deploying a specific directory

To deploy a specific directory, use the `dir` key:

```yaml
deploy:
  provider: netlify
  # ⋮
  dir: "_build/"
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
