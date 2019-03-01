---
title: Installing Dependencies
layout: en

redirect_from:
  - /user/apt/
---



## Installing Packages on Standard Infrastructure

To install Ubuntu packages that are not included in the standard [precise](/user/reference/precise/), [trusty](/user/reference/trusty/), or [xenial](/user/reference/xenial/) distribution, use apt-get in the `before_install` step of your `.travis.yml`:

```yaml
before_install:
  - sudo apt-get install -y libxml2-dev
```
{: data-file=".travis.yml"}

By default, `apt-get update` does not get run automatically. If you want to update `apt-get` automatically on every build, there are two ways to do this. The first is by running `apt-get update` explicitly in the `before_install` step:

```yaml
before_install:
  - sudo apt-get update
  - sudo apt-get install -y libxml2-dev
```
{: data-file=".travis.yml"}

The second way is to use the [APT addon](#installing-packages-with-the-apt-addon):

```yaml
before_install:
  - sudo apt-get install -y libxml2-dev
addons:
  apt:
    update: true
```
{: data-file=".travis.yml"}

> Do not run `apt-get upgrade` in your build as it downloads up to 500MB of packages and significantly extends your build time.
>
> Use the `-y` parameter with apt-get to assume yes as the answer to each apt-get prompt.

### Installing Packages from a custom APT repository

For some packages, you may find an existing repository, which isn't yet set up on our build environment by default. You can easily add custom repositories and Launchpad PPAs as part of your build.

For example, to install gcc from the ubuntu-toolchain ppa

```yaml
before_install:
  - sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
  - sudo apt-get update -q
  - sudo apt-get install gcc-4.8 -y
```
{: data-file=".travis.yml"}

For repositories not hosted on Launchpad, you need to add a GnuPG key as well.

If you're installing packages this way, make sure you download the correct version for your environment.

This example adds the APT repository for Varnish 3.0 for Ubuntu 12.04 to the locally available list of APT sources and then installs the `varnish` package.

```yaml
before_script:
  - curl http://repo.varnish-cache.org/debian/GPG-key.txt | sudo apt-key add -
  - echo "deb http://repo.varnish-cache.org/ubuntu/ precise varnish-3.0" | sudo tee -a /etc/apt/sources.list
  - sudo apt-get update -qq
  - sudo apt-get install varnish -y
```
{: data-file=".travis.yml"}

### Installing Packages without an APT Repository

For some projects, there may be a Debian/Ubuntu package available, but no corresponding APT repository. These are still easy to install, but require the extra step of downloading.

If you're installing packages this way, make sure you download the correct version for your environment.

Say your project requires the pngquant tool to compress PNG files, here's how to download and install the .deb file:

```yaml
before_install:
  - wget http://pngquant.org/pngquant_1.7.1-1_i386.deb
  - sudo dpkg -i pngquant_1.7.1-1_i386.deb
```
{: data-file=".travis.yml"}

### Installing Packages with the APT Addon

You can also install packages and sources using the APT addon, without running `apt-get` commands in your `before_install` script.

If your requirements goes beyond the normal installation, please use another method described above.

#### Adding APT Sources

To add APT sources, you can use one of the following three types of entries:

1. aliases defined in [source safelist](https://github.com/travis-ci/apt-source-safelist)
2. `sourceline` key-value pairs which will be added to `/etc/apt/sources.list`
3. when APT sources require GPG keys, you can specify this with `key_url` pairs in addition to `sourceline`.

The following snippet shows these three types of APT sources

```yaml
addons:
  apt:
    sources:
    - deadsnakes
    - sourceline: 'ppa:ubuntu-toolchain-r/test'
    - sourceline: 'deb https://packagecloud.io/chef/stable/ubuntu/precise main'
      key_url: 'https://packagecloud.io/gpg.key'
```
{: data-file=".travis.yml"}

#### Adding APT Packages

List APT packages under the `addons.apt.packages` key:

```yaml
addons:
  apt:
    packages:
    - cmake
    - time
```
{: data-file=".travis.yml"}

> Note: When using APT sources and packages together, you need to make
> sure they are under the same key space in the YAML file. e.g.

```yaml
addons:
  apt:
    sources:
    - ubuntu-toolchain-r-test
    packages:
    - gcc-4.8
    - g++-4.8
```
{: data-file=".travis.yml"}

> Note: If `apt-get install` fails, the build is marked an error.

### Installing Snap Packages with the Snaps Addon

You can install [snap](http://snapcraft.io/) packages using our Xenial images:

```yaml
dist: xenial
```
{: data-file=".travis.yml"}

The Ubuntu Snap store offers many packages directly maintained by upstream developers, often with newer versions than the ones available in the Apt archive. For example, you can install and run the latest version of [hugo](http://gohugo.io/):

```yaml
dist: xenial

addons:
  snaps:
  - hugo

script:
- hugo new site test-site
```
{: data-file=".travis.yml"}

If you need to install a package from a different channel, or a package that uses [classic confinement](https://blog.ubuntu.com/2017/01/09/how-to-snap-introducing-classic-confinement), you can do so with the following config:

```yaml
dist: xenial

addons:
  snaps:
  - name: aws-cli
    classic: true
    channel: latest/edge

script:
- aws help
```
{: data-file=".travis.yml"}

## Installing Packages on macOS

To install packages that are not included in the [default macOS environment](/user/reference/osx/#compilers-and-build-toolchain) use [Homebrew](http://brew.sh).

For convenience, you can use Homebrew addon in your `.travis.yml`.
For example, to install beanstalk:

```yaml
addons:
  homebrew:
    packages:
    - beanstalk
```
{: data-file=".travis.yml"}

By default, the Homebrew addon will not run `brew update` before installing packages. `brew update` can take a long time and slow down your builds. If you need more up-to-date versions of packages than the snapshot on the build VM has, you can add `update: true` to the addon configuration:

```yaml
addons:
  homebrew:
    packages:
    - beanstalk
    update: true
```
{: data-file=".travis.yml"}

### Installing Casks

The Homebrew addon also supports installing [casks][homebrew-cask]. You can add them to the `casks` key in the Homebrew addon configuration to install them:

[homebrew-cask]: https://github.com/Homebrew/homebrew-cask

```yaml
addons:
  homebrew:
    casks:
    - dotnet-sdk
```
{: data-file=".travis.yml"}

### Installing From Taps

Homebrew supports installing casks and packages from third-party repositories called [taps][homebrew-tap], and you can use these with the Homebrew addon.

For instance, Homebrew maintains a tap of older versions of certain casks at [`homebrew/cask-versions`][cask-versions]. If you wanted to install Java 8 on an image with Java 10 installed, you can add that tap and then install the `java8` cask:

[homebrew-tap]: https://docs.brew.sh/Taps
[cask-versions]: https://github.com/Homebrew/homebrew-cask-versions

```yaml
osx_image: xcode10
addons:
  homebrew:
    taps: homebrew/cask-versions
    casks: java8
```
{: data-file=".travis.yml"}

### Using a Brewfile

Under the hood, the Homebrew addon works by creating a `~/.Brewfile` and running `brew bundle --global`. You can also use the addon to install dependencies from your own [Brewfile][] that is checked in to your project. By passing `brewfile: true`, the addon will look for a `Brewfile` in the root directory of your project:

[brewfile]: https://github.com/Homebrew/homebrew-bundle

```yaml
addons:
  homebrew:
    brewfile: true
```
{: data-file=".travis.yml"}

You can also provide a path if your Brewfile is in a different location.

```yaml
addons:
  homebrew:
    brewfile: Brewfile.travis
```
{: data-file=".travis.yml"}

### Using Homebrew without addon on older macOS images

If you're running the `brew` command directly in your build scripts, and you're using an older macOS image, you may see a warning such as this:

    Homebrew must be run under Ruby 2.3! You're running 2.0.0.

You'll need to update to Ruby 2.3 or newer:

```
rvm use 2.3 --install --binary
brew update
brew install openssl
rvm use $TRAVIS_RUBY_VERSION # optionally, switch back to the Ruby version you need.
```

## Installing Dependencies on Multiple Operating Systems

If you're testing on both Linux and macOS, you can use both the APT addon and the Homebrew addon together. Each addon will only run on the appropriate platform:

```yaml
addons:
  apt:
    packages: foo
  homebrew:
    packages: bar
```
{: data-file=".travis.yml"}

If you're installing packages manually, use the `$TRAVIS_OS_NAME` variable to install dependencies separately for each OS:

```yaml
install:
  - if [ $TRAVIS_OS_NAME = linux ]; then sudo apt-get install foo; else brew install bar; fi
```
{: data-file=".travis.yml"}

## Installing Projects from Source

Some dependencies can only be installed from a source package. The build may require a more recent version or a tool or library that's not available as a Ubuntu package.

You can easily include the build steps in either your .travis.yml or, and this is the recommended way, by running a script to handle the installation process.

Here's a simple example that installs CasperJS from a binary package:

```yaml
before_script:
  - wget https://github.com/n1k0/casperjs/archive/1.0.2.tar.gz -O /tmp/casper.tar.gz
  - tar -xvf /tmp/casper.tar.gz
  - export PATH=$PATH:$PWD/casperjs-1.0.2/bin/
```
{: data-file=".travis.yml"}

Note that when you're updating the `$PATH` environment variable, that part can't be moved into a shell script, as it will only update the variable for the sub-process that's running the script.

To install something from source, you can follow similar steps. Here's an example to download, compile and install the protobufs library.

```yaml
install:
  - wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
  - tar -xzvf protobuf-2.4.1.tar.gz
  - pushd protobuf-2.4.1 && ./configure --prefix=/usr && make && sudo make install && popd
```
{: data-file=".travis.yml"}

These three commands can be extracted into a shell script, let's name it `install-protobuf.sh`:

```bash
#!/bin/sh
set -ex
wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
tar -xzvf protobuf-2.4.1.tar.gz
cd protobuf-2.4.1 && ./configure --prefix=/usr && make && sudo make install
```

Once it's added to the repository, you can run it from your .travis.yml:

```yaml
before_install:
  - ./install-protobuf.sh
```
{: data-file=".travis.yml"}

Note that the first version uses `pushd` and `popd` to ensure that after the `install` section completes, the working directory is returned to its original value.  This is not necessary in the shell script, as it runs in a sub-shell and so does not alter the original working directory.
