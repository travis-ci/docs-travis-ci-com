---
title: Building a Julia Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
[Julia](http://julialang.org) projects. Please make sure to read our
[Tutorial](/user/tutorial/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Julia is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=julia)
and cc `@ararslan @staticfloat @StefanKarpinski`.

## Choosing Julia versions to test against

Julia workers on Travis CI download and install a binary of Julia. You can specify
the Julia versions to test in the `julia:` key in your `.travis.yml` file. For example:

```yaml
language: julia
julia:
  - nightly
  - 0.7
  - 0.6.4
```
{: data-file=".travis.yml"}

Acceptable formats are:
 - `nightly` will test against the latest [nightly build](https://julialang.org/downloads/nightlies.html)
of Julia.
 - `X.Y` will test against the latest release for that minor version.
 - `X.Y.Z` will test against that exact version.

The oldest versions for which binaries are available is 0.3.1 for Linux,
or 0.2.0 for [OS X](/user/multi-os/).

## Coverage

Services such as [codecov.io](https://codecov.io) and [coveralls.io](https://coveralls.io) provide summaries and analytics of the coverage of the test suite. After enabling the respective services for the repositories, the `codecov` and `coveralls` options can be used, e.g.
```yaml
codecov: true
coveralls: true
```
which will then upload the coverage statistics upon successful completion of the tets.

## Default Build and Test Script

If your repository contains `JuliaProject.toml` or `Project.toml` file, and you are
building on Julia v0.7 or later, the default build script will be:
```julia
using Pkg
Pkg.build()
Pkg.test()
```

Otherwise it will use the older form:
```julia
if VERSION >= v"0.7.0-DEV.5183"
    using Pkg
end
Pkg.clone(pwd())
Pkg.build("$pkgname")
Pkg.test("$pkgname", coverage=true)
```
where the package name `$pkgname` is the repository name, with any trailing `.jl` removed.

## Dependency Management

If your Julia package has a `deps/build.jl` file, then `Pkg.build("$name")`
will run that file to install any dependencies of the package. If you need
to manually install any dependencies that are not handled by `deps/build.jl`,
it is possible to specify a custom dependency installation command as described
in the [general build configuration](/user/customizing-the-build/) guide.

## Build Matrix

For Julia projects, `env` and `julia` can be given as arrays
to construct a build matrix.

## Environment Variable

The version of Julia a job is using is available as:
```
TRAVIS_JULIA_VERSION
```
