---
title: Travis CI for Complete Beginners
layout: en
permalink: /user/for-beginners/
---

If you're not familiar with continuous integration and don't already have a repository that you want to build, this guide will show you what it is all about.

You need to sign up for a [GitHub account](https://github.com/) if you do not already have one.

### To get started with Travis CI:

1. On GitHub, fork the [example PHP repository](https://github.com/plaindocs/travis-broken-example).

2. [Sign in to Travis CI](https://travis-ci.org/auth) with your GitHub account, accepting the GitHub [access permissions confirmation](/user/github-oauth-scopes).

2. Once you're signed in, and we've synchronized your repositories from GitHub, go to your [profile page](https://travis-ci.org/profile) and enable
Travis CI builds for your fork of the `travis-broken-example` repository.

	> Note: You can only enable Travis CI builds for repositories you have admin access to.  

2. Take a look at `.travis.yml`, the file which tells Travis CI what to do:

   ```yaml
   language: php
   php:
   - 5.5
   - 5.4
   - hhvm
   script: phpunit Test.php
   ```

   This file tells Travis CI that this project is written in PHP, and to test `Test.php` with phpunit against PHP versions 5.5, 5.4 and HHVM.

2. Edit the empty `NewUser.txt` file by adding your name to the empty file. Add the file to git, commit and push, to trigger a Travis CI build:

   ```bash
   $ git add -A
   $ git commit -m 'Testing Travis CI'
   $ git push
   ```

	> Note: Travis only runs a build on the commits you push after adding the repository to Travis.

	Wait for Travis CI to run a build on your fork of the `travis-broken-example` repository, check the [build status](https://travis-ci.org/repositories) and notice that the build fails. (Travis CI sends you an email when this happens)

2. Fix the code by making sure that `2=1+1` in `Test.php`, commit and push to GitHub. This time, the build does not fail.


   ```bash
   $ git add -A
   $ git commit -m 'Testing Travis CI: fixing the build'
   $ git push
   ```

Congratulations, you have added a GitHub repository to Travis and learnt the basics of configuring builds and testing code.

> Note there is no need to make a pull request to the original repository, the build is run on your fork.
