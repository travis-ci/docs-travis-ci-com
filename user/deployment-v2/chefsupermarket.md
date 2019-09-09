---
title: Chef Supermarket deployment
layout: en
deploy: v2
provider: chef_supermarket
---

Travis CI can automatically deploy your cookbook to [Chef Supermarket](https://supermarket.chef.io/)
after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: chef_supermarket
  user_id: <username>
  category: <category>
```
{: data-file=".travis.yml"}

Encrypt your client key by running the following command and add it to your
`.travis.yml` file:

```bash
travis encrypt-file client.pem
```

See [Encrypting Files](http://localhost:4000/user/encrypting-files/) for
detailed instructions on how to add encrypted files to your repository and
`.travis.yml` file.

{% include deploy/providers/chef_supermarket.md %}

{% include deploy/shared.md %}
