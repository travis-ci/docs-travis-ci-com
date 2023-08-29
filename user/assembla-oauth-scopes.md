---
title: Travis CI's use of Assembla API
layout: en
permalink: /user/assembla-oauth-scopes/

---

When you sign in to Travis CI for the first time, we ask for permissions to access
some of your data on Assembla. Read the
[Scopes for the Assembla REST API](https://api-docs.assembla.cc/)
for general information about this, or pick an explanation of what data we need and why we need it.

## Travis CI for Open Source and Private Projects

On <https://travis-ci.com>, via our Assembla integration, we ask for the following permissions:

- Read access to code
- Read access to metadata and pull requests
- Read and write access to administration, checks, commit statuses, and deployments

## WebHooks

We use scoped OAuth tokens to integrate with Assembla.

## Used Scopes

### repository
Gives the app read access to all the repositories the authorizing user has access to.
> This scope does not give access to a repository's pull requests.

### repository:admin
Gives the app admin access to all the repositories the authorizing user has access to. This permission is needed to add the access key. Travis CI uses the key to read the travis.yml file content.


### pullrequest
Gives the app read access to pull requests and collaborate on them. This scope implies repository, giving read access to the pull request's destination repository.

### email
Ability to see the user's primary email address. This should make it easier to use Assembla as a login provider to apps or external applications.

### account
Ability to see all the user's account information. Note that this does not include any ability to mutate any of the data.

### team
The ability to find out what teams the current user is part of. This is covered by the teams endpoint.

### webhook
Gives access to webhooks. This scope is required for any webhook related operation.

This scope gives read access to existing webhook subscriptions on all resources you can access, without needing further scopes.
This means that a client can list all existing webhook subscriptions on repository foo/bar (assuming the principal user has access
to this repo). The additional repository scope is not required for this.

Likewise, existing webhook subscriptions for a repo's issue tracker can be retrieved without holding the issue scope.
All that is required is the webhook scope.

However, to create a webhook for issue:created, the client will need to have both the webhook as well as issue scope.

## Version Control System specific information

Aside from Git Repository integration, Travis CI supports following VCS (Version Control System) integartions with Assembla:

| Repository type     | Supported integration                | Authorization engine                                    |
| ------------------- | ------------------------------------ | ------------------------------------------------------- |
| Perforce Helix Core | Streams mainline and dev depots only | Ticket-based authorization only                         |
| SVN                 | Apache SVN server only               | svn+ssh (implies SSH keys used) + optionally use realms |

### SVN

When enabling Assembla SVN Repository in Travis CI, the 'write access' SSH deploy key with title 'travis-ci.com' is 
added to the Assembla SVN Repository Settings. This is current Assembla requirement for authorizing the connection. 
Travis CI does not require write access to your repositories - only read access is needed to set up the connection and 
trigger builds in Travis CI. 
The svn+ssh protcol is used to obtain SVN repository copy into the ephemerical build job environment for the time 
needed to execute build instructions.

### Perforce Helix Core (P4)

When enabling Assembla P4 Repository in Travis CI, special access group is created for this P4 repository in Assembla. 
You can see it in the respective 'P4 Admin' section for enabled P4 repository. It will be named 'TravisCIAccessGroup-<guid>'
and login timeout for the group will be set so the ticket based authorization does not expire until repository is disabled 
in Travis CI. The group will contain the Assembla user enabling repository in Travis CI.
This is required for Travis CI build job to communicate with Assembla P4 and obtain copy of source code to the ephemerical
build job environment for the time needed to execute build instructions.
