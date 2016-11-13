---
title: anynines Deployment
layout: en
permalink: /user/deployment/anynines/
---

You now have the amazing ability to deploy directly to [anynines](http://www.anynines.com/) after a successful build on Travis CI

## Getting on the Edge

Proper anynines support is currently included only in the edge version of Travis.  See how to enable it via the `.travis.yml` below.

## The Easy Way

Go Grab the Travis gem from [GitHub](https://github.com/travis-ci/travis.rb) and run this command:

`travis setup anynines`

You will be asked to answer a few simple questions about your anynines setup and Travis will take care of the rest!

Open up your newly created `.travis.yml` and add `edge: true` to enable the deploy tool.  See yml below for an example of how to do this.

## The Slightly Harder Way

So you want to write your own `.travis.yml`, fine.  Here is the minimum required to get up and running

```
 deploy:
   edge: true
   provider: anynines
   username: johndoe@example.com
   password: secretpassword
   organization: myorganization
   space: staging
```

***Make sure that you encrypt your password before pushing your updated .travis.yml to GitHub.***

This can be easily accomplished using the Travis gem above and running:

```
travis encrypt --add deploy.password
```

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
