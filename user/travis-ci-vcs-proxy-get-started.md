---
title: Getting started with Travis CI using Travis CI VCS Proxy
layout: en
---

## Get Started with Travis CI using Travis CI Proxy (Perforce Helix Core, Apache SVN)

<blockquote class="beta">
  <p>
    This section documents the new TCI VCS Proxy option that is currently in closed beta.
  </p>
</blockquote>

### Closed Beta users

After receiving our sign-up confirmation email, Travis CI Staff creates your Travis CI (TCI) Version Control System (VCS) Proxy account. Once the account is created, you will receive an automatic email message asking for TCI Proxy sign-up confirmation. Next, follow the link and on-screen instructions to set up your 2FA for TCI VCS Proxy.

#### Prerequisites

To get started with Travis CI VCS Proxy, first, you will need:

1. An organization with at least one repository assigned in TCI VCS Proxy. 
2. To configure the repository with appropriate credentials in TCI VCS Proxy. 

For more information read the [Setting up Travis CI VCS Proxy](/user/travis-ci-vcs-proxy/).

#### Steps to geting started

1. Open the received link to Travis CI and select the *Sign up with TCI Proxy* option.

2. Accept the Travis CI´s Authorization email.

3. On the top right of the Travis Dashboard, click on your profile picture and select the *Settings* option. Next, click on the ‘Sync account’ button on the left menu and toggle the repositories you want to use with Travis CI.

4. Add a `.travis.yml` file to your repository to tell Travis CI what to do.

The following example specifies a Ruby project built with Ruby 2.2 and the latest versions of JRuby.

```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
   ```
{: data-file=".travis.yml"}

The defaults for Ruby projects are a `bundle install` to [install dependencies](/user/job-lifecycle/#customizing-the-installation-phase), and `rake` to build the project.

5. Add the `.travis.yml` file to git, commit and push to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file.

 **IMPORTANT**

Perforce depot/repository may be very heavy, so downloading it fully for build (e.g., terabytes of data) is often unwanted, as the source code to be built/tested is only a fraction of the whole depot size. To download it partially, a Travis CI user must define a specific subpath, which is later downloaded by the Travis CI build job. Such subpaths may be defined by using the `perforce_test_path` tag within a `.travis.yml` file. If the property is not provided, the default behavior is downloading the whole depot/repository. See the example below for reference.

   ```yaml
   language: ruby
   rvm:
    - 2.2
    - jruby
  perforce_test_path: /your/subpath/within/repository/which/will/be/downloaded
   ```
   {: data-file=".travis.yml"}
