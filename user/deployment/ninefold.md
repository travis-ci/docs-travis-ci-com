---
title: Ninefold Deployment
layout: en
permalink: ninefold/
---

Travis CI can automatically deploy your [Ninefold](https://ninefold.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: ninefold
      auth-token: "NINEFOLD AUTH TOKEN"
      app-id: "NINEFOLD APP ID"


It is recommended to encrypt your auth token. Assuming you have the  Travis CI command line client installed, you can do it like this:

    $ travis encrypt THE-API-TOKEN --add deploy.api_key

You can also have the `travis` tool set up everything for you:

    $ travis setup ninefold

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: ninefold
      auth-token: "NINEFOLD AUTH TOKEN"
      app-id: "NINEFOLD APP ID"
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: ninefold
      auth-token: "NINEFOLD AUTH TOKEN"
      app-id: "NINEFOLD APP ID"
      on:**
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

    deploy:
      provider: ninefold
      auth-token: "NINEFOLD AUTH TOKEN"
      app-id: "NINEFOLD APP ID"
      skip_cleanup: true

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: ninefold
      auth-token: "NINEFOLD AUTH TOKEN"
      app-id: "NINEFOLD APP ID"
      on:
        branch: staging
        rvm: 2.0.0

The above configuration will trigger a deploy if the staging branch is passing on Ruby 2.0.0.

You can also add custom conditions:

    deploy:
      provider: ninefold
      auth-token: "NINEFOLD AUTH TOKEN"
      app-id: "NINEFOLD APP ID"      bucket: "S3 Bucket"
      on:
        condition: "$cc = gcc"

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