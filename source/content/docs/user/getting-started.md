---
title: Getting started
kind: article
layout: article
---

<h3>Make sure your project is ready to build</h3>

In order to build on Travis CI your repository should have a Rakefile with the default task being a test task. That's it. Travis CI will first run `bundle install` if you have a Gemfile, and then `rake` for you by default.

More on configuring this below.

<h3>Sign in</h3>

To get started with Travis CI simply sign in through Github OAuth. Go to <a href="http://travis-ci.org">Travis CI</a> and follow the sign in link.

Github will ask you for granting read- and write access. Travis CI needs write access for setting up service hooks for your repositories when you request it, but it won't touch anything else.

<h3>Add service hooks</h3>

Once you're signed in go to your <a href="http://travis-ci.org/profile">profile page</a>. You'll see a list of your repositories. Flip the on/off switch for each repository that you want to hook up on Travis CI.

<h3>What triggers the build process?</h3>

To start a build you can either commit and push something to your repository, or you can go to your GitHub service hooks page and use the "Test Hook" button for Travis.

That should put a build job into the job queue on <a href="http://travis-ci.org">Travis CI</a> and your build will start as soon as a worker is available.

<h3>Tweaking your build configuration</h3>

You can configure your build by adding a `.travis.yml` file to the root of your repository. See <a href="/docs/user/build-configuration/">Build Configuration</a> for details.

<h3>Need help?</h3>

For any kind of questions feel free to join our IRC channel <a href="irc://irc.freenode.net#travis">#travis on irc.freenode.net</a>! We're there to help :)
