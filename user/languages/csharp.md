---
title: Building a C#, F#, or Visual Basic Project
layout: en
permalink: csharp/
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

Currently, Travis builds your C#, F#, and Visual Basic project with the latest version of the [Mono runtime](http://www.mono-project.com/).
It is based on the ECMA C# and CLR standards but might not be a perfect replacement for the Microsoft .NET Framework.

### Overview

The setup for C#, F#, and Visual Basic projects looks like this:

{% highlight yaml %}
language: csharp
solution: solution-name.sln
{% endhighlight %}

### Script

By default Travis will run `xbuild solution-name.sln`. Xbuild is a build tool designed to be an implementation for Microsoft's MSBuild tool.
To override this, you can set the `script` attribute like this:

{% highlight yaml %}
language: csharp
solution: solution-name.sln
script: make build
{% endhighlight %}


### NuGet

By default, Travis will run `nuget restore solution-name.sln`, which restores all NuGet packages from your solution file.
To override this, you can set the `install` attribute like this:

{% highlight yaml %}
language: csharp
solution: solution-name.sln
install: make install
{% endhighlight %}
