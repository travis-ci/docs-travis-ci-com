---
title: Nodejitsu Deployment
layout: en
permalink: nodejitsu/
---

Travis CI can automatically deploy your [Nodejitsu](https://www.nodejitsu.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: nodejitsu
      user: "YOUR USER NAME"
      api_key: "YOUR API KEY"

You can create an API key by running `jitsu tokens create travis` or retrieve an existing one by running `jitsu tokens list`.
It is recommended to encrypt that key. Assuming you have the Nodejitsu and Travis CI command line clients installed, you can do it like this:

    $ jitsu token create travis
    ...
    data:    travis : THE-API-TOKEN
    ...
    $ travis encrypt THE-API-TOKEN --add deploy.api_key

You can also have the `travis` tool set up everything for you:

    $ travis setup nodejitsu

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: nodejitsu
      user: ...
      api_key: ...
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: nodejitsu
      user: ...
      api_key: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

    deploy:
      provider: nodejitsu
      user: ...
      api_key: ...
      skip_cleanup: true

### Conditional Deploys

It is possible to make deployments conditional using the **on** option:

    deploy:
      provider: nodejitsu
      user: ...
      api_key: ...
      on:
        branch: staging
        node: 0.11

The above configuration will trigger a deploy if the staging branch is passing on NodeJS 0.11.

Available conditions are:

* **all_branches** - when set to true, trigger deploy from any branch if passing
* **branch** - branch or list of branches to deploy from if passing
* **condition** - custom condition or list of custom conditions
* **node** - NodeJS version to deploy from if passing
* **repo** - only trigger a build for the given repository, to play nice with forks
