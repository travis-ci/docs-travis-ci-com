---
title: Building a Ruby Project
kind: content
---

Travis was originally intended for just Ruby, so things should Just
Work! You do not need to specify language in your .travis.yml file.

Travis will use Bundler to install your project's dependencies and run `rake` to run your tests.



### before_install, before_script and friends

See <a href="/docs/user/build-configuration/">Build configuration</a> to learn about *before_install*, *before_script*, branches configuration, email notification
configuration and so on.


### Provided Ruby Versions

Here's a list of all of the Ruby versions supported by Travis. 1.8.7 is
the default.

- 1.8.7
- 1.9.2
- 1.9.3
- jruby
- rbx
- ree
- ruby-head

[Ruby 1.8.6 and 1.9.1 are no longer provided on travis-ci.org](https://twitter.com/travisci/status/114926454122364928).
More information about provided Ruby versions and implementations is available <a href="/docs/user/ci-environment/">in a separate guide</a>.
