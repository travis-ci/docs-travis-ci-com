---
title: Transifex Deployment
layout: en
deploy: v2
provider: transifex
---

Travis CI supports uploading to [Transifex](https://www.transifex.com/).

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: transifex
  controller: <controller>
  username: <username>
  password: <encrypted password>
  app: <app_name>
```
{: data-file=".travis.yml"}

{% include deploy/providers/testfairy.md %}

{% include deploy/shared.md %}
