---
title: GitHub Pages Deployment
layout: en
deploy: v1

---

> Deploying to GitHub Pages uses `git push --force` to overwrite the history on the *target* branch, so make sure you only deploy to a branch used for that specific purpose, such as `gh-pages`. It is *possible* to disable this "force push" behavior by setting `keep_history` option to `true`.

Travis CI can deploy your static files to [GitHub
Pages](https://pages.github.com/) after a successful build.

You will need to provide a [personal access
token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
and set the deployment provider details in `.travis.yml`.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pages
  skip_cleanup: true
  github_token: $GITHUB_TOKEN  # Set in the settings page of your repository, as a secure variable
  keep_history: true
  on:
    branch: master
```
{: data-file=".travis.yml"}

> Make sure you have `skip_cleanup` set to `true`, otherwise Travis CI will delete
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

* `local_dir`: Directory to push to GitHub Pages, defaults to current directory.
  Can be specified as an absolute path or a relative path from the current directory.
* `repo`: Repo slug, defaults to current repo. **Note:** The slug consists of username and repo name and is formatted like `user/repo-name`.
* `target_branch`: Branch to (force, see: `keep_history`) push `local_dir`
  contents to, defaults to `gh-pages`.
* `keep_history`: Optional, create incremental commit instead of doing push
  force, defaults to `false`.
* `fqdn`: Optional, sets a custom domain for your website, defaults to no custom domain support.
* `project_name`: Defaults to value of `fqdn` or repo slug, used for metadata.
* `email`: Optional, committer info, defaults to `deploy@travis-ci.org`.
* `name`: Optional, committer, defaults to `Deployment Bot`.
* `committer_from_gh`: Optional, defaults to `false`. Allows you to use the token's owner name and email for commit. Overrides `email` and `name` options.
* `allow_empty_commit`: Optional, defaults to `false`. Enabled if only
  `keep_history` is `true`.
* `github_url`: Optional, the URL of the self-hosted GitHub enterprise, defaults to `github.com`.
* `verbose`: Optional, be verbose about internal steps, defaults to `false`.
* `deployment_file`: Optional, defaults to `false`, enables creation of deployment-info files.
