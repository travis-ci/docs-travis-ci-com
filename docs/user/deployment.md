---
title: Deployment
layout: en
permalink: deployment/
---

### Supported Providers

Continuous Deployment to the following providers are currently supported out of the box:

* [Heroku](/docs/user/deployment/heroku)
* [Nodejitsu](/docs/user/deployment/nodejitsu)
* [OpenShift](/docs/user/deployment/openshift)
* [cloudControl](/docs/user/deployment/cloudcontrol)
* [RubyGems](/docs/user/deployment/rubygems)
* [PyPI](/docs/user/deployment/pypi)
* [NPM](/docs/user/deployment/npm)
* [S3](/docs/user/deployment/s3)
* [Engine Yard](/docs/user/deployment/engineyard)
* [Custom deployment via after_success hook](/docs/user/deployment/custom)

### Deploying to multiple Providers

If you would like to deploy to multiple providers, you will need to set up your `.travis.yml` a little differently.
Add the information for the providers you want to deploy to to the `deploy` section of your `.travis.yml`, just like you would add them individually.
Now, in front of each provider declaration (e.g. `provider: heroku`), place a dash (-).
If you want to deploy to, say, cloudControl and Heroku, your `deploy` section would look like this:

    deploy:
      - provider: cloudcontrol
        email: "YOUR CLOUDCONTROL EMAIL"
        password: "YOUR CLOUDCONTROL PASSWORD"
        deployment: "APP_NAME/DEP_NAME"
      - provider: heroku
        api_key "YOUR HEROKU API KEY"

### Other Providers

We are working on adding support for other PaaS providers. If you host your application with a provider not listed here and you would like to have Travis CI automatically deploy your application, please [get in touch](mailto:support@travis-ci.com).

If you contribute to or experiment with the [deploy tool](https://github.com/travis-ci/dpl) make sure you use the edge version from GitHub:

    deploy:
      provider: awesome-experimental-provider
      edge: true
