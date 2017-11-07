---
title: AWS CodeDeploy
layout: en

---

Travis CI can automatically trigger a new Deployment on [AWS CodeDeploy](http://aws.amazon.com/documentation/codedeploy/) after a successful build.

For a minimal configuration with S3, add the following to your `.travis.yml`:

```yaml
    deploy:
      - provider: s3
        ⋮ # rest of S3 deployment for MyApp.zip
      - provider: codedeploy
        access_key_id: "YOUR AWS ACCESS KEY"
        secret_access_key: "YOUR AWS SECRET KEY"
        bucket: "S3 Bucket"
        key: latest/MyApp.zip
        application: MyApp
        deployment_group: MyDeploymentGroup
```
{: data-file=".travis.yml"}

Note that in this example, Travis CI will attempt to deploy to an existing CodeDeploy Application called MyApp in AWS Region `us-east-1`.  

A complete example can be found [here](https://github.com/travis-ci/cat-party/blob/master/.travis.yml).

You can find your AWS Access Keys [here](https://console.aws.amazon.com/iam/home?#security_credential). It is recommended to encrypt that key.

If your CodeDeploy application lives in any region other than `us-east-1` please add a region field to `.travis.yml` (see [AWS-region-to-deploy-to](https://docs.travis-ci.com/user/deployment/codedeploy#AWS-region-to-deploy-to)).

Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
travis encrypt --add deploy.secret_access_key
```

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

```bash
travis setup codedeploy
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

This command will also offer to set up [S3 deployment](http://docs.travis-ci.com/user/deployment/s3/), if you want to bundle to be uploaded from the Travis CI build.

### Branch to deploy from

You can explicitly specify the branch to deploy from with the **on** option:

```yaml
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
```
{: data-file=".travis.yml"}

Alternatively, you can also configure Travis CI to deploy from all branches:

```yaml
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
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a release.

### S3 deployment or GitHub deployment

For a minimal configuration with GitHub, add the following to your `.travis.yml`:

```yaml
    deploy:
      - provider: codedeploy
        revision_type: github
        access_key_id: "YOUR AWS ACCESS KEY"
        secret_access_key: "YOUR AWS SECRET KEY"
        application: "Your Codedeploy application"
        deployment_group: "The Deployment group associated with the codedeploy application"
        region: "Region in which your ec2 instance is."
```
{: data-file=".travis.yml"}

Please note that `region` should match the instance region on which codedeploy is configured.

### Waiting for Deployments

By default, the build will continue immediately after triggering a CodeDeploy deploy. To wait for the deploy to complete, use the **wait-until-deployed** option:

```yaml
deploy:
  provider: codedeploy
    ⋮
    wait-until-deployed: true
```
{: data-file=".travis.yml"}

Travis CI will wait for the deploy to complete, and log whether it succeeded.

### Conditional deployments

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

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

### AWS region to deploy to

You can explicitly specify the AWS region to deploy to with the **region** option:

```yaml
    deploy:
      provider: codedeploy
      access_key_id: "YOUR AWS ACCESS KEY"
      secret_access_key: "YOUR AWS SECRET KEY"
      bucket: "S3 Bucket"
      key: latest/MyApp.zip
      application: MyApp
      deployment_group: MyDeploymentGroup
      region: us-west-1
```
{: data-file=".travis.yml"}
