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

Travis CI applications sometimes have to share certain piece of code. For example, `Travis Hub` and `Travis Server` need to agree on the database schema. Because of that
and to structure our code better, we extracted and/or developed a number of Travis CI libraries:

 * [travis-core](https://github.com/travis-ci/travis-core) hosts most of our domain models
 * [travis-build](https://github.com/travis-ci/travis-build) encapsulates build lifecycle `Travis Workers` use and provides a unified API for language-specific builders
 * [travis-support](https://github.com/travis-ci/travis-support) contains various support classes and utilities

In addition, there are mutliple side projects we developed as part of working on Travis CI, for example

 * [simple_states](https://github.com/svenfuchs/simple_states)
 * [hashr](https://github.com/svenfuchs/hashr)
 * [sous chef](https://github.com/michaelklishin/sous-chef)

as well as projects we rely on heavily and contribute to, like

 * [hot bunnies](https://github.com/ruby-amqp/hot_bunnies)
 * [amqp gem](https://github.com/ruby-amqp/amqp)


## CI Environment

`Travis CI Environment` refers to the environment (tools, services, libraries, environment settings, etc) inside `Travis VMs` that `Travis Workers` use to run builds. The environment is
snapshotted (no state is left between builds).


Part of the appeal of Travis CI is that [common services and tools](/docs/user/ci-environment) (like MySQL, PostgreSQL, RabbitMQ, Redis, MongoDB, Riak and many more) are preinstalled and
available for projects to use. We also provide passwordless sudo to make it possible to test projects with unique requirements and avoid having to install and maintain
all the software known to mankind.

`Travis CI Environment` is provisioned using modern automation tools and distirbuted in the form of `Travis VM images`.


## VM images

`Travis VMs` are created from `Travis VM images`. There is one image per technology we support, for example, Node.js or Erlang. Because Travis CI has its roots in the Ruby
community, Ruby VMs are referred to as `common VMs` and also host Clojure, Java and even Lua projects. We will spin off new image types, for example, for JVM languages,
as we improve support for them (for example, move to provide multiple JDK versions to test against).

`Travis VM images` are built using [travis-boxes](https://github.com/travis-ci/travis-boxes), a set of tools based on [Vagrant](http://vagrantup.com), [Veewee](https://github.com/jedi4ever/veewee)
and [OpsCode Chef](http://opscode.com/chef). Chef cookbooks we use all live in the [travis-cookbooks](https://github.com/travis-ci/travis-cookbooks) repository and are Apache 2.0 and MIT
licensed.



## CI Environment Upgrade Process

To update software in the `CI environment`, we periodically rebuild `Travis VM images` and deploy them. Although this process is highly automated, there is certain amount of testing involved
and it takes time to build, upload and download `Travis VM images` that range from 1.6 to 2.5 GB in size. This means that CI environment upgrades happen roughly once a week for
each worker type.



### Buzzwords List (tm)

Travis CI currently uses

 * [PostgreSQL](http://postgresql.org) 9.0+ as its main data store
 * [RabbitMQ](http://rabbitmq.com) 2.5+ for messaging
 * [JRuby](http://jruby.org) for `Travis Worker` with the official VirtualBox Java client.
 * JRuby for `Travis Hub` with [Hot Bunnies](https://github.com/ruby-amqp/hot_bunnies) and the official RabbitMQ Java client.
 * CRuby 1.9.2 on [Heroku](http://heroku.com) for `Travis Server`
 * [Ember.js](http://emberjs.com/) (formerly known as SproutCore 2) for the rich `Travis Server` UI frontend
 * [Pusher](http://pusher.com) for delivering messages to Web browsers over WebSockets
 * [OpsCode Chef](http://opscode.com/chef), [Vagrant](http://vagrantup.com) and [Veewee](https://github.com/jedi4ever/veewee) for `CI environment` provisioning & managing VM images.
 * CouchDB for build log archiving

This technology stack has changed significantly in the past and will change if the need arises.


### Worker Machines

Worker machines travis-ci.org uses are donated by the community and our sponsors ([drop us a line](mailto:contact@travis-ci.org) if you are interested in donating hardware or otherwise sponsoring the project).
`Travis Workers` run alongside `Travis VMs` they use, one worker thread per virtual machine. We currently VirtualBox for virtualization and `Travis Worker` implementation
depends on it, although the dependency will be abstracted away in the future.

Application instances that power travis-ci.org are primarily hosted in two locations: West coast in the US and Germany.



## What To Read Next

TBD
