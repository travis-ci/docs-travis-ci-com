---
title: GitHub Releases Uploading
layout: en
permalink: releases/
---

Travis CI can automatically upload assets to your git tags on your GitHub repository.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: releases
      api-key: "GITHUB OAUTH TOKEN"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true
        all_branches: true

Make sure you have skip_cleanup set to true, otherwise Travis CI will delete all the files created during the build, which will probably delete what you are trying to upload.

You can always use the Travis CI command line client set everything up for you:

    $ travis setup releases

###  Authenticating with an Oauth token

The reccomend way of authentication is with a GitHub oauth token. It must have the `public_repo` or `repo` scope to upload assets. Instead of setting it up manually, it is highly reccomended to use `travis setup releases`, which will automatically create a GitHub oauth token with the correct scopes and encrypts it.

### Authentication with a Username and Password

You can also authenticate with your GitHub username and password using the `user` and `password` options. This is not reccomened as it allows full access to your GitHub account but is simpliest to setup. It is reccomened to encrypt you password using `travis encrypt "GITHUB PASSWORD" --add deploy.password`. This example authenticates using  a username and password.

    deploy:
      provider: releases
      user: "GITHUB USERNAME"
      password: "GITHUB PASSWORD"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true
        all_branches: true

### Uploading Multiple Files

You can upload multiple files using yml array notation. This example uploads two files.

    deploy:
      provider: releases
      api-key: "GITHUB OAUTH TOKEN"
      file:
        - "FILE 1"
        - "FILE 2"
      skip_cleanup: true
      on:
        tags: true
        all_branches: true


### Conditional releases

It is possible to make releases conditional using the **on** option:

    deploy:
      provider: releases
      api-key: "GITHUB OAUTH TOKEN"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true
        all_branches: true
        node: 0.10

The above configuration will trigger a release if the tag is passing on NodeJS 0.10.

or

    deploy:
      provider: releases
      api-key: "GITHUB OAUTH TOKEN"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true
        all_branches: true
        rvm: 2.0.0

The above configuration will trigger a release if the tag is passing on Ruby 2.0.0.

You can also add custom conditions:

    deploy:
      provider: releases
      api-key: "GITHUB OAUTH TOKEN"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true
        all_branches: true
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
