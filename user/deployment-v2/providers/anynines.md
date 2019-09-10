---
title: anynines Deployment
layout: en
deploy: v2
provider: anynines
---

You can deploy your application to [anynines](http://www.anynines.com/) after a successful build on Travis CI.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
 deploy:
   provider: anynines
   username: <username>
   password: <encrypted password>
   organization: <organziation>
   space: <space>
```
{: data-file=".travis.yml"}

{% include deploy/providers/anynines.md %}

{% include deploy/shared.md %}

