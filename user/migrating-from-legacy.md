---
title: Migrating from legacy to container-based infrastructure
layout: en

---

<div id="toc">
</div>

## Outdated

This document is from a switch in our default infrastructure in 2015 and may contain outdated information.

## tl;dr

Not using sudo? Containers sound cool? Add `sudo: false` to `.travis.yml` and you're set.

For more details check out the awesome information below.

## Why migrate to container-based infrastructure?

### Builds start in seconds

Your builds start in less than 10 seconds. The new infrastructure makes it much easier for us to scale CPU capacity which means your builds start in seconds.

### More available resources

The new containers have 2 dedicated cores and 4GB maximum of shared memory, vs 1.5 cores and 3GB on our legacy infrastructure. CPU resources are now guaranteed, which means less impact from 'noisy neighbors' on the same host machine and more consistent build times throughout the day.

### Better network capacity, availability and throughput

Our container-based infrastructure is running on EC2, which means much faster network access to most services, especially those also hosted on EC2. Access to S3 is also much faster than on our legacy infrastructure.

### Caching available for open source projects

The best news for open source projects is that our build caching is now available for them too. That means faster build speeds by caching dependencies. Make sure to read the [docs on caching](/user/caching/) before trying it out.

For Ruby projects, it's as simple as adding `cache: bundler` to your .travis.yml.

## How can I use container-based infrastructure?

Container-based infrastructure is the default for new repositories, but if you
want to set it explicitly or have an older repository, add the following line to
your `.travis.yml`:

```yaml
sudo: false
```
{: data-file=".travis.yml"}

### What are the restrictions?

#### Using sudo isn't possible (right now)

Our new container infrastructure uses Docker under the hood. This has a lot of benefits like faster boot times and better utilization of resources. But it also comes with some restrictions. At this point, it's not possible to use any command requiring sudo in your builds.

If you require sudo, for instance to install Ubuntu packages, a workaround is to use precompiled binaries, uploading them to S3 and downloading them as part of your build,then installing them into a non-root directory.

#### Databases don't run off a memory disk

On our legacy infrastructure, both MySQL and PostgreSQL run off a memory disk to increase transaction and query speed. This can impact projects making heavy use of transactions or fixtures.

## How do I install APT sources and packages?

As you can't use sudo on the new container-based infrastructure, you need to use the `addons.apt.packages` and `addons.apt.sources` plugins to install packages and package sources.

### Adding APT Sources

To add APT sources before your custom build steps, use the `addons.apt.sources` key, e.g.:

```yaml
addons:
  apt:
    sources:
    - deadsnakes
    - ubuntu-toolchain-r-test
```
{: data-file=".travis.yml"}

The aliases for the allowed sources (such as `deadsnakes` above) are managed in a
[whitelist](https://github.com/travis-ci/apt-source-whitelist). If you need additional sources you must use `sudo: required`.

### Adding APT Packages

To install packages before your custom build steps, use the `addons.apt.packages` key, e.g.:

```yaml
addons:
  apt:
    packages:
    - cmake
    - time
```
{: data-file=".travis.yml"}

The allowed packages are managed in a [whitelist](https://github.com/travis-ci/apt-package-whitelist), and any attempts to install disallowed packages will result in a log message detailing the package approval process.

## How Do I Install Custom Software?

Some dependencies can only be installed from a source package. The build may require a more recent version or a tool or library that's not available as a Ubuntu package.

Install custom software by running a script to handle the installation process. Here is an example that installs CasperJS from a binary package:

```yaml
before_script:
  - wget https://github.com/n1k0/casperjs/archive/1.0.2.tar.gz -O /tmp/casper.tar.gz
  - tar -xvf /tmp/casper.tar.gz
  - export PATH=$PATH:$PWD/casperjs-1.0.2/bin/
```
{: data-file=".travis.yml"}

To install custom software from source, you can follow similar steps. Here's an example that downloads, compiles and installs the protobufs library.

```yaml
install:
  - wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
  - tar -xzvf protobuf-2.4.1.tar.gz
  - cd protobuf-2.4.1 && ./configure --prefix=$HOME/protobuf && make && make install
```
{: data-file=".travis.yml"}

These three commands can be extracted into a shell script, let's name it `install-protobuf.sh`:

```bash
#!/bin/sh
set -e
wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
tar -xzvf protobuf-2.4.1.tar.gz
cd protobuf-2.4.1 && ./configure --prefix=$HOME/protobuf && make && make install
```
{: data-file="install-protobuf.sh"}

Note that you can't update the `$PATH` environment variable in the first example inside a shell script, as it only updates the variable for the sub-process that is running the script.

Once you have added to the repository, you can run it from your `.travis.yml`:

```yaml
before_install:
  - bash install-protobuf.sh
```
{: data-file=".travis.yml"}

We can also add a `script` command to list the content of the protobuf folder to make sure it is installed:

```yaml
script:
  - ls -R $HOME/protobuf
```
{: data-file=".travis.yml"}

### How Do I Cache Dependencies and Directories?

In the previous example, to avoid having to download and compile the protobuf library each time we run a build, cache the directory.

Add the following to your `.travis.yml`:

```yaml
cache:
  directories:
  - $HOME/protobuf
```
{: data-file=".travis.yml"}

And then change the shell script to only compile and install if the cached directory is not empty:

```bash
#!/bin/sh
set -e
# check to see if protobuf folder is empty
if [ ! -d "$HOME/protobuf/lib" ]; then
  wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz;
  tar -xzvf protobuf-2.4.1.tar.gz;
  cd protobuf-2.4.1 && ./configure --prefix=$HOME/protobuf && make && make install;
else
  echo 'Using cached directory.';
fi
```
{: data-file="install-protobuf.sh"}

See [here](https://github.com/travis-ci/container-example) for a working example of compiling, installing, and caching protobuf.

More information about caching can be found in our [Caching Directories and Dependencies](http://docs.travis-ci.com/user/caching/) doc.

## Need Help?

Please feel free to contact us via our [support](mailto:support@travis-ci.com) email address, or create a [GitHub issue](https://github.com/travis-ci/travis-ci/issues).
