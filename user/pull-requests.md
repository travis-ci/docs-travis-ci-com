---
title: Testing Pull Requests
layout: en
permalink: /user/pull-requests/
---
Pull requests are an essential feature of Travis CI. For a project that has
testing via Travis CI enabled, whenever a pull request is opened for the
project, Travis CI will build it and update a status on the pull request.

### How Pull Requests are Tested

When a pull request is opened, Travis CI receives a pull request notification
from GitHub. We turn this notification into a build and run it.

Along the way, we update the commit status of the commits involved, which in
turn shows on GitHub as either a warning that the build is still running, that
the pull request should be merged with caution because the build failed, or that
it can be merged safely because the build was successful.

Travis CI builds a pull request when it's first opened and when commits are
added to the pull request throughout its lifetime.

Rather than test the commits from the branches the pull request is sent from, we
test the merge between the origin and the upstream branch.

### Security Restrictions when testing Pull Requests

The most important restriction for pull requests is about secure environment
variables, or rather, any data that's encrypted with our encryption feature.

A pull request sent from a fork of the upstream repository could be manipulated
to expose any environment variables. The upstream repository's maintainer would
have no protection against this attack, as pull requests can be sent by anyone
with a fork.

For the protection of secure data, Travis CI makes it available only on pull
requests coming from the same repository. These are considered trustworthy, as
only members with write access to the repository can send them.

Pull requests sent from forked repositories don't have this data available in
their builds. All data that's considered confidential will not be added to the
build's environment.

If your build relies on these to run, for instance to run Selenium tests with
Sauce Labs, your build needs to take this into account. You won't be able to run
these tests for pull requests from external contributors.

To work around this, you could restrict these tests only to situations where the
environment variables are available, or disable them for pull requests entirely.
Here's an example of how to structure a build command for this purpose:

    script:
      - '[ "${TRAVIS_PULL_REQUEST}" = "false" ] && bundle exec rake tests:integration || false'

The environment variable `${TRAVIS_PULL_REQUEST}` is set to `"false"`
when the build is for a normal branch commit. When the build is for a
pull request, it will contain the pull request's number.

### My Pull Request isn't being built

If a pull request isn't built or doesn't show up in Travis CI's user interface,
that usually means that it can't be merged. We rely on the merge commit that
GitHub transparently creates between the changes in the source branch and the
upstream branch the pull request is sent against.

So when you create or update a pull request, and Travis CI doesn't create a
build for it, make sure the pull request is mergeable. If it isn't, rebase it
against the upstream branch and resolve any merge conflicts. When you push the
fixes up to GitHub and to the pull request, Travis CI will happily test them.

Travis CI also currently doesn't build pull requests when the upstream branch is
updated. When this happens, GitHub will update the merge commit between the
downstream and upstream branch, and send out a notifications. But Travis CI
currently ignores this update, as it could lead to a large number of new builds
on repositories with lots of pull requests and lots of updates on the upstream
branches.
