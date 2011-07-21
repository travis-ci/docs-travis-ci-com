---
title: Getting started
kind: article
layout: article
---

<h3>Sign in</h3>

To get started with Travis CI simply sign in through Github oauth (i.e. go to <a href="http://travis-ci.org">Travis CI</a> and click the link on the top right).

Github will ask you for granting read- and write access. Travis CI needs write access for setting up service hooks for your repositories when you request it, but it won't touch anything else.

<h3>Add service hooks</h3>

Once you're signed in go to your <a href="http://travis-ci.org/profile">profile page</a>. You'll see a list of your repositories. Simply click the on/off switch for each repository that you want to hook up on Travis CI.

You can then click on the small wrench icon next to the on/off switch to get to your service hooks page.

<h3>Prepare your build</h3>

In order to build on Travis CI your repository needs to have a Gemfile (unless you do not have *any* dependencies to install) and a Rakefile with a default test task (unless you specify a different build script in your configuration, see below).

That's it. Travis CI will run `bundle install` (if you have a Gemfile) and then `rake` for you by default.

<h3>Start your build</h3>

To start a build you can either commit and push something to your repository. Or you can go to your service hooks page and click the "Test Hook" button.

That should put a build job into the job queue on <a href="http://travis-ci.org">Travis CI</a> and your build will start as soon as a worker is available.

<h3>Tweaking your build configuration</h3>

You can configure your build by adding a file `.travis.yml` to your repository. See <a href="/docs/build-configuration/">Build Configuration</a> for details.

<h3>Need help?</h3>

For any kind of questions feel free to join our IRC channel <a href="irc://irc.freenode.net#travis">#travis on irc.freenode.net</a>! We're there to help :)
