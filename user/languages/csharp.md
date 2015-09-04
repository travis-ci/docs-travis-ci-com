---
title: Building a C#, F#, or Visual Basic Project
layout: en
permalink: /user/languages/csharp/
---

### What this guide covers

This guide covers build environment and configuration topics specific to C#, F#, and Visual Basic
projects. Please make sure to read our [Getting started](/user/getting-started/)
and [general build configuration](/user/customizing-the-build/) guides first.

### Beta Warning

Travis CI support for C#, F#, and Visual Basic is currently in beta and may be removed or altered at any time.
If you run into any problems, please report them in the [Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new)
and cc @joshua-anderson @akoeplinger @nterry.

### Build Environment

Currently, Travis builds your C#, F#, and Visual Basic project with the latest version of the [Mono runtime](http://www.mono-project.com/) on Linux.
It is based on the ECMA C# and CLR standards but might not be a perfect replacement for the Microsoft .NET Framework.

### Overview

The setup for C#, F#, and Visual Basic projects looks like this:

{% highlight yaml %}
language: csharp
solution: solution-name.sln
{% endhighlight %}

When the optional `solution` key is present, Travis will run NuGet package restore and build the given solution. You can also specify your own scripts, as shown in the next section.

### Script

By default Travis will run `xbuild /p:Configuration=Release solution-name.sln`. Xbuild is a build tool designed to be an implementation for Microsoft's MSBuild (the tool that Visual Studio uses to build your projects).
To override this, you can set the `script` key like this:

{% highlight yaml %}
language: csharp
solution: solution-name.sln
script:    # the following commands are just examples, use whatever your build process requires
  - ./build.sh
  - ./test.sh
  - grep "Test Results" build.log
{% endhighlight %}

### NuGet

By default, Travis will run `nuget restore solution-name.sln` in the `install` step, which restores all NuGet packages from your solution file.
To override this (e.g. if you want to install additional packages), you can set the `install` attribute like this:

{% highlight yaml %}
language: csharp
solution: solution-name.sln
install:
  - sudo apt-get install -y gtk-sharp2
  - nuget restore solution-name.sln
{% endhighlight %}

### Choosing Mono version to test against

By default Travis CI will use the latest Mono release. It is also possible to test projects against specific versions of Mono. To do so, specify the version using the `mono` key in .travis.yml. For example, to test against latest, 3.12.0 and 3.10.0:

{% highlight yaml %}
language: csharp
mono:
  - latest
  - 3.12.0
  - 3.10.0
...
{% endhighlight %}

You can choose from the following Mono versions:

| Version          | Installed Packages                                               |
|------------------|------------------------------------------------------------------|
| 3.10.0 and later | mono-complete, mono-vbnc, fsharp, nuget, referenceassemblies-pcl |
| 3.8.0            | mono-complete, mono-vbnc, fsharp, nuget                          |
| 3.2.8            | mono-complete, mono-vbnc, fsharp                                 |
| 2.10.8           | mono-complete, mono-vbnc                                         |

*Note*: even if you specify e.g. 3.12.0 the version used by your build may actually be 3.12.1 depending on what the latest version in the 3.12.x series is (it's a limitation of the Xamarin repositories right now).

**Alpha, Beta, and Weekly Channel**: To install and test against upcoming Mono versions specify `alpha`, `beta`, or `weekly` as the version number. Please report bugs you encounter on these channels to the Mono project so they can be fixed before release.

### Build Matrix

For C#, F#, and Visual Basic projects, `mono` can be given as an array to construct a build matrix.

### Addons

The [Coverity Scan](/user/coverity-scan/) addon is not supported because it only works with msbuild on Windows right now.

### Running unit tests (NUnit, xunit, etc.)

To run your unit test suite, you'll need to install a test runner first. The recommended approach is to install it from NuGet, as this also works on the [container-based](http://docs.travis-ci.com/user/workers/container-based-infrastructure/) Travis infrastructure (i.e. it doesn't need `sudo`).

The following examples show how you'd override `install` and `script` to install a test runner and pass your test assemblies to it for running the tests.

#### NUnit

{% highlight yaml %}
language: csharp
solution: solution-name.sln
install:
  - nuget restore solution-name.sln
  - nuget install NUnit.Runners -Version 2.6.4 -OutputDirectory testrunner
script:
  - xbuild /p:Configuration=Release solution-name.sln
  - mono ./testrunner/NUnit.Runners.2.6.4/tools/nunit-console.exe ./MyPoject.Tests/bin/Release/MyProject.Tests.dll
{% endhighlight %}

#### xunit

{% highlight yaml %}
language: csharp
solution: solution-name.sln
install:
  - nuget restore solution-name.sln
  - nuget install xunit.runners -Version 1.9.2 -OutputDirectory testrunner
script:
  - xbuild /p:Configuration=Release solution-name.sln
  - mono ./testrunner/xunit.runners.1.9.2/tools/xunit.console.clr4.exe ./MyPoject.Tests/bin/Release/MyProject.Tests.dll
{% endhighlight %}

*Note:* There's [a bug](https://github.com/mono/mono/pull/1654) in Mono that makes xunit 2.0 hang after test execution, we recommended you stick with 1.9.2 until it is fixed.

#### Using solution-level NuGet package

Another way is to add the console testrunner of your choice as a solution-level nuget package.

For many .NET projects this will be the file found at ` ./.nuget/packages.config `.

nuget restore solution-name.sln will then install that package as well.

{% highlight yaml %}
language: csharp
solution: solution-name.sln
script:
  - xbuild /p:Configuration=Release solution-name.sln
  - mono ./packages/xunit.runners.*/tools/xunit.console.clr4.exe ./MyPoject.Tests/bin/Release/MyProject.Tests.dll

{% endhighlight %}

Notice the use of filename expansion (the ```*```) in order to avoid having to hard code the version of the test runner.

#### Other test frameworks

If you're using other test frameworks the process is similar. Please note that the MSTest framework is not supported, as it only works on Windows/Visual Studio.
