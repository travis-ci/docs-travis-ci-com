---
title: Script deployment
layout: en
permalink: /user/deployment/script/
---

You can deploy your application using a custom script.

This provides a more streamlined custom deployment strategy than
using the `after_success`.

{% highlight yaml %}
deploy:
  provider: script
  script: scripts/deploy.sh
  on:
    branch: develop
{% endhighlight %}

This example executes `scripts/deploy.sh` on the `develop` branch
if the tests pass.

`script` must be a scalar pointing to an executable command.
If you need to execute multiple commands, write a wrapper script
that does all the work for you.
Be sure to make the script executable.

If the script returns a nonzero status, deployment is considered
a failure, and the build will be marked as "errored".

## Deployment is executed by Ruby 1.9.3

In order to ensure that deployments are executed reliably, we use a version of Ruby that
is pre-installed on all of our build images.
Currently, this is Ruby 1.9.3.

A side effect of this is that, if you need to execute a command
that requires a different Ruby, you need to execute it explicitly.
For example,

{% highlight yaml %}
deploy:
  provider: script
  script: rvm $TRAVIS_RUBY_VERSION do script.rb
{% endhighlight %}
