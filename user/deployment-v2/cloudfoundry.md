---
title: CloudFoundry Deployment
layout: en
deploy: v2
provider: cloudfoundry
---

You now have the amazing ability to deploy directly to [CloudFoundry](https://run.pivotal.io/) after a successful build on Travis CI.

## The Easy Way

Go grab [the Travis gem from GitHub](https://github.com/travis-ci/travis.rb) and run this command:

`travis setup cloudfoundry`

You will be asked to answer a few simple questions about your CloudFoundry setup, and Travis will take care of the rest!

## The Slightly Harder Way

So you want to write your own `.travis.yml`, fine.  Here is the minimum required to get up and running:

```yaml
 deploy:
   provider: cloudfoundry
   username: your@email.com
   password: your_password
   api: https://api.run.pivotal.io
   organization: your_organization
   space: staging
   manifest: manifest-staging.yml       # (optional)  Defaults to manifest.yml.
   app_name: your_app_name              # (optional)
```
{: data-file=".travis.yml"}

***Make sure that you encrypt your password before pushing your updated .travis.yml to GitHub.***

You can do this using the Travis gem above and running:

```bash
travis encrypt --add deploy.password
```

{% include deploy/shared.md %}
