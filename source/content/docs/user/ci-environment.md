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

curl, wget, OpenSSL, rsync


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

* [RabbitMQ](http://rabbitmq.com) 2.7.x
* [ZeroMQ](http://www.zeromq.org/) 2.1.x

### Headless Browser Testing Tools

* [xvfb](http://en.wikipedia.org/wiki/Xvfb) (X Virtual Framebuffer)
* [Phantom.js](http://www.phantomjs.org/) 1.4.x

### Environment variables

* DEBIAN_FRONTEND=noninteractive
* CI=true
* TRAVIS=true
* HAS_JOSH_K_SEAL_OF_APPROVAL=true
* USER=vagrant (**a subject to change, do not depend on this value**)
* HOME=/home/vagrant (**a subject to change, do not depend on this value**)
* LANG=en_US.UTF-8
* LC_ALL=en_US.UTF-8


### Libraries

* OpenSSL
* ImageMagick


### apt configuration

apt is configured to not require confirmation (assume -y switch by default) using both `DEBIAN_FRONTEND` env variable and apt configuration
file). This means `apt-get install` can be used without the -y flag.



## JVM (Clojure, Groovy, Java, Scala) VM images

### Maven version

Stock Apache Maven 3.0.x.


### Leiningen version

travis-ci.org uses standalone ("uberjar") Leiningen 1.6.x, currently 1.6.2.


### SBT version

travis-ci.org provides SBT 0.11.x.


### Gradle version

Currently 1.0 Milestone 8.



## Erlang VM images

### Erlang/OTP releases

* R15B
* R14B04
* R14B03
* R14B02

Erlang/OTP releases are built using [kerl](https://github.com/spawngrid/kerl).


## Node.js VM images

### Node.js versions

* 0.4 (0.4.12)
* 0.6 (0.6.11)
* 0.7 (0.7.5)

Node runtimes are built using [NVM](https://github.com/creationix/nvm).

### SCons

Scons is available to [build joyent/node on travis-ci.org](http://travis-ci.org/#!/joyent/node). Other projects can use it, too.



## Perl VM images

### Perl versions

* 5.14
* 5.12
* 5.10

installed via [Perlbrew](http://perlbrew.pl/).

### cpanm

cpanm (App::cpanminus) version 1.5007



## PHP VM images

### PHP versions

* 5.2 (5.2.17)
* 5.3 (5.3.10, 5.3.2)
* 5.4 (5.4.0RC8)

PHP runtimes are built using [php-build](https://github.com/CHH/php-build).


### XDebug

Is supported.


### Extensions

<pre>
$ php -m
[PHP Modules]
bcmath
bz2
Core
ctype
curl
date
dom
ereg
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
intl
json
libxml
mbstring
mcrypt
mysql
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
Phar
posix
readline
Reflection
session
shmop
SimpleXML
soap
sockets
SPL
sqlite3
standard
sysvsem
sysvshm
tidy
tokenizer
xdebug
xml
xmlreader
xmlrpc
xmlwriter
xsl
zip
zlib

[Zend Modules]
Xdebug
</pre>


## Python VM images

### Python versions

* 2.6
* 2.7
* 3.1
* 3.2

Every Python has a separate virtualenv that comes with `pip` and `distribute` and is activated before running the build.


### Preinstalled pip packages

* nose
* py.test
* mock



## Ruby (aka common) VM images

### Ruby versions/implementations

* 1.8.7 (default)
* 1.9.2
* 1.9.3
* jruby-18mode (1.6.7; alternative alias: jruby)
* jruby-19mode (1.6.7 in Ruby 1.9 mode)
* rbx-18mode (alternative alias: rbx)
* rbx-19mode (in Ruby 1.9 mode)
* ree (2012.02)
* ruby-head (upgraded every 1-2 weeks)
* jruby-head (upgraded every 1-2 weeks)

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

We currently use Vagrant to develop, test, build, export and import VM images (a.k.a "Vagrant boxes"). Provisioning is automated using [OpsCode Chef](http://www.opscode.com/chef/).
VM images are then uploaded to our internal network and deployed to each individual worker during slow periods of the day (around 03:00 GMT). VM images for different
workers vary in size but in general are **between 1.6 and 3.3 GB in size**.

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

The Travis CI environment is set up using [OpsCode Chef](http://www.opscode.com/chef/). All the [cookbooks used by travis-ci.org](https://github.com/travis-ci/travis-cookbooks/tree/master/ci_environment) are open source and can be found on GitHub.
travis-ci.org uses 32-bit Ubuntu Linux 11.04 but thanks to Chef, migrating to a different Ubuntu version or another distribution is much easier.

Chef cookbooks are developed using [Vagrant](http://vagrantup.com/) and [Sous Chef](https://github.com/michaelklishin/sous-chef) so
cookbook contributors are encouraged to use them.


Many cookbooks Travis CI environment uses are taken from the [official OpsCode cookbooks repository](https://github.com/opscode/cookbooks).
We modify some of them for continuous integration needs and sync them periodically or as the need arises.
