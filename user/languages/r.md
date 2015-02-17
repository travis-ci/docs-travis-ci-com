---
title: Building an R Project
layout: en
permalink: /user/languages/r/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to R
projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/build-configuration/) guides first.

### Community-Supported Warning

Travis CI support for R is contributed by the community and may be removed or
altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=community:r)
and cc [@craigcitro](https://github.com/craigcitro),
[@eddelbuettel](https://github.com/eddelbuettel), and
[@hadley](https://github.com/hadley).

## Basic configuration

If your R repository doesn't need any dependencies beyond those specified in
your `DESCRIPTION` file, your `.travis.yml` can simply be

    language: r

## Configuration options

Travis CI supports a number of configuration options for your R package.

### Dependencies

By default, Travis CI will install all R packages listed as dependencies in
your package `DESCRIPTION` file. However, it's often necessary or desirable to
install additional dependencies, or newer versions of those dependencies.
Adding an entry to one of the lists below will install before building your
package; note that these lists are processed in order, so entries can depend
on dependencies in a previous list.

* `apt_packages`: A list of packages to install via `apt-get`. Common examples
  here include entries in `SystemRequirements` (such as curl or XML
  libraries). This option is ignored on non-linux builds.

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

* `r_check_cran_incoming`: if `true`, sets the value of the
  `_R_CHECK_CRAN_INCOMING_` environment variable, which forces additional
  CRAN-readiness checks.

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

* `pandoc`: If `true`, a recent version of
  [pandoc](http://johnmacfarlane.net/pandoc/) will be installed and available
  in your `$PATH`. This is particularly useful for packages using
  [RMarkdown](http://rmarkdown.rstudio.com/) or
  [knitr](http://yihui.name/knitr/).

* `cran`: CRAN mirror to use for fetching packages. Defaults to
  `http://cran.rstudio.com/`.

* `r_check_revdep`: if `true`, also run checks on CRAN packages which depend
  on this one. This can be quite expensive, so it's not recommended to leave
  this set to `true`.

## Complex examples

Here we provide a more complex examples using several options above.

    language: r

    # Be strict when checking our package
    r_check_cran_incoming: true
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

`TODO(craigcitro)`: Add a few examples once we've tested R support.
