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
[Travis CI Julia Community Forums](https://travis-ci.community/c/languages/julia)
and cc [@ararslan](https://github.com/ararslan), [@staticfloat](https://github.com/staticfloat), and [@StefanKarpinski](https://github.com/StefanKarpinski).

For general Julia support on Travis CI go to the [Travis Community](https://travis-ci.community/c/languages/julia) or [Julia Lang Slack Channel](https://julialang.slack.com) in the __#testing__ channel.

## Choosing Julia versions to test against

Julia workers on Travis CI download and install a binary of Julia. You can specify
the Julia versions to test in the `julia:` key in your `.travis.yml` file. For example:

```yaml
language: julia
julia:
  - nightly
  - 1.0.5
  - 1.3.1
```
{: data-file=".travis.yml"}

Acceptable formats are:
 - `nightly` will test against the latest [nightly build](https://julialang.org/downloads/nightlies/)
of Julia.
 - `X` will test against the latest release for that major version. (Applies only to major versions 1 and later.)
 - `X.Y` will test against the latest release for that minor version.
 - `X.Y.Z` will test against that exact version.

The oldest versions for which binaries are available is 0.3.1 for Linux,
or 0.2.0 for [macOS](/user/multi-os/).

## Coverage

Services such as [codecov.io](https://codecov.io) and [coveralls.io](https://coveralls.io)
provide summaries and analytics of the coverage of the test suite.
After enabling the respective services for the repositories, the `codecov` and `coveralls`
options can be used as follows, placing them at the top level of the YAML document:

```yaml
codecov: true
coveralls: true
```

This will then upload the coverage statistics upon successful completion of the tests to
the specified services.

## Default Build and Test Script

If your repository contains `JuliaProject.toml` or `Project.toml` file, and you are
building on Julia v0.7 or later, the default build script will be:

```julia
using Pkg
Pkg.build() # Pkg.build(; verbose = true) for Julia 1.1 and up
Pkg.test(coverage=true)
```

Otherwise it will use the older form:

```julia
if VERSION >= v"0.7.0-DEV.5183"
    using Pkg
end
Pkg.clone(pwd())
Pkg.build("$pkgname") # Pkg.build("$pkgname"; verbose = true) for Julia 1.1 and up
Pkg.test("$pkgname", coverage=true)
```

where the package name `$pkgname` is the repository name, with any trailing `.jl` removed.

Note that the `coverage=true` argument only tells `Pkg.test` to emit coverage information
about the tests it ran; it does not submit this information to any services.
To submit coverage information, see the coverage section above.

There are two scripts that describe the default behavior for using Julia with Travis CI:
 [julia.rb](https://github.com/travis-ci/travis-build/blob/master/lib/travis/build/script/julia.rb)
 and [julia_spec.rb](https://github.com/travis-ci/travis-build/blob/master/spec/build/script/julia_spec.rb).

## Dependency Management

If your Julia package has a `deps/build.jl` file, then `Pkg.build("$name")`
will run that file to install any dependencies of the package. If you need
to manually install any dependencies that are not handled by `deps/build.jl`,
it is possible to specify a custom dependency installation command as described
in the [general build configuration](/user/customizing-the-build/) guide.

In a rare case, you may need to clone a private repo if it is a dependency of the repo you are trying to test. To add a private repo, check out the link here: [Private Dependencies](/user/private-dependencies/).  Once you have the repo added, you will need to copy it to your julia folder and then run the default build script.  Check out the script below for __Linux__ to see how that is done: 

```
script:
 #- ls #Optional command.  Just here to confirm the Dependency is in the folder you think it is. 
 #- pwd #Optional command. Just here so you can see where you are in the file system to make sure the path is correct below. 
 - julia --project --color=yes --check-bounds=yes -e 'using Pkg; Pkg.develop(PackageSpec(path="/home/travis/build/path_to_private_Dependency")); Pkg.instantiate()'
 - julia --project --color=yes --check-bounds=yes -e 'using Pkg; Pkg.instantiate(); Pkg.build();'
 ```
Note: you will need to have the `project.toml` file in your repo for these commands above to work. This can be found in your `~/.julia/enviroments/` folder. 

## Build Matrix

For Julia projects, `env` and `julia` can be given as arrays
to construct a build matrix.

## Environment Variable

The version of Julia a job is using is available as:

```
TRAVIS_JULIA_VERSION
```

In addition, `JULIA_PROJECT` is set to `@.`, which means Julia will search through parent directories until a `Project.toml` or `JuliaProject.toml` file is found; the containing directory then is used in the home project/environment.

## Example Projects

Here's a list of open-source Julia projects utilizing Travis CI in different ways:
- [AbstractPlotting.jl](https://github.com/JuliaPlots/AbstractPlotting.jl/blob/master/.travis.yml)
- [DiffEqDocs.jl](https://github.com/JuliaDiffEq/DiffEqDocs.jl/blob/master/.travis.yml)
- [Pkg.jl](https://github.com/JuliaLang/Pkg.jl/blob/master/.travis.yml)
- [NeuralVerification.jl](https://github.com/sisl/NeuralVerification.jl/blob/master/.travis.yml)
- [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl/blob/master/.travis.yml)

## Build Config Reference

You can find more information on the build config format for [Julia](https://config.travis-ci.com/ref/language/julia) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).

