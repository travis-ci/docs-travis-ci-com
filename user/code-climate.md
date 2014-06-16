---
title: Using Code Climate with Travis CI
layout: en
permalink: code-climate/
---
[Code Climate](https://www.codeclimate.com) is a hosted platform to continuously
measure and monitor code quality.

It keeps an eye on your [code's overall quality](https://codeclimate.com/tour),
but it can also [track test
coverage](https://codeclimate.com/tour/test-coverage). For that purpose, it
integrates neatly with Travis CI.

Code Climate supports Ruby and JavaScript projects, with [support for PHP on the
horizon](https://codeclimate.com/php).

As a Travis CI customer, [you get 20% off for your first three
months](https://codeclimate.com/partners/travisci)!

## Measuring Test Coverage with Code Climate

Test coverage integration is currently available for Ruby projects and requires
adding a library to your Gemfile called
[`code-climate-reporter`](https://github.com/codeclimate/ruby-test-reporter):

    gem "codeclimate-test-reporter", group: :test, require: nil

Next, require the reporter in your `test_helper.rb` or `spec_helper.rb`, right
at the top:

    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start

As a last step, you need to tell Travis CI about the token to use for
transmitting the coverage results. You can find the token in your repository's
settings on Code Climate. Then you can add it to your `.travis.yml`:

    addons:
      code_climate:
        repo_token: adf08323...

## Common Problems

#### I get an error transmitting coverage results

If your project is using WebMock to stub out HTTP requests, you'll need to
explicitly whitelist the Code Climate API, otherwise you'll get an error that
the coverage results couldn't be transmitted. Here's how you can set up WebMock
to whitelist Code Climate:

    WebMock.disable_net_connect!(allow: %w{codeclimate.com})

One way to do this is to add the following to your `spec_helper.rb` file:

    # whitelist codeclimate.com so test coverage can be reported
    config.after(:suite) do
      WebMock.disable_net_connect!(:allow => 'codeclimate.com')
    end

#### I want to use Code Climate with parallel builds

Code Climate currently doesn't aggregate test coverage results across multiple
test runs. That means, you can't effectively use it yet with libraries like
`parallel_test` or parallel builds using our build matrix.

#### My build is successful even though rspec failed

Due to a [bug in Simplecov's 0.8 release
branch](https://github.com/colszowka/simplecov/issues/281), rspec's exit code is
overridden by Simplecov, making a failed build appear successful.

Until the issue is fixed in Simplecov, it's recommended to use the latest 0.7
release instead, which doesn't have this issue.
