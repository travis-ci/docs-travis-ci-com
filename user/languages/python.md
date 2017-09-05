---
title: Building a Python Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Python projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

Python builds are not available on the OS X environment.

<div id="toc"></div>

## Choosing Python versions to test against

Travis CI supports Python versions 2.6, 2.7, 3.2, 3.3, 3.4, 3.5, 3.6 as well as recent development versions.

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
  - "nightly" # currently points to 3.7-dev
# command to install dependencies
install: "pip install -r requirements.txt"
# command to run tests
script: pytest
```
{: data-file=".travis.yml"}

As time goes, new releases come out and we provision more Python versions and/or implementations, aliases like `3.2` will float and point to different exact versions, patch levels and so on.

For precise versions pre-installed on the VM, please consult "Build system information" in the build log.

### Travis CI Uses Isolated virtualenvs

[CI Environment](/user/reference/precise/) uses separate virtualenv instances for each Python version. System Python is not used and should not be relied on. If you need to install Python packages, do it via pip and not apt.

If you decide to use apt anyway, note that Python system packages only include Python 2.7 libraries on Ubuntu 12.04 LTS. This means that the packages installed from the repositories are not available in other virtualenvs even if you use the --system-site-packages option.

### PyPy Support

Travis CI supports PyPy and PyPy3.

To test your project against PyPy, add "pypy" or "pypy3" to the list of Pythons in your `.travis.yml`:

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

## Default Python Version

If you leave the `python` key out of your `.travis.yml`, Travis CI will use Python 2.7.

## Specifying Test Script

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
message and fails the build.

## Dependency Management

### pip

By default Travis CI uses `pip` to manage python dependencies. If you have a
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

### Pre-installed packages

Travis CI installs the following packages by default in each virtualenv:

- pytest
- nose
- mock

### Testing Against Multiple Versions of Dependencies (e.g. Django or Flask)

If you need to test against multiple versions of, say, Django, you can instruct Travis CI to do multiple runs with different sets or values of environment variables. Use *env* key in your .travis.yml file, for example:

```yaml
env:
  - DJANGO_VERSION=1.7.8
  - DJANGO_VERSION=1.8.2
```
{: data-file=".travis.yml"}

and then use ENV variable values in your dependencies installation scripts, test cases or test script parameter values. Here we use ENV variable value to instruct pip to install an exact version:

```yaml
install:
  - pip install -q Django==$DJANGO_VERSION
  - python setup.py -q install
```
{: data-file=".travis.yml"}

The same technique is often used to test projects against multiple databases and so on. For a real world example, see [getsentry/sentry](https://github.com/getsentry/sentry/blob/master/.travis.yml) and [jpvanhal/flask-split](https://github.com/jpvanhal/flask-split/blob/master/.travis.yml).

## Nightly build support

Travis CI supports a special version name `nightly`, which points to
a recent development version of [CPython](https://bitbucket.org/mirror/cpython) build.

It also has the [packages above](#Pre-installed-packages) pre-installed.

## How Python Version is Chosen

When you specify Python versions, your job will first look for the runtime
pre-installed on the image.
If that version is not available, the job will fetch a pre-compiled
archive that matches the version for the image the job is running on,
and installed on demand.

For the complete list of Python runtimes available for on-demand installation,
see [the table below](#python-runtime-list).

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

## Python Versions Available for On-Demand Installation

These Python runtimes are available for on-demand installation.

<table id="python-runtime-list">
  <tr>
    <th>Python</th>
    <th>Distribution</th>
    <th>Versions</th>
  </tr>
  <tr>
    <th rowspan="{{ site.data.language_archives.python.precise | size }}" text-align="top">Python</th>
    <th rowspan="{{ site.data.language_archives.python.precise | size }}" text-align="top">Precise</th>
    <td>{{ site.data.language_archives.python.precise[0] }}</td>
  </tr>
  {% for x in site.data.language_archives.python.precise offset:1 %}
  <tr>
    <td>{{ x }}</td>
  </tr>
  {% endfor %}
  <tr>
    <th rowspan="{{ site.data.language_archives.python.trusty | size }}" text-align="top">Python</th>
    <th rowspan="{{ site.data.language_archives.python.trusty | size }}" text-align="top">Trusty</th>
    <td>{{ site.data.language_archives.python.trusty[0] }}</td>
  </tr>
  {% for x in site.data.language_archives.python.trusty offset:1 %}
  <tr>
    <td>{{ x }}</td>
  </tr>
  {% endfor %}
  <tr>
    <th rowspan="{{ site.data.language_archives.pypy.precise | size }}" text-align="top">PyPy</th>
    <th rowspan="{{ site.data.language_archives.pypy.precise | size }}" text-align="top">Precise</th>
    <td>{{ site.data.language_archives.pypy.precise[0] }}</td>
  </tr>
  {% for x in site.data.language_archives.pypy.precise offset:1 %}
  <tr>
    <td>{{ x }}</td>
  </tr>
  {% endfor %}
  <tr>
    <th rowspan="{{ site.data.language_archives.pypy.trusty | size }}" text-align="top">PyPy</th>
    <th rowspan="{{ site.data.language_archives.pypy.trusty | size }}" text-align="top">Trusty</th>
    <td>{{ site.data.language_archives.pypy.trusty[0] }}</td>
  </tr>
  {% for x in site.data.language_archives.pypy.trusty offset:1 %}
  <tr>
    <td>{{ x }}</td>
  </tr>
  {% endfor %}
</table>
