---
title: Building a Perl Project
layout: en
permalink: perl/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Perl projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Choosing Perl versions to test against

Perl workers on travis-ci.org use [Perlbrew](http://perlbrew.pl/) to provide several Perl versions your projects can be tested against. To specify them, use `perl:` key in your `.travis.yml` file, for example:

    language: perl
    perl:
      - "5.16"
      - "5.14"

A more extensive example:

    language: perl
    perl:
      - "5.16"
      - "5.14"
      - "5.12"
      - "5.10"
      - "5.8"

As time goes, new releases come out and we upgrade both Perlbrew and Perls, aliases like `5.14` will float and point to different exact versions, patch levels and so on.
For full up-to-date list of provided Perl versions, see our [CI environment guide](/docs/user/ci-environment/).

*Perl versions earlier than 5.8 are not and will not be provided. Please do not list them in `.travis.yml`.*

## Default Perl Version

If you leave the `perl` key out of your `.travis.yml`, Travis CI will use Perl 5.14.

## Default Test Script

### Module::Build

If your repository has Build.PL is the root, it will be used to generate build script:

    perl Build.PL && ./Build test

### EUMM

If your repository has Makefile.PL is the root, it will be used like so

    perl Makefile.PL && make test

If neither Module::Build nor EUMM build files are found, Travis CI will fall back to running

    make test

It is possible to override test command as described in the [general build configuration](/docs/user/build-configuration/) guide.


## Dependency Management

### Travis CI uses cpanm

By default Travis CI use `cpanm` to manage your project's dependencies. It is possible to override dependency installation command as described in the [general build configuration](/docs/user/build-configuration/) guide.

The exact default command is

    cpanm --installdeps --notest .

### When Overriding Build Commands, Do Not Use sudo

When overriding `install:` key to tweak dependency installation command (for example, to run cpanm with verbosity flags), do not use sudo.
Travis CI Environment has Perls installed via Perlbrew in non-privileged user $HOME directory. Using sudo will result in dependencies
being installed in unexpected (for Travis CI Perl builder) locations and they won't load.



## Network-local CPAN Mirror

Travis CI has a network-local CPAN mirror at [cpan.mirrors.travis-ci.org](http://cpan.mirrors.travis-ci.org/) and `PERL_CPANM_OPT` is configured to use
it.


## Examples

* [leto/math--primality](https://github.com/leto/math--primality/blob/master/.travis.yml)
* [fxn/algorithm-combinatorics](https://github.com/fxn/algorithm-combinatorics/blob/master/.travis.yml)
* [fxn/net-fluidinfo](https://github.com/fxn/net-fluidinfo/blob/master/.travis.yml)
* [fxn/acme-pythonic](https://github.com/fxn/acme-pythonic/blob/master/.travis.yml)
* [judofyr/parallol](https://github.com/judofyr/parallol/blob/travis-ci/.travis.yml)
* [mjgardner/SVN-Tree](https://github.com/mjgardner/SVN-Tree/blob/master/.travis.yml)
* [mjgardner/svn-simple-hook](https://github.com/mjgardner/svn-simple-hook/blob/master/.travis.yml)
