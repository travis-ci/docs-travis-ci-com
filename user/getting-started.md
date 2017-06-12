---
title: Getting started
layout: en
permalink: /user/getting-started/
---

The very short guide to using Travis CI with your GitHub hosted code repository. If you're new to continuous integration or would like some more information on what Travis CI does, start with [Travis CI for Complete Beginners](/user/for-beginners) instead.

<div id="toc"></div>

## To get started with Travis CI

You'll need a GitHub account with admin access to at least one repository, and ideally you'll already have a working build script that you run manually.

1. [Sign in to Travis CI](https://travis-ci.org/auth) with your GitHub account, accepting the GitHub [access permissions confirmation](/user/github-oauth-scopes).

2. Once you're signed in, and we've synchronized your GitHub repositories, go to your [profile page](https://travis-ci.org/profile) and enable Travis CI for the *open source* repository you want to build. If you want to build a private repository, sign in to [Travis CI for private repositories](https://travis-ci.com/profile) instead.

3. Add a `.travis.yml` file to your repository to tell Travis CI what to build.

   This example tells Travis CI that this is a Ruby project, so unless you change the default, Travis CI uses `bundle install` to [install dependencies](/user/customizing-the-build/#Customizing-the-Installation-Step), and `rake` to build it.

   Travis CI tests this project against Ruby 2.2 and the latest versions of JRuby and Rubinius, which can all pass or fail independently.


   ```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
    - rbx-2
   ```
   {: data-file=".travis.yml"}

4. Add the `.travis.yml` file to git, commit and push, to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've enabled the repository in Travis CI.

5. Check the [build status](https://travis-ci.org/repositories) page to see if your build [passes or fails](/user/customizing-the-build/#Breaking-the-Build), according to the return status of the build command.

## Selecting a programming language

Use one of these common languages:

```yaml
language: ruby
```

```yaml
language: java
```

```yaml
language: node_js
```

```yaml
language: python
```

```yaml
language: php
```

Or pick one from the [full list](/user/languages/).

## Selecting infrastructure (optional)

The most straightforward way to determine what infrastructure your build runs on
is to set the `language`. If you do this your build runs on the default
infrastructure (with a few exceptions), which is Container Based Ubuntu 12.04.
You can explicitly select the default infrastructure by adding `sudo: false` to your `.travis.yml`.

* If you need a more up-to-date version of Ubuntu on the same infrastructure, use
the beta of Ubuntu Linux Trusty 14.04:

   ```yaml
   sudo: false
   dist: trusty
   ```

* If you need a more customizable environment running in a virtual machine, use the Sudo
Enabled infrastructure:

  ```yaml
  sudo: enabled
  ```

* Sudo Enabled infrastructure also has a beta of a more up-to-date Ubuntu Linux
Trusty 14.04:

  ```yaml
  sudo: enabled
  dist: trusty
  ```

* If you have tests that need to run on macOS, or your project uses Swift or
Objective-C, use our OS X environment:

  ```yaml
  os: osx
  ```

  > You do *not* necessarily need to use OS X if you develop on a Mac, only if
  > you need Swift, Objective-C or other macOS software.

## More than running tests

Travis CI isn't just for running tests, there are many others things you can do with your code:

* deploy to [GitHub pages](/user/deployment/pages/)
* run apps on [Heroku](/user/deployment/heroku/)
* upload [RubyGems](/user/deployment/rubygems/)
* send [notifications](/user/notifications/)

## Further Reading

Read more about

* [customizing your build](/user/customizing-the-build)
* [security best practices](/user/best-practices-security/)
* [build stages](/user/build-stages/)
* [build matrixes](/user/customizing-the-build/#Build-Matrix)
* [installing dependencies](/user/installing-dependencies)
* [setting up databases](/user/database-setup/)
