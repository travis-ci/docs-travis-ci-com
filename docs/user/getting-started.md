---
title: Getting started
layout: default
permalink: getting-started/
---

### Travis CI Overview

Travis CI is a distributed continuous integration for the open source community. It is integrated with GitHub and offers first class support for
multiple technologies

 * Clojure
 * Erlang
 * Groovy
 * Java
 * Node.js
 * Perl
 * PHP
 * Python
 * Ruby
 * Scala

and more. Our CI environment provides multiple runtimes (e.g. Node.js or PHP versions), data stores and so on. Because of this,
hosting your project on travis-ci.org means you can effortlessly test your library or applications against multiple runtimes and
data stores without even having all of them installed locally.

travis-ci.org originally started as a service for the Ruby community in early 2011 but has added support for many other technologies since
then.


### Step one: Sign in

To get started with Travis CI, sign in through Github OAuth. Go to <a href="http://travis-ci.org">Travis CI</a> and follow the Sign In link at the top.

Github will ask you for granting read- and write access. Travis CI needs write access for setting up service hooks for your repositories when you request it,
but it won't touch anything else.

### Step two: Activate GitHub Service Hook

Once you're signed in go to your <a href="http://travis-ci.org/profile">profile page</a>. You'll see a list of your repositories. Flip the on/off switch for each repository that you want to hook up on Travis CI. Then visit the GitHub service hooks page for that project and paste your GitHub username and Travis token into
the settings for the Travis service if it is not already pre-filled.

If your repository belongs to organization or flipping the switch did not set up the hook, please <a href="/docs/user/how-to-setup-and-trigger-the-hook-manually/">set it up manually</a> on GitHub, it will take just a couple of minutes.


###  Step three: Add .travis.yml file to your repository

In order for Travis to build your project, you need to tell the system a little bit about it. To do so, add .travis.yml to the root of your repository.
We will only cover basic .travis.yml options in this guide. The most important one is the **language** key. It tells Travis what builder to pick: Ruby projects
typically use different build tools and practices than Clojure or PHP projects do, so Travis needs to know what to do.

If `.travis.yml` is not in the repository, is mispelled or is not [valid YAML](http://yaml-online-parser.appspot.com/), travis-ci.org will ignore it, assume
Ruby as the language and use default values for everything.

Here are some basic **.travis.yml** examples:

#### Clojure

    language: clojure

Learn more about <a href="/docs/user/languages/clojure/">.travis.yml options for Clojure projects</a>

#### Erlang

    language: erlang
    otp_release:
      - R15B
      - R14B02
      - R14B03
      - R14B04

Learn more about <a href="/docs/user/languages/erlang/">.travis.yml options for Erlang projects</a>

#### Groovy

    language: groovy

Learn more about <a href="/docs/user/languages/groovy/">.travis.yml options for Groovy projects</a>


#### Java

    language: java

Learn more about <a href="/docs/user/languages/java/">.travis.yml options for Java projects</a>


#### Node.js

     language: node_js
     node_js:
       - 0.4
       - 0.6
       - 0.7 # development version of 0.8, may be unstable

Learn more about <a href="/docs/user/languages/javascript-with-nodejs/">.travis.yml options for Node.js projects</a>


#### Perl

    language: perl
    perl:
      - "5.14"
      - "5.12"

Learn more about <a href="/docs/user/languages/perl/">.travis.yml options for Perl projects</a>


#### PHP

    language: php
    php:
      - 5.3
      - 5.4

Learn more about <a href="/docs/user/languages/php/">.travis.yml options for PHP projects</a>


#### Python

    language: python
    python:
      - 2.6
      - 2.7
      - 3.2
    # command to install dependencies, e.g. pip install -r requirements.txt --use-mirrors
    install: PLEASE CHANGE ME
    # command to run tests, e.g. python setup.py test
    script:  PLEASE CHANGE ME

Learn more about <a href="/docs/user/languages/python/">.travis.yml options for Python projects</a>


#### Ruby

    language: ruby
    rvm:
      - 1.8.7
      - 1.9.2
      - 1.9.3
      - jruby-18mode # JRuby in 1.8 mode
      - jruby-19mode # JRuby in 1.9 mode
      - rbx-18mode
      - rbx-19mode
    # uncomment this line if your project needs to run something other than `rake`:
    # script: bundle exec rspec spec

Learn more about <a href="/docs/user/languages/ruby/">.travis.yml options for Ruby projects</a>

#### Scala

     language: scala
     scala:
       - 2.8.2
       - 2.9.1

Learn more about <a href="/docs/user/languages/scala/">.travis.yml options for Scala projects</a>

#### Validate Your .travis.yml

We recommend you to use [travis-lint](http://github.com/travis-ci/travis-lint) (command-line tool) or [.travis.yml validation Web app](http://lint.travis-ci.org) to validate your `.travis.yml` file.

`travis-lint` requires Ruby 1.8.7+ and RubyGems installed. Get it with

    gem install travis-lint

and run it on your `.travis.yml`:

    # inside a repository with .travis-yml
    travis-lint
    
    # from any directory
    travis-lint [path to your .travis.yml]

`travis-lint` will check things like

 * That `.travis.yml` file is [valid YAML](http://yaml-online-parser.appspot.com/)
 * That `language` key is present
 * That runtime versions (Ruby, PHP, OTP, etc) specified are supported in the [Travis CI Environment](/docs/user/ci-environment/)
 * That are you not using deprecated features or runtime aliases

and so on. `travis-lint` is your friend, use it.


### Step four: Trigger Your First Build With a Git Push

Once GitHub hook is set up, push your commit that adds .travis.yml to your repository.
That should add a build into one of the queues on <a href="http://travis-ci.org">Travis CI</a> and your build will start as soon as one worker for your
language is available.

To start a build you can either commit and push something to your repository, or you can go to your GitHub service hooks page and use the "Test Hook" button for Travis.
Please note that **you cannot trigger your first build using Test Hook button**. It has to be triggered by a push to your repository.


### Step five: Tweaking your build configuration

Chances are, your project requires some customization to the build process: maybe you need to create a database before running your tests or you use build tools
different from what Travis defaults are. Worry not: Travis lets you override almost everything.
See <a href="/docs/user/build-configuration/">Build Configuration</a> to learn more.

After making some changes to the `.travis.yml`, don't forget to check that it is [valid YAML](http://yaml-online-parser.appspot.com/) and run
`travis-lint` to validate it.


### Step six: Learn more

A Travis worker comes with a good amount of services you might depend on, including MySQL, PostgreSQL, MongoDB, Redis, CouchDB, RabbitMQ, memcached and others.

See <a href="/docs/user/database-setup/">Database setup</a> to learn how to configure a database connection for your test suite. More information
about our test environment can be found <a href="/docs/user/ci-environment/">in a separate guide</a>.


### Step seven: We are here to help!

For any kind of questions feel free to join our IRC channel <a href="irc://irc.freenode.net#travis">#travis on irc.freenode.net</a>.
We're there to help :)
