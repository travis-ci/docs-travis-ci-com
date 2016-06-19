---
title: Installing Dependencies
layout: en
permalink: /user/installing-dependencies/
redirect_from:
  - /user/apt/
---

<div id="toc"></div>

## Installing Packages on Standard or Trusty Infrastructure

To install Ubuntu packages that are not included in the default [standard](/user/ci-environment/) or [trusty](/user/trusty-ci-environment/) use apt-get in the `before_install` step of your `.travis.yml`:

    before_install:
      - sudo apt-get -qq update
      - sudo apt-get install -y libxml2-dev

> Make sure to run `apt-get update` to update the list of available packages (`-qq` for less output). Do not run `apt-get upgrade` as it downloads up to 500MB of packages and significantly extends your build time.

> Use the `-y` parameter with apt-get to assume yes as the answer to each apt-get prompt.

### Installing Packages from a custom APT repository

For some packages, you may find an existing repository, which isn't yet set up on our build environment by default. You can easily add custom repositories and Launchpad PPAs as part of your build.

For example, to install gcc from the ubuntu-toolchain ppa

```
before_install:
  - sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
  - sudo apt-get update -q
  - sudo apt-get install gcc-4.8 -y
```

For repositories not hosted on Launchpad, you need to add a GnuPG key as well.

If you're installing packages this way, make sure you download the correct version for your environment, either 12.04 LTS for the standard environment or 14.04 LTS for the Trusty environment.

This example adds the APT repository for Varnish 3.0 for Ubuntu 12.04 to the locally available list of APT sources and then installs the `varnish` package.

    before_script:
      - curl http://repo.varnish-cache.org/debian/GPG-key.txt | sudo apt-key add -
      - echo "deb http://repo.varnish-cache.org/ubuntu/ precise varnish-3.0" | sudo tee -a /etc/apt/sources.list
      - sudo apt-get update -qq
      - sudo apt-get install varnish

### Installing Packages without an APT Repository

For some projects, there may be a Debian/Ubuntu package available, but no corresponding APT repository. These are still easy to install, but require the extra step of downloading.

If you're installing packages this way, make sure you download the correct version for your environment, either 12.04 LTS for the standard environment or 14.04 LTS for the Trusty environment.

Say your project requires the pngquant tool to compress PNG files, here's how to download and install the .deb file:

    before_install:
      - wget http://pngquant.org/pngquant_1.7.1-1_i386.deb
      - sudo dpkg -i pngquant_1.7.1-1_i386.deb

### Installing Packages with the APT Addon

You can also use the APT addon.

#### Adding APT Sources

To add APT sources from the [source whitelist](https://github.com/travis-ci/apt-source-whitelist) before your custom build steps, use the `addons.apt.sources` key:

``` yaml
addons:
  apt:
    sources:
    - deadsnakes
    - ubuntu-toolchain-r-test
```

#### Adding APT Packages

To install packages from the [package whitelist](https://github.com/travis-ci/apt-package-whitelist)  before your custom build steps, use the `addons.apt.packages` key:

``` yaml
addons:
  apt:
    packages:
    - cmake
    - time
```

> Note: When using APT sources and packages together, you need to make
> sure they are under the same key space in the YAML file. e.g.

``` yaml
addons:
 apt:
   sources:
   - ubuntu-toolchain-r-test
   packages:
   - gcc-4.8
   - g++-4.8
```

> Note: If `apt-get install` fails, the build is marked an error.

## Installing Packages on Container Based Infrastructure

To install packages not included in the default [container-based-infrastructure](/user/workers/container-based-infrastructure) you need to use the APT addon, as sudo apt-get is not available.

### Adding APT Sources

To add APT sources from the [source whitelist](https://github.com/travis-ci/apt-source-whitelist) before your custom build steps, use the `addons.apt.sources` key:

``` yaml
addons:
  apt:
    sources:
    - deadsnakes
    - ubuntu-toolchain-r-test
```

### Adding APT Packages

To install packages from the [package whitelist](https://github.com/travis-ci/apt-package-whitelist)  before your custom build steps, use the `addons.apt.packages` key:

``` yaml
addons:
  apt:
    packages:
    - cmake
    - time
```

> Note: When using APT sources and packages together, you need to make
> sure they are under the same key space in the YAML file. e.g.

``` yaml
addons:
 apt:
   sources:
   - ubuntu-toolchain-r-test
   packages:
   - gcc-4.8
   - g++-4.8
```

> Note: If `apt-get install` fails, the build is marked an error.

## Installing Packages on OSX

To install packages that are not included in the [default OSX environment](/user/osx-ci-environment/#Compilers-and-Build-toolchain) use [Homebrew](http://brew.sh) in your `.travis.yml`. For example, to install beanstalk:

    before_install:
      - brew update
      - brew install beanstalk

Use `brew update` to update the local Homebrew package list.

## Installing Projects from Source

Some dependencies can only be installed from a source package. The build may require a more recent version or a tool or library that's not available as a Ubuntu package.

You can easily include the build steps in either your .travis.yml or, and this is the recommended way, by running a script to handle the installation process.

Here's a simple example that installs CasperJS from a binary package:

    before_script:
      - wget https://github.com/n1k0/casperjs/archive/1.0.2.tar.gz -O /tmp/casper.tar.gz
      - tar -xvf /tmp/casper.tar.gz
      - export PATH=$PATH:$PWD/casperjs-1.0.2/bin/

Note that when you're updating the `$PATH` environment variable, that part can't be moved into a shell script, as it will only update the variable for the sub-process that's running the script.

To install something from source, you can follow similar steps. Here's an example to download, compile and install the protobufs library.

    install:
      - wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
      - tar -xzvf protobuf-2.4.1.tar.gz
      - cd protobuf-2.4.1 && ./configure --prefix=/usr && make && sudo make install

These three commands can be extracted into a shell script, let's name it `install-protobuf.sh`:

    #!/bin/sh
    set -ex
    wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
    tar -xzvf protobuf-2.4.1.tar.gz
    cd protobuf-2.4.1 && ./configure --prefix=/usr && make && sudo make install

Once it's added to the repository, you can run it from your .travis.yml:

    before_install:
      - ./install-protobuf.sh
