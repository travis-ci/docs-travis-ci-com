---
title: VM VM VM VM VM VM VM VM VM VM VM
author: Josh Kalderimis
twitter: j2h
created_at: Fri 8 Nov 2013 12:00:00 CEST
layout: post
permalink: blog/2013-11-08-ci-environment-updates
---

TODO-JOSHK: english review for the WHOLE post content, please...
TODO-JOSHK: CHANGE BLOG Title/FileName/Permalink with final date

TODO-JOSHK: <GREATINGS!>

TODO-JOSHK: <INTRO/CONTEXT> see example in 2013-06-17-time-for-a-vm-update.md

These VM changes will be live for https://travis-ci.org users TODO-JOSHK <tomorrow> (TODO-JOSHK Tuesday 18 June, 12pm CEST), and for https://travis-ci.com users on Monday next week (TODO-JOSHK 24th June, 12pm CEST).

If you have any issues or requests, please create an issue on our [issue tracker](https://github.com/travis-ci/travis-ci/issues).

Below are the full details of the updates included in the VM refresh.

TODO-JOSHK: Continuous SOMETHING!

Josh and the Travis Team.


### Language Updates:

C/C++:

- Clang 3.3

Go:

- 1.1.2 preinstalled and set as the default

Java:

- TODO-JOSHK JDK8 introduction mentioned in "New Features" section, so maybe better to drop the Java section here...
- latest patch versions installed

Erlang / OTP:

- R16B02, R16B01
- TODO-JOSHK: there were more changes after https://github.com/travis-ci/travis-ci.github.com/pull/364, see https://github.com/travis-ci/travis-cookbooks/commit/119651cdf20dd7a1f505d916b8ba04b59e255b36 for instance

Node.js:

- TODO-JOSHK: https://github.com/travis-ci/travis-images/blob/master/templates/worker.node-js.yml

Perl: TODO-JOSHK: no changes

PHP:

- 5.3.27, 5.4.21 and 5.5.5

Python:

- Python 2.5 removed, TODO-JOSHK based on low usage statistics
- TODO-JOSHK: `distribute` is out (distribute_setup renamed to setuptools/ez_setup), virtualenv 1.10.1
- TODO-JOSHK: latest patch versions installed

Ruby:

- TODO-JOSHK

Scala:

- Scala 2.10.3 is set as new default
- sbt 0.13.0 is set as new default (TODO-JOSHK: but [dynamic switch to required sbt version](/docs/user/languages/scala/#Projects-using-sbt) is still operational, of course!)


### Services Updates:

- Cassandra: **v2.0.2**

- ElasticSearch: **v0.90.5**

- MongoDB: **v2.4.8**

- Neo4J: **v1.9.4**

- PhantomJs: **v1.9.2**

- Redis: **v2.6.16**

- Riak: **v1.4.2-1**


### Tools Updates

- Gradle: **v1.8**

- Leinigen: **v2.3.1**

- Maven: **v3.1.1**


### Other Changes worthy to mention (TODO-JOSHK, or maybe not worthy ;-)

- RAM-Disk partition used by MySQL and PostgreSQL increased to 768megs

- Build download time improved for Scala projects: Scala and sbt boot libraries are now preinstalled for following Scala versions: 2.11.0-M5, 2.10.3, 2.10.2, 2.10.1, 2.10.0, 2.9.3, 2.9.2

- Scala SBT and JVM default tunings will now only be effective when `language: scala` is selected (see https://github.com/travis-ci/travis-build/pull/154). It means that having an other language in .travis.yml will lead to use default settings from sbt-extras (which should be good enough).

- New PHP modules: kerberos, imap, imap-ssl


### New Features

- Introduction of Oracle JDK 8 "Early Access" edition (TODO-JOSHK: explain we're still in **Bêta** mode, even with known problem(s)).

- Ability to [select PosgreSQL version](/docs/user/addons/#PostgreSQL) to test with. Travis new VMs will provide versions 9.1, 9.2 and 9.3.

- PostGIS 2.1 and other well known PostgreSQL [additional modules](http://www.postgresql.org/docs/devel/static/contrib.html) are now preconfigured for all PostgreSQL 9.x versions.


### Resolved Problems

- Cassandra: TODO-JOSHK definitly fixed, service should now start up like a dream.

- Maven will be (again) installed from Apache packages and this will solve [this annoying bug](http://stackoverflow.com/questions/19158720/why-does-travis-ci-think-my-code-is-java-1-3-and-how-to-fix-it/19844340#19844340) (TODO-JOSHK: reword/extend please)

- **memcached** and **redis-server** services were wrongly auto-started on VM boot. This is now fixed, so you may need to add extra `services` statements to your .travis.yml if these service doesn't respond anymore in your builds. (TODO-JOSHK: i'm not 100% sure if there is not a 3rd service in this case... but I lack of time to check it)


### Related Known Issues

- At the moment, Gradle does not work with Oracle JDK 8 **on Travis CI virtual machines**. We're investigating... (TODO-JOSHK: tell me if you want more details about that point)

- Travis CI is still equipped by default with `gcc-4.6`, but we are aware that C++11 projects need `gcc-4.8` and we are working on an update...

More generally, please check our [issue tracker](https://github.com/travis-ci/travis-ci/issues)

