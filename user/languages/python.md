---
title: Building a Python Project
layout: en

---

<div id="toc"></div>

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
    - 3.6
    - nightly
  script:
    - pytest
```
{: data-file=".travis.yml"}

</aside>

### What This Guide Covers

{{ site.data.snippets.trusty_note_no_osx }}

Python builds are not available on the OS X environment.


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
  - "3.2"
  - "3.3"
  - "3.4"
  - "3.5"
  - "3.5-dev" # 3.5 development branch
  - "3.6"
  - "3.6-dev" # 3.6 development branch
  - "3.7-dev" # 3.7 development branch
  - "nightly"
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
version. System Python is not used and should not be relied on. If you need
to install Python packages, do it via pip and not apt.

If you decide to use apt anyway, note that Python system packages only
include Python 2.7 libraries on Ubuntu. This means that the packages
installed from the repositories are not available in other virtualenvs even
if you use the --system-site-packages option.

### PyPy Support

Travis CI supports PyPy and PyPy3.

To test your project against PyPy, add "pypy" or "pypy3" to the list of Pythons
in your `.travis.yml`:

```yaml
language: python
python:
  - "2.6"
  - "2.7"
  - "3.2"
  - "3.3"
  - "3.4"
  # PyPy versions
  - "pypy"  # PyPy2 2.5.0
  - "pypy3" # Pypy3 2.4.0
  - "pypy-5.3.1"
# command to install dependencies
install:
  - pip install .
  - pip install -r requirements.txt
# command to run tests
script: pytest
```
{: data-file=".travis.yml"}

### Nightly build support

Travis CI supports a special version name `nightly`, which points to
a recent development version of [CPython](https://bitbucket.org/mirror/cpython) build.

### Development releases support

From Python 3.5, Python In Development versions are available.

You can specify these in your builds with `3.5-dev`, `3.6-dev` or `3.7-dev`.

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
  - DJANGO_VERSION=1.7.8
  - DJANGO_VERSION=1.8.2
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
