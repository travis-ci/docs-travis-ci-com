---
title: Appfog deployment
layout: en

---

Travis CI can automatically deploy your [Appfog](https://www.appfog.com/) application after a successful build.

<aside markdown="block" class="ataglance">

## Options

{{ site.data.dpl.appfog  }}

</aside>


For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: appfog
  email: "YOUR EMAIL ADDRESS"
  password: "YOUR PASSWORD" # should be encrypted
```
{: data-file=".travis.yml"}

It is recommended that you encrypt your password.
Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt "YOUR PASSWORD" --add deploy.password
```

You can also have the `travis` tool set everything up for you:

```bash
$ travis setup appfog
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Application to deploy

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to an Appfog app named *travis-chat*.

You can explicitly set the name via the **app** option:

```yaml
deploy:
  provider: appfog
  email: ...
  password: ...
  app: my-app-123
```
{: data-file=".travis.yml"}

It is also possible to deploy different branches to different applications:

```yaml
deploy:
  provider: appfog
  email: ...
  password: ...
  app:
    master: my-app-staging
    production: my-app-production
```
{: data-file=".travis.yml"}

If these apps belong to different Appfog accounts, you will have to do the same for the email and password:

```yaml
deploy:
  provider: appfog
  email:
    master: ...
    production: ...
  password:
    master: ...
    production: ...
  app:
    master: my-app-staging
    production: my-app-production
```
{: data-file=".travis.yml"}

### Branch to deploy from

If you have branch specific options, as [shown above](#Application-to-deploy), Travis CI will automatically figure out which branches to deploy from. Otherwise, it will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

```yaml
deploy:
  provider: appfog
  email: ...
  password: ...
  on: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure it to deploy from all branches:

```yaml
deploy:
  provider: appfog
  email: ...
  password: ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: appfog
  email: ...
  password: ...
  skip_cleanup: true
```
{: data-file=".travis.yml"}

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
{: data-file=".travis.yml"}
