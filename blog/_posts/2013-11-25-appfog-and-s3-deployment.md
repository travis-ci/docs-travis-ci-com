---
title: "Deploy to AppFog and S3!"
author: Aaron Hill
created_at: Mon Nov 25 2013 15:15:00 EST
layout: post
permalink: blog/2013-10-24-appfog-and-s3-deployment
---

Following in the wake of PyPI and NPM support, we're happy to announce support for deploying to AppFog and Amazon S3!

# Deploying to AppFog

Getting started is easy. Sign up for an account with [AppFog](http://appfog.com), and create an app.

Once your app is set up, simply add the following to your `.travis.yml`:

    deploy:
      provider: appfog
      email: "YOUR EMAIL"
      password: "YOUR PASSWORD" # should be encrypted

To encrypt your password, install [the Travis client](http://github.com/travis-ci/travis), then run `travis encrypt`.
You will be prompted to enter in your password.

Or, assuming you have [the Travis client](http://github.com/travis-ci/travis) installed, just use the `setup` command:

    $ travis setup appfog

# Pushing to S3

To set up pushing to S3, you'll first need to create an account with [Amazon S3](http://aws.amazon.com/s3/?navclick=true),
and create a bucket.

Once your bucket is set up, just add this to your `.travis.yml`:

    deploy:
      provider: s3
      access-key-id: "Your ACCESS KEY ID"
      secret-access-key: "YOUR SECRET ACCESS KEY" # should be encrypted
      bucket: "YOUR S3 BUCKET NAME"

As with AppFog, you'll need to install [our command line client](http://github.com/travis-ci/travis) in order to encrypt the secret access key.

Alternatively, you can just use the `setup` command:

    $ travis setup s3

That's it!

### Is your provider still missing?

We've been adding support for lots of new providers, but there are still plenty more out there.
If you'd like to support for your cloud provider on Travis CI, please [shoot us an email](mailto:support@travis-ci.org).

Or, send us a pull request over at our [dpl repository](http://github.com/travis-ci/dpl).
