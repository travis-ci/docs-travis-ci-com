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

   This example tells Travis CI that this is a Ruby project, so unless you change the default, Travis CI uses `rake` to build it.

   Travis CI tests this project against Ruby 2.2 and the latest versions of JRuby and Rubinius.

   ```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
    - rbx-2
   ```

4. Add the `.travis.yml` file to git, commit and push, to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've enabled the repository in Travis CI.

5. Check the [build status](https://travis-ci.org/repositories) page to see if your build passes or fails, according to the return status of the build command. The previous example will have three jobs, which can pass or fail independently.

## Selecting infrastructure

The most straight forward way to determine what infrastructure your build runs on is to set the `language` as we did in the previous example. But sometimes you have more complex requirements that require explicitly selecting a particular infrastructure on which to run your build.

## Selecting a programming language

Use one of these common languages:

```yaml
language: ruby
language: java
language: node_js
language: android
language: php
```

Or pick one from the [full list](/user/languages/index/).

## After the build

After a succesful build there are many things you can do with the results of your code:

* upload pages websites or documentation
* run apps on Heroku
* upload RubyGems

## Further Reading

Read more about

* [customizing your build](/user/customizing-the-build)
* build stages
* [installing dependencies](/user/installing-dependencies)
* [setting up databases](/user/database-setup/)
* build matrixes
