---
title: PyPI deployment
layout: en
deploy: v2
provider: pypi
---

Travis CI can automatically release your Python package to [PyPI](https://pypi.python.org/) after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: pypi
  user: "Your username"
  password: "Your password"
```
{: data-file=".travis.yml"}

However, this would expose your PyPI password to the world.
We recommend you [encrypt](/user/encryption-keys/) your password and add it to your .travis.yml by running:

```bash
travis encrypt your-password-here --add deploy.password
```

If you are using travis-ci.com and not travis-ci.org, you need to add the `--com` argument to switch the Travis API endpoint:

```bash
travis encrypt your-password-here --add deploy.password --com
```

> Note that if your PyPI password contains [special characters](/user/encryption-keys#note-on-escaping-certain-symbols) you need to escape them before encrypting your password. Some people have [reported difficulties](https://github.com/travis-ci/dpl/issues/377) connecting to PyPI with passwords containing anything except alphanumeric characters.

```yaml
deploy:
  provider: pypi
  user: "Your username"
  password:
    secure: "Your encrypted password"
```
{: data-file=".travis.yml"}

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

By default, Travis CI runs the deploy step for each `python` and `environment` that you specify. Many of these will generate competing build artifacts that will fail to upload to pypi with a message something like this:

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

{% include deploy/shared.md %}
