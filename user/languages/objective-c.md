---
title: Building an Objective-C or Swift Project
layout: en

swiftypetags:
  - swift
---

<div id="toc">
</div>

## What This Guide Covers

This guide covers build environment and configuration topics specific to
Objective-C and Swift projects. Please make sure to read our [Getting
Started](/user/getting-started/) and [general build
configuration](/user/customizing-the-build/) guides first.

Objective-C/Swift builds are not available on the Linux environments.

## Supported Xcode versions

Travis CI uses OS X 10.13 (and Xcode 9.4.1) by default. You can use another
version of Xcode (and OS X) by specifying the corresponding `osx_image` key from
the following table:

<table>

<tr align="left"><th>osx_image value</th><th>Xcode version</th><th>OS X version</th></tr>
{% for image in site.data.xcodes.osx_images %}
<tr>
  <td><code>osx_image: {{image.image}}</code>{% if image.default == true %}  <em>Default</em> {% endif %}</td>
  <td><a href="/user/reference/osx/#xcode-{{image.xcode | downcase | remove:'.' | remove: '-'}}">Xcode {{ image.xcode_full_version }}</a></td>
  <td>OS X {{ image.osx_version}}
  </td></tr>
{% endfor %}
</table>

> Detailed iOS SDK versions are available in the [OS X CI environment
> reference](https://docs.travis-ci.com/user/reference/osx/#xcode-version)

## Default Test Script

Travis CI runs xcodebuild and [xcpretty](https://github.com/supermarin/xcpretty) by default to
execute your tests. In order for xcodebuild to work, you need to tell it where to
find your project or workspace, what scheme you would like to build and test, and which
device or simulator run tests on. For example:

```yaml
language: objective-c
xcode_project: MyNewProject.xcodeproj # path to your xcodeproj folder
xcode_scheme: MyNewProjectTests
xcode_destination: platform=iOS Simulator,OS=10.1,name=iPad Pro (9.7-inch)
```
{: data-file=".travis.yml"}

You can also specify an SDK using the `xcode_sdk` variable. This needs to be on
the form `iphonesimulatorX.Y` where `X.Y` is the version you want to test
against.

If you are using a workspace instead of a project, use the `xcode_workspace`
key in your .travis.yml instead of `xcode_project`.

> Builds using the `xcode6.4` or `xcode7.3` images use
> [xctool](https://github.com/facebook/xctool) by default rather
> than xcodebuild and xcpretty.

### Shared Schemes

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
configured. Check this file into your repository and xcodebuild will be able to
find and execute your tests.

### Device Destinations

To be able to run tests, xcodebuild needs to know which device to run them on, whether
that's a real device (the Mac running xcodebuild or an iOS device connected to the Mac)
or a simulator. When you run tests in Travis CI, you need to tell xcodebuild which
simulator you want to use by specifying a **device destination**.

Device destinations are strings that identify a particular device to use. You can pass
them to xcodebuild by using the `-destination` flag. If you're using the default script
in your Travis CI build, you can use the `xcode_destination` key in your .travis.yml:

```
xcode_destination: platform=iOS Simulator,OS=11.3,name=iPhone X
```
{: data-file=".travis.yml"}

A device destination is a comma-separated list of key-value pairs. When you're testing
on Travis CI, you should include the following keys in your device destination:

- `platform`: one of `macOS`, `iOS Simulator`, `watchOS Simulator`, `tvOS Simulator`.
  (The "Simulator" portion is important. Travis CI does not support running tests against
  hardware iOS devices)
- If `platform` is not `macOS`, also include:
  - `OS`: the version number of the OS on the simulated device.
  - `name`: the name of the simulated device. For example: "iPhone X" or "Apple TV 1080p".

Some examples of valid device destinations include:

- `platform=macOS`
- `platform=iOS Simulator,OS=9.3,name=iPhone 5s`
- `platform=tvOS Simulator,OS=11.0,name=Apple TV 4K`

It's important that your device destination uniquely identifies your device among those
that Xcode knows about. Since Travis CI's build images have many different simulator
OS versions installed, you should specify the OS version in your device destination, as
the name alone is not likely to uniquely identify a single simulator.

You can learn more about device destinations in the xcodebuild man page. If you're on your
Mac, you can [click here](x-man-page://xcodebuild) to view the xcodebuild man page in the
Terminal app.

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
{: data-file=".travis.yml"}

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
{: data-file=".travis.yml"}

## Build Matrix

For Objective-C projects, `env`, `rvm`, `gemfile`, `xcode_sdk`, and
`xcode_scheme` can be given as arrays to construct a build matrix.

## Simulators

A complete list of simulators available in each version of Xcode is shown on the [OS X environment page](/user/reference/osx#Xcode-version).
