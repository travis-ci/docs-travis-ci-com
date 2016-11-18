---
title: Validating .travis.yml files
layout: en
permalink: /user/travis-lint/
---

Validating your `.travis.yml` file before committing it reduces common build errors such as

- invalid [YAML](http://yaml-online-parser.appspot.com/)
- missing `language` key
- unsupported [runtime versions](/user/ci-environment/) of Ruby, PHP, OTP, etc
- deprecated features or runtime aliases

## Online Validation

Validate your `.travis.yml` [online](http://lint.travis-ci.org) by entering your
github repository or by pasting the contents of your `.travis.yml` into the form.

## Command line Validation

To install the [command line client](https://github.com/travis-ci/travis.rb#installation),
 which requires Ruby 1.9.3 and RubyGems:

```bash
gem install travis --no-rdoc --no-ri
```

To run the command line [lint](https://github.com/travis-ci/travis.rb#lint) tool:

```bash
# from any directory
travis lint [path to your .travis.yml]
```
