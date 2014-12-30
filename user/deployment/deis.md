---
title: Deis Deployment
layout: en
permalink: /user/deployment/deis/
---

Travis CI supports uploading to [Deis](http://deis.io/).

A minimal configuration is:

{% highlight yaml %}
deploy:
  provider: deis
  controller: deis.deisapps.com
  username: "Deis User Name"
  password: "Deis Password"
  app: App_name
{% endhighlight %}

It is recommended that you encrypt your password.
Assuming you have the Travis CI command line client installed, you can do it like this:

{% highlight console %}
$ travis encrypt "YOUR DEIS PASSWORD" --add deploy.password
{% endhighlight %}

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

{% highlight console %}
$ travis setup deis
{% endhighlight %}

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
