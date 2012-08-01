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
      - 0.8
      - 0.6

This will make Travis run your tests against the latest (as provided by Travis maintainers, not necessary the absolutely the latest) 0.6.x branch release. 0.8 is an alias for "the most recent 0.8.x release" and so on. Please note that using exact versions (for example, 0.6.19) is highly discouraged because as versions change, your .travis.yml will get outdated and things will break.

For example, see [hook.io-amqp-listener .travis.yml](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml).

## Provided Node.js Versions

 * 0.8.x
 * 0.6.x
 * 0.9.x (development, may be unstable)

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

Travis uses [NPM](http://http://npmjs.org/) to install your project's dependencies. It is possible to override this behavior and there are project that use different tooling but the majority of Node.js projects hosted on Travis use NPM, which is also bundled with Node starting with 0.6.0 release.

By default, Travis CI will run

    npm install

to install your dependencies. Note that dependency installation in Travis CI environment always happens from scratch (there are no NPM packages installed at the beginning of your build).
