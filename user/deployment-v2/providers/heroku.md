---
title: Heroku Deployment
layout: en
deploy: v2
provider: heroku
---

Travis CI can automatically deploy your [Heroku](https://www.heroku.com/)
application after a successful build.

{% include deploy/providers/heroku_git.md %}

## Specifying the application name

By default, your repository name will be used as the application name.

You can set a different application name using the `app` option:

```yaml
deploy:
  provider: heroku
  # ⋮
  app: <app_name>
```
{: data-file=".travis.yml"}

## Running commands

In some setups, you might want to run a command on Heroku after a successful
deploy. You can do this with the **run** option:

```yaml
deploy:
  provider: heroku
  # ⋮
  run: rake db:migrate
```
{: data-file=".travis.yml"}

It also accepts a list of commands:

```yaml
deploy:
  provider: heroku
  # ⋮
  run:
    - rake db:migrate
    - rake cleanup
```
{: data-file=".travis.yml"}

> Take note that Heroku app might not be completely deployed and ready to serve
> requests when we run your commands. To mitigate this situation, you can add a
> `sleep` statement to add a delay before your commands.

### Deploying branches to different apps

In order to choose apps based on the current branch use separate deploy
configurations:

```yaml
deploy:
  - provider: heroku
    # ⋮
    app: app-production
    on:
      branch: master
  - provider: heroku
    # ⋮
    app: app-staging
    on:
      branch: staging
```
{: data-file=".travis.yml"}

Or using YAML references:

```yaml
deploy:
  - &deploy
    provider: heroku
    # ⋮
    app: app-production
    on:
      branch: master
  - <<: *deploy
    app: app-staging
    on:
      branch: staging
```
{: data-file=".travis.yml"}

### Error Logs for Custom Commands

Custom Heroku commands do not affect the Travis CI build status or trigger
Travis CI notifications, because Heroku's CLI [always exits](https://github.com/heroku/cli/issues/1319)
with `0`, even if the command failed.

As an alternative, you can use an addon such as [Papertrail](https://elements.heroku.com/addons/papertrail){: data-proofer-ignore=""}
or [Logentries](https://elements.heroku.com/addons/logentries){: data-proofer-ignore=""}
to get notifications for `rake db:migrate` or other commands.

These add-ons have email notification systems that can be triggered when
certain string matches occur in your Heroku logs. For example you could trigger
an e-mail notification if the log contains "this and all later migrations
canceled" or similar messages.

### Restarting Applications

Sometimes you want to restart your Heroku application between or after
commands. You can easily do so by adding a "restart" command:

```yaml
deploy:
  provider: heroku
  # ⋮
  run:
    - rake db:migrate
    - restart
    - rake cleanup
```
{: data-file=".travis.yml"}

### Deploy Strategy

Travis CI supports different mechanisms for deploying to Heroku:

- **api:** Uses Heroku's [Build API](https://devcenter.heroku.com/articles/build-and-release-using-the-api). This is the default strategy.
- **git:** Does a `git push` over HTTPS.

It defaults to **api**, but you can change that via the **strategy** option:

```yaml
deploy:
  provider: heroku
  # ⋮
  strategy: git
```
{: data-file=".travis.yml"}

#### Using .gitignore on the Git strategy

When you use any of the `git` strategies, be mindful that the deployment will
honor `.gitignore`.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#running-commands-before-and-after-deploy) to change
its content.

{% include deploy/shared.md %}
