---
title: Hackage Deployment
layout: en
deploy: v2
provider: hackage
---

Travis CI can automatically upload to [Hackage](https://hackage.haskell.org/) after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: hackage
  username: <user>
  password: <password>
```
{: data-file=".travis.yml"}

{% include deploy/providers/hackage.md %}

{% include deploy/shared.md %}
