---
title: Travis CI's use of Bitbucket API Scopes
layout: en

---

When you sign in to Travis CI for the first time, we ask for permissions to access
some of your data on Bitbucket. Read the
[Scopes for the Bitbucket Cloud REST API](https://developer.atlassian.com/cloud/bitbucket/bitbucket-cloud-rest-api-scopes/)
for general information about this, or pick an explanation of what data we need and why we need it.

## Travis CI for Open Source and Private Projects

On <https://travis-ci.com>, via our Bitbucket integration, we ask for the following permissions:

- Read access to code
- Read access to metadata and pull requests
- Read and write access to administration, checks, commit statuses, and deployments

## WebHooks

We use scoped OAuth tokens to integrate with Bitbucket.

## Used Scopes

### repository
Gives the app read access to all the repositories the authorizing user has access to. 
> This scope does not give access to a repository's pull requests.

### repository:write
Gives the app write (not admin) access to all the repositories the authorizing user has access to. 
No distinction is made between public or private repos. This scope implies repository, which does not need to be requested separately. 
This scope alone does not give access to the pull requests API.

### webhook
Gives access to webhooks. This scope is required for any webhook related operation.

This scope gives read access to existing webhook subscriptions on all resources you can access, without needing further scopes. 
This means that a client can list all existing webhook subscriptions on repository foo/bar (assuming the principal user has access 
to this repo). The additional repository scope is not required for this.

Likewise, existing webhook subscriptions for a repo's issue tracker can be retrieved without holding the issue scope. 
All that is required is the webhook scope.

However, to create a webhook for issue:created, the client will need to have both the webhook as well as issue scope.

