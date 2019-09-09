---
title: Cloud 66 Deployment
layout: en
deploy: v2
provider: cloud66
---

Travis CI can automatically deploy your [Cloud 66](https://www.cloud66.com/) application after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloud66
  redeployment_hook: <url>
```
{: data-file=".travis.yml"}

You can find the redeployment hook URL in the information menu within the Cloud 66 portal.

{% include deploy/providers/cloud66.md %}

{% include deploy/shared.md %}
