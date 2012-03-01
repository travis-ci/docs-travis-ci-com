---
title: VM environment upgrade, Oct 31st, 2011
kind: article
created_at: Mon Oct 31 16:26:26 EDT 2011
---

travis-ci.org Ruby workers were upgraded to provide the following:

 * Ruby 1.9.3-p0 (final release)
 * JRuby 1.6.5
 * Updated Rubinius 2.0 from 2.0.testing branch
 * Node.js 0.4.12, npm 1.0.18
 * MongoDB 2.0.1
 * Riak 1.0.1
 * ragel
 * RVM 1.9.2

There is also one more change we want to highlight: we now provide two installations of Rubinius, one in Ruby 1.8 mode
and another one in Ruby 1.9 mode. Their RVM aliases are *rbx-18mode* and *rbx-19mode*, respectively. For example, to test your gem
against Rubinius in both modes, you can use the following list of Rubies in your .travis.yml file:

    rvm:
      - 1.8.7
      - 1.9.3
      - jruby
      - rbx-18mode
      - rbx-19mode


Existing aliases for 1.8 mode (*rbx* and *rbx-2.0*) are still around and will work.

Rubinius' Ruby 1.9 features support is still a work in progress (it does not support encodings yet, for example) but
we encourage Ruby developers to try testing their libraries against Rubinius, in both 1.8 and 1.9 modes. Now it is even
easier to do on travis-ci.org.

To get regular updates about travis-ci.org environment upgrades and other developments, [follow Travis CI on Twitter](https://twitter.com/travisci)
and watch our [Chef cookbooks repository on GitHub](https://github.com/travis-ci/travis-cookbooks/tree/master/vagrant_base).


[MK](https://twitter.com/michaelklishin)
