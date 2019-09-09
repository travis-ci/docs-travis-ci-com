---
title: Hephy Deployment
layout: en
deploy: v2
provider: hephy
---

Travis CI supports uploading to Hephy.

A minimal configuration is:

```yaml
deploy:
  provider: hephy
  controller: <controller>
  username: <username>
  password: <password>
  app: <app>
```
{: data-file=".travis.yml"}

{% include deploy/providers/hephy.md %}

{% include deploy/shared.md %}
