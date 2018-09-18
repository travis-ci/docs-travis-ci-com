---
title: Heroku Deployment
layout: en

---



Travis CI can automatically deploy your [Heroku](https://www.heroku.com/) application after a successful build.

To use the default configuration, add your encrypted Heroku api key to your `.travis.yml`:

```yaml
deploy:
  provider: heroku
  api_key:
    secure: "YOUR ENCRYPTED API KEY"
```
{: data-file=".travis.yml"}

If you have both the [Heroku](https://toolbelt.heroku.com/) and [Travis CI](https://github.com/travis-ci/travis.rb#readme) command line clients installed, you can get your key, encrypt it and add it to your `.travis.yml` by running the following command from your project directory:

```bash
travis encrypt $(heroku auth:token) --add deploy.api_key
```

You can also use the Travis CI command line setup tool `travis setup heroku`.

## Deploying Custom Application Names

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to a Heroku app named *travis-chat*.

You can explicitly set the name via the **app** option:

```yaml
deploy:
  provider: heroku
  api_key: ...
  app: my-app-123
```
{: data-file=".travis.yml"}

It is also possible to deploy different branches to different applications:

```yaml
deploy:
  provider: heroku
  api_key: ...
  app:
    master: my-app-staging
    production: my-app-production
```
{: data-file=".travis.yml"}

If these apps belong to different Heroku accounts, you will have to do the same for the API key:

```yaml
deploy:
  provider: heroku
  api_key:
    master: ...
    production: ...
  app:
    master: my-app-staging
    production: my-app-production
```
{: data-file=".travis.yml"}

## Deploying Specific Branches

If you have branch specific options, as [shown above](#Deploying-Custom-Application-Names), Travis CI will automatically figure out which branches to deploy from. Otherwise, it will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

```yaml
deploy:
  provider: heroku
  api_key: ...
  on: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure it to deploy from all branches:

```yaml
deploy:
  provider: heroku
  api_key: ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a deploy.

## Running Commands

In some setups, you might want to run a command on Heroku after a successful deploy. You can do this with the **run** option:

```yaml
deploy:
  provider: heroku
  api_key: ...
  run: "rake db:migrate"
```
{: data-file=".travis.yml"}

It also accepts a list of commands:

```yaml
deploy:
  provider: heroku
  api_key: ...
  run:
    - "rake db:migrate"
    - "rake cleanup"
```
{: data-file=".travis.yml"}

> Take note that Heroku app might not be completely deployed and ready to serve requests when we run your commands. To mitigate this situation, you can add a `sleep` statement to add a delay before your commands.

### Error Logs for Custom Commands

Custom Heroku commands do not affect the Travis CI build status or trigger Travis CI notifications.

Use an addon such as [Papertrail](https://elements.heroku.com/addons/papertrail){: data-proofer-ignore=""} or [Logentries](https://elements.heroku.com/addons/logentries){: data-proofer-ignore=""} to get notifications for `rake db:migrate` or other commands.

These add-ons have email notification systems that can be triggered when certain string matches occur in your Heroku logs. For example you could trigger an e-mail notification if the log contains "this and all later migrations canceled".

### Restarting Applications

Sometimes you want to restart your Heroku application between or after commands. You can easily do so by adding a "restart" command:

```yaml
deploy:
  provider: heroku
  api_key: ...
  run:
    - "rake db:migrate"
    - restart
    - "rake cleanup"
```
{: data-file=".travis.yml"}

## Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: heroku
  api_key: ...
  skip_cleanup: true
```
{: data-file=".travis.yml"}

{% include conditional_deploy.html provider="heroku" %}

### Deploy Strategy

Travis CI supports different mechanisms for deploying to Heroku:

- **api:** Uses Heroku's [Build API](https://devcenter.heroku.com/articles/build-and-release-using-the-api). This is the default strategy.
- **git:** Does a `git push` over HTTPS.

It defaults to **api**, but you can change that via the **strategy** option:

```yaml
deploy:
  provider: heroku
  api_key: ...
  strategy: git
```
{: data-file=".travis.yml"}

#### Using `.gitignore` on `git` strategy

When you use any of the `git` strategies, be mindful that the deployment will
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
