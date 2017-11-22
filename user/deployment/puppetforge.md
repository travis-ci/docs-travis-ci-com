---
title: Puppet Forge Deployment
layout: en

---

<div id="toc"></div>

Travis CI can automatically deploy your modules to [Puppet Forge ](https://forge.puppet.com/) or to your own Forge instance after a successful build.

<aside markdown="block" class="ataglance">

## Options

{{ site.data.dpl.puppet-forge }}

</aside>

To deploy to Puppet Forge, add your Puppet Forge username and your
[encrypted](/user/encryption-keys/#Usage) Puppet Forge password to your
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

## Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use
the `before_deploy` and `after_deploy` stages for this. These will only be
triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
