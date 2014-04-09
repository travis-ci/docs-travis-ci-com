---
title: Divshot.io Deployment
layout: en
permalink: divshot/
---

Travis CI can automatically deploy your [Divshot](https://www.divshot.com) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: divshot
      api_key: "YOUR API KEY"

It is recommended that you encrypt your api key. You can encrypt this key using the `travis` command line client and this command:

    $ travis encrypt THE-API-TOKEN --add deploy.api_key

You can also have the `travis` tool set up everything for you:

    $ travis setup divshot

Keep in mind that both the above commands have to run in your project directory, so it can modify the `.travis.yml` for you.

### Divshot Environment

Travis CI defaults to deploying to the `production` environment of your app. If you would like Travis CI to push to one of the other environments you can do so using the `environment` option. You environment must be production, development, or staging. The following example deploys to the development environment of your divshot.io app.

    deploy:
      provider: divshot
      api_key: "YOUR API KEY"
      environment: development

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option. The above example deploys from the production branch of your git repo:

    deploy:
      provider: divshot
      api_key: "YOUR API KEY"
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: divshot
      api_key: "YOUR API KEY"
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

    deploy:
      provider: divshot
      api_key: "YOUR API KEY"
      skip_cleanup: true

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: divshot
      api_key: "YOUR API KEY"
      on:
        branch: staging
        node: 0.11

The above configuration will trigger a deploy if the staging branch is passing on NodeJS 0.11.

Available conditions are:

* **all_branches** - when set to true, trigger deploy from any branch if passing
* **branch** - branch or list of branches to deploy from if passing
* **tags** - when set to true, Travis CI only deploys on tagged builds
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
