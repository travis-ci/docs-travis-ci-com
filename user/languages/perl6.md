---
title: Building a Perl 6 Project
layout: en
support: community
maintainers:
  - 'paultcochrane'
  - 'hoelzro'
  - 'ugexe'
  - 'tony-o'
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
Perl 6 projects. Please make sure to read our [Tutorial](/user/tutorial/)
and [general build configuration](/user/customizing-the-build/) guides first.

Perl 6 builds are not available on the macOS environment.

### Community-Supported Warning

Travis CI support forPerl 6 is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:perl6)
and cc {% for m in page.maintainers %}<a href="https://github.com/{{m}}">@{{m}}</a> {% endfor %}.

## Choosing Perl 6 versions to test against

Perl 6 workers on Travis CI use
[rakudobrew](https://github.com/tadzik/rakudobrew) to provide several Perl 6
versions that your projects can be tested against. To specify them, use the
`perl6:` key in your `.travis.yml` file, for example:

```yaml
language: perl6
perl6:
  - latest
  - '2017.05'
  - '2017.04'
```
{: data-file=".travis.yml"}

Over time, new releases come out and we upgrade both rakudobrew and
Perls, aliases like `2017.05` will float and point to different exact
versions, patch levels and so on.

For precise versions pre-installed on the VM, please consult "Build system
information" in the build log.

## Perl 6 Stack

At present the Perl 6 that is built is [Rakudo](http://rakudo.org/) upon
[NQP](https://github.com/perl6/nqp/) with the [MoarVM](http://moarvm.org/)
backend.  Future support for the
[JVM](http://en.wikipedia.org/wiki/Java_virtual_machine) backend is planned.

## Default Perl 6 Version

If you leave the `perl6` key out of your `.travis.yml`, Travis CI will build
Rakudo Perl 6 from the latest commit from the project's `master` branch.

## Default Test Script

By default, the following command will be used to run the project's tests:

```
PERL6LIB=lib prove -v -r --exec=perl6 t/
```

## Dependency Management

### There is currently no automated dependency management

At present, by default Travis CI does not automatically manage your
project's dependencies.  It is possible to manage dependencies yourself by
either downloading and installing your dependencies as part of the `install`
step, or you could use [zef](https://github.com/ugexe/zef) (the Perl 6
module package manager) like so:

```yaml
install:
    - rakudobrew build-zef
    - zef --debug --depsonly install .
```
{: data-file=".travis.yml"}

this will install the latest `zef` version.

Further information about overriding dependency installation commands is
described in the [general build configuration](/user/customizing-the-build/)
guide.

### When overriding build commands, do not use sudo

When overriding the `install:` key to tweak dependency installation
commands, do not use sudo.  Travis CI Environment has Perl 6 versions
installed via rakudobrew in a non-privileged user `$HOME` directory. Using
sudo will result in dependencies being installed in unexpected (for the
Travis CI Perl 6 builder) locations and they won't load.

## Build Matrix

For Perl 6 projects, `env` and `perl6` can be given as arrays to construct a
build matrix. (As yet untested).

## Environment Variable

The Perl 6 version a job is using is available via:

```
TRAVIS_PERL6_VERSION
```

## Examples

### Build and test with the latest Rakudo

```yaml
language: perl6

perl6:
    - latest

install:
    - rakudobrew build-zef
    - zef --debug --depsonly install .
```
{: data-file=".travis.yml"}

### Build and test with multiple Rakudo versions

```yaml
language: perl6

perl6:
    - '2017.05'
    - '2017.04'

install:
    - rakudobrew build-zef
    - zef --debug --depsonly install .
```
{: data-file=".travis.yml"}

### Build and test with the latest Rakudo, but with non-standard lib and test dirs

Use e.g. `src/` for the module library code, and `tests/` as the test
directory.  Please note that it is standard practice to put the module
library code under `lib/` and the tests under `t/`.

```yaml
language: perl6

script:
    - PERL6LIB=src prove -v -r --exec=perl6 tests/
```
{: data-file=".travis.yml"}
