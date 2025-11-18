---
title: Travis CI's use of GitHub API Scopes
layout: en

---

When you sign in to Travis CI for the first time, we ask for permission to access
some of your data on GitHub. Read the [GitHub API Scope Documentation](https://developer.github.com/v3/oauth/#scopes) for general information about this, or pick an explanation of what data we need and why we need it.

## Access rights for Travis CI GitHub OAuth App

{{ site.data.snippets.github_oauth_access_rights }}

## Travis CI for Open-Source and Private Projects

On <https://travis-ci.com>, via our GitHub Apps integration, we ask for the following permissions:

- Read access to code.
- Read access to metadata and pull requests.
- Read and write access to administration, checks, commit statuses, and deployments.
- Synchronize user email to send notifications and important information.

## Legacy WebHooks

Before GitHub Apps, we used scoped OAuth tokens to integrate with GitHub. As of May 2018, OAuth-based integration is considered our "Legacy" integration.

### Private and Public Repositories 

The following section shows how to use Repositories on https://travis-ci.com (Private and public).

- `user:email` (read-only)

    We synchronize your email addresses so we can email you the build
    notifications.

    Your email address can be hidden from the GitHub profile, which also hides it from us.

- `read:org` (read-only)

    When you're logged in on Travis CI, we show you all of your repositories,
    including the ones from any organization you're part of.

    The GitHub API hides any organizations you're a private member of without
    this scope. So, to make sure we show you all of your repositories, we require
    this scope.

    Note that this scope allows access to the basic information about both private
    and public repositories, but not on any of the stored data or code.

- `repo`

    Grants read and write access to code, commit statuses, collaborators, and
    deployment statuses for public and private repositories and organizations.

    We need this level of access because GitHub does not provide the `read:org` (read-only) scope for private repositories.
