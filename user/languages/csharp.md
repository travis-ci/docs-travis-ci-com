---
title: Building a C#, F#, or Visual Basic Project
layout: en

---

### What this guide covers

This guide covers build environment and configuration topics specific to C#, F#, and Visual Basic
projects. Please make sure to read our [Getting started](/user/getting-started/)
and [general build configuration](/user/customizing-the-build/) guides first.

### Community Supported Language

 C#, F#, and Visual Basic support is community-supported in Travis CI.
If you run into any problems, please report them in the [Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new)
and cc [@joshua-anderson](https://github.com/joshua-anderson), [@akoeplinger](https://github.com/akoeplinger) and [@nterry](https://github.com/nterry).

### Build Environment

Currently, Travis builds your C#, F#, and Visual Basic project with the either the [Mono](http://www.mono-project.com/) or the [.NET Core](https://github.com/dotnet/core) runtimes on Linux or OS X. Note that these runtimes do not implement the entire .NET framework, so Windows .NET framework programs may not be fully compatible and require porting.

### Overview

The setup for C#, F#, and Visual Basic projects looks like this:

```yaml
language: csharp
solution: solution-name.sln
```
{: data-file=".travis.yml"}

When the optional `solution` key is present, Travis will run NuGet package restore and build the given solution. You can also specify your own scripts, as shown in the next section.

### Script

By default Travis will run `xbuild /p:Configuration=Release solution-name.sln`. Xbuild is a build tool designed to be an implementation for Microsoft's MSBuild (the tool that Visual Studio uses to build your projects).
To override this, you can set the `script` key like this:

```yaml
language: csharp
solution: solution-name.sln
script:    # the following commands are just examples, use whatever your build process requires
  - ./build.sh
  - ./test.sh
  - grep "Test Results" build.log
```
{: data-file=".travis.yml"}

### NuGet

By default, Travis will run `nuget restore solution-name.sln` in the `install` step, which restores all NuGet packages from your solution file.
To override this (e.g. if you want to install additional packages), you can set the `install` attribute like this:

```yaml
language: csharp
solution: solution-name.sln
install:
  - sudo apt-get install -y gtk-sharp2
  - nuget restore solution-name.sln
```
{: data-file=".travis.yml"}

### Choosing runtime and version to test against

#### Mono

By default Travis CI will use the latest Mono release. It is also possible to test projects against specific versions of Mono. To do so, specify the version using the `mono` key in `.travis.yml`. For example, to test against latest, 3.12.0 and 3.10.0:

```yaml
language: csharp
mono:
  - latest
  - 3.12.0
  - 3.10.0
...
```
{: data-file=".travis.yml"}

You can choose from the following Mono versions:

| Version          | Installed Packages (Linux only, OS X always includes everything) |
|:-----------------|:-----------------------------------------------------------------|
| 3.10.0 and later | mono-complete, mono-vbnc, fsharp, nuget, referenceassemblies-pcl |
| 3.8.0            | mono-complete, mono-vbnc, fsharp, nuget                          |
| 3.2.8            | mono-complete, mono-vbnc, fsharp                                 |
| 2.10.8           | mono-complete, mono-vbnc                                         |
| none             | *disables Mono (use this if you only want .NET Core, see below)* |

> *Note*: even if you specify e.g. 3.12.0 the version used by your build may actually be 3.12.1 depending on what the latest version in the 3.12.x series is (it's a limitation of the Xamarin repositories right now).

**Alpha, Beta, and Weekly Channel**: To install and test against upcoming Mono versions specify `alpha`, `beta`, or `weekly` as the version number. Please report bugs you encounter on these channels to the Mono project so they can be fixed before release.

#### .NET Core

By default, Travis CI does not test against .NET Core. To test against .NET Core, add the following to your `.travis.yml`. Note that at least one `script` `<command>` is required in order to build. Using `dotnet restore` is a good default.

```yml
language: csharp
mono: none
dotnet: 1.1.5
script:
 - dotnet restore
...
```

> *Note*: you need to specify the version number of the .NET Core SDK (_not_ the .NET Core Runtime).

The version numbers of the SDK can be found on the [.NET Core website](https://dot.net/core).

### Testing Against Mono and .NET Core

You can test against both Mono and .NET Core by using `matrix.include`. This example tests against both the latest mono and .NET Core

```yaml
language: csharp
solution: travis-mono-test.sln

matrix:
  include:
    - dotnet: 1.1.5
      mono: none
      env: DOTNETCORE=1  # optional, can be used to take different code paths in your script
    - mono: latest
...
```
{: data-file=".travis.yml"}

### Build Matrix

For C#, F#, and Visual Basic projects, `mono` and `dotnet` can be given as an array to construct a build matrix.

### Addons

The [Coverity Scan](/user/coverity-scan/) addon is not supported because it only works with msbuild on Windows right now.

### Running unit tests (NUnit, xunit, etc.)

To run your unit test suite, you'll need to install a test runner first. The recommended approach is to install it from NuGet, as this also works on the [container-based](http://docs.travis-ci.com/user/workers/container-based-infrastructure/) Travis infrastructure (i.e. it doesn't need `sudo`).

The following examples show how you'd override `install` and `script` to install a test runner and pass your test assemblies to it for running the tests.

#### NUnit

```yaml
language: csharp
solution: solution-name.sln
install:
  - nuget restore solution-name.sln
  - nuget install NUnit.Runners -Version 2.6.4 -OutputDirectory testrunner
script:
  - xbuild /p:Configuration=Release solution-name.sln
  - mono ./testrunner/NUnit.Runners.2.6.4/tools/nunit-console.exe ./MyProject.Tests/bin/Release/MyProject.Tests.dll
```
{: data-file=".travis.yml"}

#### xunit

```yaml
language: csharp
solution: solution-name.sln
install:
  - nuget restore solution-name.sln
  - nuget install xunit.runners -Version 1.9.2 -OutputDirectory testrunner
script:
  - xbuild /p:Configuration=Release solution-name.sln
  - mono ./testrunner/xunit.runners.1.9.2/tools/xunit.console.clr4.exe ./MyProject.Tests/bin/Release/MyProject.Tests.dll
```
{: data-file=".travis.yml"}

> *Note:* There's [a bug](https://github.com/mono/mono/pull/1654) in Mono that makes xunit 2.0 hang after test execution, we recommended you stick with 1.9.2 until it is fixed.

#### Using solution-level NuGet package

Another way is to add the console testrunner of your choice as a solution-level nuget package.

For many .NET projects this will be the file found at `./.nuget/packages.config`.

`nuget restore solution-name.sln` will then install that package as well.

```yaml
language: csharp
solution: solution-name.sln
script:
  - xbuild /p:Configuration=Release solution-name.sln
  - mono ./packages/xunit.runners.*/tools/xunit.console.clr4.exe ./MyProject.Tests/bin/Release/MyProject.Tests.dll
```
{: data-file=".travis.yml"}

Notice the use of filename expansion (the `*`) in order to avoid having to hard code the version of the test runner.

#### Other test frameworks

If you're using other test frameworks the process is similar. Please note that the MSTest framework is not supported, as it only works on Windows/Visual Studio.
