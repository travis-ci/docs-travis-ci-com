---
title: "Continuous Deployment: PyPI, NPM and more"
created_at: Wed 2 Oct 2013 19:15:00 CET
author: Aaron Hill
layout: post
permalink: blog/2013-10-02-continuous-deployment-pypi-npm-and-more
---

Recently, we've been adding new providers and other goodies to our continuous deployment.
This is a wrap-up of what's been happening.

All these features are immediately available to all our users including our [Travis Pro](http://travis-ci.com) customers.

# Releasing to PyPI

Just like [Ruby developers](/blog/2013-08-22-let-travis-push-your-rubygems), Python package developers can now also enjoy continuous releases, thanks to our new support for PyPI!

Simply add the following lines to your `.travis.yml`:

    deploy:
      provider: pypi
      user: "YOUR_USER_NAME"
      password: "YOUR_PASSWORD" # should be encrypted with `travis encrypt`

To make things even easier, if you've installed [our command line tool](http://github.com/travis-ci/travis),
you can simply run the following in a clone of your repository:

    $ travis setup pypi

Just follow the prompts to get set up releasing to PyPI.

As with RubyGems, you might only want to trigger a new release when the commit has been tagged. It's pretty straight forward.
Just add the tags condition to your `deploy` section so that it looks like this:

    deploy:
      provider: pypi
      user: "YOUR_USER_NAME"
      password: "YOUR_PASSWORD"
      on:
        tags: true

# Release your NodeJS packages to NPM

In a similar vein, we didn't want NodeJS users to feel left out, so today we're happy to announce support for releasing packages to NPM!

Setting this up is just like deploying or releasing to any other service. Just add the following lines to your `.travis.yml`:

    deploy:
       provider: npm
       email: "YOUR-EMAIL-ADDRESS"
       api_key: "YOUR-API-KEY" # should be encrypted with `travis encrypt`

To retrieve your api key, you'll need to have the `npm` tool installed. Run the following command:

    $ npm login

Follow the prompts to log in to your NPM account. You can then find your API key in your ~/.npmrc file.

That's it!

Again, if you've installed [our command line tool](http://github.com/travis-ci/travis),
you can simply run the following in a clone of your repository:

    $ travis setup npm

# Allowing Deployment Failures

If you've been using continuous deployment on Travis CI, you may have noticed that if anything goes wrong during the deployment process,
it causes that job to be marked as failed or errored. We've had mixed reactions to this: it's considered a bug by some, and a feature by others.

Today, we're happy to announce that you can now decide whether or not a deployment problem should cause a job to fail.
Simple add `allow_failure: true` to the `deploy` section of your `.travis.yml`. It should look like this:

    deploy:
      provider: ...
      allow_failure: true

Now, any problem during deployment won't reflect in the status of a build.

# Deploying to Multiple Providers

We've been hard at work adding support for deploying to your favourite cloud providers. But, until now, you've been limited to choosing only one provider per repository.

Today, we're happy to announce support for deploying to multiple providers from within the same build! To set this up, simply add as many `provider` sections as you want to your `.travis.yml`, placing a dash (-) before each `provider`.

For example, if you want to deploy to Heroku and Nodejitsu, set up your `.travis.yml` to look like this:

    deploy:
      - provider: heroku
        api_key: "YOUR HEROKU API KEY"
      - provider: nodejitsu
        user: "YOUR NODEJITSU USERNAME"
        password: "YOUR NODEJITSU API KEY"

If you have `before_deploy` and `after_deploy` sections set up, they will run before and after deploying to each provider you specify.
