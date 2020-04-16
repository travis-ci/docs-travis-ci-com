---
title: PyPI deployment
layout: en
deploy: v1

---

Travis CI can automatically release your Python package to [PyPI](https://pypi.python.org/) after a successful build.



For a minimal configuration, generate [PyPI API token](https://pypi.org/help/#apitoken) and add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pypi
  user: "__token__"
  password: "Your PyPI API token, including the pypi- prefix"
```
{: data-file=".travis.yml"}

However, this would expose your PyPI API token to the world.
We recommend you [encrypt](/user/encryption-keys/) your password and add it to your .travis.yml by running:

```bash
travis encrypt your-api-token --add deploy.password
```

If you are using travis-ci.com and not travis-ci.org, you need to add the `--com` argument to switch the Travis API endpoint:

```bash
travis encrypt your-api-token --add deploy.password --com
```

```yaml
deploy:
  provider: pypi
  user: "__token__"
  password:
    secure: "Your encrypted token"
```
{: data-file=".travis.yml"}

It is also possible, but not recommended, to use PyPI user and password, instead of token.

> Note that if your PyPI password contains [special characters](/user/encryption-keys#note-on-escaping-certain-symbols) you need to escape them before encrypting your password. Some people have [reported difficulties](https://github.com/travis-ci/dpl/issues/377) connecting to PyPI with passwords containing anything except alphanumeric characters.


## Deploying tags

Most likely, you would only want to deploy to PyPI when a new version of your
package is cut. To do this, you can tell Travis CI to only deploy on tagged
commits, like so:

```yaml
deploy:
  provider: pypi
  user: ...
  password: ...
  on:
    tags: true
```
{: data-file=".travis.yml"}

If you tag a commit locally, remember to run `git push --tags` to ensure that your tags are uploaded to GitHub.

## Deploying specific branches

You can explicitly specify the branch to release from with the **on** option:

```yaml
deploy:
  provider: pypi
  user: ...
  password: ...
  on:
    branch: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure Travis CI to release from all branches:

```yaml
deploy:
  provider: pypi
  user: ...
  password: ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

By default, Travis CI will only release from the **master** branch.

Builds triggered from Pull Requests will never trigger a release.

## Releasing to a self hosted PyPI

To release to a different PyPI index:

```yaml
deploy:
  provider: pypi
  user: ...
  password: ...
  server: https://mypackageindex.com/index
```
{: data-file=".travis.yml"}

## Uploading different distributions

By default, only a source distribution ('sdist') will be uploaded to PyPI.
If you would like to upload different distributions, specify them using the `distributions` option, like this:

```
deploy:
  provider: pypi
  user: ...
  password: ...
  distributions: "sdist bdist_wheel" # Your distributions here
```

If you specify `bdist_wheel` in the distributions, the `wheel` package will automatically be installed.

## Upload artifacts only once

By default, Travis CI runs the deploy stage for each `python` and `environment` that you specify. Many of these will generate competing build artifacts that will fail to upload to pypi with a message something like this:

```
HTTPError: 400 Client Error: File already exists. See https://pypi.org/help/#file-name-reuse for url: https://upload.pypi.org/legacy/
```

To avoid this, use the `skip_existing` flag:

```
deploy:
  provider: pypi
  user: ...
  password: ...
  skip_existing: true
```

## Releasing build artifacts

After your tests ran and before the release, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be released, too. There is now an option to skip the clean up:

```
deploy:
  provider: pypi
  user: ...
  password: ...
  skip_cleanup: true
```

## Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#conditional-releases-with-on).

## Running commands before and after release

Sometimes you want to run commands before or after releasing a package. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

```
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
