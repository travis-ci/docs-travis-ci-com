---
title: Bluemix CloudFoundry Deployment
layout: en
deploy: v2
provider: bluemixcloudfoundry
---

Travis CI can automatically deploy files to [IBM Bluemix](http://bluemix.net/)
after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
 deploy:
   provider: bluemixcloudfoundry
   username: <username>
   password: <encrypted password>
   organization: <organization>
   space: <space>
```
{: data-file=".travis.yml"}

{% include deploy/providers/bluemixcloudfoundry.md %}

{% include deploy/shared.md %}
