---
title: Chef Supermarket Deployment
layout: en
deploy: v2
provider: chef_supermarket
---

Travis CI can automatically deploy your cookbook to [Chef Supermarket](https://supermarket.chef.io/)
after a successful build.

{% capture content %}
  Encrypt your client key by running the following command and add it to your
  `.travis.yml` file:

  ```yaml
  travis encrypt-file client.pem
  ```
{: data-file=".travis.yml"}

  See [Encrypting Files](/user/encrypting-files/) for instructions on adding
  encrypted files to your repository and `.travis.yml` file.
{% endcapture %}

{% include deploy/providers/chef_supermarket.md content=content %}
{% include deploy/shared.md %}
