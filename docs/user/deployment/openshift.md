---
title: OpenShift Deployment
layout: en
permalink: openshift/
---

Travis CI can automatically deploy your [OpenShift](https://www.openshift.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: openshift
      user: "YOU USER NAME"
      password: "YOUR PASSWORD" # can be encrypted
      domain: "YOUR OPENSHIFT DOMAIN"

Currently it is not possible to use a token instead of the password, as these tokens expire too quickly. We are working with the OpenShift team on a solution.

You can also have the `travis` tool set up everything for you:

    $ travis setup openshift

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

To provide the best service possible, Travis CI has teamed up with OpenShift as a [partner](https://www.openshift.com/partners) and there is an official [Travis CI QuickStart](https://www.openshift.com/quickstarts/travis-ci-on-openshift) to get you going.

### Application to deploy

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to an OpenShift app named *travis-chat*.

You can explicitly set the name via the **app** option:

    deploy:
      provider: openshift
      ...
      app: my-app-123

It is also possible to deploy different branches to different applications:

    deploy:
      provider: openshift
      ...
      app:
        master: my-app-staging
        production: my-app-production

If these apps belong to different OpenShift domains, you will have to do the same for the domain:

    deploy:
      provider: openshift
      ...
      domain:
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
      ...
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: openshift
      ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

    deploy:
      provider: openshift
      ...
      skip_cleanup: true

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: openshift
      ...
      on:
        branch: staging
        rvm: 2.0.0

The above configuration will trigger a deploy if the staging branch is passing on Ruby 2.0.0.

You can also add custom conditions:

    deploy:
      provider: openshift
      ...
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
