---
title: Travis CI Onboarding
layout: en
redirect_from:
  - /user/getting-started/
---

This is a short guide to using Travis CI with your cloud platform-hosted code repository. If you're new to continuous integration or would like some more information on what Travis CI does, start with [Core Concepts for Beginners](/user/for-beginners/)
instead.

## Prerequisites

To start using Travis CI, make sure you have the following:

 * A [GitHub](https://github.com/), [Assembla](https://www.assembla.com/), [Bitbucket](https://bitbucket.org/), or [GitLab](https://about.gitlab.com/) account.
 * Owner permissions for a project hosted on [GitHub](https://help.github.com/categories/importing-your-projects-to-github/), [Assembla](https://articles.assembla.com/en/articles/1665737-advanced-user-permissions-controls), [Bitbucket](https://confluence.atlassian.com/bitbucket/transfer-repository-ownership-289964397.html), or [GitLab](https://www.tutorialspoint.com/gitlab/gitlab_user_permissions.htm).

## Get Started with Travis CI

Get started with Travis CI, a continuous integration service used to test and build software projects hosted on [GitHub](https://github.com/), [Assembla](https://www.assembla.com/), [Bitbucket](https://bitbucket.org/), or [GitLab](https://about.gitlab.com/).

1. **Sign up for Travis CI**. 

Go to [Travis-ci.com](https://app.travis-ci.com) and [*Sign-in with your preferred account*](https://app.travis-ci.com/signin).

   ![Travis CI Sign-in](/user/images/onboarding-travis-sign-in.png)

2. **Accept Travis CI Authorization**. 

Once redirected to your chosen platform, log into your account and accept Travis CI’s authorization request. 

  If you have any doubts about the Travis CI access rights to your chosen platform, read more details here:
   * [GitHub Authorized OAuth App](/user/github-oauth-scopes/#travis-ci-github-oauth-app-access-rights).
   * [GitHub permissions used by Travis CI](/user/github-oauth-scopes).
   * [Assembla permissions used by Travis CI](/user/assembla-oauth-scopes/)
   * [BitBucket permissions used by Travis CI](/user/bb-oauth-scopes/)
   * [GitLab permissions used by Travis CI](/user/gl-oauth-scopes/)

3. **Verify your email account**. 

Travis CI sends a verification email. Check your email and verify your account to continue. Otherwise, you will have limited build functions.

4. **Select a Plan**. 

Choose the best plan for you, or get started with our Trial Plan.

   ![Plan Selection](/user/images/onboarding-select-plan.png)

5. **Credit Card Validation**. 

To commence the selected plan, you must first insert your billing information and a valid Credit Card.

   ![Payment Screen](/user/images/onboarding-payment.png)

   > **Note**: For Trial Plans, credit card authorization may result in a small fee being held on the card for a short duration. Trial Plan users are granted a small allotment of trial credits to be used within the next 14 days.

6. **Settings configurations**.

In your Travis Dashboard, click on your profile picture at the top right and select the Settings option to see a list of your available repositories.

7. **Select repositories**.

Click the **Manage Repositories** button. Once directed to your chosen platform, select the repositories you want to use with Travis CI. 

![Manage Repositories](/user/images/onboarding-manage-repositories.png)

> Depending on your chosen platform, you can also make this selection with the authorization message by clicking the *Activate all repositories* button on the Getting Started page to activate all your repos.


## Add a .travis.yml File

The next step is to add a `.travis.yml` file to your repository to tell Travis CI what to do. The following example specifies a Ruby project built with Ruby 2.2 and the latest version of JRuby.

  ```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
   ```
   {: data-file=".travis.yml"}

> The defaults for Ruby projects are `bundle install` to [install dependencies](/user/job-lifecycle/#customizing-the-installation-phase),
   and `rake` to build the project.

Add the `.travis.yml` to a specific location in your repository.

> Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.
Finally, visit [Travis CI](https://app.travis-ci.com) and select your repository to check the build status page to see if your build [passes or fails](/user/job-lifecycle/#breaking-the-build) according to the return status of the build command.

### Assembla .travis.yml File Configuration

<blockquote class="beta">
  <p>
    This section documents the new Assembla option that is currently in beta.
  </p>
</blockquote>

For Assembla users, configure the `.travis.yml` as follows:
1. Git Repository:  in the repositories root (`main` and branches).
2. SVN Repository:
        1. In the `/trunk/` (default is `/trunk/.travis.yml`) for builds to run after commits to `trunk`.
        2. In the `/branches/<branch name>/` (e.g.,`/branches/abc/.travis.yml` for branch named `abc`) for builds to run after commits to a specific branch.
3. P4 (Perforce Helix Core) Repository:
        1. In the `/<depotname>/main/` (default is `/depot/main/.travis.yml`) for builds to run after submits to `/<depotname>/main`.
        2. In the directory respective to specific stream `/depot/<stream name>/`.travis.yml (e.g., `/depot/abc/.travis.yml` for stream `abc`) for builds to run after submits to a specific stream.

 **IMPORTANT**

Perforce depot/repository may be very heavy, so downloading it fully for build (e.g., terabytes of data) is often unwanted, as the source code to be built/tested is only a fraction of the whole depot size. To download it partially, a Travis CI user must define a specific subpath, which is later downloaded by the Travis CI build job. Such subpaths may be defined using the `perforce_test_path` tag within a `.travis.yml` file. If the property is not provided, the default behavior is downloading the whole depot/repository. 

See the example below for reference.

   ```yaml
   dist: focal
   language: ruby
   rvm:
    - 2.2
    - jruby
   perforce_test_path: /your/subpath/within/repository/which/will/be/downloaded
   ```
   {: data-file=".travis.yml"}

Perforce and SVN builds are currently **available only for Linux Ubuntu** and standard amd64 CPU architecture build environments, starting from the Bionic Beaver Ubuntu distribution.


## Switch Accounts

You can easily switch between your cloud platform provider accounts:

1. Click on your account icon in the top right corner on [Travis-ci.com](https://app.travis-ci.com).

2. Select the desired account and have fun using Travis CI.

![Switch Accounts](/user/images/onboarding-settings.png)

## Select a different programming language

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

## Further Reading

Find more useful information in our Tutorial pages:

* [Sign up for Travis](https://youtu.be/IZJJxl9BkmA)
* [Get Started with Travis CI](https://youtu.be/_Og2kydTLWk)
* [Core concepts for Beginners](https://youtu.be/EER3AWu4sqM)
* [Travis CI Tutorials](/user/tutorials/tutorials-overview/)
