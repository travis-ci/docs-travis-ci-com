---
title: Script deployment
layout: en
permalink: /user/deployment/script/
---

If your deployment needs more customization than the `after_success` method allows,
use a custom script.

The following example runs `scripts/deploy.sh` on the `develop` branch of your repository if the build is successful.

```yaml
deploy:
  provider: script
  script: scripts/deploy.sh
  on:
    branch: develop
```

`script` must be a scalar pointing to an executable file or command.

If you need to run multiple commands, write a executable wrapper script that runs them all.

If the script returns a nonzero status, deployment is considered
a failure, and the build will be marked as "errored".

## Deployment is executed by Ruby 1.9.3

In order to ensure that deployments are executed reliably, we use a version of Ruby that is pre-installed on all of our build images.

Currently, this is Ruby 1.9.3.

A side effect of this is that, if you need to execute a command
that requires a different Ruby, you need to execute it explicitly.
For example,

{% highlight yaml %}
deploy:
  provider: script
  script: rvm $TRAVIS_RUBY_VERSION do script.rb
{% endhighlight %}
