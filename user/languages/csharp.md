---
title: Building a C#, F#, or Visual Basic Project
layout: en
permalink: /user/languages/csharp/
---

### What this guide covers

This guide covers build environment and configuration topics specific to C#, F#, and Visual Basic
projects. Please make sure to read our [Getting started](/user/getting-started/)
and [general build configuration](/user/build-configuration/) guides first.

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

You can choose from the versions available from Mono's [snapshot repositories](http://www.mono-project.com/docs/getting-started/install/linux/#accessing-older-releases), i.e. 3.8.0 and later. To make it easier for you to test against the versions that ship with Ubuntu 12.04 and 14.04, we also support `2.10.8` and `3.2.8`. Other earlier versions are not supported. Note that those special cases also don't provide NuGet and PCL reference assemblies.

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
  - mono ./testrunner/xunit.runners.1.9.2/tools/xunit.console.exe ./MyPoject.Tests/bin/Release/MyProject.Tests.dll
{% endhighlight %}

#### Other test frameworks

If you're using other test frameworks the process is similar. Please note that the MSTest framework is not supported, as it only works on Windows/Visual Studio.
