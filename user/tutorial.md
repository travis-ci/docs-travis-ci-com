---
title: Travis CI Tutorial
layout: en
redirect_from:
  - /user/getting-started/
---

This is a short guide to using Travis CI with your cloud platform-hosted code repository.
If you're new to continuous integration or would like some more information on
what Travis CI does, start with [Core Concepts for Beginners](/user/for-beginners)
instead.

## Prerequisites

To start using Travis CI, make sure you have:

 * A [GitHub](https://github.com/), [Assembla](https://www.assembla.com/), [Bitbucket](https://bitbucket.org/), or [GitLab](https://about.gitlab.com/) account.
 * Owner permissions for a project hosted on [GitHub](https://help.github.com/categories/importing-your-projects-to-github/), [Assembla](https://articles.assembla.com/en/articles/1665737-advanced-user-permissions-controls), [Bitbucket](https://confluence.atlassian.com/bitbucket/transfer-repository-ownership-289964397.html), or [GitLab](https://www.tutorialspoint.com/gitlab/gitlab_user_permissions.htm).

## To get started with Travis CI using GitHub

1. Go to [Travis-ci.com](https://app.travis-ci.com) and [*Sign up with GitHub*](https://app.travis-ci.com/signin).

2. Accept the Authorization of Travis CI. You'll be redirected to GitHub. For any doubts about the Travis CI GitHub Authorized OAuth App access rights message, please read more details [below](/user/tutorial#travis-ci-github-oauth-app-access-rights)

3. Click on your profile picture in the top right of your Travis Dashboard, click Settings, and then the green *Activate* button, and select the repositories you want to use with Travis CI.

> Or click the *Activate all repositories using GitHub Apps* button on the Getting Started page to activate all your repos.

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

5. Add the `.travis.yml` file to git, commit, and push to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

6. Check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build) according to the return status of the build command by visiting [Travis CI](https://app.travis-ci.com) and selecting your repository.

#### Travis CI GitHub OAuth App access rights

{{ site.data.snippets.github_oauth_access_rights }}

Read more about it: [GitHub permissions used by Travis CI](/user/github-oauth-scopess).

## To get started with Travis CI using Assembla

<blockquote class="beta">
  <p>
    This section documents the new Assembla option that is currently in beta.
  </p>
</blockquote>

1. Go to [Travis-ci.com](https://app.travis-ci.com) and [*Sign up with Assembla*](https://app.travis-ci.com/signin).

2. Accept the Authorization of Travis CI. You'll be redirected to Assembla.

3. Click on your profile picture in the top right of your Travis Dashboard, click *Settings*, and toggle the repositories you want to use with Travis CI.

4. Create a `.travis.yml` in your repository to tell Travis CI what to do.

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

5. Add the `.travis.yml` file to a specific location in your repository:
    1. Git Repository: in the root of the repository (`main` and branches). 
    2. SVN Repository: 
        1. In the `/trunk/` (default is `/trunk/.travis.yml`) for builds to run after commits to `trunk`.
        2. In the `/branches/<branch name>/` (e.g.,`/branches/abc/.travis.yml` for branch named `abc`) for builds to run after commits to a specific branch.
    3. P4 (Perforce Helix Core) Repository:
        1. In the `/<depotname>/main/` (default is `/depot/main/.travis.yml`) for builds to run after submits to `/<depotname>/main`.
        2. In the directory respective to specific stream `/depot/<stream name>/`.travis.yml (e.g., `/depot/abc/.travis.yml` for stream `abc`) for builds to run after submits to a specific stream.

6. Commit and push/submit to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

7. Check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build) according to the return status of the build command by visiting [Travis CI](https://app.travis-ci.com) and selecting your repository.

 **IMPORTANT**

Perforce depot/repository may be very heavy, so downloading it fully for build (e.g., terabytes of data) is often unwanted, as the source code to be built/tested is only a fraction of the whole depot size. To download it partially, a Travis CI user must define a specific subpath, which is later downloaded by the Travis CI build job. Such subpaths may be defined using the `perforce_test_path` tag within a `.travis.yml` file. If the property is not provided, the default behavior is downloading the whole depot/repository. See the example below for reference.

   ```yaml
   dist: focal
   language: ruby
   rvm:
    - 2.2
    - jruby
   perforce_test_path: /your/subpath/within/repository/which/will/be/downloaded
   ```
   {: data-file=".travis.yml"}

Perforce and SVN builds are currently **available only for Linux Ubuntu** and standard amd64 CPU architecture build environments, starting from Bionic Beaver Ubuntu distribution.

#### Travis CI access rights to Assembla

Read more about it: [Assembla permissions used by Travis CI](/user/assembla-oauth-scopes).

## To get started with Travis CI using Bitbucket

<blockquote class="beta">
  <p>
    This section documents the new Bitbucket option that is currently in beta.
  </p>
</blockquote>

1. Go to [Travis-ci.com](https://app.travis-ci.com) and [*Sign up with Bitbucket*](https://app.travis-ci.com/signin).

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

5. Add the `.travis.yml` file to git, commit, and push to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

6. Check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build) according to the return status of the build command by visiting [Travis CI](https://app.travis-ci.com) and selecting your repository.

#### Travis CI access rights to BitBucket

Read more about it: [BitBucket permissions used by Travis CI](/user/bb-oauth-scopes).

## Get started with Travis CI using GitLab

<blockquote class="beta">
  <p>
    This section documents the new GitLab option that is currently in beta.
  </p>
</blockquote>

1. Go to [Travis-ci.com](https://app.travis-ci.com) and [*Sign up with GitLab*](https://app.travis-ci.com/signin).

2. Accept the Authorization of Travis CI. You'll be redirected to GitLab.

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

5. Add the `.travis.yml` file to git, commit, and push to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

6. Check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build) according to the return status of the build command by visiting [Travis CI](https://app.travis-ci.com) and selecting your repository.

#### Travis CI access rights to GitLab

Read more about it: [GitLab permissions used by Travis CI](/user/gl-oauth-scopes).

## Switching accounts

You can easily switch between your cloud platform provider accounts:

1. Click on your account icon in the top right corner on [Travis-ci.com](https://app.travis-ci.com).

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

Travis CI isn't just for running tests. There are many other things you can do with your code:

* deploy to [GitHub pages](/user/deployment/pages/)
* run apps on [Heroku](/user/deployment/heroku/)
* upload [RubyGems](/user/deployment/rubygems/)
* send [notifications](/user/notifications/)

## Further Reading

Read more about:

* [customizing your build](/user/customizing-the-build)
* [shared build configuration imports](/user/build-config-imports)
* [security best practices](/user/best-practices-security/)
* [build stages](/user/build-stages/)
* [build matrixes](/user/customizing-the-build/#build-matrix)
* [installing dependencies](/user/installing-dependencies)
* [setting up databases](/user/database-setup/)
