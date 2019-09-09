---
title: Cloud Foundry Deployment
layout: en
deploy: v2
provider: cloudfoundry
---

Travis CI can automatically upload your build to [Cloud Foundry](https://run.pivotal.io/) after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
 deploy:
   provider: cloudfoundry
   username: <username>
   password: <pasword>
   api: https://api.run.pivotal.io
   organization: <organization>
   space: <space>
```
{: data-file=".travis.yml"}

{% include deploy/providers/cloudfoundry.md %}

{% include deploy/shared.md %}
