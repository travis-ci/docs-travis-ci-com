---
title: Building an R Project
layout: en
permalink: /user/languages/r/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to R
projects. Please make sure to read our [Getting
Started](/user/getting-started/) and [general build
configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for R is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker][github] and cc [@craigcitro][github 2],
[@hadley][github 3], and [@jimhester][github 4].

## Basic configuration

R support in Travis CI is designed to make it easy to test [R
packages][r-project]. If your R package doesn't need any system dependencies
beyond those specified in your `DESCRIPTION` file, your `.travis.yml` can
simply be

```yaml
language: r
```

Using the package cache to store R package dependencies can significantly speed
up build times and is recommended for most builds.

```yaml
language: r
cache: packages
```

If you do _not_ see
```
This job is running on container-based infrastructure, which does not allow use of
'sudo', setuid and setguid executables.
```

You will need to set `sudo: false` in order to use the container based builds
and package caching.

The R environment comes with [LaTeX][tug] and [pandoc][johnmacfarlane]
pre-installed, making it easier to use packages like [RMarkdown][rstudio] or
[knitr][yihui].

## Configuration options

Travis CI supports a number of configuration options for your R package.

### R Versions ###

Travis CI supports R versions `3.1.3`, `3.2.3` and `devel` on Linux Precise
builds. The names `oldrel` and `3.1` are aliased to `3.1.2` and the names
`release` and `3.2` are aliased to `3.2.3`. Matrix builds _are_ supported for R
builds, however both instances of `r` must be in _lowercase_.

```yaml
language: r
r:
  - oldrel
  - release
  - devel
```

As new minor versions are released, aliases will float and point to the most
current minor release.

For exact versions used for a build, please consult "Build system information"
in the build log.

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

The best way to figure out what packages you may need is to look at the
packages listed in the LaTeX error message and search for them on [CTAN][ctan].
Packages often have a `Contained in:` field that indicates the package group
you need to install.

### Pandoc ###

The default pandoc version installed is `1.15.2`. Alternative [pandoc
releases][github 7] can be installed by setting the `pandoc_version` to the
desired version.

```yaml
language: r
pandoc_version: 1.16
```

### Package check options

You can use the following top-level options to control what options are used
when building and checking your package:

* `warnings_are_errors`: This option forces all `WARNINGS` from `R CMD check` to
  become build failures (default `true`). This is especially helpful when preparing
  your package for submission to CRAN, and is recommended for most packages.
  Simply set `warnings_are_errors: false` if you need to disable this feature.

* `r_build_args`: additional arguments to pass to `R CMD build`, as a single
  string. Defaults to empty.

* `r_check_args`: additional arguments to pass to `R CMD check`, as a single
  string. Defaults to `--as-cran`.

### Bioconductor

A typical [Bioconductor][bioconductor] package should only need to specify the
Bioconductor version they want to test against in their `.travis.yml`.

```yaml
language: r
r: bioc-devel
```

Or if you want to test against the release branch

```yaml
language: r
r: bioc-release
```

Travis CI will use the proper R version for that version of Bioconductor and
configure Bioconductor appropriately for installing dependencies.

### Miscellaneous

* `cran`: CRAN mirror to use for fetching packages. Defaults to
  `https://cloud.r-project.org`.

* `repos`: Dictionary of repositories to pass to `options(repos)`. If `CRAN` is
  not given in the dictionary the value of the `cran` option is used.
  Example:

```yaml
repos:
  CRAN: https://cloud.r-project.org
  ropensci: http://packages.ropensci.org
```

* `r_check_revdep`: if `true`, also run checks on CRAN packages which depend
  on this one. This can be quite expensive, so it's not recommended to leave
  this set to `true`.

### Additional Dependency Fields ###

For most packages you should not need to specify any additional dependencies in
your `.travis.yml`. However for rare cases the following fields
are supported.

Each of the names below is a list of packages you can optionally specify as a
top-level entry in your `.travis.yml`; entries in these lists will be
installed before building and testing your package. Note that these lists are
processed in order, so entries can depend on dependencies in a previous list.

* `apt_packages`: A list of packages to install via `apt-get`. Common examples
  here include entries in `SystemRequirements`. This option is ignored on
  non-linux builds and will not work if `sudo: false`.

* `brew_packages`: A list of packages to install via `brew`. This option is
  ignored on non-OS X builds.

* `r_binary_packages`: A list of R packages to install as binary packages on
  linux builds, via Michael Rutter's
  [cran2deb4ubuntu PPA][launchpad].
  These installs will be faster than source installs, but may not always be
  the most recent version. Specify the name just as you would when installing
  from CRAN. On OS X builds and builds without `sudo: required`, these packages
  are installed from source.

* `r_packages`: A list of R packages to install via `install.packages`.

* `bioc_packages`: A list of [Bioconductor][bioconductor]
  packages to install.

* `r_github_packages`: A list of packages to install directly from GitHub,
  using `devtools::install_github` from the
  [devtools package][github 8]. The package names
  here should be of the form `user/repo`.

## Examples

If you are using the [container based builds][container] you can take advantage
of the package cache to speed up subsequent build times. For most projects
these two lines are sufficient.

```yaml
language: r
cache: packages
```

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
[github 3]: https://github.com/hadley
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
[yihui]: http://yihui.name/knitr/
