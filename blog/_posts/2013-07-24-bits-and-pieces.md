---
title: Bits and Pieces
author: Konstantin Haase
twitter: konstantinhaase
created_at: Wed 24 Jul 2013 19:30:00 CEST
layout: post
permalink: blog/2013-07-24-bits-and-pieces
---

Travis CI is moving fast, quickly approaching the 70,000 project mark. To make sure you get the best CI experience, we want to keep you up to date with what's going on. So here is a few things that landed recently.

Of course, everything described here is available right now to both [travis-ci.org](http://travis-ci.org) and [travis-ci.com](http://travis-ci.com).

### Continuous Deployment

We've recently launched built-in continuous deployment support for [Heroku](/blog/2013-07-09-introducing-continuous-deployment-to-heroku/) and [Nodejitsu](/blog/2013-07-22-deploy-your-apps-to-nodejitsu/) and have heard back from the first happy users. We've looked at your feedback and are happy to tell you about our two new deployment features.

##### Only deploy tagged commits

Travis CI can now restrict deploys to commits that have also been tagged:

    deploy:
      on:
        tags_only: true

##### Restarting Heroku applications

Sometimes you need to restart your Heroku application after running some command.
One example is running migrations for a Rails application, which only loads the database schema on boot.

You can now simply add `restart` to the `run` section of your `.travis.yml`:

    deploy:
      provider: heroku
      run:
      - "rake db:migrate"
      - restart

This also works in between two steps!

##### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

    deploy:
      skip_cleanup: true

##### Setting Heroku buildpack

When deploying to Heroku via the [Anvil](/docs/user/deployment/heroku/#Deploy-Strategy) strategy, you can now set the [buildpack](https://devcenter.heroku.com/articles/buildpacks) to use:

    deploy:
      provider: heroku
      buildpack: ruby

You can either use a shorthand for the [default buildpacks](https://devcenter.heroku.com/articles/buildpacks#default-buildpacks), like `ruby` or `nodejs` or give it the full URL for a [custom buildpack](https://devcenter.heroku.com/articles/buildpacks#using-a-custom-buildpack).

### Command Line Tool

Our [command line client](https://github.com/travis-ci/travis#the-travis-client) also got a few new features that should make your life easier. Get the latest version by running

    $ gem install travis

If that command doesn't work, make sure you have [Ruby installed](https://github.com/travis-ci/travis#updating-your-ruby).

##### Initializing a project for Travis CI

If you want to set up a project on Travis CI, you can now run `travis init`, which will create a `.travis.yml` with some sane defaults and enable the project, so the next push to GitHub will trigger a new build.

    $ travis init
    Main programming language used: java
    .travis.yml file created!
    example/project: enabled :)

The `.travis.yml` generated from the above example looks like this:

    language: java
    jdk:
    - oraclejdk7
    - openjdk6

You can also pass in a lot of options to influence the generated configuration:

    $ travis init ruby --rvm 1.8.7 --rvm 1.9.3 --script "rake test"
    .travis.yml file created!
    example/project: enabled :)

##### Setup wizard for continuous deployment and addons

When setting up continuous deployment or an addon, you probably spend some time looking at the docs figuring out which options to set and if you should encrypt some of them.

To ease that, we now offer a `travis setup` command that you can run in your project directory:

    [~/travis-api]$ travis setup heroku
    Heroku application name: |travis-api|
    Deploy only from travis-ci/travis-api? |yes|
    Encrypt API key? |yes|

You can also use this for setting up [Sauce Connect](http://about.travis-ci.org/docs/user/addons/#Sauce-Connect):

    [~/travis-api]$ travis setup sauce_connect
    Sauce Labs user: rkh
    Sauce Labs access key: ***************
    Encrypt access key? |yes|

##### Improved value encryption

When you add [encrypted environment variables](http://about.travis-ci.org/docs/user/build-configuration/#Secure-environment-variables), you don't want to override existing variables, which is why the `travis encrypt` command turns it into a list if it isn't already and appends the new value.

However, this causes issues when you re-encrypt for instance a deploy token, as you might accidentally turn it into a list with two entries even though you wanted to override the old one.

Therefore, by default, `travis encrypt` will only use the former behavior for `env` values and override the current value otherwise. You can change this via `--override` or `--append`:

    $ travis encrypt "my secret" --add env.global --override

Keep in mind that using `--add` requires you to run the command from inside the project directory.

##### Branch overview and details

Similar to the "Branches" tab in the web interface, you can now get a branch overview in the console:

<figure>
  [ ![travis branches](/images/travis-branches.png) ](/images/travis-branches.png)
  <figcaption>`travis branches`</figcaption>
</figure>

##### Accessing the public key

You can now access a repo's public key by running `travis pubkey`:

    $ travis pubkey -r travis-ci/travis
    Public key for travis-ci/travis:

    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQC ...

Like all `travis` commands, this is pipe friendly:

    $  travis pubkey -r travis-ci/travis --pem > travis.pem

##### Lots of small fixes

There were a lot of small improvements, especially dealing with edge cases and encodings. The documentation and error messages have also seen some love.

### Thank you

Special thanks for helping with these features go out to [Aaron Hill](Aaron1011), [Johannes Würbach](https://github.com/johanneswuerbach) and [Peter Souter](https://github.com/petems). You rock!