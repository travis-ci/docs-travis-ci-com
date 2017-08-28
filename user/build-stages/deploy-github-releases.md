---
title: "Build Stages: Deploying to GitHub Releases"

layout: en
---

This example has 2 build stages:

* Two jobs that run tests
* One job that deploys (releases) a file to GitHub Releases

Here's what the `.travis.yml` config could look like:

```yaml
jobs:
  include:
    - script: "Running unit tests (1)"
    - script: "Running unit tests (2)"
    - stage: GitHub Release
      script: echo "Deploying to GitHub releases ..."
      deploy:
        provider: releases
        api_key: $GITHUB_OAUTH_TOKEN
        skip_cleanup: true
        if:
          tags: true
```

This is how the build matrix might look:

![image](https://cloud.githubusercontent.com/assets/2208/25899452/37a973de-3590-11e7-9e95-8dbe31528a33.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/deploy-github-releases)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/deploy-github-releases/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/230744658)
