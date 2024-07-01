---
title: Building a C#, F#, or Visual Basic Project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| C#                                          | Default                                              |
|:--------------------------------------------|:-----------------------------------------------------|
| [Default `install`](#dependency-management) | `nuget restore solution-name.sln`                    |
| [Default `script`](#default-build-script)   | `msbuild /p:Configuration=Release solution-name.sln` |
| [Matrix keys](#build-matrix)                | `dotnet`, `env`, `mono`, `solution`                  |
| Support                                     | [Community Support](https://travis-ci.community/c/languages/37-category) |

Minimal example:

```yaml
language: csharp
```
{: data-file=".travis.yml"}

</aside>

This guide covers build environment and configuration topics specific to C#, F#, and Visual Basic
projects. Please make sure to read our [Tutorial](/user/tutorial/)
and [general build configuration](/user/customizing-the-build/) guides first.

### Community Supported Language

 C#, F#, and Visual Basic support is community-supported in Travis CI.
If you run into any problems, please report them in the [Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new)
and cc [@joshua-anderson](https://github.com/joshua-anderson), [@akoeplinger](https://github.com/akoeplinger) and [@nterry](https://github.com/nterry).

### Build Environment

Currently, Travis builds your C#, F#, and Visual Basic project with the either the [Mono](http://www.mono-project.com/) or the [.NET Core](https://github.com/dotnet/core) runtimes on Linux or macOS. Note that these runtimes do not implement the entire .NET framework, so Windows .NET framework programs may not be fully compatible and require porting.

### Overview

The setup for C#, F#, and Visual Basic projects looks like this:

```yaml
language: csharp
solution: solution-name.sln
```
{: data-file=".travis.yml"}

When the optional `solution` key is present, Travis will run NuGet package restore and build the given solution.

## Choosing Runtime and Version to Test Against

### Mono

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

| Version          | Installed Packages (Linux only, macOS always includes everything) |
|:-----------------|:------------------------------------------------------------------|
| 3.10.0 and later | mono-complete, mono-vbnc, fsharp, nuget, referenceassemblies-pcl  |
| 3.8.0            | mono-complete, mono-vbnc, fsharp, nuget                           |
| 3.2.8            | mono-complete, mono-vbnc, fsharp                                  |
| 2.10.8           | mono-complete, mono-vbnc                                          |
| none             | *disables Mono (use this if you only want .NET Core, see below)*  |

> *Note*: even if you specify e.g. 3.12.0 the version used by your build may actually be 3.12.1 depending on what the latest version in the 3.12.x series is (it's a limitation of the Xamarin repositories right now).

**Alpha, Beta, and Weekly Channel**: To install and test against upcoming Mono versions specify `alpha`, `beta`, or `weekly` as the version number. Please report bugs you encounter on these channels to the Mono project so they can be fixed before release.

### .NET Core

By default, Travis CI does not test against .NET Core. To test against .NET Core, add the following to your `.travis.yml`. Note that at least one `script` `<command>` is required in order to build. Using `dotnet restore` is a good default.

```yml
language: csharp
mono: none
dotnet: 2.1.502
script:
 - dotnet restore
...
```

> *Note*: you need to specify the version number of the .NET Core SDK (_not_ the .NET Core Runtime).

The version numbers of the SDK can be found on the [.NET Core website](https://dot.net/core).

## Testing Against Mono and .NET Core

You can test against both Mono and .NET Core by using `matrix.include`. This example tests against both the latest mono and .NET Core:

```yaml
language: csharp
solution: travis-mono-test.sln

jobs:
  include:
    - dotnet: 2.1.502
      mono: none
      env: DOTNETCORE=2  # optional, can be used to take different code paths in your script
    - mono: latest
...
```
{: data-file=".travis.yml"}

## Addons

The [Coverity Scan](/user/coverity-scan/) addon is not supported because it only works with msbuild on Windows right now.

## Running Unit Tests (NUnit, xUnit, etc.)

To run your unit test suite, you'll need to install a test runner first. The recommended approach is to install it from NuGet, as this also works on the [container-based](/user/workers/container-based-infrastructure/) Travis infrastructure (i.e. it doesn't need `sudo`).

The following examples show how you'd override `install` and `script` to install a test runner and pass your test assemblies to it for running the tests.

### NUnit

```yaml
language: csharp
solution: solution-name.sln
install:
  - nuget restore solution-name.sln
  - nuget install NUnit.Console -Version 3.9.0 -OutputDirectory testrunner
script:
  - msbuild /p:Configuration=Release solution-name.sln
  - mono ./testrunner/NUnit.ConsoleRunner.3.9.0/tools/nunit3-console.exe ./MyProject.Tests/bin/Release/MyProject.Tests.dll
```
{: data-file=".travis.yml"}

### xUnit

```yaml
language: csharp
solution: solution-name.sln
install:
  - nuget restore solution-name.sln
  - nuget install xunit.runners -Version 1.9.2 -OutputDirectory testrunner
script:
  - msbuild /p:Configuration=Release solution-name.sln
  - mono ./testrunner/xunit.runners.1.9.2/tools/xunit.console.clr4.exe ./MyProject.Tests/bin/Release/MyProject.Tests.dll
```
{: data-file=".travis.yml"}

> *Note:* There's [a bug](https://github.com/mono/mono/pull/1654) in Mono that makes xUnit 2.0 hang after test execution, we recommended you stick with 1.9.2 until it is fixed.

### Using Solution-Level NuGet Packages

Another way is to add the console testrunner of your choice as a solution-level NuGet package.

For many .NET projects this will be the file found at `./.nuget/packages.config`.

`nuget restore solution-name.sln` will then install that package as well.

```yaml
language: csharp
solution: solution-name.sln
script:
  - msbuild /p:Configuration=Release solution-name.sln
  - mono ./packages/xunit.runners.*/tools/xunit.console.clr4.exe ./MyProject.Tests/bin/Release/MyProject.Tests.dll
```
{: data-file=".travis.yml"}

Notice the use of filename expansion (the `*`) in order to avoid having to hard code the version of the test runner.

### MSTest

The [MSTest framework](https://www.nuget.org/packages/MSTest.TestFramework/) is supported when testing against .NET Core. Example:

```yaml
language: csharp
mono: none
dotnet: 2.1.502
solution: solution-name.sln
script:
  - dotnet restore
  - dotnet test
...
```
{: data-file=".travis.yml"}

## Build Config Reference

You can find more information on the build config format for [C#](https://config.travis-ci.com/ref/language/csharp) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).
