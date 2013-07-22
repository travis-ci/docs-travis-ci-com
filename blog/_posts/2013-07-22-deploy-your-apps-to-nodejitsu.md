---
title: Deploy Your Apps to Nodejitsu
author: Konstantin Haase
twitter: konstantinhaase
created_at: Mon 22 Jul 2013 18:00:00 CEST
layout: post
permalink: blog/2013-07-22-deploy-your-apps-to-nodejitsu
---

<figure class="small right">
  ![](/images/nodejitsu.png)
  <figcaption>
  Nodejitsu offers simple, reliable and intelligent Node.js hosting
  </figcaption>
</figure>

Recently we announced built-in support for [deploying to Heroku](/blog/2013-07-09-introducing-continuous-deployment-to-heroku).

Last week we sat together with our awesome customers and good friends from [Nodejitsu](https://www.nodejitsu.com/) and are pleased to announce that we now also offer [first class support](/docs/user/deployment/nodejitsu/) for continuous deployment to their amazing platform!

All you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: nodejitsu
      user: "YOUR USER NAME"
      api_key: "YOUR API KEY" # can of course be encrypted

But we've made it even simpler than that: If you have [our command line tool](https://github.com/travis-ci/travis) installed, you just use the brand new setup command:

    $ travis setup nodejitsu

<figure class="small right">
  ![](/images/dscape.png)
  <figcaption>
  [Nuno Job](https://github.com/dscape) and [Maciej Małecki](https://github.com/mmalecki) were a great help in implementing this feature
  </figcaption>
</figure>

Done!

This feature is immediately available to all our users including our [Travis Pro](http://travis-ci.com) customers.

### Conditional deploys

You can make deploys conditional. For instance, if you only want to deploy from the staging branch and only on Node.js 0.11 if it is passing (but you also test on other versions):

    deploy:
      provider: nodejitsu
      user: ...
      api_key: ...
      on:
        node: "0.11"
        branch: staging

For more infos, head over to [the documentation](/docs/user/deployment/nodejitsu/).

### Your Nodejitsu project on Travis CI

If you have a project hosted on Nodejitsu and would love get started on Travis CI for your private projects, email [support@travis-ci.com](mail:support@travis-ci.com) before the 29th of July for a 20% off for three months coupon.

### Provider still missing?

You run your application in the cloud and would love to have Travis CI automatically deploy to it, but we don't support your provider at the moment? Please [let us know](mail:support@travis-ci.com)!

Already using continuous deployment? [Tell us](mail:support@travis-ci.com) about your experience.
