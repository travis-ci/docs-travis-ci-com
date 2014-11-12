---
title: Amazon CodeDeploy
layout: en
permalink: codedeploy/
---

Travis CI can automatically trigger a new Deployment on [Amazon CodeDeploy](http://aws.amazon.com/documentation/codedeploy/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: codedeploy
      access_key_id: "YOUR AWS ACCESS KEY"
      secret_access_key: "YOUR AWS SECRET KEY"
      bucket: "S3 Bucket"
      key: latest/MyApp.zip
      application: MyApp
      deployment_group: MyDeploymentGroup

You can find your AWS Access Keys [here](https://console.aws.amazon.com/iam/home?#security_credential). It is recommended to encrypt that key.

Assuming you have the Travis CI command line client installed, you can do it like this:

    travis encrypt --add deploy.secret_access_key

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

    $ travis setup codedeploy

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

This command will also offer to set up [S3 deployment](http://docs.travis-ci.com/user/deployment/s3/), if you want to bundle to be uploaded from the Travis CI build.


### Branch to deploy from

You can explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: codedeploy
      access_key_id: "YOUR AWS ACCESS KEY"
      secret_access_key: "YOUR AWS SECRET KEY"
      bucket: "S3 Bucket"
      key: latest/MyApp.zip
      application: MyApp
      deployment_group: MyDeploymentGroup
      on:
        branch: production

Alternatively, you can also configure Travis CI to deploy from all branches:

    deploy:
      provider: codedeploy
      access_key_id: "YOUR AWS ACCESS KEY"
      secret_access_key: "YOUR AWS SECRET KEY"
      bucket: "S3 Bucket"
      key: latest/MyApp.zip
      application: MyApp
      deployment_group: MyDeploymentGroup
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a release.

### Conditional deployments

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after deployment

Sometimes you want to run commands before or after triggering a deployment. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
