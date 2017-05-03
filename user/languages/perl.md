---
title: Building a Perl Project
layout: en
permalink: /user/languages/perl/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Perl projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

Perl builds are not available on the OSX environment.

## Choosing Perl versions to test against

Perl workers on travis-ci.org use [Perlbrew](http://perlbrew.pl/) to provide several Perl versions your projects can be tested against. To specify them, use the `perl:` key in your `.travis.yml` file, for example:

```yaml
language: perl
perl:
  - "5.24"
  - "5.22"
  - "5.20"
```

A more extensive example:

```yaml
language: perl
perl:
  - "5.24"
  - "5.22"
  - "5.20"
  - "5.18"
  - "5.16"
```

As time goes, new releases come out and we upgrade both Perlbrew and Perls, aliases like `5.14` will float and point to different exact versions, patch levels and so on.

For precise versions pre-installed on the VM, please consult "Build system information" in the build log.

*Perl versions earlier than 5.8 are not and will not be provided. Please do not list them in `.travis.yml`.*

### Perl runtimes with `-Duseshrplib`

Additionally, some Perls have been compiled with threading support. They have
been compiled with the additional compile flags `-Duseshrplib` and `-Duseithreads`. This are the
versions that are available:

```yaml
5.24-shrplib
5.22-shrplib
5.20-shrplib
5.18-shrplib
```


## Default Perl Version

If you leave the `perl` key out of your `.travis.yml`, Travis CI will use Perl 5.14.

## Default Test Script

### Module::Build

If your repository has Build.PL in the root, it will be used to generate the build script:

```bash
perl Build.PL && ./Build test
```

### EUMM

If your repository has Makefile.PL in the root, it will be used like so

```bash
perl Makefile.PL && make test
```

If neither Module::Build nor EUMM build files are found, Travis CI will fall back to running

```bash
make test
```

It is possible to override test command as described in the [general build configuration](/user/customizing-the-build/) guide.

## Dependency Management

### Travis CI uses cpanm

By default Travis CI use `cpanm` to manage your project's dependencies. It is possible to override dependency installation command as described in the [general build configuration](/user/customizing-the-build/) guide.

The exact default command is

```bash
cpanm --quiet --installdeps --notest .
```

### When Overriding Build Commands, Do Not Use sudo

When overriding `install:` key to tweak dependency installation command (for example, to run cpanm with verbosity flags), do not use sudo.
Travis CI Environment has Perls installed via Perlbrew in non-privileged user $HOME directory. Using sudo will result in dependencies
being installed in unexpected (for Travis CI Perl builder) locations and they won't load.

## Build Matrix

For Perl projects, `env` and `perl` can be given as arrays
to construct a build matrix.

## Environment Variable

The version of Perl a job is using is available as:

```
TRAVIS_PERL_VERSION
```

## Examples

- [leto/math--primality](https://github.com/leto/math--primality/blob/master/.travis.yml)
- [fxn/algorithm-combinatorics](https://github.com/fxn/algorithm-combinatorics/blob/master/.travis.yml)
- [fxn/net-fluidinfo](https://github.com/fxn/net-fluidinfo/blob/master/.travis.yml)
- [fxn/acme-pythonic](https://github.com/fxn/acme-pythonic/blob/master/.travis.yml)
- [judofyr/parallol](https://github.com/judofyr/parallol/blob/travis-ci/.travis.yml)
- [mjgardner/SVN-Tree](https://github.com/mjgardner/SVN-Tree/blob/master/.travis.yml)
- [mjgardner/svn-simple-hook](https://github.com/mjgardner/svn-simple-hook/blob/master/.travis.yml)
