---
title: "OpsWorks, Cloudfiles, and Divshot.io Deployment"
author: Joshua Anderson
created_at: Fri 10 Jan 2014 00:00:00 PST
layout: post
permalink: /blog/2014-01-01-divshot-deployment
---
Over the holidays, we have been very busy adding support for deploying to several new providers: [AWS OpsWorks](https://aws.amazon.com/en/opsworks/), [Rackspace Cloud Files](https://cart.rackspace.com/cloud/?cp_id=cloud_files), and [Divshot.io](https://www.divshot.io).

### AWS OpsWorks

To start deploying to AWS OpsWorks, add the following to your `.travis.yml`.

     deploy:
      provider: opsworks
      access-key-id: <AWS Secret Access Key>
      secret-access-key: <AWS Secret Access Key>    
      app-id: <AWS App Id>

We recommend you [encrypt the AWS Secret Access Key in your `.travis.yml`](http://about.travis-ci.org/docs/user/encryption-keys/)

To read more about deployment to AWS OpsWorks you can go [here](http://about.travis-ci.org/docs/user/deployment/opsworks).

### Rackspace Cloud Files

To push files to Rackspace after every build, [sign up for Rackspace Cloud Files](https://cart.rackspace.com/cloud/?cp_id=cloud_files)  and add the following to your `travis.yml`.

    deploy:
      provider: cloudfiles
      username: <Rackspace Username>
      api-key:  <Rackspace Api Key>
      region:   <Cloudfiles Region>
      container:<Cloudfiles Container>

 We recommend you [encrypt the Api Key in your `.travis.yml`](http://about.travis-ci.org/docs/user/encryption-keys/).
 
You can always use the `travis` tool to set this up as well.

    $ travis setup cloudfiles

To learn more about pushing files to Rackspace Cloud files you can go [here](http://about.travis-ci.org/docs/user/deployment/cloudfiles).

### Divshot.io

To get started with [Divshot.io](https://www.divshot.io), just sign up and add the following to your `.travis.yml`.

    deploy:
      provider: divshot
      api-key: <api-key>

We recommend you [encrypt the api key in your `.travis.yml`](http://about.travis-ci.org/docs/user/encryption-keys/).

As always, you can use the `travis` tool to set this up as well.

    $ travis setup divshot

Read more about Divshot.io deployment [here](http://about.travis-ci.org/docs/user/deployment/divshot).

### Is your provider still missing?

We've been adding support for lots of new providers, but there are still plenty more out there.
If you'd like to support for your cloud provider on Travis CI, please [shoot us an email](mailto:support@travis-ci.org).

Or, send us a pull request over at our [dpl repository](http://github.com/travis-ci/dpl).