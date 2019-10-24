---
title: Building a JavaScript and Node.js project
layout: en

---

## What This Guide Covers

<aside markdown="block" class="ataglance">

| JavaScript and Node.js                      | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#dependency-management) | `npm install` or `npm ci`                 |
| [Default `script`](#default-build-script)   | `npm test`                                |
| [Matrix keys](#build-matrix)                | `env`, `node_js`                          |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

(If `package-lock.json` or `npm-shrinkwrap.json` exists and your npm version supports it, Travis CI will use `npm ci` instead of `npm install`.)

Minimal example:

```yaml
language: node_js
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.all_note }}

This guide covers build environment and configuration topics specific to JavaScript and Node.js
projects. Please make sure to read our [Tutorial](/user/tutorial/)
and [general build configuration](/user/customizing-the-build/) guides first.

## Specifying Node.js versions

The easiest way to specify Node.js versions is to use one or more of the latest
releases in your `.travis.yml`:

- `node` latest stable Node.js release
- `lts/*` latest LTS Node.js release
{% for vers in site.data.node_js_versions %}
- `{{vers}}` latest {{vers}}.x release
{% endfor %}

```yaml
language: node_js
node_js:
  - 7
```
{: data-file=".travis.yml"}

More specific information on what versions of Node.js are available is in
the Environment Reference pages:

* [Precise](/user/reference/precise/#javascript-and-nodejs-images)
* [Trusty](/user/reference/trusty/#javascript-and-nodejs-images)

If you need more specific control of Node.js versions in your build, use any
version installable by `nvm`. If your `.travis.yml` contains a version of
Node.js that `nvm` cannot install, such as `0.4`, the job errors immediately.

For a precise list of versions pre-installed on the VM, please consult "Build
system information" in the build log.

## Specifying Node.js versions using .nvmrc

Optionally, your repository can contain a `.nvmrc` file in the repository root
to specify which *single* version of Node.js to run your tests against.

The `.nvmrc` file is *only read* when `node_js` key in your `.travis.yml` files
does *not* specify a nodejs version. When the `.nvmrc` file is read,
`$TRAVIS_NODE_VERSION` is set to the nodejs version. See [nvm
documentation](https://github.com/creationix/nvm#usage) for more information on
`.nvmrc`.

## Default Build Script

The default build script for projects using nodejs is:

```bash
npm test
```

### Yarn is supported

If `yarn.lock` exists, the default test command will be `yarn test` instead of `npm test`.

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
{: data-file=".travis.yml"}

## Dependency Management

Travis CI uses [npm](https://npmjs.org/) or [yarn](https://yarnpkg.com) to install your project dependencies.

> Note that there are no npm packages installed by default in the Travis CI environment.

### Using `npm`

#### Using a specific `npm` version

Add the following to the [`before_install` phase](/user/job-lifecycle/) of `.travis.yml`:

```yaml
before_install:
  - npm i -g npm@version-number
```
{: data-file=".travis.yml"}

### `npm ci` support

If `package-lock.json` or `npm-shrinkwrap.json` exists and your npm version
supports it, Travis CI will use `npm ci` instead of `npm install`.

This command will delete your `node_modules` folder and install all dependencies
as specified in your lock file.

#### Caching with `npm`

`npm` is now cached by default, in case you want to disable it, please add the following to your `.travis.yml`:

```yaml
cache:
  npm: false
```

To explicitly cache your dependencies:

```yaml
cache: npm
```
{: data-file=".travis.yml"}

1. This caches `$HOME/.npm` precisely when `npm ci` is the default `script` command.
(See above.)

1. In all other cases, this will cache `node_modules`.
Note that `npm install` will still run on every build and will update/install
any new packages added to your `package.json` file.

Even when `script` is overridden, this shortcut is effective.

### Using `yarn`

Travis CI detects use of [yarn](https://yarnpkg.com/).

If both `package.json` and `yarn.lock` are present in the current
directory, we run the following command _instead of_
`npm install`:

```bash
yarn
```

Note that `yarn` requires Node.js version 4 or later.
If the job does not meet this requirement, `npm install` is used
instead.


#### Using a specific `yarn` version

Add the following to the [`before_install` phase](/user/job-lifecycle/) of `.travis.yml`:

```yaml
before_install:
  - curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version version-number
  - export PATH="$HOME/.yarn/bin:$PATH"
```
{: data-file=".travis.yml"}

#### Caching with `yarn`

```yaml
cache: yarn
```
{: data-file=".travis.yml"}

will add `yarn`'s default caching directory (which varies depending on the OS),
as indicated by [`yarn cache dir`](https://yarnpkg.com/en/docs/cli/cache#toc-yarn-cache-dir).

If your caching needs to include other directives, you can use:

```yaml
cache:
  yarn: true
```
{: data-file=".travis.yml"}

For more information, refer to [Caching](/user/caching) documentation.

### Using shrinkwrapped git dependencies

Note that `npm install` can fail if a shrinkwrapped git dependency pointing to a
branch has its HEAD changed.

## Ember Apps

You can build your Ember applications on Travis CI. The default test framework
is [`Qunit`](http://qunitjs.com/). The following example shows how to build and
test against different Ember versions.

```yaml
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
jobs:
  fast_finish: true
  allow_failures:
    - env: EMBER_VERSION=release
    - env: EMBER_VERSION=beta
    - env: EMBER_VERSION=canary

before_install:
    # setting the path for phantom.js 2.0.0
    - export PATH=/usr/local/phantomjs-2.0.0/bin:$PATH
    # starting a GUI to run tests, per https://docs.travis-ci.com/user/gui-and-headless-browsers/#using-xvfb-to-run-tests-that-require-a-gui
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
{: data-file=".travis.yml"}

## Meteor Apps

You can build your Meteor Apps on Travis CI and test against
[`laika`](http://arunoda.github.io/laika/):

```yaml
language: node_js
node_js:
  - "7"
before_install:
  - "curl -L https://raw.githubusercontent.com/arunoda/travis-ci-laika/6a3a7afc21be99f1afedbd2856d060a02755de6d/configure.sh | /bin/sh"
services:
  - mongodb
env:
  - LAIKA_OPTIONS="-t 5000"
```
{: data-file=".travis.yml"}

More info on [testing against laika](https://github.com/arunoda/travis-ci-laika).

## Meteor Packages

You can also build your Meteor Packages on Travis CI by extending the Node.js configuration.

The following `before_install` script installs the required dependencies:

```yaml
language: node_js
node_js:
  - "7"
before_install:
  - "curl -L https://raw.githubusercontent.com/arunoda/travis-ci-meteor-packages/dca8e51fafd60d9e5a8285b07ca34a63f22a5ed4/configure.sh | /bin/sh"
before_script:
  - "export PATH=$HOME/.meteor:$PATH"
```
{: data-file=".travis.yml"}

Find the source code at [travis-ci-meteor-packages](https://github.com/arunoda/travis-ci-meteor-packages).

## Node.js v4 (or io.js v3) compiler requirements

To compile native modules for io.js v3 or Node.js v4 or later, a [C++11
standard](https://en.wikipedia.org/wiki/C%2B%2B11)-compliant compiler is
required. More specifically, either gcc 4.8 (or later), or clang 3.5 (or later)
works.

Our Trusty images have gcc and clang that meet this requirement, but the Precise
image does not.

To update these compilers to a newer version, for example, `gcc/g++` to version
4.8, add the following in your `.travis.yml`:

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
{: data-file=".travis.yml"}
