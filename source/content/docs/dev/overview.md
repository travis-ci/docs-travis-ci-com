---
title: Overview
kind: content
---

## What This Guide Covers

This guide explains what applications, libraries, tools and practices make travis-ci.org run. It briefly outlines
why each part of the system works the way it does and what upsides and downsides it entails. It intentionally leaves out many
details and should be considered a high level overview.


## Applications

Travis CI v3 (deployed in November 2011) consists of 4 key applications:

 * Travis Hub
 * Travis Server
 * Travis Worker
 * Travis Boxes

that communicate primarily over [AMQP 0.9.1](http://rubyamqp.info/articles/amqp_9_1_model_explained/). Some of them also share
our main database but in a way isolates updates from read requests.

### One Day in Life of Build Request

#### Early Morning

When external `Build Request` (currently, push notification from GitHub) comes in via HTTP, it is handled by `Travis Server`. If there is no existing builds history for
the project, it is initialized. `Travis Server` then emits a `configuration task` message and is done with its part.

`Configuration task` message is routed by RabbitMQ to a queue used by `Travis Hub`. The Hub fetches `.travis.yml` from project
repository, parses it and checks whether the build has to be skipped. If so, the message is not processed further. If not, then
it publishes one or more `build task` messages, one per `build matrix` row.

#### Noon

`Build task` messages are routed to one of several queues (depending on project language setting in `.travis.yml`) and consumed
by one of `Travis Workers`. `Travis Worker` that consumed the message then uses information in it to determine how to run the build.
Then it establishes SSH connection to one of snapshotted `Travis VMs`, picks a `technology-specific builder` and runs the build.
Build lifecycle is documented in detail in our [Build Configuration guide](/docs/user/build-configuration).

Commands that `technology-specific builder` runs over SSH produce output (via standard in and standard out streams) that `Travis Worker`
captures and publishes as `build log chunk` messages. Those messages are routed by RabbitMQ to one of several queues (one per project
type: Clojure, Node.js, PHP, Ruby, etc). From there, they are pushed to consumers in `Travis Hub` which **primary purpose is to
collect build logs and process them**.

Build log processing in `Travis Hub` has multiple steps, some of which have strict ordering requirements and some are executed
asynchronously in separate threads:

 * Update build log in the database
 * Propagate `build log chunk` messages to Web browsers using WebSockets
 * Detect build termination
 * On build termination: update build task records, deliver email/IRC/Campfire notifications

This is where our single page rich client app that `Travis Server` serves comes in. It receives propagated event messages via WebSockets
and updates the UI in near real time.

#### Night

When the build is done (successfully or not), apps prepare to sleep:

 * `Travis Hub` finalizes build tasks state, propagates `build termination event` messages to Web browsers, delivers notifications if needed.
 * `Travis Worker` powers off and rolls back the VM it had been using to run this build. This wipes any changes to the CI environment so no state is preserved between builds.

The End. The system is ready for another build request.


## Libraries

TBD


## VM images

TBD



## CI Environment Upgrade Process

TBD



## Dependency Updates Policy

TBD


## Libraries

TBD


## What To Read Next

TBD
