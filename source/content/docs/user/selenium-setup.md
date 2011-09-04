---
title: Selenium setup
kind: content
---

You can run Selenium tests (and anything else that requires a browser) on Travis CI. The environment has xvfb and Firefox installed. xvfb is a "virtual framebuffer" that lets you run a real browser on a headless machine, as if a proper display were attached. It does require a little extra setup, though.

First, somewhere in your before_script, you need this line:

    sh -e /etc/init.d/xvfb start

This starts xvfb on display port :99.0. The display port is set directly in the /etc/init.d script. 

Second, when you run your tests, you need to tell your Selenium process about that display port, so it knows where to start Firefox. Here's an example rake task that runs Rspec, Jasmine, and Cucumber tests:

    task :travis do
      ["rspec spec", "rake jasmine:ci", "rake cucumber"].each do |cmd|
        puts "Starting to run #{cmd}..."
        system("export DISPLAY=:99.0 && bundle exec #{cmd}")
        raise "#{cmd} failed!" unless $?.exitstatus == 0
      end
    end

In this example, both Jasmine and Cucumber need the display port, because they both use real browsers. Rspec would run without it, but it does no harm to set it.
