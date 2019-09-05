---
title: Puppet Forge Deployment
layout: en
deploy: v2
provider: puppetforge
---

Travis CI can automatically deploy your modules to [Puppet Forge ](https://forge.puppet.com/) or to your own Forge instance after a successful build.

To deploy to Puppet Forge, add your Puppet Forge username and your
[encrypted](/user/encryption-keys/#usage) Puppet Forge password to your
`.travis.yml`:

```yaml
deploy:
  provider: puppetforge
  user: "<Your username>"
  password:
    secure: "YOUR ENCRYPTED PASSWORD"
```
{: data-file=".travis.yml"}

## Deploying to a custom forge

To deploy to your own hosted Forge instance by adding it in the `url` key:

You can explicitly set the name via the **app** option:

```yaml
deploy:
  provider: puppetforge
  user: "<Your username>"
  password:
    secure: "YOUR ENCRYPTED PASSWORD"
  url: https://forgeapi.example.com/
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
