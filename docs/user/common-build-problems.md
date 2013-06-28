---
title: Common Build Problems
layout: en
permalink: common-build-problems/
---

<div id="toc"></div>

## Ruby: RSpec returns 0 even though the build failed

In some scenarios, when running `rake rspec` or even rspec directly, the command
returns 0 even though the build failed. This is commonly due to some RubyGem
overwriting the `at_exit` handler of another RubyGem, in this case RSpec's.

The workaround is to install this `at_exit` handler in your code, as pointed out
in [this article](http://www.davekonopka.com/2013/rspec-exit-code.html).

```
if defined?(RUBY_ENGINE) && RUBY_ENGINE == "ruby" && RUBY_VERSION >= "1.9"
  module Kernel
    alias :__at_exit :at_exit
    def at_exit(&block)
      __at_exit do
        exit_status = $!.status if $!.is_a?(SystemExit)
        block.call
        exit exit_status if exit_status
      end
    end
  end
end
```

## Ruby: Installing the `debugger_ruby-core-source` library fails

This Ruby library unfortunately has a history of breaking with even patchlevel
releases of Ruby. It's commonly a dependency of libraries like linecache or
other Ruby debugging libraries.

We recommend moving these libraries to a separate group in your Gemfile and then
to install RubyGems on Travis CI without this group. As these libraries are only
useful for local development, you'll even gain a speedup during the installation
process of your build.

```
# Gemfile
group :debug do
  gem 'debugger'
  gem 'debugger-linecache'
  gem 'rblineprof'
end
```

```
# .travis.yml
bundler_args: --without development debug
```
