---
title: GitHub Releases Uploading
layout: en
permalink: /user/deployment/releases/
---

Travis CI can automatically upload assets to your git tags on your GitHub repository.

**Please note that deploying GitHub Releases works only for tags, not for branches.**

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: releases
      api_key: "GITHUB OAUTH TOKEN"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true

Make sure you have skip_cleanup set to true, otherwise Travis CI will delete all the files created during the build, which will probably delete what you are trying to upload.

Note that the section at the end of the .travis.yml above is required to make sure that your tags get deployed.

You can always use the Travis CI command line client set everything up for you:

    $ travis setup releases

###  Authenticating with an Oauth token

The recommend way of authentication is with a GitHub oauth token. It must have the `public_repo` or `repo` scope to upload assets. Instead of setting it up manually, it is highly recommended to use `travis setup releases`, which will automatically create a GitHub oauth token with the correct scopes and encrypts it.

### Authentication with a Username and Password

You can also authenticate with your GitHub username and password using the `user` and `password` options. This is not recommended as it allows full access to your GitHub account but is simplest to setup. It is recommended to encrypt your password using `travis encrypt "GITHUB PASSWORD" --add deploy.password`. This example authenticates using  a username and password.

    deploy:
      provider: releases
      user: "GITHUB USERNAME"
      password: "GITHUB PASSWORD"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
      on:
        tags: true

### Deploying to GitHub Enterprise

If you wish to upload assets to a GitHub Enterprise repository, you must override the `$OCTOKIT_API_ENDPOINT` environment variable with your GitHub Enterprise API endpoint:
```
http(s)://"GITHUB ENTERPRISE HOSTNAME"/api/v3/
```

You can configure this in [Repository Settings](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings) or via your `.travis.yml`:

    env:
      global:
        - OCTOKIT_API_ENDPOINT: "GITHUB ENTERPRISE API ENDPOINT"

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


### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after release

Sometimes you want to run commands before or after releasing a gem. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

    before_deploy: "echo 'ready?'"
    deploy:
      ..
    after_deploy:
      - ./after_deploy_1.sh
      - ./after_deploy_2.sh
