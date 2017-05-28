---
title: Getting started
layout: en
permalink: /user/getting-started/
---

The very short guide to using Travis CI with your GitHub hosted code repository. Totally new to all this? Try reading [Travis CI for Complete Beginners](/user/for-beginners) instead.

Or if you want a more complete guide to a particular language, pick one of these:

{% include languages.html %}

### To get started with Travis CI:

1. [Sign in to Travis CI](https://travis-ci.org/auth) with your GitHub account, accepting the GitHub [access permissions confirmation](/user/github-oauth-scopes).

2. Once you're signed in, and we've synchronized your repositories from GitHub, go to your [profile page](https://travis-ci.org/profile) and enable Travis CI for the repository you want to build.

   > Note: You can only enable Travis CI builds for repositories you have admin access to.

3. Add a `.travis.yml` file to your repository to tell Travis CI what to build:

   ```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
    - rbx-2
   # uncomment and edit the following line if your project needs to run something other than `rake`:
   # script: bundle exec rspec spec
   ```

   This example tells Travis CI that this is a project written in Ruby and built with `rake`. Travis CI tests this project against Ruby 2.2 and the latest versions of JRuby and Rubinius.

4. Add the `.travis.yml` file to git, commit and push, to trigger a Travis CI build:

   > Travis only runs a build on the commits you push **after** adding the repository to Travis.

5. Check the [build status](https://travis-ci.org/repositories) page to see if your build passes or fails.

Make sure you're aware of [security best practices](/user/best-practices-security/) when [customizing your build](/user/customizing-the-build), [installing dependencies](/user/installing-dependencies) or [setting up a Database](/user/database-setup/). Or maybe you just want more information about the [test environment](/user/ci-environment/)?
