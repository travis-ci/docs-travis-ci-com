---
title: Travis CI's use of GitHub API Scopes
layout: en
permalink: /user/github-oauth-scopes/
---
When you sign in on Travis CI, we ask for a few permissions to access your data.

This page provides an overview of which we ask for and why.

### Travis CI for Open Source

On <https://travis-ci.org> we currently ask for the following permissions.

Note that for open source projects, we don't have any write access to your
source code or your profile.

Make sure to check with [GitHub API's documentation](/user/github-oauth-scopes/)
for additional details on the scopes we use.

* `user:email`

    We synchronize your email addresses for the purpose of emailing you build
    notifications. They're currently not being used for any other means.

    We ask for this permission, because without it, we may have no means of
    sending you the build notifications. Your email address can be hidden from
    the GitHub profile, which in turns hides it from us as well.

* `read:org`

    When you're logged in on Travis CI, we show you all of your repositories,
    including the ones from any organization you're part of.

    The GitHub API hides any organizations you're a private member of without
    this scope. So to make sure we show you all of your repositories, we require
    this scope.

    Note that this scope allows access to the basic information on both private
    and public repositories, but not on any of the data and code stored in them.

* `repo_deployment`

    Gives us access to the [upcoming deployments
    API](http://developer.github.com/v3/repos/deployments/), currently in preview mode.

    This scope currently isn't actively used, but will be in the future.

* `repo:status`

    After every build, we update the status of its commit, which is most
    relevant for testing pull request. This scope gives us the permission to
    update the commit status as the build starts and finishes.

* `write:repo_hook`

    Building a new repository on Travis CI is as easy as enabling it in your
    profile and pushing a new commit.

    Updating the webhook required for us to be notified from GitHub on new
    commits or pull requests requires this API scope. Additionally, your user
    needs to have admin access to the repository you want to enable.
