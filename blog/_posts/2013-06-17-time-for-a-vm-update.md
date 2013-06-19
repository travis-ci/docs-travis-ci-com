---
title: Time For A VM Update
author: Josh Kalderimis
twitter: j2h
created_at: Mon 17 Jun 2013 16:00:00 CEST
layout: post
permalink: blog/2013-06-17-time-for-a-vm-update
---

Happy Monday Everyone!

We love starting off the week with great news!

After a bit of a delay, we are happy to let everyone know that our VMs have been updated with a host of fixes, updates, and general polish and shine. From language versions, to services, to system settings.

These VM changes will be live for https://travis-ci.org users tomorrow (Tuesday 18 June, 12pm CEST), and for https://travis-ci.com users on Monday next week (24th June, 12pm CEST).

If you have any issues or requests, please create an issue on our [issue tracker](https://github.com/travis-ci/travis-ci/issues).

Below are the full details of the updates included in the VM refresh.

Have a great Monday,

Josh and the Travis Team.


### Language Updates:

Ruby:
- JRuby 1.7.4
- MRI 1.9.3-p429 and p327, and 2.0.0-p195

Node.js:
- 0.8.24, 0.10.9 and 0.11.2 

Go:
- 1.1.1 preinstalled and set as the default

PHP:
- 5.3.26, 5.4.16 and 5.5.0RC3

Perl:
- added 5.8 and 5.19
- updated current versions to 5.12.5, 5.14.4, and 5.16.3

Python:
- latest patch versions installed


### Services Updates:

Redis: **v2.6.13**

ElasticSearch: **v0.90.1**

MongoDB: **v2.4.4**

Cassandra: **v1.2.5**

PhantomJs: **v1.9.1**


### Note worthy mentions:

- Clojure: Leinigen updated to v2.2 

- Composer: Read-only GitHub OAuth token added, this should help resolve rate limit issues.

- PHP: PEAR is now available on v5.5

- Cassandra: Config fixed, service should now start up like a dream.

- Postgres: shmmax and shmmall both increased

- Tmpfs for Mysql and Postgres DBs doubled to 512megs

- Mirrors removed: We provided EU based mirrors for Maven and Perl, these have been removed as our VMs are based in the US.

- FireFox locked to 19.0, see http://about.travis-ci.org/docs/user/addons/#Firefox for more info
