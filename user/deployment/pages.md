---
title: GitHub Pages Deployment
layout: en

---

> Deploying to GitHub Pages uses `git push --force` to overwrite the history on the *target* branch, so make sure you only deploy to a branch used for that specific purpose, such as `gh-pages`.

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
  github_token: $GITHUB_TOKEN # Set in travis-ci.org dashboard
  if:
    branch: master
```

> Make sure you have `skip_cleanup` set to true, otherwise Travis CI will delete
> all the files created during the build, which will probably delete what you are
> trying to upload.

## Setting the GitHub token

You'll need to generate a [personal access
token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
with the `public_repo` or `repo` scope (`repo` is required for private
repositories). Since the token should be private,
you'll want to pass it to Travis securely in your [repository
settings](https://docs.travis-ci.com/user/environment-variables#Defining-Variables-in-Repository-Settings)
or via [encrypted variables in
`.travis.yml`](https://docs.travis-ci.com/user/environment-variables#Defining-encrypted-variables-in-.travis.yml).

## Further configuration

* `local_dir`: Directory to push to GitHub Pages, defaults to the current
    directory
* `repo`: Repo slug, defaults to current repo
* `target_branch`: Branch to force push to, defaults to `gh-pages`
* `fqdn`: Optional, sets a custom domain for your website, defaults to no custom domain support.
* `project_name`: Defaults to value of `fqdn` or repo slug, used for metadata
* `email`: Optional, comitter info, defaults to `deploy@travis-ci.org`
* `name`: Optional, comitter, defaults to `Deployment Bot`
* `github_url`: Optional, the URL of the self-hosted GitHub enterprise, defaults to `github.com`
