---
title: Validating .travis.yml files
layout: en
permalink: /user/travis-lint/
---

Validating your `.travis.yml` file before committing it reduces common build errors such as

* invalid [YAML](http://yaml-online-parser.appspot.com/) in `.travis.yml` 
* missing `language` key
* unsupported [runtime versions](/user/ci-environment/) of Ruby, PHP, OTP, etc
* deprecated features or runtime aliases

### Using lint.travis-ci.org

You can use the [web app](http://lint.travis-ci.org) by entering a link to your repository or by pasting the contents of your `.travis.yml` into the form.  

### Using the travis-lint command-line tool

To install the `travis-lint` command-line tool, which requires Ruby 1.8.7+ and RubyGems:

    gem install travis-lint

To run `travis-lint`:

    # from any directory
    travis-lint [path to your .travis.yml]
