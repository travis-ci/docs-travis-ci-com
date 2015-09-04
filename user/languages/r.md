---
title: Building an R Project
layout: en
permalink: /user/languages/r/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to R
projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for R is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:r)
and cc [@craigcitro](https://github.com/craigcitro),
[@eddelbuettel](https://github.com/eddelbuettel), and
[@hadley](https://github.com/hadley).

## Basic configuration

R support in Travis CI is designed to make it easy to test
[R packages](http://cran.r-project.org/doc/manuals/R-exts.html). If your R
package doesn't need any dependencies beyond those specified in your
`DESCRIPTION` file, your `.travis.yml` can simply be

    language: r
    sudo: required

The R environment comes with LaTeX and
[pandoc](http://johnmacfarlane.net/pandoc/) preinstalled, making it easier to
use packages like [RMarkdown](http://rmarkdown.rstudio.com/) or
[knitr](http://yihui.name/knitr/).

Note that R support in Travis CI currently requires `sudo`, which means it
can't be used with
[container-based builds](/user/workers/container-based-infrastructure/).

## Configuration options

Travis CI supports a number of configuration options for your R package.

### Dependencies

By default, Travis CI will find all R packages listed as dependencies in your
package's `DESCRIPTION` file, and install them from CRAN. It's sometimes
necessary to augment this, for a variety of reasons:

* system-wide dependencies used by R packages (eg crypto or XML libraries)
* binary installs of dependencies (to speed up builds)
* development versions of packages from github (useful for testing upcoming
  releases, or picking up not-yet-released bugfixes)

Each of the names below is a list of packages you can optionally specify as a
top-level entry in your `.travis.yml`; entries in these lists will be
installed before building and testing your package. Note that these lists are
processed in order, so entries can depend on dependencies in a previous list.

* `apt_packages`: A list of packages to install via `apt-get`. Common examples
  here include entries in `SystemRequirements`. This option is ignored on
  non-linux builds.

* `brew_packages`: A list of packages to install via `brew`. This option is
  ignored on non-OSX builds.

* `r_binary_packages`: A list of R packages to install as binary packages on
  linux builds, via Michael Rutter's
  [cran2deb4ubuntu PPA](https://launchpad.net/~marutter/+archive/ubuntu/c2d4u).
  These installs will be faster than source installs, but may not always be
  the most recent version. Specify the name just as you would when installing
  from CRAN. On OSX builds, these packages are installed from source.

* `r_packages`: A list of R packages to install via `install.packages`.

* `bioc_packages`: A list of [BioConductor](http://www.bioconductor.org/)
  packages to install.

* `r_github_packages`: A list of packages to install directly from github,
  using `devtools::install_github` from the
  [devtools package](https://github.com/hadley/devtools). The package names
  here should be of the form `user/repo`.

### Package check options

You can use the following top-level options to control what options are used
when building and checking your package:

* `warnings_are_errors`: Set this option to `true` to force all warnings to
  become failures. This is especially helpful when preparing your package for
  submission to CRAN, and is recommended for most packages.

* `r_build_args`: additional arguments to pass to `R CMD build`, as a single
  string. Defaults to empty.

* `r_check_args`: additional arguments to pass to `R CMD check`, as a single
  string. Defaults to `--as-cran`.

### BioConductor

If your package is detected as a BioConductor package, Travis CI will first
configure BioConductor, and then use a BioConductor repo in place of the usual
CRAN repo when installing dependencies.

There are two ways to signal to Travis CI that your package is a BioConductor
package:

* If `bioc_packages` is nonempty, your package will install dependencies from
  BioConductor.

* If the variable `bioc_required` is set to `true`, your package will install
  dependencies from BioConductor.

A simple BioConductor package should generally be able to use Travis CI with
the following `.travis.yml`:

    language: r
    bioc_required: true

### Miscellaneous

* `cran`: CRAN mirror to use for fetching packages. Defaults to
  `http://cran.rstudio.com/`.

* `r_check_revdep`: if `true`, also run checks on CRAN packages which depend
  on this one. This can be quite expensive, so it's not recommended to leave
  this set to `true`.

## Converting from r-travis

If you've already been using
[r-travis](https://github.com/craigcitro/r-travis) to test your R package,
you're encouraged to switch to using the native support described here. We've
written a
[porting guide](https://github.com/craigcitro/r-travis/wiki/Porting-to-native-R-support-in-Travis)
to help you modify your `.travis.yml`.

## A complex example

Here we provide a more complex examples using several options above.

    language: r

    # Be strict when checking our package
    warnings_are_errors: true

    # System dependencies for HTTP calling
    apt_packages:
     - libcurl4-openssl-dev
     - libxml2-dev
    r_binary_packages:
     - RUnit
     - testthat

    # Install the bleeding edge version of a package from github (eg to pick
    # up a not-yet-released bugfix)
    r_github_packages:
     - hadley/httr


## Examples

(coming soon)

## Acknowledgements

R support for Travis CI was originally based on the
[r-travis](https://github.com/craigcitro/r-travis) project, and thanks are due
to all the
[contributors](https://github.com/craigcitro/r-travis/graphs/contributors).
For more information on moving from r-travis to native support, see the
[porting guide](https://github.com/craigcitro/r-travis/wiki/Porting-to-native-R-support-in-Travis).
