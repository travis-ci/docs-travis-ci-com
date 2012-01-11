---
title: About Travis CI Environment
kind: content
---

## What This Guide Covers

This guide explain what packages, tools and settings are available in the Travis CI environment (often referred to as "CI environment") as well as
how virtual machines that travis-ci.org workers use are upgraded and deployed. The latter explains how soon you should expect new versions of
Ruby, PHP, Node.js and so on to be provided.


## Overview

Travis CI runs builds in virtual machines that are snapshotted before each build and rolled back at the end of it.
This offers a number of benefits:

 * Host OS is not affected by test suites
 * No state persists between runs
 * Passwordless sudo is available (so you can install dependencies using apt and so on)
 * It is possible for test suites to create databases, add RabbitMQ vhosts/users and so on

The environment available to test suites is known as the *Travis CI environment*. VMs are deployed from VM images ("boxes") that are available to the public.
Provisioning of VM images is highly automated, new versions are deployed on average about once a week.


## CI environment OS

travis-ci.org uses 32-bit Ubuntu Linux 11.04 (server edition).



## How travis-ci.org VMs are provisioned

Provisioning of VMs is automated using [OpsCode Chef](http://www.opscode.com/chef/). VMs are never upgraded "on the go", we always replace entire images.
VM images are first uploaded to our internal network and deployed to each individual worker during slow periods of the day. On average, we try to
deploy new versions of runtimes (e.g. Ruby or PHP) and software like data stores within a week from their public availability, given that Travis Core Team
is aware of or notified about the release.



## Environment common to all VM images

### Built toolchain

GCC 4.5.x, make, autotools, et cetera.

### Networking tools

curl, wget, OpenSSL headers, rsync


### Runtimes

Every worker has at least one version of

 * Ruby
 * OpenJDK
 * Python
 * Node.js

to accomodate projects that may need one of those runtimes during the build.

Language-specific workers have multiple runtimes for their respective language (for example, Ruby workers have about 10 Ruby versions/implementations).

### Data Stores

* MySQL 5.1.x
* PostgreSQL 8.4.x
* SQLite 3.7.x
* MongoDB 2.0.x
* Riak 1.0.x
* Redis 2.4.x
* CouchDB 1.0.x

### Messaging Technology

* RabbitMQ 2.7.x
* ZeroMQ 2.1.x

### Environment variables

* DEBIAN_FRONTEND=noninteractive
* CI=true
* TRAVIS=true
* HAS_JOSH_K_SEAL_OF_APPROVAL=true
* USER=vagrant
* HOME=/home/vagrant
* LANG=en_US.UTF-8
* LC_ALL=en_US.UTF-8


### Libraries

* OpenSSL
* ImageMagick


### apt configuration

apt is configured to not require confirmation (assume -y switch by default) using both `DEBIAN_FRONTEND` env variable and apt configuration
file). This means `apt-get install` can be used without the -y flag.


## Clojure worker VM images

Clojure projects are currently built on Ruby workers, see Ruby worker VM images section below.

### Leiningen version

travis-ci.org uses standalone ("uberjar") Leiningen 1.6.x, currently 1.6.2.



## Erlang worker VM images

### Erlang/OTP releases

* R15B
* R14B04
* R14B03
* R14B02

Erlang/OTP releases are built using [kerl](https://github.com/spawngrid/kerl).


## Node.js VM images

### Node.js versions

* 0.4 (0.4.12)
* 0.6 (0.6.7)

Node runtimes are built using [NVM](https://github.com/creationix/nvm).

### SCons

Scons is available to [build joyent/node on travis-ci.org](http://travis-ci.org/#!/joyent/node). Other projects can use it, too.



## PHP VM images

### PHP versions

* 5.2 (5.2.17)
* 5.3 (5.3.9, 5.3.2)
* 5.4 (5.4.0rc5)

PHP runtimes are built using [php-build](https://github.com/CHH/php-build).


### XDebug

Is supported.


### Extensions

TBD: PHP maintainers, please write me



## Ruby (aka common) worker VM images

### Ruby versions/implementations

* 1.8.7 (default)
* 1.9.2
* 1.9.3
* jruby
* rbx-18mode (aliased as rbx)
* rbx-19mode (in Ruby 1.9 mode)
* ree (2011.03)
* ruby-head (upgraded every 1-2 weeks)

[Ruby 1.8.6 and 1.9.1 are no longer provided on travis-ci.org](https://twitter.com/travisci/status/114926454122364928).

Rubies are built using [RVM](https://rvm.beginrescueend.com/) that is installed per-user and sourced from ~/.bashrc.

### Bundler version

Recent 1.0.x version (usually the most recent)


### Gems in the global gem set

* bundler
* rake


### Environment variables

* RAILS_ENV=test
* RACK_ENV=test
* MERB_ENV=test
* JRUBY_OPTS="--server -Dcext.enabled=false"



## How VM images are upgraded and deployed

We use Vagrant to develop, test, build, export and import VM images (a.k.a "Vagrant boxes"). Provisioning is automated using [OpsCode Chef](http://www.opscode.com/chef/).
VM images are then uploaded to our internal network and deployed to each individual worker during slow periods of the day (around 03:00 GMT). VM images for different
workers vary in size but in general are **between 1.5 and 2.5 GB in size**.

This means that to provision a new PHP release (for example), we do the following:

 * Update our PHP-related cookbooks and possibly tools like php-build that they depend on.
 * Test cookbooks locally
 * Build a new PHP VM image
 * Upload the image to our internal network
 * Take php1.worker.travis-ci.org down to import new images


For new releases of data stores or messaging technologies, for example, Riak

 * Update our Riak cookbook
 * Test the cookbook locally
 * Build a new standard VM image, then worker-specific (Ruby, PHP, Node.js and so on) VM images based on the new standard image
 * Upload new images to our internal network
 * Take travis-ci.org workers down one by one to import new images

The entire process usually takes from one to several hours (depending on how many VM images need to be rebuilt). Combined with the time for
testing, new releases of runtimes and other widely used software usually go live on travis-ci.org within a week from the moment Travis Core team is
notified about the release.



## Chef Cookbooks

The Travis CI environment is set up using [OpsCode Chef](http://www.opscode.com/chef/). All the [cookbooks used by travis-ci.org](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base) are open source and can be found on GitHub.
travis-ci.org uses 32-bit Ubuntu Linux 11.04 but thanks to Chef, migrating to a different Ubuntu version or another distribution is much easier.

Chef cookbooks are developed using [Vagrant](http://vagrantup.com/) and [Sous Chef](https://github.com/michaelklishin/sous-chef) so
cookbook contributors are encouraged to use them.


Many cookbooks Travis CI environment uses are taken from the [official OpsCode cookbooks repository](https://github.com/opscode/cookbooks).
We modify some of them for continuous integration needs and sync them periodically or as the need arises.
