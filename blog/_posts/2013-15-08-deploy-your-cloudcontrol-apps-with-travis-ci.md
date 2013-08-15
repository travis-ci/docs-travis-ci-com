---
title: Deploy Your cloudControl Apps with Travis CI
author: Mathias Meyer
twitter: roidrage
created_at: Thu 15 Aug 2013 12:00:00 CEST
permalink: blog/2013-15-08-deploy-your-cloudcontrol-apps-with-travis-ci
layout: post
---
Today we're happy to announce continuous deployment support for
[cloudControl](https://www.cloudcontrol.com), a cloud application platform
provider from Berlin, Germany.

They're Berlin locals, just like us, and they've been incredible supporters of
Travis CI.

The great news is that you can now deploy your applications to cloudControl
after a successful build.

It's as simple as adding the following to your .travis.yml:

    deploy:
      provider: cloudcontrol
      email: "YOUR-EMAIL-ADDRESS"
      password: "YOUR-PASSWORD" # encrypted, of course
      deployment: "YOUR-APP-NAME" # optional, defaults to your repository name

Make sure to use our [travis](https://github.com/travis-ci/travis) command line
tool to encrypt your password.

To see all the available options for deployments to cloudControl, see our
[documentation](http://about.travis-ci.org/docs/user/deployment/cloudcontrol/).

We have a [little example app](https://github.com/rkh/ruby-sinatra-example-app)
running on there, [neatly deployed from Travis
CI](http://myfoo.cloudcontrolled.com).

To get started using cloudControl, check out their [quickstart
guide](https://www.cloudcontrol.com/dev-center/Quickstart).

Happy shipping!
