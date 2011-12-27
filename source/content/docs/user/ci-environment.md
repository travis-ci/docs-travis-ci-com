---
title: About Travis CI Environment
kind: content
---

## Purpose of this page

To explain what packages, tools and settings are available in the Travis CI environment (often referred to as "[Vagrant](http://vagrantup.com/) base" or "CI environment").


## Overview

Travis CI runs builds in virtual machines that are snapshotted before each build and rolled back at the end of it.
This offers a number of benefits:

 * Host OS is not affected by test suites
 * No state persists between runs
 * Passwordless sudo is available
 * It is possible for test suites to create databases, add RabbitMQ vhosts/users and so on

The environment available to test suites is known as the *Travis CI environment* or *Vagrant base* (not to be confused with
the worker environment that runs one or more instances of the Travis worker application).

The Travis CI environment is set up using [OpsCode Chef](http://www.opscode.com/chef/). All the [cookbooks used by travis-ci.org](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base) are open source and
can be found on GitHub. travis-ci.org uses 32-bit Ubuntu Linux 10.04 but thanks to Chef, migrating to a different Ubuntu version or another distribution is a relatively small undertaking.

Chef cookbooks are developed using [Vagrant](http://vagrantup.com/) and [Sous Chef](https://github.com/michaelklishin/sous-chef) so
cookbook contributors are encouraged to use them.


## Cookbooks

Many cookbooks Travis CI environment uses are taken from the [official OpsCode cookbooks repository](https://github.com/opscode/cookbooks).
We modify some of them for continuous integration needs and sync them periodically or as the need arises.

* [Build essentials](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/build-essential): gcc, autotools, make, bison and so on
* [Networking essentials](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/networking_basics) (curl, wget and so on)
* [apt](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/apt)
* [git](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/git) 1.7.5.x with GitHub patches
* [rvm](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/rvm). We customized this cookbook to install multiple Ruby versions/implementations with the same default gem set.
* [openssl](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/openssl)
* [OpenJDK 6](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/java)
* [mysql](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/mysql) 5.1.41. We customized this cookbook to provide [mysql::server_on_ramfs recipe](http://bit.ly/mysql-on-ramfs) I/O-heavy test suites (like the Ruby on Rails one) use.
* [postgresql](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/postgresql) 8.4.x
* [sqlite](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/sqlite)
* [redis](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/redis) 2.2.x
* [memcached](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/memcached)
* [riak](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/riak) 1.0.x
* [mongodb](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/mongodb) 2.0.x
* [erlang](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/erlang) (see below)
* [rabbitmq](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/rabbitmq) 2.7.x
* [node.js](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/nodejs) (see below)
* [leiningen](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/leiningen) 1.6.x
* [sbt (simple build tool)](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/sbt) 0.10.x
* [imagemagick](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/imagemagick).
* [sphinx](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/sphinx) 0.9.9, 1.10 and 2.x
* [emacs](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/emacs) (for debugging)
* [vim](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base/vim) (for debugging)


## Ruby versions/implementations

* 1.8.7 (default)
* 1.9.2
* 1.9.3
* jruby
* rbx (aliased as rbx-2.0 and rbx-18mode)
* rbx-19mode (in Ruby 1.9 mode)
* ree (2011.03)
* ruby-head

## Erlang/OTP releases

* R14B04
* R14B03
* R14B02
* R14B
* R14A
* R13B04
* R13B03

## Node.js versions

* 0.4 (0.4.12)
* 0.6 (0.6.6)

## PHP versions

* 5.2 (5.2.17)
* 5.3 (5.3.8, 5.3.9rc3, 5.3.2)
* 5.4 (5.4.0rc4)


## Gems in the global gem set

* chef
* bundler
* rake


## Environment variables

* DEBIAN_FRONTEND=noninteractive
* CI=true
* TRAVIS=true
* HAS_JOSH_K_SEAL_OF_APPROVAL=true
* USER=vagrant
* HOME=/home/vagrant
* LANG=en_US.UTF-8
* LC_ALL=en_US.UTF-8
* RAILS_ENV=test
* RACK_ENV=test
* MERB_ENV=test
* JRUBY_OPTS="--server -Dcext.enabled=false"
