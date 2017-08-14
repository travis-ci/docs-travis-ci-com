---
title: Building a Node.js project
layout: en

---

<div id="toc"></div>

This guide covers build environment and configuration topics specific to Node.js
projects. Please make sure to read our [Getting Started](/user/getting-started/)
and [general build configuration](/user/customizing-the-build/) guides first.

## Specifying Node.js versions

The easiest way to specify Node.js versions is to use one or more of the latest
releases in your `.travis.yml`:

- `node` latest stable Node.js release
- `iojs` latest stable io.js release
- `lts/*` latest LTS Node.js release
- `7` latest 7.x release
- `6` latest 6.x release
- `5` latest 5.x release
- `4` latest 4.x release

```yaml
language: node_js
node_js:
  - "iojs"
  - "7"
```

We also have many more [versions of
Node.js](/user/languages/javascript-with-nodejs/#Even-more-Nodejs-versions).

## Specifying Node.js versions using .nvmrc

Optionally, your repository can contain a `.nvmrc` file in the repository root
to specify which *single* version of Node.js to run your tests against.

The `.nvmrc` file is *only read* when `node_js` key in your `.travis.yml` files
does *not* specify a nodejs version. When the `.nvmrc` file is read,
`$TRAVIS_NODE_VERSION` is set to the nodejs version. See [nvm
documentation](https://github.com/creationix/nvm#usage) for more information on
`.nvmrc`.

## Default Test Script

The default test script for projects using nodejs is:

```bash
npm test
```

### Using other Test Suites

You can tell npm how to run your test suite by adding a line in `package.json`.
For example, to test using Vows:

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
  - npm install -g gulp-cli
script: gulp
```

## Dependency Management

### Travis CI uses npm

Travis CI uses [npm](http://npmjs.org/) to install your project dependencies:

```bash
npm install
```

> Note that there are no npm packages installed by default in the Travis CI environment, your dependencies are downloaded and installed during each build.

#### Using a specific npm version

Add the following to the [`before_install` phase](/user/customizing-the-build/#The-Build-Lifecycle) of `.travis.yml`:

```yaml
before_install:
  - npm i -g npm@version-number
```

#### Caching with `npm`

Travis CI is able to cache the `node_modules` folder:

```yaml
cache:
  directories:
    - "node_modules"
```

`npm install` will still run on every build and will update/install any new packages added to your `package.json` file.

### Travis CI supports yarn

Travis CI detects use of [yarn](https://yarnpkg.com/).

If both `package.json` and `yarn.lock` are present in the root
directory of the repository, we run the following command _instead of_
`npm install`:

```bash
yarn
```

Note that `yarn` requires Node.js version 4 or later.
If the job does not meet this requirement, `npm install` is used
instead.


#### Using a specific yarn version

Add the following to the [`before_install` phase](/user/customizing-the-build/#The-Build-Lifecycle) of `.travis.yml`:

```yaml
before_install:
  - curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version version-number
  - export PATH="$HOME/.yarn/bin:$PATH"
```

#### Caching with `yarn`

You can cache `$HOME/.cache/yarn` with:

```yaml
cache: yarn
```

If your caching needs to include other directives, you can use:

```yaml
cache:
  yarn: true
```

For more information, refer to [Caching](/user/caching) documentation.

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
  - "7"
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
  - "7"
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
  - "7"
before_install:
  - "curl -L https://raw.githubusercontent.com/arunoda/travis-ci-meteor-packages/master/configure.sh | /bin/sh"
before_script:
  - "export PATH=$HOME/.meteor:$PATH"
```

Find the source code at [travis-ci-meteor-packages](https://github.com/arunoda/travis-ci-meteor-packages).

## Build Matrix

For JavaScript/Node.js projects, `env` and `node_js` can be used as arrays
to construct a build matrix.

## Even more Nodejs versions

If you need more specific control of Node.js version in your build, use any of
the following available versions. Releases not shown in this list may be used if
`nvm` can install them.

- 7.7.x
- 6.1.x
- 6.0.x
- 5.11.x
- 5.10.x
- 5.9.x
- 5.8.x
- 5.7.x
- 5.6.x
- 5.5.x
- 5.4.x
- 5.3.x
- 5.2.x
- 5.1.x
- 5.0.x
- 4.4.x
- 4.3.x
- 4.2.x
- 4.1.x
- 4.0.x
- 0.12.x
- 0.11.x
- 0.10.x
- 0.8.x
- 0.6.x
{: .column-3}

Specifying only a major (e.g., "7") or major.minor version (e.g., "7.7") will run using the
latest published patch release for that version such as "7.7.1".
[nvm](https://github.com/creationix/nvm) handles version resolution, so any
version or [alias](https://github.com/creationix/nvm#usage) of Node.js or io.js
that nvm can install is available.

If your `.travis.yml` specifies a version of Node.js that `nvm` cannot install,
the job errors immediately. For example, see [hook.io-amqp-listener
.travis.yml](https://github.com/scottyapp/hook.io-amqp-listener/blob/master/.travis.yml).

For precise versions pre-installed on the VM, please consult "Build system
information" in the build log.

## Node.js v4 (or io.js v3) compiler requirements

To compile native modules for io.js v3 or Node.js v4 or later, a
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

