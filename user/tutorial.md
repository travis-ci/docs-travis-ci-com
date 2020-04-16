---
title: Travis CI Tutorial
layout: en
redirect_from:
  - /user/getting-started/
---

This is a very short guide to using Travis CI with your cloud platform hosted code repository.
If you're new to continuous integration or would like some more information on
what Travis CI does, start with [Core Concepts for Beginners](/user/for-beginners)
instead.

## Prerequisites

To start using Travis CI, make sure you have:

 * A [GitHub](https://github.com/) or [Bitbucket](https://bitbucket.org/) account.
 * Owner permissions for a project hosted on [GitHub](https://help.github.com/categories/importing-your-projects-to-github/) or [Bitbucket](https://confluence.atlassian.com/bitbucket/transfer-repository-ownership-289964397.html).

## To get started with Travis CI using GitHub

1. Go to [Travis-ci.com](https://travis-ci.com) and [*Sign up with GitHub*](https://travis-ci.com/signin).

2. Accept the Authorization of Travis CI. You'll be redirected to GitHub.

3. Click on your profile picture in the top right of your Travis Dashboard, click Settings and then the green *Activate* button, and select the repositories you want to use with Travis CI.

> Or you click the *Activate all respositories using GitHub Apps* button on the getting started page to just activate all your repos

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

   The defaults for Ruby projects are `bundle install` to [install dependencies](/user/job-lifecycle/#customizing-the-installation-phase),
   and `rake` to build the project.

5. Add the `.travis.yml` file to git, commit and push to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

6. Check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build) according to the return status of the build command by visiting [Travis CI](https://travis-ci.com/auth) and selecting your repository.

## To get started with Travis CI using Bitbucket

<blockquote class="beta">
  <p>
    This section documents the new Bitbucket option that is currently in beta.
  </p>
</blockquote>

1. Go to [Travis-ci.com](https://travis-ci.com) and [*Sign up with Bitbucket*](https://travis-ci.com/signin).

2. Accept the Authorization of Travis CI. You'll be redirected to Bitbucket.

3. Click on your profile picture in the top right of your Travis Dashboard, click *Settings*, and toggle the repositories you want to use with Travis CI.

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

   The defaults for Ruby projects are `bundle install` to [install dependencies](/user/job-lifecycle/#customizing-the-installation-phase),
   and `rake` to build the project.

5. Add the `.travis.yml` file to git, commit and push to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

6. Check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build) according to the return status of the build command by visiting [Travis CI](https://travis-ci.com/auth) and selecting your repository.

## Switching accounts

You can easily switch between your cloud platform provider accounts:

1. Click on your account icon in the top right corner on [Travis-ci.com](https://travis-ci.com).

2. Select the desired account and have fun using Travis CI.


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

```yaml
language: go
```
{: data-file=".travis.yml"}

If you have tests that need to run on macOS or your project uses Swift or
Objective-C, use our macOS environment:

```yaml
os: osx
```
{: data-file=".travis.yml"}

> You do *not* necessarily need to use macOS if you develop on a Mac.
> macOS is required only if you need Swift, Objective-C, or other
> macOS-specific software.

Travis CI supports many [programming languages](/user/languages/).

## More than running tests

Travis CI isn't just for running tests, there are many other things you can do with your code:

* deploy to [GitHub pages](/user/deployment/pages/)
* run apps on [Heroku](/user/deployment/heroku/)
* upload [RubyGems](/user/deployment/rubygems/)
* send [notifications](/user/notifications/)

## Further Reading

Read more about

* [customizing your build](/user/customizing-the-build)
* [security best practices](/user/best-practices-security/)
* [build stages](/user/build-stages/)
* [build matrixes](/user/customizing-the-build/#build-matrix)
* [installing dependencies](/user/installing-dependencies)
* [setting up databases](/user/database-setup/)
