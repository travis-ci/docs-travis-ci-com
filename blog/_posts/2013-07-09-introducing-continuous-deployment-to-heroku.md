---
title: Introducing Continuous Deployment to Heroku
author: Konstantin Haase
twitter: konstantinhaase
created_at: Mon 09 Jul 2013 16:25:00 CEST
layout: post
permalink: blog/2013-07-09-introducing-continuous-deployment-to-heroku
---

<figure class="small right">
  ![](/images/heroku.png)
  <figcaption>
  Heroku is not just a happy [Travis Pro](http://travis-ci.com/) customer,
  but also one of our amazing sponsors!
  </figcaption>
</figure>

Are you testing your [Heroku](https://www.heroku.com/) application on Travis CI? Then we've got some amazing news for you: Deploying that application after a passing build has just become [incredibly easy](/docs/user/deployment/heroku/)!

Here is what you need to add to your app's `.travis.yml`:

    deploy:
      provider: heroku
      app: your-app-name # optional if it's the same as your repo name
      api_key: "YOUR API TOKEN"

You should also encrypt your token (at least if you use this on a public repository).

If you have the [travis](https://github.com/travis-ci/travis#installation) tool installed, try the following:

    travis setup heroku

This feature is available immediately on both [travis-ci.org](http://travis-ci.org) and [travis-ci.com](http://travis-ci.com). See [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat/blob/2eac1840c0f1df90ccb0b6b6a96ecf0e570119e8/.travis.yml) for a real world example.

<figure class="small right">
  ![](/images/deploy.png)
  <figcaption>Deploying from Travis CI</figcaption>
</figure>

### Common Scenarios

We have looked into how people currently [deploy to Heroku](https://www.google.com/search?btnG=1&pws=0&q=heroku+travis+ci) from Travis CI.

Given what people do in their scripts, we tried to make all the common deploy scenarios really easy. Here are a few.

Running migrations after deployment:

    deploy:
      provider: heroku
      api_key: ...
      run: "rake db:migrate"

In a Ruby matrix, only deploy from Ruby 1.9.3:

    rvm:
      - 1.9.3
      - 2.0.0
    deploy:
      provider: heroku
      api_key: ...
      on:
        rvm: 1.9.3

Deploy staging app from staging branch:

    deploy:
      provider: heroku
      api_key: ...
      app: my-app-staging
      on: staging

Deploy staging app from master branch and production app from production:

    deploy:
      provider: heroku
      api_key: ...
      app:
        master: my-app-staging
        production: my-app-production

For a description of all available options, check out [the documentation](/docs/user/deployment/heroku/).

### All open source

In good Travis CI tradition, all the code is of course released under MIT license on GitHub. You are more than welcome to [take a look and contribute](https://github.com/rkh/dpl).

More over, since we wanted to make it easy and testable, you can even run our internal tool locally (or lo and behold, use it on your Jenkins setup):

    $ gem install dpl
    $ dpl --provider=heroku --api-key=`heroku auth:token`

### More providers to come

As you might have guessed from the *provider* option, we are currently working on adding support for other providers besides Heroku.

However, for most other providers, we don't have a lot of real world examples of people already doing or planning to do continuous deployment from Travis CI. So if you do or plan to, you are more than welcome to [get in touch](mailto:support@travis-ci.com).