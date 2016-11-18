---
title: Building an Objective-C Project
layout: en
permalink: /user/languages/objective-c/
---

<div id="toc">
</div>

## What This Guide Covers

This guide covers build environment and configuration topics specific to
Objective-C projects. Please make sure to read our [Getting
Started](/user/getting-started/) and [general build
configuration](/user/customizing-the-build/) guides first.

Objective-C builds are not available on the Linux environments.

## Supported Xcode versions

Travis CI uses OS X 10.11.6 (and Xcode 7.3.1) by default. You can use another version of Xcode (and OS X) by specifying the corresponding `osx_image` key from the following table:

<table>

<tr align="left"><th>osx_image value</th><th>Xcode version</th><th>OS X version</th></tr>
{% for image in site.data.xcodes.osx_images %}
<tr>
  <td><code>osx_image: {{image.image}}</code>{% if image.default == true %}  <em>Default</em> {% endif %}</td>
  <td><a href="http://docs.travis-ci.com/user/osx-ci-environment/#Xcode-{{image.xcode}}">Xcode {{ image.xcode }}</a></td>
  <td>OS X {{ image.osx_version}}
  </td></tr>
{% endfor %}
</table>

> Detailed iOS SDK versions are available in the [OS X CI environment reference](https://docs.travis-ci.com/user/osx-ci-environment/#Xcode-version)

At this time we are unable to provide pre-release versions of Xcode due to the
NDA imposed on them. We do test them internally, and our goal is to make new
versions available the same day they come out. If you have any further questions
about Xcode pre-release availability, send us an email at support@travis-ci.com.

## Default Test Script

Travis CI runs [xctool](https://github.com/facebook/xctool) by default to
execute your tests. In order for xctool to work, you need to tell it where to
find your project or workspace and what scheme you would like to build. For
example:

```yaml
language: objective-c
xcode_project: MyNewProject.xcodeproj # path to your xcodeproj folder
xcode_scheme: MyNewProjectTests
```

You can also specify an SDK using the `xcode_sdk` variable. This needs to be on
the form `iphonesimulatorX.Y` where `X.Y` is the version you want to test
against.

If you are using a workspace instead of a project, use the `xcode_workspace`
key in your .travis.yml instead of `xcode_project`.

In order to your run tests on Travis CI, you also need to create a Shared
Scheme for your application target, and ensure that all dependencies (such as
CocoaPods) are added explicitly to the Scheme. To do so:

1. Open up the **Manage Schemes** sheet by selecting the **Product → Schemes →
   Manage Schemes…** menu option.
2. Locate the target you want to use for testing in the list. Ensure that the
   **Shared** checkbox in the far right hand column of the sheet is checked.
3. If your target include cross-project dependencies such as CocoaPods, then
   you will need to ensure that they have been configured as explicit
   dependencies. To do so:

   1. Highlight your application target and hit the **Edit…** button to
      open the Scheme editing sheet.
   2. Click the **Build** tab in the left-hand panel of the Scheme editor.
   3. Click the **+** button and add each dependency to the project.
      CocoaPods will appear as a static library named **Pods**.
   4. Drag the dependency above your test target so it is built first.

You will now have a new file in the **xcshareddata/xcschemes** directory
underneath your Xcode project. This is the shared Scheme that you just
configured. Check this file into your repository and xctool will be able to
find and execute your tests.

## Dependency Management

Travis CI uses [CocoaPods](http://cocoapods.org/) to install your project's
dependencies.

The default command run by Travis CI is:

```bash
pod install
```

Note that this is only run when we detect a Podfile in the project's root
directory. If the Podfile is in a different directory, you can use the `podfile`
setting in the *.travis.yml*:

```yaml
podfile: path/to/Podfile
```

Also, `pod install` is not run if the Pods directory is vendored and there have
been no changes to the Podfile.lock file.

If there is a `Gemfile` in your project's root directory, the `pod` command is
not executed, but instead Bundler is used as a wrapper to `pod` as follows:

```bash
bundle exec pod install
```

If you want to use a different means of handling your project's dependencies,
you can override the `install` command.

```yaml
install: make get-deps
```

## Build Matrix

For Objective-C projects, `env`, `rvm`, `gemfile`, `xcode_sdk`, and
`xcode_scheme` can be given as arrays to construct a build matrix.

## Simulators

{% for simulator in site.data.xcodes.simulators %}

### {{ simulator.name }}

The following devices are provided by the {{ simulator.name }} simulator:

{% for device in simulator.devices %}

- {{ device }}
  {% endfor %}

{% endfor %}
