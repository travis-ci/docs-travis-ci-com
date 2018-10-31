---
title: GitHub Pages Deployment
layout: en

---

> Deploying to GitHub Pages uses `git push --force` to overwrite the history on the *target* branch, so make sure you only deploy to a branch used for that specific purpose, such as `gh-pages`. It is *possible* to disable this "force push" behavior by setting `keep-history` option to `true`.

Travis CI can deploy your static files to [GitHub
Pages](https://pages.github.com/) after a successful build.

You will need to provide a [personal access
token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
and set the deployment provider details in `.travis.yml`.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pages
  skip-cleanup: true
  github-token: $GITHUB_TOKEN  # Set in the settings page of your repository, as a secure variable
  keep-history: true
  on:
    branch: master
```
{: data-file=".travis.yml"}

> Make sure you have `skip-cleanup` set to `true`, otherwise Travis CI will delete
> all the files created during the build, which will probably delete what you are
> trying to upload.

## Setting the GitHub token

You'll need to generate a [personal access
token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
with the `public_repo` or `repo` scope (`repo` is required for private
repositories). Since the token should be private,
you'll want to pass it to Travis securely in your [repository
settings](/user/environment-variables#defining-variables-in-repository-settings)
or via [encrypted variables in
`.travis.yml`](/user/environment-variables#defining-encrypted-variables-in-travisyml).

## Further configuration

* `local-dir`: Directory to push to GitHub Pages, defaults to current directory.
  Can be specified as an absolute path or a relative path from the current directory.
* `repo`: Repo slug, defaults to current repo
* `target-branch`: Branch to (force, see: `keep-history`) push `local-dir`
  contents to, defaults to `gh-pages`
* `keep-history`: Optional, create incremental commit instead of doing push
  force, defaults to `false`.
* `fqdn`: Optional, sets a custom domain for your website, defaults to no custom domain support
* `project-name`: Defaults to value of `fqdn` or repo slug, used for metadata
* `email`: Optional, committer info, defaults to `deploy@travis-ci.org`
* `name`: Optional, committer, defaults to `Deployment Bot`
* `committer-from-gh`: Optional, defaults to `false`. Allows you to use the token's
  owner name and email for commit. Overrides `email` and `name` options.
* `allow-empty-commit`: Optional, defaults to `false`. Enabled if only
  `keep-history` is `true`.
* `github-url`: Optional, the URL of the self-hosted GitHub enterprise, defaults to `github.com`
* `verbose`: Optional, be verbose about internal steps, defaults to `false`.
