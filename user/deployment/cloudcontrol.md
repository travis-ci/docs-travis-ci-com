---
title: cloudControl Deployment
layout: en
permalink: /user/deployment/cloudcontrol/
---

Travis CI can automatically deploy your [cloudControl](https://www.cloudcontrol.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloudcontrol
  email: "YOUR CLOUDCONTROL EMAIL"
  password: "YOUR CLOUDCONTROL PASSWORD"
  deployment: "APP_NAME/DEP_NAME"
```

You can sign up for an account on [their website](https://www.cloudcontrol.com) or using the [cctrl
tool](https://www.cloudcontrol.com/dev-center/quickstart#create-a-user-account-if-you-havent-already)

It is recommended that you encrypt your password. Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt "YOUR CLOUDCONTROL PASSWORD" --add deploy.password
```

You can also have the `travis` tool set up everything for you:

```bash
$ travis setup cloudcontrol
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: cloudcontrol
  email: ...
  password: ...
  deployment: ...
  skip_cleanup: true
```

### Conditional Deploys

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
