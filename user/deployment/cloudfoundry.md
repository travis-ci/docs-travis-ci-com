---
title: CloudFoundry Deployment
layout: en

---

You now have the amazing ability to deploy directly to [CloudFoundry](https://run.pivotal.io/) after a successful build on Travis CI.

<aside markdown="block" class="ataglance">

## Options

{{ site.data.dpl.cloud-foundry }}

</aside>

## The Easy Way

Go grab [the Travis gem from GitHub](https://github.com/travis-ci/travis.rb) and run this command:

`travis setup cloudfoundry`

You will be asked to answer a few simple questions about your CloudFoundry setup, and Travis will take care of the rest!

## The Slightly Harder Way

So you want to write your own `.travis.yml`, fine.  Here is the minimum required to get up and running:

```yaml
 deploy:
   provider: cloudfoundry
   username: hulk_hogan@example.com
   password: supersecretpassword
   api: https://api.run.pivotal.io
   organization: myawesomeorganization
   space: staging
```
{: data-file=".travis.yml"}

***Make sure that you encrypt your password before pushing your updated .travis.yml to GitHub.***

You can do this using the Travis gem above and running:

```bash
travis encrypt --add deploy.password
```

If your password includes symbols (such as braces, parentheses, backslashes, and pipe symbols), [you must escape those symbols before running `travis encrypt`](/user/encryption-keys/#Note-on-escaping-certain-symbols).

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
