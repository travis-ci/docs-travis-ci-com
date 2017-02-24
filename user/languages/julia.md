---
title: Building a Julia Project
layout: en
permalink: /user/languages/julia/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to
[Julia](http://julialang.org) projects. Please make sure to read our
[Getting Started](/user/getting-started/) and
[general build configuration](/user/customizing-the-build/) guides first.

### Community-Supported Warning

Travis CI support for Julia is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=julia)
and cc @tkelman @ninjin @staticfloat @simonbyrne.

## Choosing Julia versions to test against

Julia workers on travis-ci.org download and install a binary of Julia.
You can select the most recent release version, the latest nightly build
(downloaded from <https://status.julialang.org>), or a specific version number
(downloaded from <https://s3.amazonaws.com/julialang>). To select one or more
versions, use the `julia:` key in your `.travis.yml` file, for example:

```yaml
language: julia
julia:
  - release
  - nightly
  - 0.3
  - 0.3.10
```

If the version number contains one `.`, then the latest release for that minor version
is downloaded. The oldest versions for which binaries are available is 0.3.1 for Linux,
or 0.2.0 for [OS X](/user/multi-os/).

## Default Julia Version

If you leave the `julia:` key out of your `.travis.yml`, Travis CI will use
the most recent release.

## Default Test Script

If your repository follows the structure of a Julia package created by
`Pkg.generate("$name")`, then the following default script will be run:

```bash
julia -e 'Pkg.clone(pwd())'
julia -e 'Pkg.build("$name")'
if [ -f test/runtests.jl ]; then
  julia --check-bounds=yes -e 'Pkg.test("$name", coverage=true)'
fi
```

The package name `$name` is determined based on the repository name, removing
the trailing `.jl` if present. A repository is treated as a Julia package when
it contains a file at `src/$name.jl`. If your repository does not follow this
structure, then the default script will be empty.

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
