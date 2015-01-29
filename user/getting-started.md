---
title: Getting started
layout: en
permalink: /user/getting-started/
---

The very short guide to using Travis CI. You need to sign up for a [GitHub 
account](https://github.com/) if you do not already have one. 

This short guide uses a PHP project as an example. If you prefer a different 
language, check the longer guides for each language:

[C](/user/languages/c)| [C++](/user/languages/cpp)| [Clojure](/user/languages/clojure)| [C#](/user/languages/csharp/)| [D](/user/languages/d)| [Erlang](/user/languages/erlang)| [F#](/user/languages/csharp/)| [Go](/user/languages/go)| [Groovy](/user/languages/groovy)| [Haskell](/user/languages/haskell)| [Java](/user/languages/java)| [JavaScript (with Node.js)](/user/languages/javascript-with-nodejs)| [Julia](/user/languages/julia)| [Objective-C](/user/languages/objective-c)| [Perl](/user/languages/perl)| [PHP](/user/languages/php)| [Python](/user/languages/python)| [Ruby](/user/languages/ruby)| [Rust](/user/languages/rust)| [Scala](/user/languages/scala)| [Visual Basic](/user/languages/csharp/)

### To get started with Travis CI:

1. On GitHub, fork the 
[example PHP repository](https://github.com/plaindocs/travis-broken-example).

2. [Sign in to Travis CI](https://travis-ci.org/auth) with your GitHub account, accepting the GitHub
[access permissions confirmation](/user/github-oauth-scopes).

2. Once you're signed in, and we've synchronized your repositories from
GitHub, go to your [profile page](https://travis-ci.org/profile) and enable 
Travis CI builds for your fork of the `travis-broken-example` repository.

	Note: You can only enable Travis CI builds for repositories you have admin 
	access to.  

2. Take a look at `.travis.yml`, the file which tells Travis CI what to do:

	```yaml
	language: php
	php:
	- 5.5
	- 5.4
	- hhvm
	script: phpunit Test.php
	```

	This file tells Travis CI that this project is written in PHP, and to test 
	`Test.php` with phpunit against PHP versions 5.5, 5.4 and HVVM.  

2. Edit the empty `NewUser.txt` file by adding your name. Add the file to git, commit and push, to trigger a Travis CI build:

	```bash
	$ git add -A
	$ git commit -m 'Testing Travis CI'
	$ git push
	```

	Note: Travis only runs a build on the commits you push after adding the repository to Travis.
	Wait for Travis CI to run a build your fork of `travis-broken-example` repository, and notice that the tests fail. 

2. Fix the code by making sure that `2=1+1` in `Test.php`, commit and push to 
GitHub. This time, the build will pass the tests.

	```bash
	$ git add -A
	$ git commit -m 'Testing Travis CI: fixing the build'
	$ git push
	```

Congratulations, you have added a GitHub repository to Travis and learnt the basics of configuring builds, and running 
passing and failing tests.
<!-- TODO: More info on PHP, more info on config? -->

### Some basic **.travis.yml** examples:


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
