---
title: Building Pull Requests
layout: en

---

Pull request builds are an essential part of Travis CI.
Whenever a pull request is opened on GitHub, Travis CI builds it and updates the status icon on the pull request page.

> Please note, [Draft Pull Requests](https://github.blog/2019-02-14-introducing-draft-pull-requests/) are not currently supported on Travis CI.

## How Pull Requests are Built

When a pull request is opened on GitHub, Travis CI receives a notification and runs a build.
During the build, we update the status icon of the pull request to one of the following statuses:

- a warning that the build is still running.
- a notification that the build failed -- the pull request should not be merged.
- a notification that the build succeeded -- the pull request can be merged.

Travis CI builds a pull request when it is first opened, and whenever commits are added to the pull request.
Rather than build the commits that have been pushed to the branch the pull request is from, we build the merge between the source branch and the upstream branch.

To only build on push events not on pull requests, disable **Build on Pull Requests** in your repository settings.

## Pull Requests and Security Restrictions

The most important restriction for pull requests is about secure environment variables and encrypted data.

A pull request sent from a fork of the upstream repository could be manipulated to expose environment variables.
The upstream repository's maintainer would have no protection against this attack, as pull requests can be sent by anyone who forks the repository on GitHub.

Travis CI makes encrypted variables and data available only to pull requests coming from the same repository. These are considered trustworthy, as only members with write access to the repository can send them.

Pull requests sent from forked repositories do not have access to encrypted variables or data even if these are defined in the fork source project.

If your build relies on encrypted variables to run, for instance to run Selenium tests with [BrowserStack](https://www.browserstack.com) or Sauce Labs, your build needs to take this into account. You won't be able to run
these tests for pull requests from external contributors.

To work around this, restrict these tests only to situations where the
environment variables are available, or disable them for pull requests entirely, as shown in the following example:

```yaml
script:
   - 'if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then bash ./travis/run_on_pull_requests; fi'
   - 'if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then bash ./travis/run_on_non_pull_requests; fi'
```
{: data-file=".travis.yml"}

## My Pull Request isn't being built

If a pull request isn't built or doesn't show up in Travis CI's user interface, that usually means that it can't be merged.
We rely on the merge commit that GitHub transparently creates between the changes in the source branch and the upstream branch the pull request is sent against.

So when you create or update a pull request, and Travis CI doesn't create a
build for it, make sure the pull request is mergeable.
If it isn't, rebase it against the upstream branch and resolve any merge conflicts. When you push the fixes up to the pull request, Travis CI will happily build them.

Travis CI also currently doesn't build pull requests when the upstream branch is updated, as this would lead to an excessive number of new builds.

If the pull request has already been merged you can't rerun the job. You'll get an error like:


```
The command "eval git fetch origin +refs/pull/994/merge: " failed
```

Restoring the branch of a merged pull request will not trigger a build, nor will pushing a new commit to a branch that has already been merged.

## 'Double builds' on pull requests

If you see two build status icons on your GitHub pull request, it means there is one build for the branch, and one build for the pull request itself (actually the build for the merge of the head branch with the base branch specified in the pull request).

[Build pushed branches](/user/web-ui/#build-pushed-branches) and [Build pushed pull requests](/user/web-ui/#build-pushed-pull-requests) control this behaviour.

## See Also

* [Building only the latest commit](/user/customizing-the-build/#building-only-the-latest-commit)
* [Building specific branches](/user/customizing-the-build/#building-specific-branches)
