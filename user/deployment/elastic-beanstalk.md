---
title: Deis Deployment
layout: en
permalink: deis/
---

Travis CI supports deploying to [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/).

A minimal configuration is:

{% highlight yaml %}
deploy:
  provider: elasticbeanstalk
  access-key-id: "YOUR AWS ACCESS KEY"
  secret-key-id: "YOUR AWS SECRET KEY"
  app: App_name
  env: "ELASTIC BEANSTALK ENVIRONMENT"
{% endhighlight %}

It is recommend that you encrypt your AWS secret key.
Assuming you have the Travis CI command line client installed, you can do it like this:

{% highlight console %}
travis encrypt "YOUR AWS SECRET KEY" --add deploy.secret-key-id
{% endhighlight %}

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

{% highlight console %}
$ travis setup deis
{% endhighlight %}

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Deploying to a different AWS region

If your app needs to deploy to a region other than `us-east-1`, you can use the `region` option. For example, the folowing deploys to the `ap-northeast-1` region:

{% highlight yaml %}
deploy:
  provider: elasticbeanstalk
  access-key-id: "YOUR AWS ACCESS KEY"
  secret-key-id: "YOUR AWS SECRET KEY"
  app: App_name
  env: "ELASTIC BEANSTALK ENVIRONMENT"
  region: ap-northeast-1
{% endhighlight %}

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).