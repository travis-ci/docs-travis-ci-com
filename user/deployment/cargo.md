---
title: Cargo Releases
layout: en
---

Travis CI can automatically release your Rust crate to [crates.io][]
after a successful build. (Alternative registries may be supported in the
future).

A minimal `.travis.yml` configuration for publishing to [crates.io][] looks like:

```yaml
language: rust
deploy:
  provider: cargo
  token: "YOUR_API_TOKEN"
```
{: data-file=".travis.yml"}

## crates.io API token

An API token can be obtained by logging in to your [crates.io][] account, and
generating a new token at <https://crates.io/me>.

Always [encrypt](/user/encryption-keys/#Usage) your API token. Assuming you
have the Travis CI command line client installed, you can do it like this:

```bash
$ travis encrypt YOUR_API_TOKEN --add deploy.token
```

## What to release

Most likely, you would only want to deploy to crates.io when a new version of
your package is cut. To do this, you can tell Travis CI to only deploy on tagged
commits, like so:

```yaml
deploy:
  ...
  on:
    tags: true
```
{: data-file=".travis.yml"}

If you tag a commit locally, remember to run `git push --tags` to ensure that
your tags are uploaded to GitHub.

You can explicitly specify the branch to release from with the **on** option:

```yaml
deploy:
  ...
  on:
    branch: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure Travis CI to release from all branches:

```yaml
deploy:
  ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a release.

## Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any
additional files and changes you made.

This is necessary because Cargo will refuse to publish crates from a dirty
working directory (an option to allow this may be added to this provider in the
future).

## Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the
`before_deploy` and `after_deploy` stages for this. These will only be triggered
if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}

[crates.io]: https://crates.io/
