---
title: Travis CI Tutorial
layout: en
redirect_from:
  - /user/getting-started/
---

This is a very short guide to using Travis CI with your GitHub hosted code repository.
If you're new to continuous integration or would like some more information on
what Travis CI does, start with [Core Concepts for Beginners](/user/for-beginners)
instead.

## Prerequisites

To start using Travis CI, make sure you have:

 * A [GitHub](https://github.com/) account.
 * Owner permissions for a project [hosted on GitHub](https://help.github.com/categories/importing-your-projects-to-github/).

## To get started with Travis CI

1. Go to [Travis-ci.com](https://travis-ci.com) and [*Sign up with GitHub*](https://travis-ci.com/signin).

2. Accept the Authorization of Travis CI. You'll be redirected to GitHub.

3. Click the green *Activate* button, and select the repositories you want to use with Travis CI.

4. Add a `.travis.yml` file to your repository to tell Travis CI what to do.

   The following example specifies a Ruby project that should
   be built with Ruby 2.2 and the latest versions of JRuby.

   ```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
   ```
   {: data-file=".travis.yml"}

   The defaults for Ruby projects are `bundle install` to [install dependencies](/user/job-lifecycle/#Customizing-the-Installation-Phase),
   and `rake` to build the project.

5. Add the `.travis.yml` file to git, commit and push, to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

6. Check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build), according to the return status of the build command by visiting the [Travis CI](https://travis-ci.com/auth) and selecting your repository.


## Selecting a different programming language

Use one of these common languages:

```yaml
language: ruby
```
{: data-file=".travis.yml"}

```yaml
language: java
```
{: data-file=".travis.yml"}

```yaml
language: node_js
```
{: data-file=".travis.yml"}

```yaml
language: python
```
{: data-file=".travis.yml"}

```yaml
language: php
```
{: data-file=".travis.yml"}

Or pick one from the [full list](/user/languages/).

## Selecting infrastructure (optional)

The best way to determine what infrastructure your build runs on
is to set the `language`. If you do this your build runs on the default
infrastructure (with a few exceptions), which is Container Based Ubuntu 14.04.
You can explicitly select the default infrastructure by adding `sudo: false` to your `.travis.yml`.

* If you need a more customizable environment running in a virtual machine, use the Sudo
Enabled infrastructure:

  ```yaml
  sudo: enabled
  ```
  {: data-file=".travis.yml"}

* If you have tests that need to run on macOS, or your project uses Swift or
Objective-C, use our OS X environment:

  ```yaml
  os: osx
  ```
  {: data-file=".travis.yml"}

  > You do *not* necessarily need to use OS X if you develop on a Mac.
  > OS X is required only if you need Swift, Objective-C or other
  > macOS-specific software.

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
