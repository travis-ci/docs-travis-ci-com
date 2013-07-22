---
title: Openshift deployment
layout: en
permalink: openshift/
---

Travis CI can automatically deploy your [Openshift](http://openshift.com) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: openshift
      user: "YOUR EMAIL ADDRESS"
      password: "YOUR PASSWORD"
      domain: "YOUR OPENSHIFT DOMAIN"

You should encrypt your password before placing it in your `.travis.yml`.
Assuming you have the Travis CI command line client installed, you can do it like this:

    travis encrypt YOUR_PASSWORD --add deploy.password

You can also have the `travis` tool set up everything for you:

    $ travis setup openshift

### Application to deploy

By default, we will try to deploy to an application by the same name as the repository.
For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to an Openshift app named *travis-chat*.

You can explicitly set the name via the **app** option:

    deploy:
      provider: openshift
      user: ...
      password: ...
      app: my-app-123

It is also possible to deploy different branches to different applications:

    deploy:
      provider: openshift
      user: ...
      password: ...
      app:
        master: my-app-staging
        production: my-app-production

If these apps belong to different Openshift accounts, you will have to do the same for the user and password:

    deploy:
      provider: openshift
      user:
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
      provider: openshift
      user: ...
      password: ...
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: openshift
      user: ...
      password: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: openshift
      user: ...
      password: ...
      on:
        branch: staging
        rvm: 2.0.0

The above configuration will trigger a deploy if the staging branch is passing on Ruby 2.0.0.

You can also add custom conditions:

    deploy:
      provider: openshift
      user: ...
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
