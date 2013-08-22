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
* [Custom deployment via after_success hook](/docs/user/deployment/custom)

### Other Providers

We are working on adding support for other PaaS providers. If you host your application with a provider not listed here and you would like to have Travis CI automatically deploy your application, please [get in touch](mailto:support@travis-ci.com).

If you contribute to or experiment with the [deploy tool](https://github.com/rkh/dpl) make sure you use the edge version from GitHub:

    deploy:
      provider: awesome-experimental-provider
      edge: true
