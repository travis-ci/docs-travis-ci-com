---
title: Building a Python Project
kind: content
---

## What This Guide Covers

This guide covers build environment and configuration topics specific to Python projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Choosing Python versions to test against

Python workers on travis-ci.org use default Ubuntu/Debian apt repositories plus [Dead Snakes PPA]() to provide several Python versions your projects can be
tested against. To specify them, use `python:` key in your `.travis.yml` file, for example:

    language: python
    python:
      - "2.6"
      - "2.7"
      - "3.2"
    # command to install dependencies
    install: pip install -r requirements.txt --use-mirrors
    # command to run tests
    script: nosetests

A more extensive example:

    language: python
    python:
      - "2.6"
      - "2.7"
      - "3.1"
      - "3.2"
    # command to install dependencies
    install:
      - pip install . --use-mirrors
      - pip install -r requirements.txt --use-mirrors
    # command to run tests
    script: nosetests

As time goes, new releases come out and we provision more Python versions and/or implementations, aliases like `3.2` will float and point to different
exact versions, patch levels and so on. For full up-to-date list of provided Python versions, see our [CI environment guide](/docs/user/ci-environment/).

### PyPy Support

PyPy is not currently provided but we would like to provide it near in the future.


### Travis CI Uses Isolated Environments

[CI Environment](/docs/user/ci-environment/) uses separate virtualenv instances for each Python version. System Python is not used and should
not be relied on. In case you need to modify this setup, it is possible thanks to Travis CI VMs being snapshotted and rolled back between
builds. Please see [general build configuration](/docs/user/build-configuration/) guide for more information.


## Default Python Version

If you leave the `python` key out of your `.travis.yml`, Travis CI will use Python 2.7.


## Specifying Test Script

Python projects need to provide `script` key in their `.travis.yml` to specify what command to run tests with. For example, if your project
is tested by running nosetests, specify it like this:

    # command to run tests
    script: nosetests

if you need to run `make test` instead:

    script: make test

and so on.

In case `script` key is not provided in `.travis.yml` for Python projects, Python builder will print a message and fail the build.


## Dependency Management

### Travis CI uses pip

By default Travis CI use `pip` to manage your project's dependencies. It is possible (and common) to override dependency installation command
as described in the [general build configuration](/docs/user/build-configuration/) guide.

The exact default command is

    pip install -r requirements.txt --use-mirrors

which is very similar to what [Heroku build pack for Python](https://github.com/heroku/heroku-buildpack-python/) uses.

We highly recommend using `--use-mirrors` if you override dependency installation command to reduce the load on PyPI and possibility of
installation failures.


## Examples

 * [facebook/tornado](https://github.com/facebook/tornado/blob/master/.travis.yml)
 * [simplejson/simplejson](https://github.com/simplejson/simplejson/blob/master/.travis.yml)
 * [kennethreitz/requests](https://github.com/kennethreitz/requests/blob/develop/.travis.yml)
 * [dstufft/slumber](https://github.com/dstufft/slumber/blob/master/.travis.yml)
 * [dreid/cotools](https://github.com/dreid/cotools/blob/master/.travis.yml)
 * [dreid/klein](https://github.com/dreid/klein/blob/master/.travis.yml)
