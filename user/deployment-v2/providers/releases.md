---
title: GitHub Releases Uploading
layout: en
deploy: v2
provider: releases
---

Travis CI can automatically upload assets to git tags on your GitHub repository.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: releases
  token: <encrypted token>
  file: <file>
  edge: true # opt in to dpl v2
  on:
    tags: true
```
{: data-file=".travis.yml"}

This configuration will use the given GitHub OAuth token to upload the
specified file (relative to the working directory) on tagged builds.

{% include deploy/providers/releases.md minimal=false %}

## Authenticating with an OAuth token

The recommended way to authenticate is to use a GitHub OAuth token with
the `public_repo` or `repo` scope to upload assets.

The `public_repo` and `repo` scopes for GitHub oauth tokens grant write access
to all of a user's (public) repositories. For security, it's ideal for `token`
to have write access limited to only repositories where Travis deploys to
GitHub releases. The suggested workaround is to create a [machine
user](https://developer.github.com/v3/guides/managing-deploy-keys/#machine-users)
— a GitHub account that is granted write access on a per repository basis.

## Authentication with a user name and password

You can also authenticate with your GitHub username and password using the
`user` and `password` options.

```yaml
deploy:
  provider: releases
  user: <user>
  password: <password>
  # ⋮
```
{: data-file=".travis.yml"}

## Regular releases

When the `draft` option is not set to `true` (see below), a regular release is
created.

Regular releases require tags. If you set `on.tags: true` (as the initial
example in this document), this requirement is met.

## Draft releases

With

```yaml
deploy:
  provider: releases
  # ⋮
  draft: true
```
{: data-file=".travis.yml"}

the resulting deployment is a draft release that only repository collaborators
can see.

This gives you an opportunity to examine and edit the draft release.

## Setting the tag at deployment time

GitHub Releases needs the present commit to be tagged at the deployment time.
If you set `on.tags: true`, the commit is guaranteed to have a tag.  Depending
on the workflow, however, this is not desirable.

In such cases, it is possible to postpone setting the tag until you have all
the information you need. A natural place to do this is `before_deploy`.

For example:

```yaml
before_deploy:
  # Set up git user name and tag this commit
  - git config --local user.name "YOUR GIT USER NAME"
  - git config --local user.email "YOUR GIT USER EMAIL"
  - export TRAVIS_TAG=${TRAVIS_TAG:-$(date +'%Y%m%d%H%M%S')-$(git log --format=%h -1)}
  - git tag $TRAVIS_TAG
deploy:
  provider: releases
  # ⋮
```
{: data-file=".travis.yml"}

### When tag is not set at deployment time

If the tag is still not set at the time of deployment, the deployment provider
attempts to match the current commit with a tag from remote, and if one is
found, uses it.

This could be a problem if multiple tags are assigned to the current commit and
the one you want is not matched.

In such a case, assign the tag you need (the method will depend on your use
case) to `$TRAVIS_TAG` to get around the problem.

If the build commit does not match any tag at deployment time, GitHub creates
one when the release is created.

The GitHub-generated tags are of the form `untagged-*`, where `*` is a random
hex string.

> Notice that this tag is immediately available on GitHub, and thus will trigger
a new Travis CI build, unless it is prevented by other means; for instance, by
[blocklisting `/^untagged/`](/user/customizing-the-build/#safelisting-or-blocklisting-branches).

## Overwrite existing files on the release

If you need to overwrite existing files, use the option `overwrite`:

```yaml
deploy:
  provider: releases
  # ⋮
  overwrite: true
```
{: data-file=".travis.yml"}

## Deploying to GitHub Enterprise

In order to upload assets to a GitHub Enterprise repository, override the
`$OCTOKIT_API_ENDPOINT` environment variable with your GitHub Enterprise API
endpoint:

```
http(s)://"GITHUB ENTERPRISE HOSTNAME"/api/v3/
```

You can configure this in [Repository Settings](/user/environment-variables/#defining-variables-in-repository-settings)
or via your `.travis.yml`:

```yaml
env:
  global:
    - OCTOKIT_API_ENDPOINT=<endpoint>
```
{: data-file=".travis.yml"}

## Uploading Multiple Files

You can upload multiple files using yml array notation. This example uploads
two files.

```yaml
deploy:
  provider: releases
  # ⋮
  file:
    - file-1
    - file-2
```
{: data-file=".travis.yml"}

The option `file` by default takes a glob, so you can express the same as:

```yaml
deploy:
  provider: releases
  # ⋮
  file: {file-1,file-2}
```
{: data-file=".travis.yml"}

> Note that all paths in `file` are relative to the current working directory, not to [`$TRAVIS_BUILD_DIR`](/user/environment-variables/#default-environment-variables).

## Troubleshooting Git Submodules

GitHub Releases executes a number of git commands during deployment. For this
reason, it is important that the working directory is set to the one for which
the release will be created, which generally isn't a problem, but if you clone
another repository during the build or use submodules, it is worth double
checking.

{% include deploy/shared.md %}
