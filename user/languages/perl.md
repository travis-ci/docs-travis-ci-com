---
title: Building a Perl Project
layout: en

---

<div id="toc"></div>

<aside markdown="block" class="ataglance">

| Perl                                        | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#Dependency-Management) | `cpanm --quiet --installdeps --notest .`  |
| [Default `script`](#Default-Build-Script)   | Varies                                    |
| [Matrix keys](#Build-Matrix)                | `perl`, `env`                             |
| Support                                     | [Travis CI](mailto:support@travis-ci.com) |

Minimal example:

```yaml
language: perl
perl:
  - "5.26"
```
{: data-file=".travis.yml"}

</aside>

## What This Guide Covers

{{ site.data.snippets.linux_note }}

Perl builds are not available on the OS X environment.

The rest of this guide covers configuring Perl projects in Travis CI. If you're
new to Travis CI please read our [Getting Started](/user/getting-started/) and
[build configuration](/user/customizing-the-build/) guides first.

## Specifying Perl versions

Travis CI uses [Perlbrew](http://perlbrew.pl/) to provide several Perl versions
you can test your projects against:

```yaml
language: perl
perl:
  - "5.26"
  - "5.24"
  - "5.22"
```
{: data-file=".travis.yml"}

These versions specified by `major.minor` numbers are aliases to exact patch
levels, which are subject to change. For precise versions pre-installed on the
VM, please consult "Build system information" in the build log.

> Perl versions earlier than 5.8 are not supported.

### Perl runtimes with threading support

{{ site.data.language-details.perl.threading }}

## Default Build Script

The default build script varies according to your project:

* if your repository has `Build.PL` in the root:

  ```bash
  perl Build.PL && ./Build test
  ```
* if your repository has Makefile.PL in the root:

  ```bash
  perl Makefile.PL && make test
  ```

* if neither is found:

  ```bash
  make test
  ```

## Dependency Management

By default Travis CI use `cpanm` to manage your project's dependencies.

```bash
cpanm --quiet --installdeps --notest .
```

### When Overriding Build Commands, Do Not Use `sudo`

When overriding `install:` key to tweak dependency installation command (for
example, to run cpanm with verbosity flags), do not use `sudo`. Travis CI
Environment has Perls installed via Perlbrew in non-privileged user's `$HOME`
directory. Using `sudo` will result in dependencies being installed in unexpected
(for Travis CI Perl builder) locations and they won't load.

## Build Matrix

For Perl projects, `env` and `perl` can be given as arrays
to construct a build matrix.

## Environment Variables

The version of Perl a job is using is available as `TRAVIS_PERL_VERSION`.

## Examples

- [leto/math--primality](https://github.com/leto/math--primality/blob/master/.travis.yml)
- [fxn/algorithm-combinatorics](https://github.com/fxn/algorithm-combinatorics/blob/master/.travis.yml)
- [fxn/net-fluidinfo](https://github.com/fxn/net-fluidinfo/blob/master/.travis.yml)
- [fxn/acme-pythonic](https://github.com/fxn/acme-pythonic/blob/master/.travis.yml)
- [judofyr/parallol](https://github.com/judofyr/parallol/blob/travis-ci/.travis.yml)
- [mjgardner/SVN-Tree](https://github.com/mjgardner/SVN-Tree/blob/master/.travis.yml)
- [mjgardner/svn-simple-hook](https://github.com/mjgardner/svn-simple-hook/blob/master/.travis.yml)
