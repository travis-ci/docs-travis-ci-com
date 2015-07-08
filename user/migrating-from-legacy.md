---
title: Migrating from legacy to container-based infrastructure
layout: en
permalink: /user/migrating-from-legacy/
---

<div id="toc">
</div>

## What benefits does container-based infrastructure have?

### Builds start in seconds

Rather than wait for builds to start for a long time, your builds now start in less than 10 seconds. Assuming that capacity is available (which is now a lot easier for us to scale), you'll see your builds going from being scheduled to starting in only a few seconds.

### Faster builds

Mileage may vary based on how heavy your builds are on I/O, but most projects should see an improvement in build times. We'd love to hear from your if you don't or if you see slower build times.

### More available resources in a build container

The new containers have 2 dedicated cores available and 4 GB of memory, vs 1.5 cores and 3GB on our legacy infrastructure. CPU resources are now guaranteed. which means less impact by noisy neighbors on the same host machine. Build times throughout the day should be much more consistent on the new container stack.

### Better network capacity, availability and throughput

Our container-based stack is running on EC2, which means much faster network access to most services, especially those hosted on EC2 as well. Access to S3 is now also a ton faster than on our legacy stack.

### Caching available for open source projects

The best news for open source projects is that our build caching is now available for them too. That means faster build speeds by caching dependencies. Make sure to read the docs before trying it out.

For Ruby projects, it's as simple as adding `cache: bundler` to your .travis.yml.

## How can I use it?

If you see this on your log `This job is running on container-based infrastructure` it means you are already running on our container-based stack.

Otherwise, using our container-based stack only requires one additional line in your .travis.yml:

`sudo: false`

### What are the restrictions?

#### Using sudo isn't possible (right now)

Our new container stack uses Docker under the hood. This has a lot of benefits like fast boot times and better utilization of available machine resources. But it also comes with restrictions imposed by security.

At this point, it's not possible to use any command requiring sudo in your builds.

If you require sudo, for instance to install Ubuntu packages, a workaround is to use precompiled binaries, uploading them to S3 and downloading them as part of your build,then installing them into a non-root directory.

#### Databases don't run off a memory disk

On our legacy stack, both MySQL and PostgreSQL run off a memory disk to greatly increase transaction and query speed. This can impact projects depending on their use of transaction, fixtures and general database usage, but the impact generally shouldn't be negative.

## How do I install APT sources and packages?

When using the [container based infrastructure](/user/workers/container-based-infrastructure/), `sudo` is disabled in
user-defined build phases such as `before_install`. This prevents installation of APT packages via `apt-get` as well as
the addition of APT sources such as one might do with `apt-add-repository`.

### Adding APT Sources

To add APT sources before your custom build steps, use the `addons.apt.sources` key, e.g.:

``` yaml
addons:
  apt:
    sources:
    - deadsnakes
    - ubuntu-toolchain-r-test
```

The aliases for the allowed sources (such as `deadsnakes` above) are managed in a
[whitelist](https://github.com/travis-ci/apt-source-whitelist), and any attempts to add disallowed sources will result in a log message indicating how to submit sources for approval.

### Adding APT Packages

To install packages before your custom build steps, use the `addons.apt.packages` key, e.g.:

``` yaml
addons:
  apt:
    packages:
    - cmake
    - time
```

The allowed packages are managed in a [whitelist](https://github.com/travis-ci/apt-package-whitelist), and any attempts to install disallowed packages will result in a log message detailing the package approval process.

## How Do I Install Custom Software?

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
      - cd protobuf-2.4.1 && ./configure --prefix=$HOME/protobuf && make && make install

These three commands can be extracted into a shell script, let's name it `install-protobuf.sh`:

    #!/bin/sh
    set -e
    wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
    tar -xzvf protobuf-2.4.1.tar.gz
    cd protobuf-2.4.1 && ./configure --prefix=$HOME/protobuf && make && make install

Once it's added to the repository, you can run it from your `.travis.yml`:

    before_install:
      - ./install-protobuf.sh

We can also add a `script` command to list the contect of the protobuf folder to make sure it's been installed:

    script:
      - ls -R $HOME/protobuf

## How Do I Cache Dependencies and Directories?

In the example above, to avoid having to download and compile the protobuf library each time we run a build, we can cache its directory.

We add the following to our `.travis.yml`:

    cache:
      directories:
      - $HOME/protobuf

And then change our shell script to only compile and install if the cached directory is not empty:

    #!/bin/sh
    set -e
    # check to see if protobuf folder is empty
    if [ ! -d "$HOME/protobuf/lib" ]; then
      wget https://protobuf.googlecode.com/files/protobuf-2.4.1.tar.gz
      tar -xzvf protobuf-2.4.1.tar.gz
      cd protobuf-2.4.1 && ./configure --prefix=$HOME/protobuf && make && make install
    else
      echo 'Using cached directory.'
    fi

See [here](https://github.com/travis-ci/container-example) for a working example of compiling, installing, and caching protobuf.

More information about using caching can be found in our [Caching Directories and Dependencies](http://docs.travis-ci.com/user/caching/) doc.

## Need Help?

Please feel free to contact us via our [support](mailto: support@travis-ci.com) email address, or create a [GitHub issue](https://github.com/travis-ci/travis-ci/issues).
