---
title: Azure Web App Deployment
layout: en

---

Travis CI can automatically deploy your [Azure Web App](https://azure.microsoft.com/en-us/services/app-service/web/) after a successful build.

<aside markdown="block" class="ataglance">

## Options

{{ site.data.dpl.azure-web-apps }}

</aside>


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
  <img alt="Travis CI Settings" src="{{ "/images/settings-env-vars.png" | prepend: site.baseurl }}">
  <figcaption>Environment Variables in the Repository Settings</figcaption>
</figure>

### Fetch Deployment Progress and Logs

The Azure Web App provider can print Azure's deployment progress to your Travis log using the `verbose` option. However, Git will print your password if the authentication fails (it will not if you provide a correct user/password combination).

```
deploy:
  provider: azure_web_apps
  verbose: true
```

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

```
deploy:
  provider: azure_web_apps
  on: production
```

Alternatively, you can also configure it to deploy from all branches:

```
deploy:
  provider: azure_web_apps
  on:
    all_branches: true
```

Builds triggered from Pull Requests will never trigger a deploy.

### Note on `.gitignore`

As this deployment strategy relies on `git`, be mindful that the deployment will
honor `.gitignore`.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#Running-commands-before-and-after-deploy) to change
its content.

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}

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
