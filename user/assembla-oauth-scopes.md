---
title: Travis CI's use of Assembla API
layout: en
permalink: /user/assembla-oauth-scopes/

---

When you sign in to Travis CI for the first time, we ask permission to access
some of your data on Assembla. Read the
[Scopes for the Assembla REST API](https://api-docs.assembla.cc/)
for general information about this, or pick an explanation of what data we need and why we need it.

## Travis CI for Open-Source and Private Projects

On <https://travis-ci.com>, via our Assembla integration, we ask for the following permissions:

- Read access to code
- Read access to metadata and pull requests
- Read and write access to administration, checks, commit statuses, and deployments

## WebHooks

We use scoped OAuth tokens to integrate with Assembla.

## Used Scopes

The following sections show the different scopes used.

### repository
It gives the app read access to all the repositories the authorizing user has access to.
> This scope does not give access to a repository's pull requests.

### repository:admin
It gives the app admin access to all the repositories the authorizing user has access to. This permission is needed to add the access key. Travis CI uses the key to read the travis.yml file content.


### pull-request
It gives the app read access to pull requests and collaborate on them. This scope implies a repository giving read access to the pull request's destination repository.

### email
The ability to see the user's primary email address. This should make using Assembla as a login provider to apps or external applications easier.

### account
The ability to see all the user's account information. Note that this does not include any ability to mutate the data.

### team
The ability to find out what teams the current user is part of. The teams' endpoint covers this.

### webhook
Gives access to webhooks. This scope is required for any webhook-related operation.

This scope gives read access to existing webhook subscriptions on all resources you can access without needing further scopes.
This means a client can list all existing webhook subscriptions on repository foo/bar (assuming the principal user can access
this repo). The additional repository scope is not required for this.

Likewise, existing webhook subscriptions for a repo's issue tracker can be retrieved without holding the issue scope.
All that is required is the webhook scope.

However, to create a webhook for issue:created, the client will need to have both the webhook as well as issue scope.

## Version Control System Specific Information

Aside from Git Repository integration, Travis CI supports the following VCS (Version Control System) integrations with Assembla:

| Repository type     | Supported integration                | Authorization engine                                    |
| ------------------- | ------------------------------------ | ------------------------------------------------------- |
| Perforce Helix Core | Streams mainline and dev depots only | Ticket-based authorization only                         |
| SVN                 | Apache SVN server only               | svn+ssh (implies SSH keys used) + optionally use realms |

### SVN

When enabling the Assembla SVN Repository in Travis CI, the 'write access' SSH deploy key with the title 'travis-ci.com' is 
added to the Assembla SVN Repository Settings. This is the current Assembla requirement for authorizing the connection. 
Travis CI does not require write access to your repositories. Only read access is needed to set up the connection and 
trigger builds in Travis CI. 
The svn+ssh protocol is used to obtain an SVN repository copy into the ephemerical build job environment for the time 
needed to execute build instructions.

### Perforce Helix Core (P4)

When enabling the Assembla P4 Repository in Travis CI, a special access group is created for this P4 repository in Assembla. 
You can see it in the respective 'P4 Admin' section for the enabled P4 repository. It will be named 'TravisCIAccessGroup-<guid>'
and login timeout for the group will be set so the ticket-based authorization does not expire until the repository is disabled 
in Travis CI. The group will contain the Assembla user-enabling repository in Travis CI.
This is required for the Travis CI build job to communicate with Assembla P4 and obtain a copy of the source code to the ephemerical
build job environment for the time needed to execute build instructions.
