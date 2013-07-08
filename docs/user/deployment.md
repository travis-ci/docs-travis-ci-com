---
title: Deployment
layout: en
permalink: deployment/
---

### What This Guide Covers

This guide covers how to have Travis CI automatically deploy an application after a successful test pass.

## Heroku

Travis CI can automatically deploy your [Heroku](https://www.heroku.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: heroku
      api_key: "YOUR API KEY"

You can retrieve your api key by running `heroku auth:token`. It is recommended to encrypt that key.
Assuming you have the Heroku and Travis CI command line clients installed, you can do it like this:

    travis encrypt $(heroku auth:token) --add deploy.api_key

### Application to deploy

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to a Heroku app named *travis-chat*.

You can explicitly set the name via the **app** option:

    deploy:
      provider: heroku
      api_key: ...
      app: my-app-123

It is also possible to deploy different branches to different applications:

    deploy:
      provider: heroku
      api_key: ...
      app:
        master: my-app-staging
        production: my-app-production

If these apps belong to different Heroku accounts, you will have to do the same for the API key:

    deploy:
      provider: heroku
      api_key:
        master: ...
        production: ...
      app:
        master: my-app-staging
        production: my-app-production

### Branch to deploy from

If you have branch specific options, as [shown above](#Application-to-deploy), Travis CI will automatically figure out which branches to deploy from. Otherwise, it will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: heroku
      api_key: ...
      on: production

You can also configure it to deploy from all branches:

    deploy:
      provider: heroku
      api_key: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Running commands

In some setups, you might want to run a command on Heroku after a successful deploy. You can do this with the **run** option:

    deploy:
      provider: heroku
      api_key: ...
      run: "rake db:migrate"

It also accepts a list of commands:

    deploy:
      provider: heroku
      api_key: ...
      run:
        - "rake db:migrate"
        - "rake cleanup"


### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: heroku
      api_key: ...
      on:
        branch: staging
        rvm: 2.0.0

You can also add custom conditions:

    deploy:
      provider: heroku
      api_key: ...
      on:
        condition: "$CC = gcc"

The above configuration will trigger a deploy if the staging branch is passing on Ruby 2.0.0.

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

### Deploy Strategy

Travis CI knows two different ways for deploying to Heroku: Via [Git](https://devcenter.heroku.com/articles/git#deploying-code) or via [Anvil](https://github.com/ddollar/anvil).

It defaults to the latter, but you can change that via the **strategy** option:

    deploy:
      provider: heroku
      api_key: ...
      strategy: git

The main differences:

* Anvil will run the [buildpack](https://devcenter.heroku.com/articles/buildpacks) compilation step on the Travis CI VM, whereas the Git strategy will run it on a Heroku dyno
* The Git strategy allows using *user* and *password* instead of *api_key*
* When using Git, Heroku might send you an email for every deploy, as it adds a temporary SSH key to your account

As a rule of thumb, you should switch to the Git strategy if you run into issues with Anvil.

## Custom Deployments

You can easily deploy to your own server the way you would deploy from your local machine by adding a custom [`after_success`](http://localhost:4000/docs/user/build-configuration/#Define-custom-build-lifecycle-commands) step.

### FTP

    env:
      global:
        - "FTP_USER=user"
        - "FTP_PASSWORD=password"
    after_success:
        "wget -r ftp://server.com/ --user $FTP_USER --password $FTP_PASSWORD"

The evn variables `FTP_USER` and `FTP_PASSWORD` can also be [encrypted](http://localhost:4000/docs/user/encryption-keys/).

### Git

This should also work with services like Heroku.

    after_success:
      - chmod 600 .travis/deploy_key.pem # this key should have push access
      - ssh-add .travis/deploy_key.pem
      - git remote add deploy DEPLOY_REPO_URI_GOES_HERE
      - git push deploy

See ["How can I encrypt files that include sensitive data?"](/docs/user/travis-pro/#How-can-I-encrypt-files-that-include-sensitive-data%3F) if you don't want to commit the private key unencrypted to your repository.


## Other Providers

We are working on adding support for other PaaS providers. If you host your application with a provider not listed here and you would like to have Travis CI automatically deploy your application, please [get in touch](mailto:support@travis-ci.com).
