---
title: GUI & Headless browser testing on travis-ci.org
layout: en
permalink: gui-and-headless-browsers/
---

## What This Guide Covers

This guide covers headless GUI & browser testing using tools provided by the Travis [CI environment](/docs/user/ci-environment/). Most of the content is technology-neutral and does not cover all the details of specific testing tools (like Poltergeist or Capybara). We recommend you start with the [Getting Started](/docs/user/getting-started/) and [Build Configuration](/docs/user/build-configuration/) guides before reading this one.

## Using xvfb to Run Tests That Require GUI (e.g. a Web browser)

You can run test suites that require GUI (like a web browser) on Travis CI. The environment has `xvfb` (X Virtual Framebuffer) and Firefox installed. Roughly speaking, `xvfb` imitates a monitor and lets you run a real GUI application or web browser on a headless machine, as if a proper display were attached.

Before `xvfb` can be used, it needs to be started. Typically an optimal place to do it is `before_install`, like this:

    before_install:
      - "export DISPLAY=:99.0"
      - "sh -e /etc/init.d/xvfb start"

This starts `xvfb` on display port :99.0. The display port is set directly in the `/etc/init.d` script. Second, when you run your tests, you need to tell your testing tool process (e.g. Selenium) about that display port, so it knows where to start Firefox. This will vary between testing tools and programming languages.

### Configuring xvfb screen size and more

It is possible to set xvfb screen size and pixel depth. Because xvfb is a virtual screen, it can emulate virtually any resolution. When doing so, you need to start
xvfb directly or via the `start-stop-daemon` utility and not via the init script:

    before_install:
      - "/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1280x1024x16"

In the example above, we are setting screen resolution to `1280x1024x16`.

See [xvfb manual page](http://www.xfree86.org/4.0.1/Xvfb.1.html) for more information.


## Starting a Web Server

If your project requires a web application running to be tested, you need to start one before running tests. It is common to use Ruby, Node.js and JVM-based web servers
that serve HTML pages used to run test suites. Because every travis-ci.org VM provides at least one version of Ruby, Node.js and OpenJDK, you can rely on one of those
three options.

Add a `before_script` to start a server, for example:

    before_script:
      - "export DISPLAY=:99.0"
      - "sh -e /etc/init.d/xvfb start"
      - sleep 3 # give xvfb some time to start
      - rackup  # start a Web server
      - sleep 3 # give Web server some time to bind to sockets, etc

If you need web server to be listening on port 80, remember to use `sudo` (Linux will not allow non-privileged process to bind to port 80). For ports greater than 1024, using `sudo` is not necessary (and not recommended).



## Using PhantomJS

[PhantomJS](http://phantomjs.org/) is a headless WebKit with JavaScript API. It is an optimal solution for fast headless testing, site scraping, pages capture, SVG renderer, network monitoring and many other use cases.

[CI environment](/docs/user/ci-environment/) provides PhantomJS pre-installed (available in PATH as `phantomjs`; don't rely on the exact location). Since it is completely headless, there is no need run `xvfb`.

A very simple example:

    script: phantomjs testrunner.js

If you need a web server to serve the tests, see the previous section.

## Examples

### Real World Projects

 * [Ember.js](https://github.com/emberjs/ember.js/blob/master/.travis.yml) (starts web server programmatically)
 * [Sproutcore](https://github.com/sproutcore/sproutcore/blob/master/.travis.yml) (starts web server with *before_script*)

### Ruby

#### RSpec, Jasmine, Cucumber

Here's an example rake task that runs Rspec, Jasmine, and Cucumber tests:

    task :travis do
      ["rspec spec", "rake jasmine:ci", "rake cucumber"].each do |cmd|
        puts "Starting to run #{cmd}..."
        system("export DISPLAY=:99.0 && bundle exec #{cmd}")
        raise "#{cmd} failed!" unless $?.exitstatus == 0
      end
    end

In this example, both Jasmine and Cucumber need the display port, because they both use real browsers. Rspec would run without it, but it does no harm to set it.

## Troubleshooting

### Selenium and Firefox popups

If your test suite handles a modal dialog popup, for example, [a redirect to another location](https://support.mozilla.org/en-US/questions/792131), then you may need to add a custom profile so that the popup is suppressed.

This can be fixed by applying a custom Firefox profile with the option turned off: (example is in Ruby using Capybara)

    Capybara.register_driver :selenium do |app|

      custom_profile = Selenium::WebDriver::Firefox::Profile.new

      # Turn off the super annoying popup!
      custom_profile["network.http.prompt-temp-redirect"] = false

      Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => custom_profile)
    end

