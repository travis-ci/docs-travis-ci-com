---
title: Using Code Climate with Travis CI
layout: en
permalink: /user/code-climate/
---

[Code Climate](https://www.codeclimate.com) is a hosted platform to continuously
measure and monitor code quality.

It keeps an eye on your [code's overall quality](https://codeclimate.com/tour),
but it can also [track test
coverage](https://docs.codeclimate.com/docs/getting-started-test-coverage). For that purpose, it
integrates neatly with Travis CI.

As a Travis CI customer, [you get 20% off for your first three
months](https://codeclimate.com/partners/travisci)!

## Measuring Test Coverage with Code Climate

Test coverage integration can be used on both private and open source projects,
and is free for open source.

Set up instructions for each supported language are available at the Code
Climate documentation site:

- [Ruby](https://docs.codeclimate.com/v1.0/docs/travis-ci-ruby-test-coverage)
- [JavaScript](https://docs.codeclimate.com/v1.0/docs/travis-ci-javascript-test-coverage)
- [PHP](https://docs.codeclimate.com/v1.0/docs/travis-ci-php-test-coverage)
- [Python](https://docs.codeclimate.com/v1.0/docs/travis-ci-python-test-coverage)

### I want to use Code Climate with parallel builds

Code Climate currently doesn't aggregate test coverage results across multiple
test runs. That means, you can't effectively use it yet with libraries like
`parallel_test` or parallel builds using our build matrix.
