---
title: Common Build Problems
layout: en
permalink: /user/common-build-problems/
---

<div id="toc"></div>

## My tests broke but were working yesterday

A very common cause when a test is suddenly breaking without any major code
changes involved is a change in upstream dependencies.

This can be a Ubuntu package or any of your project's language dependencies,
like RubyGems, NPM packages, Pip, Composer, etc.

To find out if this is the case, restart a build that used to be green, the last
known working one, for instance. If that build suddenly fails too, there's a
good chance, that a dependency was updated and is causing the breakage.

Make sure to check the list of dependencies in the build log, usually output
including versions, and see if there's anything that's changed.

Sometimes, this can also be caused by an indirect dependency that was updated.

After figuring out which dependency was updated, lock it to the last known
version.

Additionally, we update our build environment regularly, which brings in newer
versions of languages and the running services. Make sure to follow our
[changelog](http://changelog.travis-ci.com) to get a hold of the latest updates.

## My build script is killed without any error

Sometimes, you'll see a build script being causing an error, and the message in
the log will be something like `Killed`.

This is usually caused by the script or one of the programs it runs exhausting
the memory available in the build sandbox, which is currently 3GB. Plus, there
are two cores available, bursted.

Depending on the tool in use, this can be cause by a few things:

* Ruby test suite consuming too much memory
* Tests running in parallel using too many processes or threads (e.g. using the
  `parallel_test` gem)
* g++ needing too much memory to compile files, for instance with a lot of
  templates included.

For parallel processes running at the same time, try to reduce the number. More
than two to four processes should be fine, beyond that, resources are likely to
be exhausted.

With Ruby processes, check the memory consumption on your local machine, it's
likely to show similar causes. It can be caused by memory leaks or by custom
settings for the garbage collector, for instance to delay a sweep for as long as
possible. Dialing these numbers down should help.

## Ruby: RSpec returns 0 even though the build failed

In some scenarios, when running `rake rspec` or even rspec directly, the command
returns 0 even though the build failed. This is commonly due to some RubyGem
overwriting the `at_exit` handler of another RubyGem, in this case RSpec's.

The workaround is to install this `at_exit` handler in your code, as pointed out
in [this article](http://www.davekonopka.com/2013/rspec-exit-code.html).


```ruby
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

If your project is using the [Code Climate integration](/user/code-climate/) or
Simplecov, this issue can also come up with the 0.8 branch of Simplecov. The fix
is downgrade to the last 0.7 release until the issue is fixed.

## Capybara: I'm getting errors about elements not being found

In scenarios that involve JavaScript, you can occasionally see errors that
indicate that an element is missing, a button, a link, or some other resource
that is updated or created by asynchronous JavaScript.

This can indicate that the timeouts used for Selenium or one of its drivers are
set too low.

Capybara has a timeout setting which you can increase to a minimum of 15
seconds:

    Capybara.default_wait_time = 15

Poltergeist has its own setting for timeouts:

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, timeout: 15)
    end

If you're still seeing timeouts after increasing it initially, set it to
something much higher for one test run. Should the error still persist, there's
possibly a deeper issue on the page, for instance compiling the assets.

## Ruby: Installing the debugger_ruby-core-source library fails

This Ruby library unfortunately has a history of breaking with even patchlevel
releases of Ruby. It's commonly a dependency of libraries like linecache or
other Ruby debugging libraries.

We recommend moving these libraries to a separate group in your Gemfile and then
to install RubyGems on Travis CI without this group. As these libraries are only
useful for local development, you'll even gain a speedup during the installation
process of your build.

    # Gemfile
    group :debug do
      gem 'debugger'
      gem 'debugger-linecache'
      gem 'rblineprof'
    end

    # .travis.yml
    bundler_args: --without development debug

## Mac: Code Signing Errors

With Mavericks, quite a lot has changed in terms of code signing and the keychain application.

Signs of issues can be errors messages stating that an identity can't be found and that "User
interaction is not allowed."

The keychain must be marked as the default keychain, must be unlocked explicitly and the build needs to make sure that the keychain isn't locked before the critical point in the build is reached. The following set of commands takes care
of this:

    KEY_CHAIN=ios-build.keychain
    security create-keychain -p travis $KEY_CHAIN
    # Make the keychain the default so identities are found
    security default-keychain -s $KEY_CHAIN
    # Unlock the keychain
    security unlock-keychain -p travis $KEY_CHAIN
    # Set keychain locking timeout to 3600 seconds
    security set-keychain-settings -t 3600 -u $KEY_CHAIN

## Mac: Errors running CocoaPods

CocoaPods usage can fail for a few reasons currently.

### Newer version of CocoaPods required

Most Pods now require CocoaPods 0.32.1, but we still have 0.21 preinstalled. If
you're seeing this error, add this to your `.travis.yml`:

    before_install:
      - gem install cocoapods -v '0.32.1'

### CocoaPods can't be found

CocoaPods isn't currently installed on all available Rubies, which unfortunately
means it will fail when using the default Ruby, which is 2.0.0.

To work around this issue, you can either install CocoaPods manually as shown
above, or you can switch to Ruby 1.9.3 in your `.travis.yml`, which should work
without any issues:

    rvm: 1.9.3

### CocoaPods fails with a segmentation fault

On Ruby 2.0.0, CocoaPods has been seen crashing with a segmentation fault.

You can work around the issue by using Ruby 1.9.3, which hasn't shown these
issues. Add this to your `.travis.yml`:

    rvm: 1.9.3

## System: Required language pack isn't installed

The Travis CI build environments currently have only the en_US language pack
installed. If you get an error similar to : "Error: unsupported locale
setting", then you may need to install another language pack during your test
run.

This can be done with the follow addition to your `.travis.yml`:

    before_install:
      - sudo apt-get update && sudo apt-get --reinstall install -qq language-pack-en language-pack-de

The above addition will reinstall the en\_US language pack, as well as the de\_DE
language pack.

## Linux: apt fails to install package with 404 error.

This is often caused by old package database and can be fixed by adding the following to `.travis.yml`:

    before_install:
      - sudo apt-get update

