---
title: Big News for Continuous Deployment
created_at: Sun 29 Sep 2013 15:32:00 EST
author: Aaron Hill
layout: post
permalink: blog/2013-09-29-big-news-for-continuous-deployment
---

Recently, we've been adding new providers and other goodies to our continuous deployment.
This is a wrap-up of what's been happening.

# Releasing to PyPI

Recently, we added support for [deploying to RubyGems](/blog/2013-08-22-let-travis-push-your-rubygems).
Now, Python package developers can also enjoy continuous deployment, thanks to our new support for PyPI!

Just add the following lines to your `.travis.yml`:

    deploy:
      provider: pypi
      user: "YOUR_USER_NAME"
      password: "YOUR_PASSWORD" # should be encrypted with `travis encrypt`

To make things even simpler, if you've installed [our command line tool](http://github.com/travis-ci/travis),
you can simply run the following command:

    $ travis setup pypi

Just follow the prompts to get set up releasing to PyPI.

If you've read about releasing to RubyGems from Travis CI, you may have heard about only releasing when a tagged commit is present.
It's just as easy to set up with PyPI.
Just add `on: tags: true` to your `deploy` section so that it looks like this:

    deploy:
      provider: pypi
      user: "YOUR_USER_NAME"
      password: "YOUR_PASSWORD"
      on:
        - tags: true


# Allowing Deployment Failures

If you've been using continuous deployment on Travis CI, you may have noticed that if anything goes wrong during the deployment process,
it causes that job to be marked as failed or errored. We've had mixed reactions to this: it's considered a bug by some, and a feature by others.

Today, we're happy to announce that you can now decide whether or not a deployment problem should cause a job to fail.
Simple add `allow_failure: true` to the `deploy` section of your `.travis.yml`. It should look like this:

    deploy:
      provider: ...
      allow_failure: true

Now, any problem during deployment won't reflect in the status of a job.

# Release your NodeJS packages to NPM

At Travis CI, we've been adding support for deploying to many different cloud providers,
as well as package hosting sites like RubyGems and PyPI. We didn't want NodeJS users to feel left out, so today we're happy to announce support for releasing packages to NPM!

Setting this up is just like deploying or releasing to any other service. Just add the following lines to your `.travis.yml`:

    deploy:
       provider: npm
       email: "YOUR-EMAIL-ADDRESS"
       api_key: "YOUR-API-KEY"

To retrieve your api key, you'll need to have the `npm` tool installed. Run the following command:

    $ npm login

Follow the prompts to log in to your NPM account. You can then find your API key in your ~/.npmrc file.

That's it!

This feature is immediately available to all our users including our [Travis Pro](http://travis-ci.com) customers.

# Deploying to Multiple Providers

At Travis CI, we've been hard at work adding support for deploying to your favorite cloud providers.
But, until now, you've been limited to choosing only one provider per repository.
Today, we're happy to announce support for deploying to multiple providers!
To set this up, simply as many `provider` sections as you want to your `.travis.yml`, placing a dash (-) before each `provider`.
For example, if you want to deploy to Heroku and Nodejitsu, set up your `.travis.yml` to look like this:

    deploy:
      - provider: heroku
        api_key: "YOUR HEROKU API KEY"
      - provider: nodejitsu
        user: "YOUR NODEJITSU USERNAME"
        password: "YOUR NODEJITSU API KEY"

If you have `before_deploy` and `after_deploy` sections set up, they will run before and after deploying to each provider you specify.


## Is your provider still missing?

If you'd like to see your provider supported on Travis CI, [contact us](mailto:support@travis-ci.org) or [fork us on Github](https://github.com/travis-ci/dpl).
