---
title: AWS OpsWorks Deployment
layout: en
permalink: opsworks/
---

Travis CI can automatically trigger a deploy of your [AWS OpsWorks](https://aws.amazon.com/en/opsworks/) application after a successful build. This will not send code from Travis to OpsWorks. You will need to [configure OpsWorks to pull in your code](http://docs.aws.amazon.com/opsworks/latest/userguide/workingapps-creating.html#workingapps-creating-source) from source control, S3, or an HTTP bundle.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: opsworks
      access-key-id: ACCESS-KEY-ID
      secret-access-key: SECRET-ACCESS-KEY
      app-id: APP-ID

You can obtain your AWS Access Key Id and your AWS Secret Access Key from [here](https://console.aws.amazon.com/iam/home?#security_credential). It is recommended to encrypt your AWS Secret Access Key. Assuming you have the `travis` client installed, you can do it like this:

    $ travis encrypt SECRET-ACCESS-KEY --add deploy.secret-access-key

You can also have the `travis` tool set up everything for you:

    $ travis setup opsworks

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Migrate the Database

If you want to migrate your rails database on travis to AWS OpsWorks, add the `migrate` option to your `.travis.yml`.

    deploy:
      provider: opsworks
      access-key-id: ACCESS-KEY-ID
      secret-access-key: SECRET-ACCESS-KEY
      app-id: APP-ID
      migrate: true

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: opsworks
      access-key-id: ACCESS-KEY-ID
      secret-access-key: SECRET-ACCESS-KEY
      app-id: APP-ID
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: opsworks
      access-key-id: ACCESS-KEY-ID
      secret-access-key: SECRET-ACCESS-KEY
      app-id: APP-ID
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Waiting for Deployments

By default, the build will continue immediately after triggering an OpsWorks
deploy. To wait for the deploy to complete, use the **wait-until-deployed**
option:

    deploy:
      provider: opsworks
      access-key-id: ACCESS-KEY-ID
      secret-access-key: SECRET-ACCESS-KEY
      app-id: APP-ID
      wait-until-deployed: true

Travis CI will wait up to 10 minutes for the deploy to complete, and log
whether it succeeded.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
