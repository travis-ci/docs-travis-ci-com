---
title: ExoScale Deployment
layout: en
permalink: /user/deployment/exoscale/
---

Travis CI can automatically deploy your [ExoScale](https://www.exoscale.ch/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: exoscale
  email: "YOUR CLOUDCONTROL EMAIL OR ORGANIZATION ID"
  password: "YOUR CLOUDCONTROL PASSWORD"
  deployment: "APP_NAME/DEP_NAME"
```

You can sign up for an account on [their website](https://www.exoscale.ch/) or using the [cctrl
tool](https://community.exoscale.ch/apps/quickstart/#Create_a_User_Account_if_you_havent_already).

It is recommended that you encrypt your password. Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt "YOUR EXOSCALE PASSWORD" --add deploy.password
```

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: exoscale
  email: ...
  password: ...
  deployment: ...
  skip_cleanup: true
```

### Conditional Deploys

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

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
