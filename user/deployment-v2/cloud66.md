---
title: Cloud 66 Deployment
layout: en
deploy: v2
provider: cloud66
---

Travis CI can automatically deploy your [Cloud 66](https://www.cloud66.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloud66
  redeployment_hook: "your redeployment hook url"
```
{: data-file=".travis.yml"}

You can find the redeployment hook in the information menu within the Cloud 66 portal.

You can also have the `travis` tool set up everything for you:

```bash
travis setup cloud66
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

{% include deploy/shared.md %}
