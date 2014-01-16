---
title: Appfog deployment
layout: en
permalink: appfog/
---

Travis CI can automatically deploy your [Appfog](https://www.appfog.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to you `.travis.yml`:

    deploy:
        provider: appfog
        email: "YOUR EMAIL ADDRESS"
        password: "YOUR PASSWORD" # should be encrypted

You can also have the [travis](http://github.com/travis-ci/travis) tool set everything up for you:

    $ travis setup appfog

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Application to deploy

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to an Appfog app named *travis-chat*.

You can explicitly set the name via the **app** option:

    deploy:
      provider: appfog
      email: ...
      password: ...
      app: my-app-123

It is also possible to deploy different branches to different applications:

    deploy:
      provider: appfog
      email: ...
      password: ...
      app:
        master: my-app-staging
        production: my-app-production

If these apps belong to different Appfog accounts, you will have to do the same for the email and password:

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

### Branch to deploy from

If you have branch specific options, as [shown above](#Application-to-deploy), Travis CI will automatically figure out which branches to deploy from. Otherwise, it will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: appfog
      email: ...
      password: ...
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: appfog
      email: ...
      password: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

    deploy:
      provider: appfog
      email: ...
      password: ...
      skip_cleanup: true

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: appfog
      email: ...
      password: ...
      on:
        branch: staging
        rvm: 2.0.0

The above configuration will trigger a deploy if the staging branch is passing on Ruby 2.0.0.

You can also add custom conditions:

    deploy:
      provider: appfog
      email: ...
      password: ...
      on:
        condition: "$CC = gcc"

Available conditions are:

* **all_branches** - when set to true, trigger deploy from any branch if passing
* **branch** - branch or list of branches to deploy from if passing
* **condition** - custom condition or list of custom conditions
* **jdk** - JDK version to deploy from if passing
* **node** - NodeJS version to deploy from if passing
* **perl** - Perl version to deploy from if passing
* **php** - PHP version to deploy from if passing
* **python** - Python version to deploy from if passing
* **ruby** - Ruby version to deploy from if passing
* **repo** - only trigger a build for the given repository, to play nice with forks

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
