---
title: Getting started
layout: en

---

The very short guide to using Travis CI with your GitHub hosted code repository.
If you're new to continuous integration or would like some more information on
what Travis CI does, start with [Travis CI for Beginners](/user/for-beginners)
instead.

<div id="toc"></div>

## Prerequisites

To start using Travis CI, make sure you have *all* of the following:

 * [GitHub](https://github.com/) login
 * Project [hosted as a repository](https://help.github.com/categories/importing-your-projects-to-github/) on GitHub
 * Working code in your project
 * Working build or test script

## To get started with Travis CI

1. Using your GitHub account, sign in to either

   * [Travis CI .org](https://travis-ci.org/auth) for public repositories
   * [Travis CI .com](https://travis-ci.com/auth) for private repositories

   and accept the GitHub [access permissions confirmation](/user/github-oauth-scopes).

2. Once you're signed in to Travis CI, and we've synchronized your GitHub
   repositories, go to your profile page and enable the repository
   you want to build: ![enable button](/images/enable.png "enable button")

3. Add a `.travis.yml` file to your repository to tell Travis CI what to do.

   The following example tells Travis CI that this is a Ruby project that should
   be built with Ruby 2.2, and the latest versions of JRuby and Rubinius 2.X.

   ```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
    - rbx-2
   ```
   {: data-file=".travis.yml"}

   The defaults for Ruby projects are `bundle install` to [install dependencies](/user/customizing-the-build/#Customizing-the-Installation-Step),
   and `rake` to build the project.

4. Add the `.travis.yml` file to git, commit and push, to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've enabled the repository in Travis CI.

5. Check the build status page to see if your build [passes or fails](/user/customizing-the-build/#Breaking-the-Build), according to the return status of the build command:

   * [Travis CI .org build status](https://travis-ci.org/auth) for public repositories
   * [Travis CI .com build status](https://travis-ci.com/auth) for private repositories


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

  > You do *not* necessarily need to use OS X if you develop on a Mac, only if
  > you need Swift, Objective-C or other macOS-specific software.

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
