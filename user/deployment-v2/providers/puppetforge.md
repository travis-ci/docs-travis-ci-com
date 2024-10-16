---
title: Puppet Forge Deployment
layout: en
deploy: v2
provider: puppetforge
---

Travis CI can automatically deploy your modules to [Puppet Forge ](https://forge.puppet.com/) or to your own Forge instance after a successful build.

{% include deploy/providers/puppetforge.md %}

## Deploying to a custom Forge

To deploy to your own hosted Forge instance by adding it in the `url` key:

```yaml
deploy:
  provider: puppetforge
  # ⋮
  url: https://forgeapi.example.com/
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
