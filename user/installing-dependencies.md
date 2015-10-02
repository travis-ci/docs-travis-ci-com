---
title: Installing Dependencies
layout: en
permalink: /user/installing-dependencies/
---
Some builds need more than a set of language libraries, they need extra services or libraries not installed by default. To learn about the default setup of our build environment, please refer to <a href="/user/ci-environment">The Build Environment</a>.

You have full control over the virtual machine your tests are running on, so you can customize it to your needs.

<div id="toc"></div>

## Installing Ubuntu packages

Our Linux environment is currently based on Ubuntu 12.04 LTS. You can install all packages that are available from its package repository, including security and backports.

<div class="note-box">
Note that this feature is not available for builds that are running on the <a href="/user/workers/container-based-infrastructure">container-based workers</a>, although the
<a href="/user/apt/">APT</a> addon may be used.
</div>

To install Ubuntu packages, add something like the example below to your .travis.yml:

    before_install:
      - sudo apt-get update -qq
      - sudo apt-get install -y libxml2-dev

There are two things to note. Before installing a package, make sure to run 'apt-get update'. While we regularly update our build environment to include the latest security patches and updates, new package updates are released regularly, causing our packages indexes to be out of date. Updating the index before installing a Ubuntu package is recommended to avoid breaking your build should the package receive an update.

Second thing to note is the use of the `-y` parameter when running apt-get install. As your build runs without any means for human interaction or intervention, you should make sure that it won't stall with apt-get asking for input. Specifying this flag ensures that it'll do what it'd normally ask your permission for.

### A word on apt-get upgrade

We recommend you avoid running apt-get upgrade, as it will upgrade every single package for which apt-get can find a newer version. As we install quite a few packages by default, this could end up downloading and installing up to 500MB of packages.

This extends your build time quite significantly, so we generally recommend you avoid using it in your builds.

If you need to upgrade a very specific package, you can run a normal 'apt-get install', which will install the latest version available.

## Installing Packages from a custom APT repository

For some packages, you may find an existing repository, which isn't yet set up on our build environment by default. You can easily add custom repositories and Launchpad PPAs as part of your build.

For example, to install gcc from the ubuntu-toolchain ppa

```
before_install:
  - sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
  - sudo apt-get update -q
  - sudo apt-get install gcc-4.8 -y
```

For repositories not hosted on Launchpad, you need to add a GnuPG key as well.

This example adds the APT repository for Varnish 3.0 for Ubuntu 12.04 to the locally available list of APT sources and then installs the `varnish` package.

    before_script:
      - curl http://repo.varnish-cache.org/debian/GPG-key.txt | sudo apt-key add -
      - echo "deb http://repo.varnish-cache.org/ubuntu/ precise varnish-3.0" | sudo tee -a /etc/apt/sources.list
      - sudo apt-get update -qq
      - sudo apt-get install varnish

## Installing Packages without an APT Repository

For some projects, there may be a Debian/Ubuntu package available, but no corresponding APT repository. These are still easy to install, but require the extra step of downloading.

Say your project requires the pngquant tool to compress PNG files, here's how to download and install the .deb file:

    before_install:
      - wget http://pngquant.org/pngquant_1.7.1-1_i386.deb
      - sudo dpkg -i pngquant_1.7.1-1_i386.deb

If you're installing packages this way, make sure they're available for Ubuntu 12.04, our current Linux platform.

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

## Installing Mac Packages

On our Mac platform, you have all the developer tools available to install packages from scratch, if you need to.

First and foremost, you should look at what's available on [Homebrew](http://brew.sh), as it's already preinstalled and ready to use.

Using Homebrew over installing from scratch has several benefits. For a lot of packages, it has binary packages available, removing the need to compile packages when installing them. However, should one of them need to be compiled from source, Homebrew can also manage dependencies and the installation process for you. Using it helps keep your .travis.yml to a minimum.

Say you need to install beanstalk for your tests, you can use the following set of commands in your .travis.yml:

    before_install:
      - brew update
      - brew install beanstalk

Note the addition command `brew update`, which, similar to `apt-get update`, ensures that the local Homebrew installation has the most recent packages in its index.
