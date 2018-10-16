---
title: GitHub Releases Uploading
layout: en

---

Travis CI can automatically upload assets to git tags on your GitHub repository.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: releases
  api_key: "GITHUB OAUTH TOKEN"
  file: "FILE TO UPLOAD"
  skip_cleanup: true
  on:
    tags: true
```
{: data-file=".travis.yml"}

> Make sure you have `skip_cleanup` set to `true`, otherwise Travis CI will delete all the files created during the build, which will probably delete what you are trying to upload.

GitHub Releases uses git tags. If the build commit does not have any tags, one will be created in the form of `untagged-*`, where `*` is a random hex string.

If this is not what you want, either set your build to deploy only when the build already has a tag using `on.tags: true` as shown in the previous example `.travis.yml`, or tag the commit with `git tag` in `before_deploy`:

```yaml
    before_deploy:
      # Set up git user name and tag this commit
      - git config --local user.name "YOUR GIT USER NAME"
      - git config --local user.email "YOUR GIT USER EMAIL"
      - git tag "$(date +'%Y%m%d%H%M%S')-$(git log --format=%h -1)"
    deploy:
      provider: releases
      api_key: "GITHUB OAUTH TOKEN"
      file: "FILE TO UPLOAD"
      skip_cleanup: true
```
{: data-file=".travis.yml"}


If you need to overwrite existing files, add `overwrite: true` to the `deploy` section of your `.travis.yml`.

You can also use the [Travis CI command line client](https://github.com/travis-ci/travis.rb#installation) to configure your `.travis.yml`:

```bash
travis setup releases
```

Or, if you're using a private repository or the GitHub Apps integration:

```bash
travis setup releases --com
```

## `on.tags` condition

When working with GitHub Releases, it is important to understand how the deployment is triggered
with [the `tags` condition](/user/deployment/#conditional-releases-with-on).


## Authenticating with an OAuth token

The recommended way to authenticate is to use a GitHub OAuth token. It must have the `public_repo` or `repo` scope to upload assets. Instead of setting it up manually, it is highly recommended to use `travis setup releases`, which automatically creates and encrypts a GitHub oauth token with the correct scopes.

This results in something similar to:

```yaml
deploy:
  provider: releases
  api_key:
    secure: YOUR_API_KEY_ENCRYPTED
  file: "FILE TO UPLOAD"
  skip_cleanup: true
  on:
    tags: true
```
{: data-file=".travis.yml"}

**Warning:** the `public_repo` and `repo` scopes for GitHub oauth tokens grant write access to all of a user's (public) repositories. For security, it's ideal for `api_key` to have write access limited to only respositories where Travis deploys to GitHub releases. The suggested workaround is to create a [machine user](https://developer.github.com/guides/managing-deploy-keys/#machine-users) — a dummy GitHub account that is granted write access on a per repository basis.

## Authentication with a Username and Password

You can also authenticate with your GitHub username and password using the `user` and `password` options. This is not recommended as it allows full access to your GitHub account but is simplest to setup. It is recommended to encrypt your password using `travis encrypt "GITHUB PASSWORD" --add deploy.password`. This example authenticates using  a username and password.

```yaml
deploy:
  provider: releases
  user: "GITHUB USERNAME"
  password: "GITHUB PASSWORD"
  file: "FILE TO UPLOAD"
  skip_cleanup: true
  on:
    tags: true
```
{: data-file=".travis.yml"}

## Deploying to GitHub Enterprise

If you wish to upload assets to a GitHub Enterprise repository, you must override the `$OCTOKIT_API_ENDPOINT` environment variable with your GitHub Enterprise API endpoint:

```
http(s)://"GITHUB ENTERPRISE HOSTNAME"/api/v3/
```

You can configure this in [Repository Settings](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings) or via your `.travis.yml`:

```yaml
env:
  global:
    - OCTOKIT_API_ENDPOINT="GITHUB ENTERPRISE API ENDPOINT"
```
{: data-file=".travis.yml"}

## Uploading Multiple Files

You can upload multiple files using yml array notation. This example uploads two files.

```yaml
deploy:
  provider: releases
  api_key:
    secure: YOUR_API_KEY_ENCRYPTED
  file:
    - "FILE 1"
    - "FILE 2"
  skip_cleanup: true
  on:
    tags: true
```
{: data-file=".travis.yml"}

You can also enable wildcards by setting `file_glob` to `true`. This example
includes all files in a given directory.

```yaml
deploy:
  provider: releases
  api_key: "GITHUB OAUTH TOKEN"
  file_glob: true
  file: directory/*
  skip_cleanup: true
  on:
    tags: true
```
{: data-file=".travis.yml"}

You can use the glob pattern to recursively find the files:

```yaml
deploy:
  provider: releases
  api_key: "GITHUB OAUTH TOKEN"
  file_glob: true
  file: directory/**/*
  skip_cleanup: true
  on:
    tags: true
```
{: data-file=".travis.yml"}

Please note that all paths in `file` are relative to the current working directory, not to [`$TRAVIS_BUILD_DIR`](/user/environment-variables/#Default-Environment-Variables).

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#conditional-releases-with-on).

## Running commands before or after release

Sometimes you want to run commands before or after releasing a gem. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}

## Advanced options

Options from `.travis.yml` are passed through to [Octokit API](https://octokit.github.io/octokit.rb/Octokit/Client/Releases.html#create_release-instance_method), so you can use any valid Octokit option.

These include:

* `name`
* `body`
* `draft`
* `prerelease`

Note that formatting in `body` is [not preserved](https://github.com/travis-ci/dpl/issues/155).
