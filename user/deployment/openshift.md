---
title: OpenShift Deployment
layout: en
permalink: /user/deployment/openshift/
---

Travis CI can automatically deploy your [OpenShift](https://www.openshift.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

{% highlight yaml %}
deploy:
  provider: openshift
  user: "YOU USER NAME"
  password: "YOUR PASSWORD" # can be encrypted
  domain: "YOUR OPENSHIFT DOMAIN"
{% endhighlight %}

Currently it is not possible to use a token instead of the password, as these tokens expire too quickly. We are working with the OpenShift team on a solution.

You can also have the `travis` tool set up everything for you:

    $ travis setup openshift

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

To provide the best service possible, Travis CI has teamed up with OpenShift as a [partner](https://www.openshift.com/partners) and there is an official [Travis CI QuickStart](https://www.openshift.com/quickstarts/travis-ci-on-openshift) to get you going.

### Application to deploy

By default, we will try to deploy to an application by the same name as the repository. For example, if you deploy an application from the GitHub repository [travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without explicitly specify the name of the application, Travis CI will try to deploy to an OpenShift app named *travis-chat*.

You can explicitly set the name via the **app** option:

{% highlight yaml %}
deploy:
  provider: openshift
  ...
  app: my-app-123
{% endhighlight %}

It is also possible to deploy different branches to different applications:

{% highlight yaml %}
deploy:
  provider: openshift
  ...
  app:
    master: my-app-staging
    production: my-app-production
{% endhighlight %}

If these apps belong to different OpenShift domains, you will have to do the same for the domain:

{% highlight yaml %}
deploy:
  provider: openshift
  ...
  domain:
    master: ...
    production: ...
  app:
    master: my-app-staging
    production: my-app-production
{% endhighlight %}

### Branch to deploy from

If you have branch specific options, as [shown above](#Application-to-deploy), Travis CI will automatically figure out which branches to deploy from. Otherwise, it will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

{% highlight yaml %}
deploy:
  provider: openshift
  ...
  on: production
{% endhighlight %}

Alternatively, you can also configure it to deploy from all branches:

{% highlight yaml %}
deploy:
  provider: openshift
  ...
  on:
    all_branches: true
{% endhighlight %}

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

{% highlight yaml %}
deploy:
  provider: openshift
  ...
  skip_cleanup: true
{% endhighlight %}

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Note on `.gitignore`

As this deployment strategy relies on `git`, be mindful that the deployment will
honor `.gitignore`.

If your `.gitignore` file matches something that your build creates, use
[`before_deploy`](#Running-commands-before-and-after-deploy) to change
its content.

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

{% highlight yaml %}
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
{% endhighlight %}

### Deployment branch

OpenShift can be configured to deploy from a branch different from the default `master` via `rhc app-configure --deployment-branch mybranch`.

If you've done this to your application, specify this desired branch with `deployment_branch`:

{% highlight yaml %}
deploy:
  provider: openshift
  ...
  deployment_branch: mybranch
{% endhighlight %}

### Deploying from a distribution directory

When using travis to deploy build artifacts to your openshift deployment, you will need to perform a **git commit** in the `after_success:` section of your configuration. 

In the example below, we will assume that your distribution files will be located in a foler called **dist**

**deploy**

{% highlight yaml %}
deploy:
  provider: openshift
  user: "OPENSHIFT USERNAME"
  password: "OPENSHIFT PASSWORD"
  skip_cleanup: true
  domain: "OPENSHIFT DOMAIN"
{% endhighlight %}

**after_success**

{% highlight yaml %}
after_success:
  - cd dist
  - git init
  - git config --global user.email "travis@localhost.localdomain"
  - git config --global user.name "Travis CI"
  - git add --all
  - git commit -am "Travis change"
{% endhighlight %}
