---
title: Rackspace Cloud Files Deployment
layout: en
permalink: cloudfiles/
---

Travis CI can automatically upload your build to [Rackspace Cloud Files](https://www.rackspace.com/cloud/files/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"


However, this example is almost certainly not ideal, as you probably want to upload your built binaries and documentation. Set skip_cleanup to true to prevent Travis CI from deleting your build artifacts.

	 deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true

It is recommended encrypt that you encrypt your Rackspace api key.
Assuming you have the Travis CI command line client installed, you can do it like this:

    travis encrypt --add deploy.api-key

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

    $ travis setup cloudfiles

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Deploy On Tags

Often, you want to deploy only when you release a new version of your code.

You can tell Travis CI only to deploy on tags, like this:

	deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true
      on:
        tags: true

### Deploy To Only One Folder

Often, you don't want to upload your entire project to Cloud Files. You can tell Travis CI to only upload a single folder to Cloud Files. This example uploads the build directory of your project to Cloud Files:
	
	before_deploy: "cd build"
	deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true

### Deploy to Multiple Buckets:

If you want to upload to multiple buckets, you can do this:
	deploy:
      - provider: cloudfiles
        username: "RACKSPACE USERNAME"
        api-key: "RACKSPACE API KEY"
        region: "CLOUDFILE REGION"
        container: "CLOUDFILES CONTAINER NAME"
        skip_cleanup: true
      - provider: cloudfiles
        username: "RACKSPACE USERNAME"
        api-key: "RACKSPACE API KEY"
        region: "CLOUDFILE REGION"
        container: "CLOUDFILES CONTAINER NAME"
        skip_cleanup: true

### Branch to release from

You can explicitly specify the branch to release from with the **on** option:

    deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true
      on:
        branch: production

Alternatively, you can also configure Travis CI to release from all branches:

    deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a release.

### Conditional releases

It is possible to make releases conditional using the **on** option:

    deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true
      on:
        branch: staging
        node: 0.10

The above configuration will trigger a release if the staging branch is passing on NodeJS 0.10.

    deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true
      on:
        branch: staging
        rvm: 2.0.0

The above configuration will trigger a release if the staging branch is passing on Ruby 2.0.0.

You can also add custom conditions:

    deploy:
      provider: cloudfiles
      username: "RACKSPACE USERNAME"
      api-key: "RACKSPACE API KEY"
      region: "CLOUDFILE REGION"
      container: "CLOUDFILES CONTAINER NAME"
      skip_cleanup: true
      on:
        condition: "$cc = gcc"

The available conditions are:

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

### Running commands before and after release

Sometimes you want to run commands before or after releasing a gem. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh