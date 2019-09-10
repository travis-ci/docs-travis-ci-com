---
title: AWS Elastic Beanstalk Deployment
layout: en
deploy: v2
provider: elasticbeanstalk
---

Travis CI can automatically deploy your application to [Elastic Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/)
after a successful build.

{% include deploy/providers/elasticbeanstalk.md %}

## Creating an application without deploying it

To create an application without deploying it, use `only_create_app_version`:

```yaml
deploy:
  provider: elasticbeanstalk
  # ⋮
  only_create_app_version: true
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
