---
title: Building a Python Project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| Python                                      | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#dependency-management) | `pip install -r requirements.txt`         |
| [Default `script`](#default-build-script)   | N/A                                       |
| [Matrix keys](#build-matrix)                | `python`, `env`                           |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
  language: python
  script:
    - pytest
```
{: data-file=".travis.yml"}
</aside>

{{ site.data.snippets.linux_note }}

{: .warning}
> Python builds are not available on the macOS and Windows environments.

The rest of this guide covers configuring Python projects in Travis CI. If you're
new to Travis CI please read our [Tutorial](/user/tutorial/) and
[build configuration](/user/customizing-the-build/) guides first.

## Specifying Python versions

Specify Python versions using the `python` key. As we update the Python build
images, aliases like `3.6` will point to different exact versions or patch
levels.

```yaml
language: python
python:
  - "2.7"
  - "3.4"
  - "3.5"
  - "3.6"      # current default Python on Travis CI
  - "3.7"
  - "3.8"
  - "3.8-dev"  # 3.8 development branch
  - "nightly"  # nightly build
# command to install dependencies
install:
  - pip install -r requirements.txt
# command to run tests
script:
  - pytest
```
{: data-file=".travis.yml"}

{% if site.data.language-details.python-versions.size > 0 %}
If the specified version of Python is not available on the present build image,
the job will attempt to download the suitable remote archive and make it
available.
You can find the list of such versions in [the table below](#python-versions).

{% endif %}
### Travis CI Uses Isolated virtualenvs

The CI Environment uses separate virtualenv instances for each Python
version. This means that as soon as you specify `language: python` in `.travis.yml` your tests will run inside a virtualenv (without you having to explicitly create it).
System Python is not used and should not be relied on. If you need
to install Python packages, do it via pip and not apt.

If you decide to use apt anyway, note that for compatibility reasons, you'll only be able to use the default Python versions that are available in Ubuntu (e.g. for Xenial, this means 2.7.12 and 3.5.1).
To access the packages inside the virtualenv, you will need to specify that it should be created with the `--system-site-packages` option.
To do this, include the following in your `.travis.yml`:

```yaml
language: python
python:
  - "2.7"
  - "3.5"
virtualenv:
  system_site_packages: true
```
{: data-file=".travis.yml"}


### PyPy Support

Travis CI supports PyPy and PyPy3.

To test your project against PyPy, add "pypy" and/or "pypy3" to the list of Pythons
in your `.travis.yml`:

```yaml
language: python
python:
  - "2.7"
  - "3.8"
  # PyPy versions
  - "pypy"   # currently Python 2.7.13, PyPy 7.1.1
  - "pypy3"  # currently Python 3.6.1,  PyPy 7.1.1-beta0
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

## Default Build Script

Python projects need to provide the `script` key in their `.travis.yml` to
specify what command to run tests with.

For example, if your project uses pytest:

```yaml
# command to run tests
script: pytest
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
As described [above](/user/languages/python/#travis-ci-uses-isolated-virtualenvs), Travis already runs tests inside an isolated virtualenv whenever `language: python` is specified, so please bear that in mind whenever creating more environments with tox. If you would prefer to run tox outside the Travis-created virtualenv, it might be a better idea to use `language: generic` instead of `language: python`.

If you're using tox to test your code against multiple versions of Python, you have two options:
  * use `language: generic` and manually install the Python versions you're interested in before running tox (without the manual installation, tox will only have access to the default Ubuntu Python versions - 2.7.12 and 3.5.1 for Xenial)
  * use `language: python` and a build matrix that uses a different version of Python for each branch (you can specify the Python version by using the `python` key). This will ensure the versions you're interested in are installed and parallelizes your workload.

A good example of a `travis.yml` that runs tox using a Travis build matrix is [twisted/klein](https://github.com/twisted/klein/blob/master/.travis.yml).

## Running Python tests on multiple Operating Systems

Sometimes it is necessary to ensure that software works the same across multiple Operating Systems.  This following `.travis.yml` file will execute parallel test runs on Linux, macOS, and Windows.

```yaml
language: python            # this works for Linux but is an error on macOS or Windows
jobs:
  include:
    - name: "Python 3.8.0 on Xenial Linux"
      python: 3.8           # this works for Linux but is ignored on macOS or Windows
    - name: "Python 3.7.4 on macOS"
      os: osx
      osx_image: xcode11.2  # Python 3.7.4 running on macOS 10.14.4
      language: shell       # 'language: python' is an error on Travis CI macOS
    - name: "Python 3.8.0 on Windows"
      os: windows           # Windows 10.0.17134 N/A Build 17134
      language: shell       # 'language: python' is an error on Travis CI Windows
      before_install:
        - choco install python --version 3.8.0
        - python -m pip install --upgrade pip
      env: PATH=/c/Python38:/c/Python38/Scripts:$PATH
install: pip3 install --upgrade pip  # all three OSes agree about 'pip3'
# 'python' points to Python 2.7 on macOS but points to Python 3.8 on Linux and Windows
# 'python3' is a 'command not found' error on Windows but 'py' works on Windows only
script: python3 my_app.py || python my_app.py
```
{: data-file=".travis.yml"}

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
configuration](/user/job-lifecycle/#customizing-the-installation-phase) guide.

### Testing Against Multiple Versions of Dependencies (e.g. Django or Flask)

If you need to test against multiple versions of, say, Django, you can instruct
Travis CI to do multiple runs with different sets or values of environment variables.

Use *env* key in your .travis.yml file, for example:

```yaml
env:
  - DJANGO_VERSION=2.1.13
  - DJANGO_VERSION=2.2.6
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

For real world examples, see [getsentry/sentry](https://github.com/getsentry/sentry/blob/master/.travis.yml) and [jpvanhal/flask-split](https://github.com/jpvanhal/flask-split/blob/master/.travis.yml).

## Build Config Reference

You can find more information on the build config format for [Python](https://config.travis-ci.com/ref/language/python) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).

## Examples

- [tornadoweb/tornado](https://github.com/tornadoweb/tornado/blob/master/.travis.yml)
- [simplejson/simplejson](https://github.com/simplejson/simplejson/blob/master/.travis.yml)
- [fabric/fabric](http://github.com/fabric/fabric/blob/master/.travis.yml)
- [dstufft/slumber](https://github.com/dstufft/slumber/blob/master/.travis.yml)
- [dreid/cotools](https://github.com/dreid/cotools/blob/master/.travis.yml)
- [twisted/klein](https://github.com/twisted/klein/blob/master/.travis.yml)

{% if site.data.language-details.python-versions.size > 0 %}
## Python versions

These archives are available for on-demand installation.

{: #python-versions-table}
| Release | Arch | Name |
| :------------- | :------------- | :------- |{% for file in site.data.language-details.python-versions %}
| {{ file.release }} | {{ file.arch }} | {{ file.name }} |{% endfor %}
{% endif %}

<script src="{{ "/assets/javascripts/tablefilter/dist/tablefilter/tablefilter.js" | prepend: site.baseurl }}" type="text/javascript" charset="utf-8"></script>
<script>
var tf = new TableFilter(document.querySelector('#python-versions-table'), {
    base_path: '/assets/javascripts/tablefilter/dist/tablefilter/',
    col_0: 'select',
    col_1: 'select',
    col_2: 'none',
    col_widths: ['100px', '100px', '250px'],
    alternate_rows: true,
    no_results_message: true
});
tf.init();
tf.setFilterValue(0, "16.04");
tf.setFilterValue(1, "x86_64");
tf.filter();
</script>
