---
title: Deploying to Openshift
author: Aaron Hill
created_at: Sun 21 Jul 2013 6:24 MDT
layout: post
permalink: blog/2013-07-21-deploying-to-openshift
---

Remember a little while back when we introduced support for [deploying to Heroku](/blog/2013-07-09-introducing-continuous-deployment-to-heroku)?

Now, in addition to Nodejitsu and Heroku, we offer support for deploying to [Openshift](http://openshift.com)!

To set up continuous deployment to Openshift, add the following lines to your `.travis.yml`:

    deploy:
      provider: openshift
      user: "YOUR-EMAIL-ADDRESS"
      password: "YOUR-PASSWORD" # encrypted, of course
      app: "YOUR-APP-NAME" # optional if it's the same as your repo name
      domain: "YOUR-OPENSHIFT-DOMAIN"

Or, if your have [our command line tool](https://github.com/travis-ci/travis) installed, use the new `setup` command:

    $ travis setup openshift

That's it!

This feature is immediately available to all our users including our Travis Pro customers.

For more information, see [the documentation](/docs/user/deployment/openshift).

### Your provider still missing?

If your cloud provider isn't supported by Travis CI, please [let us know](mailto:support@travis-ci.org).

Or, if you're so inclined, add support yourself and [send us a pull request](https://github.com/rkh/dpl).
