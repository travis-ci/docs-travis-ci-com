---
title: Deploy to the Engine Yard Cloud from Travis CI!
created_at: Wed 18 Sep 2013 17:00:00
author: Mathias Meyer
twitter: roidrage
layout: post
---
<figure class=" small right">
  <a href="http://www.engineyard.com"><img src="http://about.travis-ci.org/images/logo-engineyard.png"/></a>
</figure>

Today we're happy to announce **continuous deployment support for the [Engine Yard Cloud](https://www.engineyard.com/products/cloud)!**

Engine Yard has been an [incredible supporter](https://blog.engineyard.com/2012/travis-ci) of [Travis CI](http://about.travis-ci.org/blog/2013-06-10-secure-env-in-pull-requests/), and we're very grateful to [count them amongst our customers](https://travis-ci.com). We're very excited that you can now deploy your code from Travis CI to their cloud platform.

Getting started is easy. Sign up for an account with [Engine Yard](https://www.engineyard.com/trial), if you haven't already, your first 500 hours are free!

Once your project is set up, configure the application in your .travis.yml:

    deploy:
      provider: engineyard
      api_key: <key>

We recommend [encrypting the key in your .travis.yml](http://about.travis-ci.org/docs/user/build-configuration/#Secure-environment-variables).

Alternatively, you can use username and password:

    deploy:
      provider: engineyard
      username: roidrage
      password: kittens!

You can customize the environment to deploy to if you happen to have your app deployed to multiple environments:

    deploy:
      provider: engineyard
      environment: kittens_production

For the all the gory details on the available options, check out [our documentation](/docs/user/deployment/engineyard/).

Deploying to the Engine Yard Cloud is available for [open source](https://travis-ci.org) and [private](https://travis-ci.com) repositories today!

Happy shipping!
