---
title: Azure Web App Deployment
layout: en
deploy: v2
provider: azure_web_apps
---

Travis CI can automatically deploy your [Azure Web App](https://azure.microsoft.com/en-us/services/app-service/web/) after a successful build.

For a minimal configuration, all you need to do is enable [Local Git Deployment](https://azure.microsoft.com/en-us/documentation/articles/app-service-deploy-local-git/) and add the following to your `.travis.yml`:

```yaml
deploy:
  provider: azure_web_apps
  username: azure_deployment_user       # If AZURE_WA_USERNAME isn't set
  password: azure_deployment_password   # If AZURE_WA_PASSWORD isn't set
  site: azure_deployment_sitename       # If AZURE_WA_SITE isn't set
  slot: azure_deployment_slotname       # (optional) If AZURE_WA_SLOT isn't set
```
{: data-file=".travis.yml"}

It is not recommended that you put your Azure Deployment credentials unencrypted into your `.travis.yml`. Instead, use hidden environment variables or encrypted variables.

To define variables in Repository Settings, make sure you're logged in, navigate to the repository in question, choose "Settings" from the cog menu, and click on "Add new variable" in the "Environment Variables" section. As an alternative to the web interface, you can also use the CLI's [`env`](https://github.com/travis-ci/travis.rb#env) command.

<figure>
  <img alt="Travis CI Settings" src="{{ "/images/2019-07-settings-env-vars.png" | prepend: site.baseurl }}">
  <figcaption>Environment Variables in the Repository Settings</figcaption>
</figure>

### Fetch Deployment Progress and Logs

The Azure Web App provider can print Azure's deployment progress to your Travis log using the `verbose` option. However, Git will print your password if the authentication fails (it will not if you provide a correct user/password combination).

```yaml
deploy:
  provider: azure_web_apps
  verbose: true
```
{: data-file=".travis.yml"}

### Note on `.gitignore`

As this deployment strategy relies on `git`, be mindful that the deployment will
honor `.gitignore`.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#running-commands-before-and-after-deploy) to change
its content.

### Deploying to slots

You might need to deploy multiple branches to different slots. You can set multiple providers to deploy to specific slots. The following configuration would deploy the `master` branch to the `myapp-staging` slot and the `develop` branch to the `myapp-develop` slot. In order to use slots you'll need to [set up staging environments for web apps in Azure App Service](https://azure.microsoft.com/en-us/documentation/articles/web-sites-staged-publishing/).

```yaml
deploy:
- provider: azure_web_apps
  slot: myapp-staging
- provider: azure_web_apps
  slot: myapp-develop
  on: develop
```
{: data-file=".travis.yml"}


{% include deploy/branch.md %}

{% include deploy/before_after_deploy.md %}
