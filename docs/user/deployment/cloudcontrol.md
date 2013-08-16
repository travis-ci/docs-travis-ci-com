---
title: cloudControl Deployment
layout: en
permalink: cloudcontrol/
---

Travis CI can automatically deploy your [cloudControl](https://www.cloudcontrol.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: cloudcontrol
      email: "YOUR CLOUDCONTROL EMAIL"
      password: "YOUR CLOUDCONTROL PASSWORD"
      deployment: "APP_NAME/DEP_NAME"

You can sign up for an account on [their website](https://www.cloudcontrol.com) or using the [cctrl
tool](create-a-user-account-if-you-haven39t-already).

To store the password in your .travis.yml securely, use our travis command line
tool.

$ travis encrypt <password> --add deploy.password

You can also have the `travis` tool set up everything for you:

    $ travis setup cloudcontrol

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: cloudcontrol
      email: ...
      password: ...
      deployment: ...
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: cloudcontrol
      email: ...
      password: ...
      deployment: ...
      on:
        all_branches: true

Builds triggered from pull requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

    deploy:
      provider: cloudcontrol
      email: ...
      password: ...
      deployment: ...
      skip_cleanup: true

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: cloudcontrol
      email: ...
      password: ...
      deployment: ...
      on:
        branch: staging
        python: 2.7

The above configuration will trigger a deploy if the staging branch is passing on Python 2.7.

Available conditions are:

* **all_branches** - when set to true, trigger deploy from any branch if passing
* **branch** - branch or list of branches to deploy from if passing
* **condition** - custom condition or list of custom conditions
* **repo** - only trigger a build for the given repository, to play nice with forks
* **jdk** - JDK version to deploy from if passing
* **php** - PHP version to deploy from if passing
* **python** - Python version to deploy from if passing
* **ruby** - Ruby version to deploy from if passing
