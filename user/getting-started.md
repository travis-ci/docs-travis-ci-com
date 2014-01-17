---
title: Getting started
layout: en
permalink: getting-started/
---

### Travis CI Overview

Travis CI is a hosted continuous integration service for the open source community. It is integrated with GitHub and offers first class support for:

* [C](/user/languages/c)
* [C++](/user/languages/cpp)
* [Clojure](/user/languages/clojure)
* [Erlang](/user/languages/erlang)
* [Go](/user/languages/go)
* [Groovy](/user/languages/groovy)
* [Haskell](/user/languages/haskell)
* [Java](/user/languages/java)
* [JavaScript (with Node.js)](/user/languages/javascript-with-nodejs)
* [Objective-C](/user/languages/objective-c)
* [Perl](/user/languages/perl)
* [PHP](/user/languages/php)
* [Python](/user/languages/python)
* [Ruby](/user/languages/ruby)
* [Scala](/user/languages/scala)

Our CI environment provides multiple runtimes (e.g. Node.js or PHP versions), data stores and so on. Because of this, hosting your project on travis-ci.org means you can effortlessly test your library or applications against multiple runtimes and data stores without even having all of them installed locally.

travis-ci.org originally started as a service for the Ruby community in early 2011 but has added support for many other technologies since then.

### Step one: Sign in

To get started with Travis CI, sign in through GitHub OAuth. Go to [Travis CI](http://travis-ci.org) and follow the Sign In link at the top.

GitHub will ask you to grant read and write access. Travis CI needs write access for setting up service hooks for your repositories when you request it, but it won't touch anything else.

### Step two: Activate GitHub Service Hook

Once you're signed in go to your [profile page](https://travis-ci.org/profile). You'll see a list of your repositories. Flip the on/off switch for each repository that you want to hook up on Travis CI. Then visit the GitHub service hooks page for that project and paste your GitHub username and Travis token into the settings for the Travis service if it is not already pre-filled.

###  Step three: Add .travis.yml file to your repository

In order for Travis to build your project, you need to tell the system a little bit about it. To do so, add .travis.yml to the root of your repository. We will only cover basic .travis.yml options in this guide. The most important one is the **language** key. It tells Travis what builder to pick. Ruby projects typically use different build tools and practices than Clojure or PHP projects do, so Travis needs to know what to do.

If `.travis.yml` is not in the repository, is misspelled or is not [valid YAML](http://yaml-online-parser.appspot.com/), travis-ci.org will ignore it, assume Ruby as the language and use default values for everything.

#### Note

The `language` value is case-sensitive.
If you set `language: C`, for example, your project will be considered a Ruby project.

Here are some basic **.travis.yml** examples:


#### C

    language: c
    compiler:
      - gcc
      - clang
    # Change this to your needs
    script: ./configure && make

Learn more about [.travis.yml options for C projects](/user/languages/c/)


#### C++

    language: cpp
    compiler:
      - gcc
      - clang
    # Change this to your needs
    script: ./configure && make

Learn more about [.travis.yml options for C++ projects](/user/languages/cpp/)


#### Clojure

For projects using Leiningen 1:

    language: clojure
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6

For projects using Leiningen 2:

    language: clojure
    lein: lein2
    jdk:
      - openjdk7
      - openjdk6


Learn more about [.travis.yml options for Clojure projects](/user/languages/clojure/)

#### Erlang

    language: erlang
    otp_release:
      - R15B02
      - R15B01
      - R14B04
      - R14B03

Learn more about [.travis.yml options for Erlang projects](/user/languages/erlang/)


#### Haskell

    language: haskell

Learn more about [.travis.yml options for Haskell projects](/user/languages/haskell/)


#### Go

    language: go

Learn more about [.travis.yml options for Go projects](/user/languages/go/)



#### Groovy

    language: groovy
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6


Learn more about [.travis.yml options for Groovy projects](/user/languages/groovy/)

#### Java

    language: java
    jdk:
      - oraclejdk7
      - openjdk7
      - openjdk6


Learn more about [.travis.yml options for Java projects](/user/languages/java/)

#### Node.js

     language: node_js
     node_js:
       - "0.10"
       - "0.8"
       - "0.6"

Learn more about [.travis.yml options for Node.js projects](/user/languages/javascript-with-nodejs/)

#### Objective-C

     language: objective-c

Learn more about [.travis.yml options for Objective-C projects](/user/languages/objective-c/)

#### Perl

    language: perl
    perl:
      - "5.16"
      - "5.14"
      - "5.12"

Learn more about [.travis.yml options for Perl projects](/user/languages/perl/)

#### PHP

    language: php
    php:
      - "5.5"
      - "5.4"
      - "5.3"

Learn more about [.travis.yml options for PHP projects](/user/languages/php/)

#### Python

    language: python
    python:
      - "3.3"
      - "2.7"
      - "2.6"
    # command to install dependencies, e.g. pip install -r requirements.txt --use-mirrors
    install: PLEASE CHANGE ME
    # command to run tests, e.g. python setup.py test
    script:  PLEASE CHANGE ME

Learn more about [.travis.yml options for Python projects](/user/languages/python/)

#### Ruby

    language: ruby
    rvm:
      - "1.8.7"
      - "1.9.2"
      - "1.9.3"
      - jruby-18mode # JRuby in 1.8 mode
      - jruby-19mode # JRuby in 1.9 mode
      - rbx
    # uncomment this line if your project needs to run something other than `rake`:
    # script: bundle exec rspec spec

Learn more about [.travis.yml options for Ruby projects](/user/languages/ruby/)

#### Scala

     language: scala
     scala:
       - "2.9.2"
       - "2.8.2"
     jdk:
       - oraclejdk7
       - openjdk7
       - openjdk6


Learn more about [.travis.yml options for Scala projects](/user/languages/scala/)

#### Validate Your .travis.yml

We recommend you use [travis-lint](http://github.com/travis-ci/travis-lint) (command-line tool) or [.travis.yml validation Web app](http://lint.travis-ci.org) to validate your `.travis.yml` file.

`travis-lint` requires Ruby 1.8.7+ and RubyGems installed. Get it with

    gem install travis-lint

and run it on your `.travis.yml`:

    # inside a repository with .travis.yml
    travis-lint

    # from any directory
    travis-lint [path to your .travis.yml]

`travis-lint` will check things like

* The `.travis.yml` file is [valid YAML](http://yaml-online-parser.appspot.com/)
* The `language` key is present
* The runtime versions (Ruby, PHP, OTP, etc) specified are supported in the [Travis CI Environment](/user/ci-environment/)
* That you are not using deprecated features or runtime aliases

and so on. `travis-lint` is your friend, use it.

### Step four: Trigger Your First Build With a Git Push

Once GitHub hook is set up, push your commit that adds .travis.yml to your repository. That should add a build into one of the queues on [Travis CI](http://travis-ci.org) and your build will start as soon as one worker for your language is available.

To start a build you can either commit and push something to your repository, or you can go to your GitHub service hooks page and use the "Test Hook" button for Travis. Please note that **you cannot trigger your first build using Test Hook button**. It has to be triggered by a push to your repository.

### Step five: Tweaking your build configuration

Chances are, your project requires some customization to the build process. Maybe you need to create a database before running your tests or you use build tools different from what Travis defaults are. Worry not. Travis lets you override almost everything. See [Build Configuration](/user/build-configuration/) to learn more.

After making some changes to the `.travis.yml`, don't forget to check that it is [valid YAML](http://yaml-online-parser.appspot.com/) and run `travis-lint` to validate it.

### Step six: Learn more

A Travis worker comes with a good amount of services you might depend on, including MySQL, PostgreSQL, MongoDB, Redis, CouchDB, RabbitMQ, memcached and others.

See [Database setup](/user/database-setup/) to learn how to configure a database connection for your test suite. More information about our test environment can be found [in a separate guide](/docs/user/ci-environment/).

### Step seven: We are here to help!

For any kind of questions feel free to join our IRC channel [#travis on chat.freenode.net](irc://chat.freenode.net/%23travis). We're there to help :)
