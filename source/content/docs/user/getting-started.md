---
title: Getting started
kind: content
---

### Travis CI Overview

Travis CI is a distributed continuous integration for the open source community. It is integrated with GitHub and offers first class support for
multiple technologies

 * Clojure
 * Erlang
 * Node.js
 * PHP
 * Ruby

and more. Our CI environment provides multiple runtimes (e.g. Node.js or PHP versions), data stores and so on. Because of this,
hosting your project on travis-ci.org means you can effortlessly test your library or applications against multiple runtimes and
data stores without even having all of them installed locally.


### Step one: Sign in

To get started with Travis CI, sign in through Github OAuth. Go to <a href="http://travis-ci.org">Travis CI</a> and follow the sign in link.

Github will ask you for granting read- and write access. Travis CI needs write access for setting up service hooks for your repositories when you request it, but it won't touch anything else.

###  Step two: Add service hooks

Once you're signed in go to your <a href="http://travis-ci.org/profile">profile page</a>. You'll see a list of your repositories. Flip the on/off switch for each repository that you want to hook up on Travis CI.

Then visit the GitHub service hooks page for that project and paste your GitHub username and Travis token into the settings for the Travis service if not already pre-filled.

### What triggers the build process?

To start a build you can either commit and push something to your repository, or you can go to your GitHub service hooks page and use the "Test Hook" button for Travis.

That should put a build job into the job queue on <a href="http://travis-ci.org">Travis CI</a> and your build will start as soon as a worker is available.

### Step three: Tweaking your build configuration

You can configure your build by adding a `.travis.yml` file to the root of your repository. See <a href="/docs/user/build-configuration/">Build Configuration</a> for details.

### Step four: Learn more

A Travis worker comes with a good amount of services you might depend on, including MySQL, PostgreSQL, MongoDB, Redis, CouchDB, RabbitMQ, memcached and others.

See <a href="/docs/user/database-setup/">Database setup</a> to learn how to configure a database connection for your test suite. More information
about our test environment can be found <a href="/docs/user/ci-environment/">in a separate guide</a>.

### Step five: We are here to help!

For any kind of questions feel free to join our IRC channel <a href="irc://irc.freenode.net#travis">#travis on irc.freenode.net</a>! We're there to help :)
