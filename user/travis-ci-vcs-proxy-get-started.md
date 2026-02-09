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

After receiving our sign-up confirmation email, our staff will create your Travis CI (TCI) Version Control System (VCS) Proxy account. Once the account is created, you will receive an automatic email message asking for TCI Proxy sign-up confirmation. Next, follow the link and on-screen instructions to set up your 2FA for TCI VCS Proxy.

After you sign up to Travis CI using Travis CI VCS Proxy, we will review the account and assign you a Beta Plan in Travis CI. You may use standard Trial Plan until the Beta Plan is assigned. 

#### Prerequisites

To get started with Travis CI VCS Proxy, first, you will need:

1. An organization with at least one repository assigned in TCI VCS Proxy. 

2. To configure the repository with the appropriate credentials in TCI VCS Proxy, in particular tokens.

For more information read the [Setting up Travis CI VCS Proxy](/user/travis-ci-vcs-proxy/).

#### Steps to geting started

1. Open the received link to Travis CI and select the *Sign up with TCI Proxy* option.
When you do it for the first time, a Travis CI VCS Proxy page will pop-up with an `Authorize` button present. Pressing the button will tell Travis CI VCS Proxy that Travis CI is authorized to obtain organizations, repositories, commit notifications and user emails (for build status notifications, shall you enable these) from Travis CI VCS Proxy. After first authorization it will occur automatically if you log into Travis CI Beta application in the same browser (and site data is not removed).

2. Accept the Travis CI´s Authorization email. 
> *Please note:* The Beta Travis CI application with support for Travis CI VCS Proxy and regular application are both working in the same Production environment (so once the beta is closed, you can preserve all set up if you wish to). Thus Travis CI Authorization email link may lead you to the main *app.travis-ci.com*. In such case please return to the Travis CI beta application [URL](https://beta-app.travis-ci.com). You can find it in the Travis CI VCS Proxy welcome e-mail.

3. You should now see this option when you click "Sign in":

<img width="669" alt="Screen Shot 2022-06-14 at 10 49 53 AM" src="https://user-images.githubusercontent.com/20936398/173655519-d30b1758-ca8b-4696-9425-5735e13d903b.png">

4. On the top right of the Travis Dashboard, click on your profile picture and select the *Settings* option. Next, click on the ‘Sync account’ button on the left menu and toggle the repositories you want to use with Travis CI. 
> *Please note:* If the synchronization operation doesn't refresh your Travis CI screen automatically within 1 minute, please refresh your browser window manually (Ctrl/Cmd + F5).

5. Please select a Trial Plan or wait for us to assign special Beta Plan to your account and/or organization(s). In Travis CI each individual User account and each Organization entity must have a separate plans assigned.
> *Please note:* If assigning a plan doesn't remove automatically the insufficient user license/lack of credits error message in your Travis CI Beta application screen, please refresh your browser window manually (Ctrl/Cmd + F5).

6. Create a `.travis.yml` file to tell Travis CI what to do.

The following example specifies a Ruby project built with Ruby 2.2 and the latest versions of JRuby.

```yaml
   dist: focal
   language: ruby
   rvm:
    - 2.2
    - jruby
   ```
{: data-file=".travis.yml"}

The defaults for Ruby projects are a `bundle install` to [install dependencies](/user/job-lifecycle/#customizing-the-installation-phase), and `rake` to build the project.

7. Add the `.travis.yml` file to repository, commit to the repository to trigger a Travis CI build:

   > Travis only runs builds on the commits you push *after* you've added a `.travis.yml` file. As of now, only commits performed by the TCI VCS Proxy users with correct P4/SVN credentials may trigger automatic builds in the Travis CI.

You must create `.travis.yml` file in specific path in the repository, depending on whether you use SVN or Perforce Helix Core (Perforce). 

In case of SVN: 

Travis CI watches the **/trunk/.travis.yml** by default.
Whenever configured to build from branch, e.g. branch named **abc**, Travis CI watches **/branches/abc/.travis.yml**

In case of Perforce:

Travis CI watches the **/depotname/main/.travis.yml** by default, so if depot name is e.g. **depot** - Travis CI expects **/depot/main/.travis.yml**.
Respectively, if a separate stream (e.g. **abc**) is created within depot (e.g. **depot**) and build is configured to build from specific stream, Travis CI expects **/depot/abc/.travis.yml** to be present in order to trigger the build upon submitting changes.

 
 **IMPORTANT**

Perforce depot/repository may be very heavy, so downloading it fully for build (e.g., terabytes of data) is often unwanted, as the source code to be built/tested is only a fraction of the whole depot size. To download it partially, a Travis CI user must define a specific subpath, which is later downloaded by the Travis CI build job. Such subpaths may be defined by using the `perforce_test_path` tag within a `.travis.yml` file. If the property is not provided, the default behavior is downloading the whole depot/repository. See the example below for reference.

   ```yaml
   dist: focal
   language: ruby
   rvm:
    - 2.2
    - jruby
   perforce_test_path: /your/subpath/within/repository/which/will/be/downloaded
   ```
   {: data-file=".travis.yml"}


Perforce and SVN builds during Closed Beta are **available only for Linux Ubuntu, Bionic Beaver and Focal Fossa** and standard amd64 CPU architecture build environments. In order to use these, following tags must be used in the `.travis.yml`:

   ```yaml
   dist: bionic
   ```
   {: data-file=".travis.yml"}

or

   ```yaml
   dist: focal
   ```
   {: data-file=".travis.yml"}
