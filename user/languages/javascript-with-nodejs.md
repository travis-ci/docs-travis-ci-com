---
title: Building a Node.js project
layout: en
permalink: /user/languages/javascript-with-nodejs/
---

<div id="toc"></div>

This guide covers build environment and configuration topics specific to Node.js projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

Node.js builds are not available on the OSX environment.

## Choosing Node versions to test against

You can choose Node.js and io.js versions to run your tests by adding the following to .travis.yml:

    language: node_js
    node_js:
      - "5"
      - "5.1"
      - "4"
      - "4.2"
      - "4.1"
      - "4.0"
      - "0.12"
      - "0.11"
      - "0.10"
      - "0.8"
      - "0.6"
      - "iojs"

These values are passed on to [`nvm`](https://github.com/creationix/nvm);
newer releases not shown above may be used if `nvm` recognizes them.

This will make Travis CI run your tests against the latest version 0.6.x, 0.8.x, 0.10.x, 0.11.x, 0.12.x, 4.0.x, 4.1.x, 4.2.x, and 5.1.x branch releases, as well as the latest io.js stable release. Choosing "5" or "4" will use the latest version available in the 5.x or 4.x releases.

Specifying `node` or `stable` will run using the latest stable Node.js release and specifying `iojs` will run using the latest stable io.js release.

Specifying only a major and minor version (e.g., "0.12") will run using the latest published patch release for that version. If a specific version is not needed, we encourage users to specify `node` and/or `iojs` to run using the latest stable releases. [nvm](https://github.com/creationix/nvm) handles version resolution, so any version or [alias](https://github.com/creationix/nvm#usage) of Node or io.js that nvm can install is available.

If the version of Node.js cannot be used (because `nvm` cannot install it, and a suitable version is not locally installed),
the job will error immediately.

For example, see [hook.io-amqp-listener .travis.yml](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml).

### Using `.nvmrc`

Optionally, your repository can contain `.nvmrc` file in the repository root to specify which
version of Node.js to run your tests.
This file will be consulted _only when_ the `node_js` key does not specify the version as above,
and the environment variable `$TRAVIS_NODE_VERSION` will be set to the content of this file.

See [nvm documentation](https://github.com/creationix/nvm#usage) for more information on `.nvmrc`.

## Provided Node.js Versions

* 5.1.x
* 4.2.x
* 4.1.x
* 4.0.x
* 0.12.x
* 0.11.x
* 0.10.x
* 0.8.x
* 0.6.x
* iojs (recent stable release of io.js)

For precise versions pre-installed on the VM, please consult "Build system information" in the build log.


## Default Test Script

For projects using npm, Travis CI will execute

    npm test

to run your test suite.

### Using Vows

You can tell npm how to run your test suite by adding a line in `package.json`. For example, to test using Vows:

    "scripts": {
      "test": "vows --spec"
    },


### Using Expresso

To test using Expresso, add the following lines to `package.json`:

    "scripts": {
      "test": "expresso test/*"
    },


## Using Gulp

If you already use Gulp to manage your tests, install it and run the default
`gulpfile.js` by adding the following lines to your `.travis.yml`:

```
before_script:
  - npm install -g gulp
script: gulp
```

## Dependency Management

### Travis CI uses npm

Travis CI uses [npm](http://npmjs.org/) to install your project's dependencies. It is possible to override this behavior and there are project that use different tooling but the majority of Node.js projects hosted on Travis CI use npm, which is also bundled with Node starting with 0.6.0 release.

By default, Travis CI will run

    npm install

to install your dependencies. Note that dependency installation in Travis CI environment always happens from scratch (there are no npm packages installed at the beginning of your build).

### Using shrinkwrapped git dependencies

Note that `npm install` can fail if a shrinkwrapped git dependency pointing to a branch has its HEAD
changed. The shrinkwrap process is unable to catch this reference update.

## Meteor Apps

You can build your **Meteor Apps** on Travis CI and test against
[`laika`](http://arunoda.github.io/laika/). To do this, use a .travis.yml file
like this:

    language: node_js
    node_js:
      - "0.12"
    before_install:
      - "curl -L https://raw.githubusercontent.com/arunoda/travis-ci-laika/master/configure.sh | /bin/sh"
    services:
      - mongodb
    env:
      - LAIKA_OPTIONS="-t 5000"

related source code can be found [here](https://github.com/arunoda/travis-ci-laika)

## Meteor Packages

It is also possible to build your **Meteor Packages** on Travis CI by extending the NodeJs configuration.

For example, you can use the following `.travis.yml` file .

    language: node_js
    node_js:
      - "0.12"
    before_install:
      - "curl -L https://raw.githubusercontent.com/arunoda/travis-ci-meteor-packages/master/configure.sh | /bin/sh"
    before_script:
      - "export PATH=$HOME/.meteor:$PATH"

The `before_install` script will make sure the required dependencies are installed.

The related source code can be found at the [travis-ci-meteor-packages](https://github.com/arunoda/travis-ci-meteor-packages) repository.


## Build Matrix

For JavaScript/Node.js projects, `env` and `node_js` can be given as arrays
to construct a build matrix.

## Node.js v4 (or io.js v3) compiler requirements

To compile native modules for io.js v3 or Node.js v4, a
[C++11 standard](https://en.wikipedia.org/wiki/C%2B%2B11)-compliant compiler is required.
More specifically, either gcc 4.8 (or later), or clang 3.5 (or later) works.

Our Trusty images have gcc and clang that meet this requirement, but the Precise image does not.

To update these compilers to a newer version.
For example, `gcc/g++` to version 4.8, add the following in your `.travis.yml`:

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

For clang 3.6:

    language: node_js
    node_js:
      - "4"
    compiler: clang-3.6
    env:
      - CXX=clang-3.6
    addons:
      apt:
        sources:
          - llvm-toolchain-precise-3.6
          - ubuntu-toolchain-r-test
        packages:
          - clang-3.6
          - g++-4.8
