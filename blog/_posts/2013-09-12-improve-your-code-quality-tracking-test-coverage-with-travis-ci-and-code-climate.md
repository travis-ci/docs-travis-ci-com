---
title: "Improve Your Code Quality: Tracking Test Coverage with Travis CI and Code Climate"
created_at: Thu 12 Sep 2013 20:00:00 CEST
author: Mathias Meyer
twitter: roidrage
permalink: blog/2013-09-12-improve-your-codes-quality-tracking-test-coverage-with-travis-ci-and-code-climate
layout: post
---
With continuous integration and unit testing, tracking how much of your code is
covered by tests comes as natural requirement to detect code that could break.
One could go as far as considering low test coverage a code smell.

The less of your code is covered by tests, the higher the chance that something
will break as features are added, as code changes, as code is refactored.

Our friends at **Code Climate** set out to build a tool that allows you to track
your code's quality over time. If you're working on kind of Ruby project, and
you haven't already, you [need to check them
out](https://codeclimate.com/partners/travisci). (sssh: rumor has it [they're
working on JavaScript support](https://codeclimate.com/js), but if anyone asks,
you didn't hear it from us!)

![](/images/travis-loves-code-climate.png)

Today, we're thrilled to be a part of their newest feature addition: making **test
coverage an integral part of measuring code quality** on their platform.

This new test coverage tracking integrates neatly with your builds on Travis CI
with a few simple steps.

When integrated, here's the view you're getting. You can see how coverage for our
controller handling Stripe subscriptions needs to be improved, but now we can
actually see it.

![](http://s3itch.paperplanes.de/SubscriptionsController_from_Billing__Code_Climate_20130912_170225.jpg)

Code Climate tracks any changes in coverage over time, showing you and telling
you when things got better or when they got worse.

To get started, all you need to do is sign up for a Code Climate account and one
for Travis CI too, and follow these steps:

  1. Add the `codeclimate-test-reporter` to your Gemfile:
  
         gem "codeclimate-test-reporter", group: :test, require: nil
  
  2. Add the following lines to your `spec_helper.rb` or `test_helper.rb`, at
     the very top:

         require "codeclimate-test-reporter"
         CodeClimate::TestReporter.start

  3. Add the Code Climate repository token to your `.travis.yml`:

         addons:
           code_climate:
             repo_token: 1213....
        
  4. Ship code!

You'll find these steps in the settings for your repository on Code Climate as
well and on the repositories on Travis CI.

As a Travis CI customer, we have a [special deal for you as
well](https://codeclimate.com/partners/travisci) to get started on Code Climate.

Please note that you need a paid subscription to Code Climate for both your
private and open source projects.

We're happy to be a partner in Code Climate's new offering!
