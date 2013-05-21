---
title: Migrating CI Environment to Ubuntu 11.10
layout: post
created_at: Tue Mar 27 04:00:00 CDT 2012
permalink: blog/upcoming_ubuntu_11_10_migration
author: Michael Klishin
twitter: michaelklishin
---

## Keeping Up With the Times

When we first started using virtual machines for Travis CI (around June 2011) we decided to use Ubuntu 10.04. This worked perfectly, but by the fall of 2011 10.04 started showing its age. Our users kept asking for more recent versions of certain tools and libraries which were challenging to provide without building and maintaining a myriad of Debian packages. So in November 2011 we migrated all VMs to Ubuntu 11.04 which solved the problem.

Now it is Spring 2012 and the time to move on to 11.10 is drawing close. We want to explain briefly how Travis CI will migrate to it, why we are doing it and what may change for your project.


## Why Migrate?

With Ubuntu 11.10, we will be able to provide more up-to-date versions of tools and services in our CI environment, including:

 * OpenJDK 7 alongside OpenJDK 6 (this is still a work in progress)
 * PostgreSQL 9.1 + updated extensions
 * CouchDB 1.1
 * Firefox 11

In addition, we won't have to use 3rd party apt repositories or compile certain tools from source, which greatly reduces our maintenance burden, for example:

 * Haskell Platform
 * Maven 3


## Staying One Step Behind, Intentionally

Our users are mostly software developers and they tend to like to staying up-to-date with tools, services, libraries and so on. However, production environments are rarely on the bleeding edge. So for CI in general, and Travis CI in particular, it is important to maintain a balance: not too old, but not too new either. This is why Travis CI is intentionally about 6 months behind Ubuntu releases. It gives developers several months to catch up with recent changes, fix issues and push out new releases.



## Important Changes in 11.10

### GCC

One of the biggest changes with every distro release is GCC version changes. 11.10 ships with GCC 4.6. This version is known to be more strict than previous releases and some tools and libraries may need minor changes when compiled with -Wall. Judging from the experience from one of our team members, most popular tools were updated in the beginning of this year.


### OpenSSL

Another important change OpenSSL version. 11.10 ships with OpenSSL 1.0 by default, but even more importantly,
disables SSLv2 support. SSLv2 is very old (released in [1995](http://www.youtube.com/watch?v=N6voHeEa3ig)), there were four updates to the spec after it: SSL 3.0, TLS 1.0, TLS 1.1 and TLS 1.2. In addition to that, SSLv2 contains several known [security flaws](http://en.wikipedia.org/wiki/Secure_Socket_Layer#cite_note-5)
and all new distributions either already dropped support for it or will be dropping it very soon.


### PHP 5.2

Because of the SSLv2 change explained above, we had to disable SSL support for PHP 5.2 and 5.3.2. PHP 5.2 is no longer maintained by the PHP Core Team and we were faced with a decision: either drop it completely or patch and maintain it to work with OpenSSL 1.0, or disable SSL support for it.

PHP 5.3.10 and 5.4.0 are maintained and work with OpenSSL 1.0 without modifications, and have OpenSSL support enabled, just like they have today.


## The Road to 11.10

On April 6th, 2012 we plan to update all our VMs to use Ubuntu 11.10. We will provide the same set of tools, services, and libraries, but some of them will be newer than what we have today. Most maintained software should work without any changes on your part. If you experience any issues please drop by #travis on chat.freenode.net and we will do our best to help you.

You can also try a minimalistic 11.10 image using Virtual Box and [sous chef](https://github.com/michaelklishin/sous-chef) or [Vagrant](http://vagrantup.com)
with our [11.10 base box](http://files.travis-ci.org/boxes/bases/oneiric32_base.box).


Happy testing!


The Travis CI Team
