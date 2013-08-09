---
title: Building a Python Project
layout: en
permalink: python/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Python projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Choosing Python versions to test against

Python workers on travis-ci.org use default Ubuntu/Debian apt repositories plus [Dead Snakes PPA](https://launchpad.net/~fkrull/+archive/deadsnakes) to provide several Python versions your projects can be tested against. To specify them, use `python:` key in your `.travis.yml` file, for example:

    language: python
    python:
      - "2.6"
      - "2.7"
      - "3.2"
      - "3.3"
    # command to install dependencies
    install: "pip install -r requirements.txt --use-mirrors"
    # command to run tests
    script: nosetests

A more extensive example:

    language: python
    python:
      - "2.5"
      - "2.6"
      - "2.7"
      - "3.2"
      - "3.3"
    # command to install dependencies
    install:
      - "pip install . --use-mirrors"
      - "pip install -r requirements.txt --use-mirrors"
    # command to run tests
    script: nosetests

As time goes, new releases come out and we provision more Python versions and/or implementations, aliases like `3.2` will float and point to different exact versions, patch levels and so on.
For the full up-to-date list of provided Python versions, see our [CI environment guide](/docs/user/ci-environment/).

### Travis CI Uses Isolated virtualenvs

[CI Environment](/docs/user/ci-environment/) uses separate virtualenv instances for each Python version. System Python is not used and should not be relied on. If you need to install Python packages, do it via pip and not apt.

If you decide to use apt anyway, note that Python system packages only include Python 2.7 libraries on Ubuntu 12.04 LTS. This means that the packages installed from the repositories are not available in other virtualenvs even if you use the --system-site-packages option.

### PyPy Support

We provide the most recent stable release of PyPy via [PyPy Team's Releases PPA](https://launchpad.net/~pypy/+archive/ppa). For pure Python projects,
it works well. However, due to known issues with the development (header) packages, native libraries won't install on PyPy. We have notified
PyPy package maintainers as well as PyPy core team members about the issue and waiting for it to be resolved.

To test your project against PyPy, add "pypy" to the list of Pythons in your `.travis.yml`:

    language: python
    python:
      - "2.5"
      - "2.6"
      - "2.7"
      - "3.2"
      - "3.3"
      # does not have headers provided, please ask https://launchpad.net/~pypy/+archive/ppa
      # maintainers to fix their pypy-dev package.
      - "pypy"
    # command to install dependencies
    install:
      - pip install . --use-mirrors
      - pip install -r requirements.txt --use-mirrors
    # command to run tests
    script: nosetests 


## Default Python Version

If you leave the `python` key out of your `.travis.yml`, Travis CI will use Python 2.7.

## Specifying Test Script

Python projects need to provide `script` key in their `.travis.yml` to specify what command to run tests with. For example, if your project is tested by running nosetests, specify it like this:

    # command to run tests
    script: nosetests

if you need to run `make test` instead:

    script: make test

and so on.

In case `script` key is not provided in `.travis.yml` for Python projects, Python builder will print a message and fail the build.

## Dependency Management

### Travis CI uses pip

By default Travis CI use `pip` to manage your project's dependencies. It is possible (and common) to override dependency installation command as described in the [general build configuration](/docs/user/build-configuration/) guide.

The exact default command is

    pip install -r requirements.txt --use-mirrors

which is very similar to what [Heroku build pack for Python](https://github.com/heroku/heroku-buildpack-python/) uses.

We highly recommend using `--use-mirrors` if you override dependency installation command to reduce the load on PyPI and possibility of installation failures.

### Pre-installed packages

Travis pre-installs a few packages in each virtualenv by default to
ease running tests:

- pytest
- nose
- mock

### Testing Against Multiple Versions of Dependencies (e.g. Django or Flask)

If you need to test against multiple versions of, say, Django, you can instruct Travis to do multiple runs with different sets or values of environment variables. Use *env* key in your .travis.yml file, for example:

    env:
      - DJANGO_VERSION=1.2.7
      - DJANGO_VERSION=1.3.1

and then use ENV variable values in your dependencies installation scripts, test cases or test script parameter values. Here we use DB variable value to instruct pip to install an exact version:

    install:
      - pip install -q Django==$DJANGO_VERSION
      - python setup.py -q install

The same technique is often used to test projects against multiple databases and so on. For a real world example, see [getsentry/sentry](https://github.com/getsentry/sentry/blob/master/.travis.yml) and [jpvanhal/flask-split](https://github.com/jpvanhal/flask-split/blob/master/.travis.yml).

## Examples

* [facebook/tornado](https://github.com/facebook/tornado/blob/master/.travis.yml)
* [simplejson/simplejson](https://github.com/simplejson/simplejson/blob/master/.travis.yml)
* [fabric/fabric](http://github.com/fabric/fabric/blob/master/.travis.yml)
* [kennethreitz/requests](https://github.com/kennethreitz/requests/blob/master/.travis.yml)
* [dstufft/slumber](https://github.com/dstufft/slumber/blob/master/.travis.yml)
* [dreid/cotools](https://github.com/dreid/cotools/blob/master/.travis.yml)
* [MostAwesomeDude/klein](https://github.com/MostAwesomeDude/klein/blob/master/.travis.yml)
