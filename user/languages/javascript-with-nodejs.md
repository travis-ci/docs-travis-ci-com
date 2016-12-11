---
title: Building a Node.js project
layout: en
permalink: /user/languages/javascript-with-nodejs/
---

<div id="toc"></div>

This guide covers build environment and configuration topics specific to Node.js projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

## Choosing Node versions to test against

You can choose Node.js and io.js versions to run your tests by adding them to the `node_js` section of your  `.travis.yml`:

```yaml
language: node_js
node_js:
  - "6"
  - "6.1"
  - "5.11"
  - "0.6"
  - "iojs"
```

These values are passed on to [`nvm`](https://github.com/creationix/nvm);
newer releases not shown above may be used if `nvm` recognizes them.

For precise versions pre-installed on the VM, please consult "Build system information" in the build log.

## Available Versions

* 6.1.x
* 6.0.x
* 5.11.x
* 5.10.x
* 5.9.x
* 5.8.x
* 5.7.x
* 5.6.x
* 5.5.x
* 5.4.x
* 5.3.x
* 5.2.x
* 5.1.x
* 5.0.x
* 4.4.x
* 4.3.x
* 4.2.x
* 4.1.x
* 4.0.x
* 0.12.x
* 0.11.x
* 0.10.x
* 0.8.x
* 0.6.x

Use the following convenience versions:

 * `node` latest stable Node.js release
 * `iojs` latest stable io.js release
 * `6` latest 6.x release
 * `5` latest 5.x release
 * `4` latest 4.x release

Specifying only a major and minor version (e.g., "0.12") will run using the latest published patch release for that version. If a specific version is not needed, we encourage users to specify `node` and/or `iojs` to run using the latest stable releases. [nvm](https://github.com/creationix/nvm) handles version resolution, so any version or [alias](https://github.com/creationix/nvm#usage) of Node.js or io.js that nvm can install is available.

If the version of Node.js cannot be used (because `nvm` cannot install it, and a suitable version is not locally installed), the job will error immediately.

For example, see [hook.io-amqp-listener .travis.yml](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml).

### Using `.nvmrc`

Optionally, your repository can contain a `.nvmrc` file in the repository root to specify which *single* version of Node.js to run your tests against.

The `.nvmrc` file is _only read_ when `node_js` key in your `.travis.yml` files does *not* specify a nodjs version. When the `.nvmrc` file is read, `$TRAVIS_NODE_VERSION` is set to the nodejs version. See [nvm documentation](https://github.com/creationix/nvm#usage) for more information on `.nvmrc`.

## Default Test Script

The default test script for projects using nodejs is:

```bash
npm test
```

### Using other Test Suites

You can tell npm how to run your test suite by adding a line in `package.json`. For example, to test using Vows:

```json
"scripts": {
  "test": "vows --spec"
},
```

## Using Gulp

If you already use Gulp to manage your tests, install it and run the default
`gulpfile.js` by adding the following lines to your `.travis.yml`:

```yaml
before_script:
  - npm install -g gulp
script: gulp
```

## Dependency Management

### Travis CI uses npm

Travis CI uses [npm](http://npmjs.org/) to install your project dependencies:

```bash
npm install
```

> Note that there are no npm packages installed by default in the Travis CI environment , your dependencies are downloaded and installed every build.

### Using shrinkwrapped git dependencies

Note that `npm install` can fail if a shrinkwrapped git dependency pointing to a branch has its HEAD changed.

## Ember Apps

You can build your Ember applications on Travis CI. The default test framework is [`Qunit`](http://qunitjs.com/). The following example shows how to build and test against different Ember versions.

```yaml
sudo: required
dist: trusty
addons:
  apt:
    sources:
      - google-chrome
    packages:
      - google-chrome-stable
language: node_js
node_js:
  - "0.12"
env:
    - EMBER_VERSION=default
    - EMBER_VERSION=release
    - EMBER_VERSION=beta
    - EMBER_VERSION=canary
matrix:
  fast_finish: true
  allow_failures:
    - env: EMBER_VERSION=release
    - env: EMBER_VERSION=beta
    - env: EMBER_VERSION=canary

before_install:
    # setting the path for phantom.js 2.0.0
    - export PATH=/usr/local/phantomjs-2.0.0/bin:$PATH
    # starting a GUI to run tests, per https://docs.travis-ci.com/user/gui-and-headless-browsers/#Using-xvfb-to-Run-Tests-That-Require-a-GUI
    - export DISPLAY=:99.0
    - sh -e /etc/init.d/xvfb start
    - "npm config set spin false"
    - "npm install -g npm@^2"
install:
    - mkdir travis-phantomjs
    - wget https://s3.amazonaws.com/travis-phantomjs/phantomjs-2.0.0-ubuntu-12.04.tar.bz2 -O $PWD/travis-phantomjs/phantomjs-2.0.0-ubuntu-12.04.tar.bz2
    - tar -xvf $PWD/travis-phantomjs/phantomjs-2.0.0-ubuntu-12.04.tar.bz2 -C $PWD/travis-phantomjs
    - export PATH=$PWD/travis-phantomjs:$PATH
    - npm install -g bower
    - npm install
    - bower install
script:
    - ember test --server

```

## Meteor Apps

You can build your Meteor Apps on Travis CI and test against
[`laika`](http://arunoda.github.io/laika/):

```yaml
language: node_js
node_js:
  - "0.12"
before_install:
  - "curl -L https://raw.githubusercontent.com/arunoda/travis-ci-laika/master/configure.sh | /bin/sh"
services:
  - mongodb
env:
  - LAIKA_OPTIONS="-t 5000"
```
More info on [testing against laika](https://github.com/arunoda/travis-ci-laika).

## Meteor Packages

You can also build your Meteor Packages on Travis CI by extending the Node.js configuration.

The following `before_install` script installs the required dependencies:

```yaml
language: node_js
node_js:
  - "0.12"
before_install:
  - "curl -L https://raw.githubusercontent.com/arunoda/travis-ci-meteor-packages/master/configure.sh | /bin/sh"
before_script:
  - "export PATH=$HOME/.meteor:$PATH"
```

Find the source code at [travis-ci-meteor-packages](https://github.com/arunoda/travis-ci-meteor-packages).


## Build Matrix

For JavaScript/Node.js projects, `env` and `node_js` can be used as arrays
to construct a build matrix.

## Node.js v4 (or io.js v3) compiler requirements

To compile native modules for io.js v3 or Node.js v4, a
[C++11 standard](https://en.wikipedia.org/wiki/C%2B%2B11)-compliant compiler is required. More specifically, either gcc 4.8 (or later), or clang 3.5 (or later) works.

Our Trusty images have gcc and clang that meet this requirement, but the Precise image does not.

To update these compilers to a newer version, for example, `gcc/g++` to version 4.8, add the following in your `.travis.yml`:

```yaml
language: node_js
node_js:
  - "4"
env:
  - CXX=g++-4.8
addons:
  apt:
    sources:
      - ubuntu-toolchain-r-test
    packages:
      - g++-4.8
```

Due to recent decision by the LLVM team to remove APT support, it is currently not possible to update clang on Travis CI via `apt-get` or the `apt` addon.
See [https://github.com/travis-ci/travis-ci/issues/6120](https://github.com/travis-ci/travis-ci/issues/6120).
