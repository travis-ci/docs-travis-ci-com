---
title: GitHub Pages Deployment
layout: en
permalink: /user/deployment/pages/
---

Travis CI can deploy your static files to [GitHub
Pages](https://pages.github.com/) after a successful build.

You will need to provide a [personal access
token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
and set the deployment provider details in `.travis.yml`.

> Note that Travis CI will [`--force` push](https://github.com/travis-ci/dpl/blob/bdc795f335e23c3f470fbda89aa4a173d79dd424/lib/dpl/provider/pages.rb#L52-L62)
> to the target branch (ie. `gh-pages`), replacing any files there and overwriting
> the history of that branch. This should be fine if you only use the target branch
> for deployments. It won't overwrite the source branch (ie. `master`). Can you
> [help improve this](https://github.com/travis-ci/docs-travis-ci-com/issues/1064)
> caveat?

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pages
  skip_cleanup: true
  github_token: $GITHUB_TOKEN # Set in travis-ci.org dashboard
  on:
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
* `target_branch`: Branch to push force to, defaults to `gh-pages`
* `fqdn`: Optional, no default, sets a main domain for your website
* `project_name`: Defaults to value of `fqdn` or repo slug, used for metadata
* `email`: Optional, comitter info, defaults to `deploy@travis-ci.org`
* `name`: Optional, comitter, defaults to `Deployment Bot`
