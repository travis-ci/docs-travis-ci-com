---
title: A Big Refactoring!
layout: en
created_at: Mon Aug 29 12:29:26 EDT 2011
permalink: blog/big_refactoring
---

We've just rolled out a big refactoring to the Travis CI [application](https://github.com/travis-ci/travis-ci)
(i.e. the server app which runs on Heroku) that we've been working on over the
last four weeks.

This refactoring was quite far-reaching and even though we've tried hard to
make sure everything works fine there may be glitches and bugs that we've
overlooked.

## Why?

The motivation behind all of this work was quite manifold. Maybe the best
summary is that our previous domain model still had the very basic design from
its original spike. But here are some more details. We wanted to achieve the
following things:

* Split up the monster Build model into more finegrained classes for more
  clarity
* Move to a statemachine-like pattern for more explicitely reflecting
  various state changes that happen across various models
* Lay better grounds for the long planned move to [AMQP](https://github.com/ruby-amqp/amqp)
  (communication with the workers)
* Lay better grounds for the long planned move Sproutcore (reimplementation of
  the JS client)
* Improve test coverage and move to RSpec (for unifying test technologies and a
  slightly lower barrier for new devs)
* Generally clean up both model and test code.

One major intention was to generally clean up our codebase, complete and
improve the test suite and make the model design more readable. Another was
to split up the former Build model which had grown into a huge tangled monster.
And while we were at it we also wanted to better communicate the fact that the
domain model is very much about about triggering state changes through various
events and messages.

You can find more information about the new domain model design [in this
document](https://github.com/travis-ci/travis-ci/blob/statemachine_merge/docs/notes/build_tasks.md).
Some of the details outlined there haven't been implemented, yet. E.g. the
`Build` model does not have the mentioned `errored` and `cancelled` states, the
`Task::Test` does not have `cloned` and `installed` states ... simply because the
worker does not support triggering these, yet. These things will probably be
added in a later stage.

When we reviewed common Ruby statemachine implementations we found none of them
do what we needed, so we came up with our own brand of it:
[simple_states](https://github.com/svenfuchs/simple_states) may or may not
useful for your own usecase but it does exactly what we need in Travis CI and
nothing more.

Another gem that has been implemented in the course of this refactoring is
[data_migrations](https://github.com/svenfuchs/data_migrations). We had quite a
bunch of columns to migrate from the `builds` table to various other tables
(such as `commits`, `requests`, `tasks`) and it seemed easier to come up with a
simple DSL for that than writing all these queries by hand.

Also, we're now using [hashr](https://github.com/svenfuchs/hashr) in the
application, too (for `Travis.config`, specifically). We've used it in the
[worker code](https://github.com/travis-ci/travis-worker) before and it worked
pretty well.

## In other news ...

In other news, over the last month we have extract a [small project that we use to develop our Chef cookbooks](https://github.com/michaelklishin/sous-chef) and
added the following tools to the [VM infrastructure](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base):

 * kerl to support Erlang with testing against multiple OTP releases
 * leiningen 1.6 for Clojure projects
 * sbt 0.10 for Scala projects
 * Thinking Sphinx 0.9.9, 1.10 and 2.0. [Riddle](http://freelancing-god.github.com/riddle) and [Thinking Sphinx](http://freelancing-god.github.com/ts/en/) are now hosted on Travis.
 * RabbitMQ now installs HTTP API plugin

