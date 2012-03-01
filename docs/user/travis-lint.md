---
title: Validate your .travis.yml with travis-lint
layout: default
permalink: travis-lint/
---

## What This Guide Covers

This guide covers [travis-lint](https://github.com/travis-ci/travis-lint), a small tool that validates your `.travis.yml` file to help you discover common issues.
If you are looking for info about putting your project on travis-ci.org, start with the [Getting Started](/docs/user/getting-started/) guide.


## Validate .travis.yml Using lint.travis-ci.org

[.travis.yml validation Web app](http://lint.travis-ci.org) is the easiest way to to validate your `.travis.yml` file.


## Validate .travis.yml With travis-lint (command-line tool)

If you have Ruby 1.8.7+ and RubyGems installed, you can use [travis-lint](http://github.com/travis-ci/travis-lint) to validate your `.travis.yml` file.
Get it with

    gem install travis-lint

and run it on your `.travis.yml`:

    # inside a repository with .travis-yml
    travis-lint
    
    # from any directory
    travis-lint [path to your .travis.yml]

`travis-lint` is young but improving and we are incorporating more and more checks for common issues as
we learn about them from travis-ci.org users.
