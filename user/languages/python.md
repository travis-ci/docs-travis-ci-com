---
title: Building a Python Project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| Python                                      | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#Dependency-Management) | `pip install -r requirements.txt`         |
| [Default `script`](#Default-Build-Script)   | N/A                                       |
| [Matrix keys](#Build-Matrix)                | `python`, `env`                           |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
  language: python
  python:
    - "3.6"
  script:
    - pytest
```
{: data-file=".travis.yml"}
</aside>

{{ site.data.snippets.trusty_note_no_osx }}

Python builds are not available on the macOS environment.

The rest of this guide covers configuring Python projects in Travis CI. If you're
new to Travis CI please read our [Getting Started](/user/getting-started/) and
[build configuration](/user/customizing-the-build/) guides first.

## Specifying Python versions

Specify python versions using the `python` key. As we update the Python build
images, aliases like `3.6` will point to different exact versions or patch
levels.

```yaml
language: python
python:
  - "2.6"
  - "2.7"
  - "3.3"
  - "3.4"
  - "3.5"
  - "3.5-dev"  # 3.5 development branch
  - "3.6"
  - "3.6-dev"  # 3.6 development branch
  - "3.7-dev"  # 3.7 development branch
# command to install dependencies
install:
  - pip install -r requirements.txt
# command to run tests
script:
  - pytest # or py.test for Python versions 3.5 and below
```
{: data-file=".travis.yml"}


### Travis CI Uses Isolated virtualenvs

The CI Environment uses separate virtualenv instances for each Python
version. This means that as soon as you specify `language: python` in `.travis.yml` your tests will run inside a virtualenv (without you having to explicitly create it).
System Python is not used and should not be relied on. If you need
to install Python packages, do it via pip and not apt.

If you decide to use apt anyway, note that for compatibility reasons, you'll only be able to use the default Python versions that are available in Ubuntu (e.g. for Trusty, this means 2.7.6 and 3.4.3).
To access the packages inside the virtualenv, you will need to specify that it should be created with the `--system-site-packages` option.
To do this, include the following in your `.travis.yml`:

```yaml
language: python
virtualenv:
  system_site_packages: true
```
{: data-file=".travis.yml"}


### PyPy Support

Travis CI supports PyPy and PyPy3.

To test your project against PyPy, add "pypy" or "pypy3" to the list of Pythons
in your `.travis.yml`:

```yaml
language: python
python:
  - "2.6"
  - "2.7"
  - "3.4"
  - "3.5"
  - "3.6"
  # PyPy versions
  - "pypy2.7"
  - "pypy3.5"
# command to install dependencies
install:
  - pip install -r requirements.txt
  - pip install .
# command to run tests
script: pytest
```
{: data-file=".travis.yml"}

### Nightly build support

Travis CI supports a special version name `nightly`, which points to
a recent development version of [CPython](https://github.com/python/cpython) build.

### Development releases support

From Python 3.5 and later, Python In Development versions are available.

You can specify these in your builds with `3.5-dev`, `3.6-dev`,
`3.7-dev` or `3.8-dev`.

{: .warning}
> Recent Python branches [require OpenSSL 1.0.2+](https://github.com/travis-ci/travis-ci/issues/9069).
> As this library is not available for Trusty,  `3.7`, `3.7-dev`, `3.8-dev`, and `nightly`
> do not work (or use outdated archive).

## Default Build Script

Python projects need to provide the `script` key in their `.travis.yml` to
specify what command to run tests with.

For example, if your project uses pytest:

```yaml
# command to run tests
script: pytest  # or py.test for Python versions 3.5 and below
```
{: data-file=".travis.yml"}

if it uses `make test` instead:

```yaml
script: make test
```
{: data-file=".travis.yml"}

If you do not provide a `script` key in a Python project, Travis CI prints a
message (_"Please override the script: key in your .travis.yml to run tests."_)
and fails the build.

## Using Tox as the Build Script

Due to the way Travis is designed, interaction with [tox](https://tox.readthedocs.io/en/latest/) is not straightforward.
As described [above](/user/languages/python/#Travis-CI-Uses-Isolated-virtualenvs), Travis already runs tests inside an isolated virtualenv whenever `language: python` is specified, so please bear that in mind whenever creating more environments with tox. If you would prefer to run tox outside the Travis-created virtualenv, it might be a better idea to use `language: generic` instead of `language: python`.

If you're using tox to test your code against multiple versions of python, you have two options:
  * use `language: generic` and manually install the python versions you're interested in before running tox (without the manual installation, tox will only have access to the default Ubuntu python versions - 2.7.6 and 3.4.3 for Trusty)
  * use `language: python` and a build matrix that uses a different version of python for each branch (you can specify the python version by using the `python` key). This will ensure the versions you're interested in are installed and parallelizes your workload.

A good example of a `travis.yml` that runs tox using a Travis build matrix is [twisted/klein](https://github.com/twisted/klein/blob/master/.travis.yml).

## Dependency Management

### pip

By default Travis CI uses `pip` to manage Python dependencies. If you have a
`requirements.txt` file, Travis CI runs `pip install -r requirements.txt`
during the `install` phase of the build.

You can manually override this default `install` phase, for example:

```yaml
install: pip install --user -r requirements.txt
```
{: data-file=".travis.yml"}

Please note that the `--user` option is mandatory if you are not using `language: python`, since no virtualenv will be created in that case.

### Custom Dependency Management

To override the default `pip` dependency management, alter the `before_install`
step as described in [general build
configuration](/user/customizing-the-build/#Customizing-the-Installation-Step) guide.

### Testing Against Multiple Versions of Dependencies (e.g. Django or Flask)

If you need to test against multiple versions of, say, Django, you can instruct
Travis CI to do multiple runs with different sets or values of environment variables.

Use *env* key in your .travis.yml file, for example:

```yaml
env:
  - DJANGO_VERSION=1.10.8
  - DJANGO_VERSION=1.11.5
```
{: data-file=".travis.yml"}

and then use ENV variable values in your dependencies installation scripts, test
cases or test script parameter values. Here we use ENV variable value to instruct
pip to install an exact version:

```yaml
install:
  - pip install -q Django==$DJANGO_VERSION
  - python setup.py -q install
```
{: data-file=".travis.yml"}

The same technique is often used to test projects against multiple databases and so on.

For a real world example, see [getsentry/sentry](https://github.com/getsentry/sentry/blob/master/.travis.yml) and [jpvanhal/flask-split](https://github.com/jpvanhal/flask-split/blob/master/.travis.yml).

## Build Matrix

For Python projects, `env` and `python` can be given as arrays
to construct a build matrix.

## Examples

- [tornadoweb/tornado](https://github.com/tornadoweb/tornado/blob/master/.travis.yml)
- [simplejson/simplejson](https://github.com/simplejson/simplejson/blob/master/.travis.yml)
- [fabric/fabric](http://github.com/fabric/fabric/blob/master/.travis.yml)
- [dstufft/slumber](https://github.com/dstufft/slumber/blob/master/.travis.yml)
- [dreid/cotools](https://github.com/dreid/cotools/blob/master/.travis.yml)
- [twisted/klein](https://github.com/twisted/klein/blob/master/.travis.yml)
