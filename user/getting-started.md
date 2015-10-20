---
title: Getting started
layout: en
permalink: /user/getting-started/
---

The very short guide to using Travis CI with your GitHub hosted code repository. Totally new to all this? Try reading [Travis CI for Complete Beginners](/user/for-beginners) instead. 

Or if you want a more complete guide to a particular language, pick one of these: 

{% include languages.html %}

<!-- 
[C](/user/languages/c) | [C++](/user/languages/cpp) | [Clojure](/user/languages/clojure) | [C#](/user/languages/csharp/) | [D](/user/languages/d) | [Erlang](/user/languages/erlang) | [F#](/user/languages/csharp/) | [Go](/user/languages/go) | [Groovy](/user/languages/groovy) | [Haskell](/user/languages/haskell) | [Java](/user/languages/java) | [JavaScript (with Node.js)](/user/languages/javascript-with-nodejs) | [Julia](/user/languages/julia) | [Objective-C](/user/languages/objective-c) | [Perl](/user/languages/perl) | [PHP](/user/languages/php) | [Python](/user/languages/python) | [Ruby](/user/languages/ruby) | [Rust](/user/languages/rust) | [Scala](/user/languages/scala) | [Visual Basic](/user/languages/csharp/).
-->

### To get started with Travis CI:

1. [Sign in to Travis CI](https://travis-ci.org/auth) with your GitHub account, accepting the GitHub [access permissions confirmation](/user/github-oauth-scopes).

2. Once you're signed in, and we've synchronized your repositories from GitHub, go to your [profile page](https://travis-ci.org/profile) and enable Travis CI for the repository you want to build.

	> Note: You can only enable Travis CI builds for repositories you have admin access to.  

2. Add a `.travis.yml` file to your repository to tell Travis CI what to build:

   ```yaml
   language: ruby
   rvm:
    - "1.8.7"
    - "1.9.2"
    - "1.9.3"
    - rbx
   # uncomment this line if your project needs to run something other than `rake`:
   # script: bundle exec rspec spec
   ```
   
   This example tells Travis CI that this is a project written in Ruby and built with `rake`. Travis CI tests this project against three versions of Ruby and the latest version of Rubinius.

2. Add the `.travis.yml` file to git, commit and push, to trigger a Travis CI build:

	> Note: Travis only runs a build on the commits you push after adding the repository to Travis.
	> Note: If your project already has a `.travis.yml` file, you need to push another commit to trigger a build.

2. Check the [build status](https://travis-ci.org/repositories) page to see if your build passes or fails.

You probably need to [customize your build](/user/customizing-the-build) by [installing dependencies](/user/installing-dependencies) or [setting up a Database](/user/database-setup/). Or maybe you just want more information about the [test environment](/user/ci-environment/)?

<!--

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

#### Dart

    language: dart
    dart:
      - stable
      - dev
      - "1.8.0"

Learn more about [.travis.yml options for Dart projects](/user/languages/dart/)

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

#### Haxe

    language: haxe
    haxe:
      - "3.2.1"
      - development

Learn more about [.travis.yml options for Haxe projects](/user/languages/haxe/)

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

#### R

    language: r

Learn more about [.travis.yml options for R projects](/user/languages/r/)

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

-->
