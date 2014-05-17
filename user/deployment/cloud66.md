---
title: Cloud 66 Deployment
layout: en
permalink: cloud66/
---

Travis CI can automatically deploy your [Cloud 66](https://www.cloud66.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: cloud66
      redeployment_hook: "YOUR REDEPLOYMENT HOOK URL"

You can find the redeployment hook in the information menu within the Cloud 66 portal.

You can also have the `travis` tool set up everything for you:

    $ travis setup cloud66

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: cloud66
      redeployment_hook: "YOUR REDEPLOYMENT HOOK URL"
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: cloud66
      redeployment_hook: "YOUR REDEPLOYMENT HOOK URL"
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: cloud66
      redeployment_hook: "YOUR REDEPLOYMENT HOOK URL"
      on:
        branch: staging
        node: 0.11

The above configuration will trigger a deploy if the staging branch is passing on NodeJS 0.11.

Available conditions are:

* **all_branches** - when set to true, trigger release from any branch if passing
* **branch** - branch or list of branches to release from if passing
* **tags** - when set to true, Travis CI only deploys on tagged builds
* **condition** - custom condition or list of custom conditions
* **jdk** - jdk version to release from if passing
* **node** - nodejs version to release from if passing
* **perl** - perl version to release from if passing
* **php** - php version to release from if passing
* **python** - python version to release from if passing
* **ruby** - ruby version to release from if passing
* **repo** - only trigger a build for the given repository, to play nice with forks

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
