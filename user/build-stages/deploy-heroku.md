---
title: "Build Stages: Deploying to Heroku"
permalink: /user/build-stages/deploy-heroku/
layout: en
---

This example has 5 build stages:

* Two jobs running unit tests in parallel on stage 1.
* One job deploying the application to Heroku staging.
* One job testing the staging deployment on Heroku.
* One job deploying the application to Heroku production.
* One job testing the production deployment on Heroku.

Here's what the `.travis.yml` config could look like:

```yaml
jobs:
  include:
    - stage: unit tests
      script: "Running unit tests (1)"
    - stage: unit tests
      script: "Running unit tests (2)"
    - stage: deploy to staging
      script: skip
      deploy: &heroku
        provider: heroku
        app: sf-stages-staging
        api_key: $HEROKU_AUTH_TOKEN
    - stage: test staging
      script: 'curl http://sf-stages-staging.herokuapp.com'
    - stage: deploy to production
      script: skip
      deploy:
        <<: *heroku
        app: sf-stages-production
    - stage: test production
      script: 'curl http://sf-stages-production.herokuapp.com'
```

This is how the build matrix would look like:

![image](https://cloud.githubusercontent.com/assets/2208/25851681/fea7fe80-34c6-11e7-8d24-0831a80ca0f1.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/master)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/master/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/223978563)
