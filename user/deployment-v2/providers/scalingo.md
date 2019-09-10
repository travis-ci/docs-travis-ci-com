---
title: Scalingo deployment
layout: en
deploy: v2
provider: scalingo
---

Travis CI can automatically deploy your application to [Scalingo](https://scalingo.com/) application after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: scalingo
  token: <encrypted token>
```

Alternatively, you can authenticate using a user name and password:

```yaml
deploy:
  provider: scalingo
  user: <user>
  password: <encrypted password>
```
{: data-file=".travis.yml"}

{% include deploy/providers/scalingo.md %}

{% include deploy/shared.md %}
