---
title: Build timeout
layout: en
permalink: /user/essentials/timeouts/
---

<div id="toc"></div>

## Build Timeouts

It is very common for test suites or build scripts to hang.
Travis CI has specific time limits for each job, and will stop the build and add an error message to the build log in the following situations:

- A job takes longer than 50 minutes on travis-ci.org
- A job takes longer than 120 minutes on travis-ci.com
- A job takes longer than 50 minutes on OSX infrastructure or travis-ci.org or travis-ci.com
- A job produces no log output for 10 minutes

Some common reasons why builds might hang:

- Waiting for keyboard input or other kind of human interaction
- Concurrency issues (deadlocks, livelocks and so on)
- Installation of native extensions that take very long time to compile

> There is no timeout for a build; a build will run as long as all the jobs do as long as each job does not timeout.
