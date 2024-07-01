---
title: Travis CI VCS Proxy
layout: en
---

<blockquote class="beta">
  <p>
    This section documents the new TCI VCS Proxy (Travis CI Version Control System Proxy) option that is currently in closed beta.
  </p>
</blockquote>

## Travis CI VCS Proxy

Travis CI Version Control System Proxy is a connector between Apache SVN or Perforce Helix Core server and Travis CI. It serves the purpose to allow SVN and Perforce users to utilize Travis CI as a build and testing tool.

To use Travis CI with Travis CI VCS Proxy for builds over Perforce Helix Core (P4) and Apache SVN (SVN) repositories, you will need to configure TCI VCS Proxy first. This separate configuration step is required to support both Assembla-based P4/SVN repositories and P4/SVN servers fully managed by you.


Integration supported by TCI VCS Proxy

| Repository type     | Supported integration                | Authorization engine                                    |
| ------------------- | ------------------------------------ | ------------------------------------------------------- |
| Perforce Helix Core | Streams mainline and dev depots only | Ticket-based authorization only                         |
| SVN                 | Apache SVN server only               | svn+ssh (implies SSH keys used) + optionally use realms |

## Prerequisites

You will need:

1. If you are on Assembla Cloud: you need an Assembla Cloud account with `Owner` rights to the space containing P4 or SVN repository.
   - Using SVN, you will need to connect via the `svn+ssh` protocol and prepare at least one SSH key necessary to link the TCI Proxy entry to your SVN  repositories. 
   - To generate the access token for the P4 repository, access the P4 repository via the Command Line Tool which you can grab [here](https://www.perforce.com/products/helix-core-apps/command-line-client).
2. If you host your own P4/SVN server: the server must be reachable via a public network (Internet) w/o VPN connection. In addition, you need admin rights at the server to deploy post-commit hook scripts that send notifications on commits to TCI VCS Proxy. Please verify the `Supported integration` and `Authorization engine` that TCI VCS Proxy integration supports (see table above). Please sign up for closed beta and contact Beta Support email address for more details.
3. Sign-up for closed beta.
4. Google Authenticator application to configure 2-Factor Authentication (2FA) within TCI VCS Proxy.
5. You will receive an email with subsequent instructions.

If you are on Windows when working with Perforce repository, you may want to check [Windows section](/user/travis-ci-vcs-proxy#windows) below in the *P4 CLI Usage* chapter.

## Setting up repositories and organization TCI Proxy

You will go through following major steps in configuration

* In case of Assembla Cloud with P4 or SVN repository
  * Note down certain configuration details from your P4 or SVN repository in Assembla Cloud. 
  * Add Travis Ci VCS Proxy listener token to the Assembla Cloud P4 or SVN repository settings.
  * For Assembla Cloud P4 repository: optionally configure a group with long login timeout (to prevent builds not running due to expired P4 tickets/tokens). 

> Please note, that Assembla Git repositories are not avialable in Travis CI VCS Proxy. These are available after you [directly sign-up to Travis CI using Assembla](/user/tutorial/#to-get-started-with-travis-ci-using-assembla). Travis CI VCS Proxy is a separate connection layer for P4 and SVN servers, as it is meant to connect also self-hosted P4 or SVN servers.
 
* Travis CI VCS Proxy
  * Add an organization.
  * Add at least one repository in the organization, using details acquired e.g. from Assembla Cloud.
  * Note down Travis CI VCS Proxy listener tokens, needed for Assembla Cloud P4 or SVN repositories to report commits. That will, in the end, trigger Travis CI builds.
  * Optionally, invite collaborators to the created organization.

Once you set the 2FA for your account, click on the upper-right profile menu and navigate to the `Repositories` option. You need to scan the QR code first before you enable 2FA. 

<img width="779" alt="Screen Shot 2022-06-13 at 2 58 22 PM" src="https://user-images.githubusercontent.com/20936398/173452347-2077c561-b2b2-46b2-93b7-de8c6d2d044b.png">

### Set up an Organization

The user creating the Organization automatically becomes the `admin` of the Organization in TCI Proxy. See [roles description in TCI Proxy](#roles-in-tci-vcs-proxy) below. To set up an Organization, click on the `Add Organization` button.

1. First, fill in the name, and include a short description. 
2. Fill in the listener token.

Then the important part is the listener token, which is a key needed to successfully send notifications from your P4/SVN repository to the Travis CI Proxy (and from TCI Proxy to Travis CI) upon a commit/push of the changes to the repository. If filled in, please note it down. You will need it later. 

You can read more about the [listener tokens in TCI Proxy](#tci-vcs-proxy-listener-tokens) below.

### Add repository to the Organization

The next step is to add a repository to your Organization. Use the `Add Repository` button to add a repository to the TCI Proxy Organization. Depending on the repository type  - P4 or SVN - you will need specific connection data. 

> In TCI VCS Proxy, a single repository (defined by URL and a repository name) can belong to only one TCI VCS Proxy organization!

#### Assembla - SVN repository

1. In **Assembla**:
    1. First, navigate to your selected SVN Repository, and select the `Source` option.
    2. On the right-hand menu, use the `Checkout` option, **select 'SSH'** and note down both the `REPO_NAME` and the `svn+ssh://` link. You will need these in TCI VS Proxy.
    3. Navigate to your SVN Repository `Settings` option, and select the `Deploy SSH keys` option - add here the **public** key you intend to use with TCI VCS Proxy and Travis CI (or copy an already added one if you wish to). Please refer to [Assembla - using SVN+SSH protocol](https://articles.assembla.com/en/articles/1137042-using-svn-ssh-protocol) for more details.
        - **Please note**: for the integration with Travis CI VCS Proxy you will need a key in PEM format with no passphrase generated, e.g. via `ssh-keygen -t rsa -f test_key_with_no_passphrase -N "" -m PEM` due to Travis CI VCS Proxy conciously not wanting to store your SSH key passwords for automated connection
        - **Please note**: When pasting a public SSH Key in Assembla Repository settings, make sure it has 'write access' checked in order to make the integration with TCI VCS Proxy work. This is current Assembla requirement for authorizing the connection. Neither Travis CI VCS Proxy nor Travis CI requires write access to your repositories - only read access is needed to set up Travis CI VCS Proxy and trigger builds in Travis CI.
    4. Next, navigate to your SVN Repository `Settings` option, and select `Travis VCS Proxy integration` - enter the same listener token previously defined in your TCI VCS Proxy Organization.
2. In **TCI VCS Proxy** (from the `Add Repository` view, `Checkout` -> `SSH` ):
    1. First, select TCI VCS Proxy Organization.
    2. In the `Name` field - paste the REPO_NAME copied from Assembla.
    3. In the `URL` field - paste the **svn+ssh://** url copied from Assembla.
    4. `SVN REALM` - in the case of Assembla, leave the field empty.
    5. `USERNAME` - provide your Assembla user name.
    6. `SSH KEY` - paste the selected private SSH key in the 'Deploy SSH Keys' setting for an Assembla SVN repository.
    7. Click the 'Add Repository' button to complete the configuration.

The first user adding an SVN repository to TCI VCS Proxy organization becomes an ‘admin’ for this repository. Therefore, we recommend Assembla Space owners to perform this action in TCI VCS Proxy.

#### Assembla - P4 repository

1. In **Assembla**:
    1. First, navigate to your selected Perforce Repository, and select the `Instructions` option. Note down the depot link, including the port number. You will need it in TCI VS Proxy.
    2. Next, navigate to your Perforce Repository `Settings` option, select `General settings` - note down the `Repo name`, you will need it in TCI VS Proxy.
    3. Next, navigate to your Perforce Repository `Settings` option, and select the `Travis VCS Proxy integration` option - enter the same listener token previously defined in your TCI VCS Proxy Organization (or, optionally, individual Repository listener token, read more on listener tokens below).
    4. Next, navigate to your Perforce Repository `Settings` option, select the `P4 Admin` option, and create a group with a long or `unlimited` login timeout. This is recommended to prevent constant updates of your credentials in the TCI VCS Proxy. Please follow your team's security policy. 
    5. Finally, assign a user to the group. For your convenience, consider creating a special CI/CD user with an `unlimited` login timeout - you may need access to the user´s password.
2. In the **local command line with P4 CLI** - where a `P4` command-line tool is present, and a connection to Assembla P4 is available and tested:
    1. Use `p4 login -a -p` for the user you want to configure as repository access in the TCI VCS Proxy (e.g., dedicated CI/CD user), login using your Assembla password.
    2. You'll then want to go to Assembla and go to **Settings => Travis VCS Proxy Integration** and copy the token you got from running `p4 login -a -p` there.
    3. Note down the displayed ticket - you will need it in TCI VCS Proxy.
3. In **TCI VCS Proxy** (from the `Add Repository` view):
    1. First, select a TCI VCS Proxy Organization.
    2. In the `Name` field - paste the `Repo name` copied from Assembla. If a problem appears for Assembla P4 repository (`Request failed` on screen error), try putting into `Name` value:  `depot`.
    3. In the `URL` field - paste the link copied from the `Instructions` section in Assembla.
    4. In the `PERFORCE USERNAME` field - provide your Assembla user name (as it may be a dedicated CI/CD user).
    5. In the `Server Level TICKET / TOKEN` field - paste the ticket or token corresponding to the user name, noted down after `p4 login -a -p`. 
    6. Complete the configuration by clicking on the `Add Repository` button.

In the TCI VCS Proxy, the user access rights to the repository are derived from the Perforce Helix Core access rights. Admins and owners are `admins` in TCI VCS Proxy.

> If the credentials/connection data is correct, the repository is created and visible in the `Repositories` screen.

Please note down the minimum required connection details for your collaborators. Due to security reasons, the collaborators will have to repeat explicitly the `Add repository` steps (separate credentials and access rights may be in place).

## P4 Environment Variables 

As stated above you need to make sure your credentials/connection data is correct, so when you ser your final `P4CONFIG` file should look like this: 

```bash
P4PORT=ssl:perforce.assembla.app:xxxx # (The port number will be under the "instructions" tab in Assembla).
P4PASSWD= # This will be set later.
P4USER=MontanaMendy # As an example. 
P4CHARSET=utf8 
P4CLIENT=testspace_j # This is your local client name, choose anything.
```
You can access your P4 environment variables by running in your command line `cat ~/.p4enviro` and if you want to edit your environment variables run `vim ~/.p4enviro` in your command line or use an IDE or text editor of your choice.

## Inviting collaborators to TCI VCS Proxy Organization

To allow users to trigger builds in Travis CI, first, you must add them as members of the organization in the TCI VCS Proxy. 

Please note: Only TCI VCS Proxy users can trigger builds in Travis CI. If a user, who is not a member of the organization in the TCI VCS Proxy but has access to the P4 repository, performs a commit - then the commit will not trigger a build in TCI. Thus, to trigger the build in Travis CI, a subsequent commit must be done by a user recognized by TCI VCS Proxy. Alternatively, you can perform a manual build trigger from the Travis CI user interface to initiate the build. 

In the TCI VCS Proxy, please navigate to the `Repositories` screen and in the list of repositories **click on organization name in a repository row**. This will open screen an `Organization view` for organization linked with the repository, with a list of members and their assigned roles. 

> As of the Beta version, TCI VCS Proxy doesn’t provide a list of created organizations linked to the user account in order to limit various security-related use cases. We're interested in feedback on that part from you.

To invite a collaborator, use the `Invite user` button. The invited collaborator will receive an email notification with the link to activate the account. 

During the closed Beta, a TCI VCS Proxy account is automatically created for the invited collaborator. Invited users should follow the instructions from the email to complete the account configuration process.

> As of the Beta version, once an invited user signs in, TCI VCS Proxy doesn’t present a list of repositories that invited user can access straight after the first login for security reasons.

Once a collaborator signs in to TCI VCS Proxy and sets their 2FA, they can navigate to the `Repositories` screen. First, every user needs to `Add Repository` as explained in the [Add repository to the Organization](#add-repository-to-the-organization) section. During that process collaborator must provide individual access credentials to the repository. Only after that step is completed, the Repository will appear in the list of repositories.

Please note that a TCI VCS Proxy user invited to the organization is actually re-adding a Repository already linked the TCI VCS Proxy organization. If an invited, non-admin (in terms of TCI VCS Proxy Organization role) collaborator tries to add a completely new repository to the existing TCI VCS Proxy organization the action will fail with an error.

> As inconvenient as it may seem, this forces every user to provide correct access credentials to the repository. This process is a one-time action for each repository and aims to protect an individual´s token/ssh keys from being shared unconsciously with other TCI Proxy Users. We prefer a more secure approach to accessing your source code and are curious about your feedback on the subject.

## Roles in TCI VCS Proxy

TCI VCS Proxy implements a very flat role model for smooth data synchronization with Travis CI (organizations, members of organizations, repositories).

### Admin
A TCI VCS Proxy `admin` can:

* Add, edit, or delete the TCI VCS Proxy organization.
* Add, edit, or delete the TCI VCS Proxy repository within the TCI VCS Proxy organization. 

Upon synchronizing of TCI VCS Proxy organization with Travis CI, an `admin` becomes Travis CI organization admin. In the main Travis CI, only admins of organizations can activate/deactivate repositories and select billing plans.

### Member

A TCI VCS Proxy user invited to a TCI VCS Proxy organization can:

* Re-add a TCI VCS Proxy repository previously added to the TCI VCS Proxy organization by the organization admin to make it visible under this person´s account.
* Edit the re-added TCI VCS Proxy repository personal access credentials.

Upon synchronizing of TCI VCS Proxy organization with Travis CI, a `member` becomes a Travis CI organization member. Members in the main Travis CI, have access to respective repository builds and jobs information. TCI VCS Proxy translates user access rights to the single repository (and forwards that information to Travis CI) in accordance with following rule of thumb:

| Repository type | Admin of the repository                       | Write access to the repository         | Read access to the repository |
| --------------- | --------------------------------------------- | -------------------------------------- | ----------------------------- |
| P4 (Perforce)   | derived from owner/admin in P4                | derived from P4 access rights          | derived from P4 access rights |
| SVN             | first user adding repository to TCI VCS Proxy organization | all subsequent users adding repository (write-access can commit and trigger a build) | N/A |


The builds in Travis CI are executed based on the personal access credentials for each account configured in TCI VCS Proxy. Thus, as of now, **only commits performed by the TCI VCS Proxy users with correct P4/SVN credentials may trigger automatic builds in the Travis CI**.

## TCI VCS Proxy listener tokens

TCI VCS Proxy listener tokens are key to authorizing automated notifications from a P4/SVN server to TCI VCS Proxy. This occurs after a source code commit is commenced. Only authorized notifications are parsed by TCI VCS Proxy. Unauthorized P4/SVN post-commit notifications will be ignored and will not trigger builds in Travis CI.

`Organization` listener token.
A token is needed by the SVN and/or P4 post-script hook script to send notifications to the TCI VCS Proxy once the commit is detected. TCI VCS Proxy determines whether this notification should or should not trigger an automatic build in Travis CI.

`Repository` listener token
Applicable for P4 repositories in Assembla. Users can create this token for individual TCI VCS Proxy repositories that must match the respective Assembla P4 repository configuration. The notifications for this particular repository are sent with this autogenerated, different from the `Organization` listener token, which helps limit access to triggering builds from P4 commits; shall the Assembla team deem it necessary.
Such constraints may be beneficial for Assembla spaces with multiple P4 repositories. However, some may contain huge amounts of non-source code assets, which are not always required in automated build and test procedures.

> As of the closed Beta launch, we recommend using individual listener tokens for each Assembla Cloud P4 repository. Meanwhile, we are working on improving the handling of shared TCI Proxy Organization-level listener tokens for your convenience.

## P4 CLI Usage

### Usage 

Below example uses [Assembla Cloud](https://get.assembla.com/perforce/) P4 repository.

Make a directory entitled `p4-test` and then have another directory called `main`. In the `main` directory, make a `.travis.yml` file with the following directions:

```yaml
language: ruby
   rvm:
    - 2.2
    - jruby
```

Here's some sample environment variables: 

```bash
P4PORT=ssl:p4-us.assembla.com:30920
P4HOST=travis-ci-ext/Travis-CI-P4-and-SVN-demo-space.8
P4CLIENT=montana6
P4USER=MontanaMendy
P4_ssl:p4-us.assembla.com:30920_CHARSET=auto
P4CONFIG=.p4config
```
In `P4CLIENT` put what your workspace name is (can be anything), then run the following: 

```bash
p4 client -S //depot/main -o | p4 client -i
```

The above command will save your `P4CLIENT` setting and then set it, so when you `reconcile` the proper files get pushed to Assembla. Then make sure you go back to your environment variables to make sure they haven't changed: 

```bash
 vim ~/.p4enviro
 ```
 
Then make sure your `p4 info` matches to your environment variables, then run: 

```bash
p4 reconcile
```

Then push up your files: 

```bash
p4 submit -d "import"
```

### Windows

If you're using Windows to push changes into Perforce Helix Core repository in Assembla, please check also:

<a href="https://articles.assembla.com/en/articles/998589-get-started-with-perforce-using-p4v" target="_blank">Get Started with Perforce Using P4V</a> 

This article shows how to set up local visual P4 client on Windows machine to interact with your P4 repository. 

Please note that actual builds in Travis CI over P4 source code are executed within Linux build environment.


### VCS Proxy 

You'll want to make sure your repository is showing up on Travis CI VCS Proxy, it should look like this if you were successful:

<img width="1298" alt="Screen Shot 2022-06-14 at 11 10 35 PM" src="https://user-images.githubusercontent.com/20936398/173755224-e22a9177-d64c-42f1-aeb7-fc4c0739bc10.png">

Check back on Assembla and see if your files are there, it should look like this:

<img width="846" alt="Screen Shot 2022-06-14 at 11 06 40 PM" src="https://user-images.githubusercontent.com/20936398/173754520-ba44a32e-bd5b-4845-9a73-ade01f485e0d.png">

After you pushed successfully, with your Assembla username, you can see my `.travis.yml` in Assembla. That will ultimately trigger a build in Travis CI Beta App on Perforce sources: 

<img width="661" alt="Screen Shot 2022-06-14 at 11 08 20 PM" src="https://user-images.githubusercontent.com/20936398/173754690-cc112ee0-1ca0-486e-84d8-252eb59acad6.png">

### More on Assembla Cloud Perforce 

You may find more of the useful information in <a href="https://articles.assembla.com/en/collections/33902-using-perforce" target="_blank">Assembla articles on working with Perforce Helix Core<a/>. 

## I want to build with Travis CI

Once the Travis CI VCS Proxy configuration is ready for at least one organization and repository, please follow the instructions in [Getting started with Travis CI using Travis CI VCS Proxy](/user/travis-ci-vcs-proxy-get-started/).

The general workflow is summarized in the following picture:

![P4 SVN TCI drawing](/user/images/P4_SVN_TCI_drawing.png)
