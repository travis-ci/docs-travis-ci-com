---
title: AWS OpsWorks Deployment
layout: en

---

Travis CI can automatically deploy your [AWS OpsWorks](https://aws.amazon.com/en/opsworks/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: opsworks
  access-key-id: ACCESS-KEY-ID
  secret-access-key: SECRET-ACCESS-KEY
  app-id: APP-ID
```

You can obtain your AWS Access Key Id and your AWS Secret Access Key from [here](https://console.aws.amazon.com/iam/home?#security_credential). It is recommended to encrypt your AWS Secret Access Key. Assuming you have the `travis` client installed, you can do it like this:

```bash
travis encrypt SECRET-ACCESS-KEY --add deploy.secret-access-key
```

You can also have the `travis` tool set up everything for you:

```bash
travis setup opsworks
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Migrate the Database

If you want to migrate your rails database on travis to AWS OpsWorks, add the `migrate` option to your `.travis.yml`.

```yaml
deploy:
  provider: opsworks
  access-key-id: ACCESS-KEY-ID
  secret-access-key: SECRET-ACCESS-KEY
  app-id: APP-ID
  migrate: true
```

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

```yaml
deploy:
  provider: opsworks
  access-key-id: ACCESS-KEY-ID
  secret-access-key: SECRET-ACCESS-KEY
  app-id: APP-ID
  if: production
```

Alternatively, you can also configure it to deploy from all branches:

```yaml
deploy:
  provider: opsworks
  access-key-id: ACCESS-KEY-ID
  secret-access-key: SECRET-ACCESS-KEY
  app-id: APP-ID
  if:
    all_branches: true
```

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests run and before the deploy stage, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: opsworks
  access-key-id: ACCESS-KEY-ID
  secret-access-key: SECRET-ACCESS-KEY
  app-id: APP-ID
  skip_cleanup: true
```

### Waiting for Deployments

By default, the build will continue immediately after triggering an OpsWorks
deploy. To wait for the deploy to complete, use the **wait-until-deployed**
option:

```yaml
deploy:
  provider: opsworks
  access-key-id: ACCESS-KEY-ID
  secret-access-key: SECRET-ACCESS-KEY
  app-id: APP-ID
  wait-until-deployed: true
```

Travis CI will wait up to 10 minutes for the deploy to complete, and log
whether it succeeded.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `if:`](/user/deployment#Conditional-Releases-with-on%3A).

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
