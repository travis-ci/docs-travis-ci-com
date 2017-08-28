---
title: OpenShift Deployment
layout: en

---

Travis CI can automatically deploy your [OpenShift](https://www.openshift.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: openshift
  user: "YOU USER NAME"
  password: "YOUR PASSWORD" # can be encrypted
  domain: "YOUR OPENSHIFT DOMAIN"
```

Currently it is not possible to use a token instead of the password, as these tokens expire too quickly. We are working with the OpenShift team on a solution.

You can also have the `travis` tool set up everything for you:

```bash
travis setup openshift
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

To provide the best service possible, Travis CI has teamed up with OpenShift as a [partner](https://www.openshift.com/partners) and there is an official [Travis CI QuickStart](https://hub.openshift.com/quickstarts/26-travis-ci) to get you going.

### Application to deploy

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to an OpenShift app named *travis-chat*.

You can explicitly set the name via the **app** option:

```yaml
deploy:
  provider: openshift
  ...
  app: my-app-123
```

It is also possible to deploy different branches to different applications:

```yaml
deploy:
  provider: openshift
  ...
  app:
    master: my-app-staging
    production: my-app-production
```

If these apps belong to different OpenShift domains, you will have to do the same for the domain:

```yaml
deploy:
  provider: openshift
  ...
  domain:
    master: ...
    production: ...
  app:
    master: my-app-staging
    production: my-app-production
```

### Branch to deploy from

If you have branch specific options, as [shown above](#Application-to-deploy), Travis CI will automatically figure out which branches to deploy from. Otherwise, it will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

```yaml
deploy:
  provider: openshift
  ...
  if: production
```

Alternatively, you can also configure it to deploy from all branches:

```yaml
deploy:
  provider: openshift
  ...
  if:
    all_branches: true
```

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: openshift
  ...
  skip_cleanup: true
```

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `if:`](/user/deployment#Conditional-Releases-with-on%3A).

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

### Deployment branch

OpenShift can be configured to deploy from a branch different from the default `master` via `rhc app-configure --deployment-branch mybranch`.

If you've done this to your application, specify this desired branch with `deployment_branch`:

```yaml
deploy:
  provider: openshift
  ...
  deployment_branch: mybranch
```
