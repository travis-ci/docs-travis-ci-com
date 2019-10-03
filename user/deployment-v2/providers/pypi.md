---
title: PyPI Deployment
layout: en
deploy: v2
provider: pypi
---

Travis CI can automatically release your Python package to [PyPI](https://pypi.python.org/) after a successful build.

{% capture content %}
  > Note that if your PyPI password contains [special > characters](/user/encryption-keys#note-on-escaping-certain-symbols)
  > you need to escape them before encrypting your password. Some people have [reported
  > difficulties](https://github.com/travis-ci/dpl/issues/377) connecting to PyPI
  > with passwords containing anything except alphanumeric characters.
{% endcapture %}

{% include deploy/providers/pypi.md capture=capture %}

## Releasing to a self hosted PyPI

To release to a different PyPI index:

```yaml
deploy:
  provider: pypi
  # ⋮
  server: https://mypackageindex.com/index
```
{: data-file=".travis.yml"}

## Uploading different distributions

By default, only a source distribution ('sdist') will be uploaded to PyPI.
If you would like to upload different distributions, specify them using the `distributions` option, like this:

```yaml
deploy:
  provider: pypi
  # ⋮
  distributions: "sdist bdist_wheel" # Your distributions here
```
{: data-file=".travis.yml"}

If you specify `bdist_wheel` in the distributions, the `wheel` package will automatically be installed.

## Upload artifacts only once

By default, Travis CI runs the deploy step for each `python` and `environment`
that you specify. Many of these will generate competing build artifacts that
will fail to upload to pypi with a message something like this:

```
HTTPError: 400 Client Error: File already exists.
```

To avoid this, use the `skip_existing` flag:

```yaml
deploy:
  provider: pypi
  # ⋮
  skip_existing: true
```
{: data-file=".travis.yml"}

{% include deploy/shared.md tags=true %}

