---
title: "Let Travis Push your RubyGems"
author: Aaron Hill
created_at: Thu 22 Aug 2013 19:15 CET
layout: post
permalink: blog/2013-08-22-let-travis-push-your-rubygems
---

With Travis CI, you are able to automatically deploy your applications to [Heroku](/blog/2013-07-09-introducing-continuous-deployment-to-heroku), [Nodejitsu](/blog/2013-07-22-deploy-your-apps-to-nodejitsu), and [Openshift](/blog/2013-07-25-more-deployment-goodness-announcing-openshift-support).

Now, it's also possible to release to [RubyGems](https://rubygems.org/)!

To set up continuous releasing to RubyGems, add the following lines to your .travis.yml:

    deploy:
        provider: rubygems
        api_key: "YOUR-ENCRYPTED-API-KEY"

Or, if you've installed our handy [command line tool](https://github.com/travis-ci/travis), just use the `setup` command:

    $ travis setup rubygems

However, releasing a gem is different than deploying an application. You probably don't want every single build to be released.
Instead, you can configure Travis CI to only deploy build with tags. This allows you to only release when you have a new version of yout gem ready.
Just add `tags: true` to the `on` section of your `.travis.yml` so it looks like this:

    deploy:
        provider: rubygems
        api_key ...
        on:
            tags: true

An alternative approach is to let Travis CI push pre-releases and still do manual releases yourself. Look at what our [deploy tool](https://github.com/rkh/dpl/blob/master/dpl.gemspec#L24-L26) does internally for some inspiration.

And you're all set!

This feature is immediately available to all our users including our [Travis Pro](http://travis-ci.com) customers.

### Is your provider still missing?

If you'd like to see your provider supported on Travis CI, [contact us](mailto:support@travis-ci.org) or [fork us on Github](https://github.com/rkh/dpl).
