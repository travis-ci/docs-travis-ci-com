---
title: Azure Web App Deployment
layout: en
deploy: v2
provider: azure_web_apps
---

Travis CI can automatically deploy your [Azure Web App](https://azure.microsoft.com/en-us/services/app-service/web/)
after a successful build.

{% include deploy/providers/azure_web_apps.md %}

## Fetching Deployment Progress and Logs

The Azure Web App provider can print Azure's deployment progress to your Travis
log using the `verbose` option.

However, Git will print your password if the authentication fails (it will not
if you provide a correct user/password combination).

```yaml
deploy:
  provider: azure_web_apps
  # ⋮
  verbose: true
```
{: data-file=".travis.yml"}

## Note on .gitignore

As this deployment strategy relies on Git, be mindful that the deployment will
honor `.gitignore`.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#running-commands-before-and-after-deploy) to change
its content.

## Deploying to slots

You might need to deploy multiple branches to different slots. You can set
multiple providers to deploy to specific slots. The following configuration
would deploy the `master` branch to the `myapp-staging` slot and the `develop`
branch to the `myapp-develop` slot. In order to use slots you'll need to [set
up staging environments for web apps in Azure App
Service](https://azure.microsoft.com/en-us/documentation/articles/web-sites-staged-publishing/).

```yaml
deploy:
- provider: azure_web_apps
  # ⋮
  slot: myapp-staging
  on:
    branch: master
- provider: azure_web_apps
  # ⋮
  slot: myapp-dev
  on:
    branch: dev
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
