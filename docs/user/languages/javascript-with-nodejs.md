---
title: Building a Node.js project
layout: en
permalink: javascript-with-nodejs/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Node.js projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Choosing Node versions to test against

Historically Node.js projects were built on Ruby workers but in November 2011 Node.js support was improved to be "first class": testing against multiple Node.js versions on a separate set of VMs. We recommend that you use them to test your Node.js project. Add the following to .travis.yml:

    language: node_js
    node_js:
      - "0.11"
      - "0.10"
      - "0.8"
      - "0.6"

This will make Travis run your tests against the latest (as provided by Travis maintainers, not necessary the absolutely the latest) 0.6.x, 0.8.x, 0.10.x and 0.11.x branch releases. 

0.10 is an alias for "the most recent 0.10.x release" and so on. Please note that using exact versions (for example, 0.10.2) is highly discouraged because as versions change, your .travis.yml will get outdated and things will break.

For example, see [hook.io-amqp-listener .travis.yml](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml).

## Provided Node.js Versions

* 0.10.x (latest stable release)
* 0.8.x
* 0.6.x
* 0.11.x (latest development release, may be unstable)
* 0.9.x (previous development, will be deprecated soon)

For full up-to-date list of provided Node versions, see our [CI environment guide](/docs/user/ci-environment/).

## Default Test Script

For projects using NPM, Travis CI will execute

    npm test

to run your test suite.

### Using Vows

You can tell npm how to run your test suite by adding a line in package.json. For example, to test using Vows:

    "scripts": {
      "test": "vows --spec"
    },


### Using Expresso

To test using Expresso:

    "scripts": {
      "test": "expresso test/*"
    },

Keeping the test script configuration in package.json makes it easy for other people to collaborate on your project, all they need to remember is the `npm test` convention.

## Dependency Management

### Travis uses NPM

Travis uses [NPM](http://npmjs.org/) to install your project's dependencies. It is possible to override this behavior and there are project that use different tooling but the majority of Node.js projects hosted on Travis use NPM, which is also bundled with Node starting with 0.6.0 release.

By default, Travis CI will run

    npm install

to install your dependencies. Note that dependency installation in Travis CI environment always happens from scratch (there are no NPM packages installed at the beginning of your build).

## Meteor Apps

You can build your **Meteor Apps** on Travis and test against [`laika`](http://arunoda.github.io/laika/). 
Simply add following `.travis.yml` file to your project root.

    language: node_js
    node_js:
      - "0.10"
    before_install:
      - "curl -L http://git.io/3l-rRA | /bin/sh"
    services:
      - mongodb
    env: 
      - LAIKA_OPTIONS="-t 5000"
      
related source code can be found [here](https://github.com/arunoda/travis-ci-laika)

## Meteor Packages

It is also possible to build your **Meteor Packages** on Travis by extending the NodeJs configuration.

For example, you can use the following `.travis.yml` file .

    language: node_js
    node_js:
      - "0.10"
    before_install:
      - "curl -L http://git.io/ejPSng | /bin/sh"

The `before_install` script will make sure the required dependencies are installed.

The related source code can be found at the [travis-ci-meteor-packages](https://github.com/arunoda/travis-ci-meteor-packages) repository.

