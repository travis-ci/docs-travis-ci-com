---
title: Getting started
layout: en
permalink: getting-started/
---

### Travis CI Overview

Travis CI is a hosted continuous integration service. It is integrated with
GitHub and offers first class support for:

* [C](/user/languages/c)
* [C++](/user/languages/cpp)
* [Clojure](/user/languages/clojure)
* [C#](/user/languages/csharp/)
* [D](/user/languages/d)
* [Erlang](/user/languages/erlang)
* [F#](/user/languages/csharp/)
* [Go](/user/languages/go)
* [Groovy](/user/languages/groovy)
* [Haskell](/user/languages/haskell)
* [Java](/user/languages/java)
* [JavaScript (with Node.js)](/user/languages/javascript-with-nodejs)
* [Julia](/user/languages/julia)
* [Objective-C](/user/languages/objective-c)
* [Perl](/user/languages/perl)
* [PHP](/user/languages/php)
* [Python](/user/languages/python)
* [Ruby](/user/languages/ruby)
* [Rust](/user/languages/rust)
* [Scala](/user/languages/scala)
* [Visual Basic](/user/languages/csharp/)


Travis CI's build environment provides different runtimes for different
languages, for instance multiple versions of Ruby, PHP, Node.js. It also comes
preinstalled with a variety of data stores and common tools like message
brokers.

You can easily test your project against one or more versions of languages and
even data stores.

### Step one: Sign in

To get started with Travis CI, sign in with your GitHub account. Go to [Travis
CI](http://travis-ci.org) and follow the Sign In link at the top.

Note that **on <https://travis-ci.org>, you'll currently only see your public
repositories**, whereas **on <https://travis-ci.com>, you can find your private
projects**.

While signing in, GitHub will ask you for a set of access permissions on our
behalf. We've [outlined them and their use in more
detail](/user/github-oauth-scopes).

### Step two: Activate GitHub Webhook

Once you're signed in, and we've initially synchronized your repositories from
GitHub, go to your [profile page for open source](https://travis-ci.org/profile)
or [for your private projects](https://magnum.travis-ci.com/profile).

You'll see all the organizations you're a member of and all the repositories you
have access to. The ones you have administrative access to are the ones you can
enable the service hook for.

Flip switch to on for all repositories you'd like to enable.

###  Step three: Add .travis.yml file to your repository

In order for Travis CI to build your project, you need to tell the system a
little bit about it. You'll need to add a file named `.travis.yml` to the root
of your repository.

We will only cover basic .travis.yml options in this guide. The most important
one is the **language** key. It tells Travis CI which language environment to
select for your project.

Ruby projects typically use different build tools and
practices than Clojure or PHP projects do, so Travis CI needs to know what to
do.

If `.travis.yml` is not in the repository, is misspelled or is not [valid
YAML](http://yaml-online-parser.appspot.com/), Travis CI will ignore it,
assume Ruby as the language and use default values for everything.

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

#### C#, F#, and Visual Basic

    language: csharp
    solution: solution-name.sln

Learn more about [.travis.yml options for C# projects](/user/languages/csharp/)

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
      - oraclejdk8
      - oraclejdk7
      - openjdk7
      - openjdk6


Learn more about [.travis.yml options for Java projects](/user/languages/java/)

#### Julia

    language: julia
    julia:
      - release
      - nightly

Learn more about [.travis.yml options for Julia projects](/user/languages/julia/)

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

To start a build, perform one of the following:

1. Commit and push something to your repository
1. Go to your repository's settings page, click on "Webhooks & Services" on the left menu, choose "Travis CI" in the "Services",  and use the "Test service" button.

Please note that **you cannot trigger your first build using Test Hook button**. It has to be triggered by a push to your repository.

### Step five: Tweaking your build configuration

Chances are, your project requires some customization to the build process.
Maybe you need to create a database before running your tests or you use build
tools different from what Travis CI's defaults are. Worry not. Travis CI lets
you override almost everything.

Learn how to [customize your build](/user/customizing-the-build) or [how to
install dependencies for your project.](/user/installing-dependencies)

After making some changes to the `.travis.yml`, don't forget to check that it is [valid YAML](http://yaml-online-parser.appspot.com/) and run `travis-lint` to validate it.

### Step six: Learn more

A Travis CI worker comes with a good number of services you might depend on, including MySQL, PostgreSQL, MongoDB, Redis, CouchDB, RabbitMQ, memcached and others.

See [Database setup](/user/database-setup/) to learn how to configure a database connection for your test suite. More information about our test environment can be found [in a separate guide](/user/ci-environment/).

### Step seven: We are here to help!

For any kind of questions feel free to join our IRC channel [#travis on chat.freenode.net](irc://chat.freenode.net/%23travis). We're there to help :)
