---
title: Building an R Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to R
projects. Please make sure to read our [Getting
Started](/user/getting-started/) and [general build
configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for R is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker][github] and cc [@craigcitro][github 2]
and [@jimhester][github 4].

## Basic configuration

R support in Travis CI is designed to make it easy to test [R
packages][r-project]. If your R package doesn't need any system dependencies
beyond those specified in your `DESCRIPTION` file, your `.travis.yml` can
simply be

```yaml
language: r
```
{: data-file=".travis.yml"}

Using the package cache to store R package dependencies can significantly speed
up build times and is recommended for most builds.

```yaml
language: r
cache: packages
```
{: data-file=".travis.yml"}

If you do *not* see

```
This job is running on container-based infrastructure, which does not allow use of
'sudo', setuid and setguid executables.
```

You will need to set `sudo: false` in order to use the container based builds
and package caching.

The R environment comes with [LaTeX][tug] and [pandoc][johnmacfarlane]
pre-installed, making it easier to use packages like [RMarkdown][rstudio] or
[knitr](https://yihui.name/knitr/){: data-proofer-ignore=""}

## Configuration options

Travis CI supports a number of configuration options for your R package.

### R Versions

Travis CI supports R versions `3.1.3` and above on Linux Precise
builds.  Aliases exist for each major release, e.g `3.1` points to `3.1.3`. In
addition the name `oldrel` is aliased to `3.2.5` and release is aliased to
`3.3.0`. `devel` is built off of the [R git
mirror](https://travis-ci.org/wch/r-source) of the R SVN trunk (updated
hourly).

Matrix builds *are* supported for R builds, however both instances of `r` must
be in *lowercase*.

```yaml
language: r
r:
  - oldrel
  - release
  - devel
```
{: data-file=".travis.yml"}

As new minor versions are released, aliases will float and point to the most
current minor release.

The exact R version used for each build is included in the 'R session information'
fold within the build log.

### Dependencies

By default, Travis CI will find all R packages listed as dependencies in your
package's `DESCRIPTION` file, and install them from CRAN. You can include
dependencies on packages in development by listing them in the `Remotes:` field
in your `DESCRIPTION`. See the [Remotes Vignette][github 5] for more
information on using development remotes in your package.

Most of the time you should not need to specify any additional dependencies in
your `.travis.yml`.

### LaTeX/TexLive Packages

The included TexLive distribution contains only a [limited set of default
packages][github 6]. If your vignettes require additional TexLive packages you
can install them using `tlmgr install` in the `before_install` step.

```yaml
language: r

before_install:
  - tlmgr install index
```
{: data-file=".travis.yml"}

The best way to figure out what packages you may need is to look at the
packages listed in the LaTeX error message and search for them on [CTAN][ctan].
Packages often have a `Contained in:` field that indicates the package group
you need to install.

If you don't need LaTeX, tell Travis CI not to install it using `latex: false`.

### Pandoc

The default pandoc version installed is `1.15.2`. Alternative [pandoc
releases][github 7] can be installed by setting the `pandoc_version` to the
desired version.

```yaml
language: r
pandoc_version: 1.16
```
{: data-file=".travis.yml"}

If you don't need Pandoc, tell Travis CI not to install it using `pandoc: false`.

### APT packages

Use the [APT addon][apt-addon]
to install APT packages on both container-based (`sudo: false`)
and standard (`sudo: required`) infrastructures.
The snippet below installs a prerequisite for the R package `xml2`:

```yaml
addons:
  apt:
    packages:
      - libxml2-dev
```
{: data-file=".travis.yml"}

Note that the APT package needs to be white-listed for this to work
on container-based infrastructure.
This option is ignored on non-Linux builds.

An alternative that works only on standard infrastructure (`sudo: required`) is
the `apt_packages` field:

```yaml
apt_packages:
  - libxml2-dev
```
{: data-file=".travis.yml"}

### Package check options

You can use the following top-level options to control what options are used
when building and checking your package:

- `warnings_are_errors`: This option forces all `WARNINGS` from `R CMD check` to
  become build failures (default `true`). This is especially helpful when preparing
  your package for submission to CRAN, and is recommended for most packages.
  Set `warnings_are_errors: false` if you don't want `WARNINGS` to fail the build.

- `r_build_args`: additional arguments to pass to `R CMD build`, as a single
  string. Defaults to empty.

- `r_check_args`: additional arguments to pass to `R CMD check`, as a single
  string. Defaults to `--as-cran`.

### Bioconductor

A typical [Bioconductor][bioconductor] package should only need to specify the
Bioconductor version they want to test against in their `.travis.yml`.

```yaml
language: r
r: bioc-devel
```
{: data-file=".travis.yml"}

Or if you want to test against the release branch

```yaml
language: r
r: bioc-release
```
{: data-file=".travis.yml"}

Travis CI will use the proper R version for that version of Bioconductor and
configure Bioconductor appropriately for installing dependencies.

### Packrat

If you want Travis CI to use your project-specific packrat package library,
rather than the default behaviour of downloading your package dependencies from CRAN, you can add this to your `.travis.yml`:

```yaml
install:
  - R -e "0" --args --bootstrap-packrat
```
{: data-file=".travis.yml"}

You can minimise build times by caching your packrat packages with:

```yaml
cache:
  directories:
    - $TRAVIS_BUILD_DIR/packrat/src
    - $TRAVIS_BUILD_DIR/packrat/lib
  packages: true
```
{: data-file=".travis.yml"}

### Miscellaneous

- `cran`: CRAN mirror to use for fetching packages. Defaults to
  `https://cloud.r-project.org`.

- `repos`: Dictionary of repositories to pass to `options(repos)`. If `CRAN` is
  not given in the dictionary the value of the `cran` option is used.
  Example:

```yaml
repos:
  CRAN: https://cloud.r-project.org
  ropensci: http://packages.ropensci.org
```
{: data-file=".travis.yml"}

- `r_check_revdep`: if `true`, also run checks on CRAN packages which depend
  on this one. This can be quite expensive, so it's not recommended to leave
  this set to `true`.

- `disable_homebrew`: if `true` this removes the preinstalled homebrew
  installation on OS X. Useful to test if the package builds on a vanilla OS X
  machine, such as the CRAN mac builder.

### Environment Variables

R-Travis sets the following additional environment variables from the [Travis
defaults](/user/environment-variables/#Default-Environment-Variables).

- `TRAVIS_R_VERSION=3.2.4` Set to version chosen by `r:`.
- `R_LIBS_USER=~/R/Library`
- `R_LIBS_SITE=/usr/local/lib/R/site-library:/usr/lib/R/site-library`
- `_R_CHECK_CRAN_INCOMING_=false`
- `NOT_CRAN=true`
- `R_PROFILE=~/.Rprofile.site`

### Additional Dependency Fields

For most packages you should not need to specify any additional dependencies in
your `.travis.yml`. However for rare cases the following fields
are supported.

Each of the names below is a list of packages you can optionally specify as a
top-level entry in your `.travis.yml`; entries in these lists will be
installed before building and testing your package. Note that these lists are
processed in order, so entries can depend on dependencies in a previous list.

- `apt_packages`: See above

- `brew_packages`: A list of packages to install via `brew`. This option is
  ignored on non-OS X builds.

- `r_binary_packages`: A list of R packages to install as binary packages on
  linux builds, via Michael Rutter's
  [cran2deb4ubuntu PPA][launchpad].
  These installs will be faster than source installs, but may not always be
  the most recent version. Specify the name just as you would when installing
  from CRAN. On OS X builds and builds without `sudo: required`, these packages
  are installed from source.

- `r_packages`: A list of R packages to install via `install.packages`.

- `bioc_packages`: A list of [Bioconductor][bioconductor]
  packages to install.

- `r_github_packages`: A list of packages to install directly from GitHub,
  using `devtools::install_github` from the
  [devtools package][github 8]. The package names
  here should be of the form `user/repo`.
  If the package is installed in a subdirectory, use `user/repo/subdirectory`.
  An alternative is to add `user/repo` or `user/repo/folder` to
  the `Remotes` section of the `DESCRIPTION` file of your package

### Customizing the Travis build steps

For some advanced use cases, it makes sense to override the default steps used
for building R packages. The default rules roughly amount to:

```yaml
install:
- R -e 'devtools::install_deps(dep = T)'

script:
- R CMD build .
- R CMD check *tar.gz
```
{: data-file=".travis.yml"}

If you'd like to see the full details, see
[the source code](https://github.com/travis-ci/travis-build/blob/master/lib/travis/build/script/r.rb).

## Examples

If you are using the [container based builds][container] you can take advantage
of the package cache to speed up subsequent build times. For most projects
these two lines are sufficient.

```yaml
language: r
cache: packages
```
{: data-file=".travis.yml"}

### Package in a subdirectory

If your package is in a subdirectory of the repository you simply need to
change to the subdirectory prior to running the `install` or `script` steps.

```yaml
language: r
before_install:
  - cd subdirectory
```
{: data-file=".travis.yml"}

### Remote package

If your package depends on another repository you can use `r_github_packages` in this way:

```yaml
r_github_packages: user/repo
```
{: data-file=".travis.yml"}

An alternative is to add the following line to your `DESCRIPTION` file:

```yaml
Imports: pkg-name-of-repo
Remotes: user/repo
```
{: data-file=".travis.yml"}

Remember that `Remotes:` specifies the *source* of a development package, so the package still needs to be listed in `Imports:`, `Suggests:` `Depends:` or `LinkingTo:`.
In the rare case where *repo* and *package* name differ, `Remotes:` expects the *reposistory* name and `Imports:` expects the *package* name (as per the `DESCRIPTION` of that imported package).


### Remote package in a subdirectory

If your package depends on another repository which holds the package in a subdirectory, you can use `r_github_packages` in this way:

```yaml
r_github_packages: user/repo/folder
```
{: data-file=".travis.yml"}

An alternative is to add the following line to your `DESCRIPTION` file:

```yaml
Remotes: user/repo/folder
```
{: data-file=".travis.yml"}

## Converting from r-travis

If you've already been using [r-travis][] to test your R package, you're
encouraged to switch to using the native support described here. We've written
a [porting guide][github 9] to help you modify your `.travis.yml`.

## Acknowledgements

R support for Travis CI was originally based on the [r-travis][] project, and
thanks are due to all the [contributors][github 10]. For more information on
moving from r-travis to native support, see the [porting guide][github 9].

[bioconductor]: https://www.bioconductor.org/

[container]: /user/workers/container-based-infrastructure/

[ctan]: https://www.ctan.org/

[github]: https://github.com/travis-ci/travis-ci/issues/new?labels=community:r

[github 2]: https://github.com/craigcitro

[github 4]: https://github.com/jimhester

[github 5]: https://github.com/hadley/devtools/blob/master/vignettes/dependencies.Rmd#package-remotes

[github 6]: https://github.com/yihui/ubuntu-bin/blob/master/TeXLive.pkgs

[github 7]: https://github.com/jgm/pandoc/releases

[github 8]: https://github.com/hadley/devtools

[github 9]: https://github.com/craigcitro/r-travis/wiki/Porting-to-native-R-support-in-Travis

[github 10]: https://github.com/craigcitro/r-travis/graphs/contributors

[johnmacfarlane]: http://johnmacfarlane.net/pandoc/

[launchpad]: https://launchpad.net/~marutter/+archive/ubuntu/c2d4u

[r-project]: http://cran.r-project.org/doc/manuals/R-exts.html

[r-travis]: https://github.com/craigcitro/r-travis

[rstudio]: http://rmarkdown.rstudio.com/

[tug]: https://www.tug.org/texlive/

[apt-addon]: /user/installing-dependencies/#Installing-Packages-with-the-APT-Addon
