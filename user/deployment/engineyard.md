---
title: Engine Yard Deployment
layout: en
permalink: /user/deployment/engineyard/
---

Travis CI can automatically deploy your [Engine Yard](https://www.engineyard.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: engineyard
      api_key: "YOUR API KEY"

You can also use `email` and `password` instead of `api_key`. It is recommended to encrypt the key/password.

Optional settings include: `app`, `account`, `environment` and `migrate`.

You can also have the `travis` tool set up everything for you:

    $ travis setup engineyard

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Application or Environment to deploy

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to a Engine Yard app named *travis-chat*.

You can explicitly set the name via the **app** option:

    deploy:
      provider: engineyard
      api_key: ...
      app: my-app-123

It is also possible to deploy different branches to different applications:

    deploy:
      provider: engineyard
      api_key: ...
      app:
        master: my-app
        foo: my-foo

This branch specific settings are possible for all options (except `on`) and can be very useful for deploying to different environments:

    deploy:
      provider: engineyard
      api_key: ...
      environment:
        master: staging
        production: production

### Branch to deploy from

If you have branch specific options, as [shown above](#Application-or-Environment-to-deploy), Travis CI will automatically figure out which branches to deploy from. Otherwise, it will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: engineyard
      api_key: ...
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: engineyard
      api_key: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Running migrations

You can trigger migrations by using the migrate option:

    deploy:
      provider: engineyard
      api_key: ...
      migrate: "rake db:migrate"

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
