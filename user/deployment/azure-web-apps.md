---
title: Azure Web App Deployment
layout: en
permalink: /user/deployment/azure-web-apps/
---

Travis CI can automatically deploy your [Azure Web App](https://azure.microsoft.com/en-us/services/app-service/web/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:  
      provider: azure_web_apps
      username: azure_deployment_user       # If AZURE_WA_USERNAME isn't set
      password: azure_deployment_password   # If AZURE_WA_PASSWORD isn't set
      site: azure_deployment_sitename       # If AZURE_WA_SITE isn't set

It is not recommended that you put your Azure Deployment credentials unencrypted into your `.travis.yml`. Instead, use hidden environment variables or encrypted variables. 

To define variables in Repository Settings, make sure you're logged in, navigate to the repository in question, choose "Settings" from the cog menu, and click on "Add new variable" in the "Environment Variables" section. As an alternative to the web interface, you can also use the CLI's [`env`](https://github.com/travis-ci/travis.rb#env) command.

<figure>
  <img alt="Travis CI Settings" src="{{ "/images/settings-env-vars.png" | prepend: site.baseurl }}">
  <figcaption>Environment Variables in the Repository Settings</figcaption>
</figure>

### Fetch Deployment Progress and Logs

The Azure Web App provider can print Azure's deployment progress to your Travis log using the `verbose` option. However, Git will print your password if the authentication fails (it will not if you provide a correct user/password combination).

    deploy:  
      provider: azure_web_apps
      verbose: true

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: azure_web_apps
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: azure_web_apps
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
