---
title: Bluemix CloudFoundry Deployment
layout: en
permalink: /user/deployment/bluemixcloudfoundry/
---

You now have the amazing ability to deploy directly to [IBM Bluemic](https://console.ng.bluemix.net/) after a successful build on Travis CI.

## Getting on the Edge

Proper Bluemix CloudFoundry support is currently included only in the edge version of Travis.  See how to enable it via the `.travis.yml` below.

## The Easy Way

Go grab [the Travis gem from GitHub](https://github.com/travis-ci/travis.rb) and run this command:

`travis setup bluemixcloudfoundry`

You will be asked to answer a few simple questions about your CloudFoundry setup, and Travis will take care of the rest!

Open up your newly-created `.travis.yml` and add `edge: true` to enable the deploy tool.  See yml below for an example of how to do this.

## The Slightly Harder Way

So you want to write your own `.travis.yml`, fine.  Here is the minimum required to get up and running:

```
 deploy:
   edge: true
   provider: bluemixcloudfoundry
   username: brian_knobbs@example.com
   password: somewhatsecretpassword
   organization: myawesomeorganization
   space: staging
   manifest: manifest-prod.yml          # (optional)  Defaults to manifest.yml.
   region: eu-gb                        # (optional)  [ng, eu-gb , au-syd] Defaults to US South region (ng).
   api: https://api.ng.bluemix.net      # (optional)  Overrides region setting if specifed for Bluemix local installations.
```

***Make sure that you encrypt your password before pushing your updated .travis.yml to GitHub.***

You can do this using the Travis gem above and running:

```
travis encrypt --add deploy.password
```

If your password includes symbols (such as braces, parentheses, backslashes, and pipe symbols), [you must escape those symbols before running `travis encrypt`](/user/encryption-keys/#Note-on-escaping-certain-symbols).

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
