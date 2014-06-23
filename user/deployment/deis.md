---
title: Deis Deployment
layout: en
permalink: deis/
---

Travis CI supports uploading to Deis.

A minimal configuration is:

    deploy:
      provider: deis
      controller: deis.deisapps.com
      username: "Deis User Name"
      password: "Deis Password"
      app: App_name

It is recommended to encrypt password.
Assuming you have the Travis CI command line client installed, you can do it like this:

    travis encrypt --add deploy.password

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

    $ travis setup deis

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
