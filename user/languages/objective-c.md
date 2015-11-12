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

## Supported OS X/iOS SDK versions

We have a few different build images with different versions of Xcode and SDKs
installed.

**Supported Xcode versions**

- [Xcode 7.2 (10.11.x)](http://docs.travis-ci.com/user/languages/objective-c/#Xcode-7.2-Beta) -- `osx_image: xcode7.2b3`
- [Xcode 7.1 (10.10.x)](http://docs.travis-ci.com/user/languages/objective-c/#Xcode-7.1) -- `osx_image: xcode7.1`
- [Xcode 7.0.1 (10.10.x)](http://docs.travis-ci.com/user/languages/objective-c/#Xcode-7) -- `osx_image: xcode7`
- [Xcode 6.4 (10.10.x)](http://docs.travis-ci.com/user/languages/objective-c/#Xcode-6.4) -- `osx_image: xcode6.4`
- [Xcode 6.3.1 (10.10.x)](http://docs.travis-ci.com/user/languages/objective-c/#Xcode-6.3.1) -- `osx_image: beta-xcode6.3`
- [Xcode 6.2 (10.9.x)](http://docs.travis-ci.com/user/languages/objective-c/#Xcode-6.2) -- `osx_image: beta-xcode6.2`
- [Xcode 6.1 (10.9.x)](http://docs.travis-ci.com/user/languages/objective-c/#Xcode-6.1) -- **Default when no other `osx_image:` is specificed**


_Note: At this time we are unable to provide pre-release versions of Xcode due to the
NDA imposed on them. We do test them internally, and our goal is to make new
versions available the same day they come out. If you have any further questions
about Xcode pre-release availability, send us an email at support@travis-ci.com._

### Xcode 7.2 Beta

Xcode 7.2 Beta 3 is available by adding `osx_image: xcode7.2b3` to your .travis.yml.

Xcode 7.2 Beta 1 is available by adding `osx_image: xcode7.2b1` to your .travis.yml.

*Note: This is also our first Xcode image on OS X 10.11, as well as having the Xcode 7.2 beta.*

Our Xcode 7.2 Beta images have the following SDKs preinstalled:

- macosx10.11
- macosx10.11
- iphoneos9.2
- iphoneos9.1
- iphonesimulator9.2
- iphonesimulator9.1
- tvos9.0
- appletvsimulator9.0
- watchos2.0
- watchsimulator2.0

In addition, the following simulators are installed:

- iOS 8.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.2
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.3
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.4
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 9.0
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPhone 6s
  - iPhone 6s Plus
  - iPad 2
  - iPad Retina
  - iPad Air
  - iPad Air 2
- iOS 9.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPhone 6s
  - iPhone 6s Plus
  - iPad 2
  - iPad Retina
  - iPad Air
  - iPad Air 2
  - iPad Pro
- watchOS 2.0
  - Apple Watch - 38mm
  - Apple Watch - 42mm
- tvOS 9.0
  - Apple TV 1080p

### Xcode 7.1

Xcode 7.1 GM is available by adding `osx_image: xcode7.1` to your .travis.yml.

Our Xcode 7.1 image has the following SDKs preinstalled:

- macosx10.11
- iphoneos9.1
- iphonesimulator9.1
- tvos9.0
- appletvsimulator9.0
- watchos2.0
- watchsimulator2.0

In addition, the following simulators are installed:

- iOS 8.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.2
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.3
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.4
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 9.0
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPhone 6s
  - iPhone 6s Plus
  - iPad 2
  - iPad Retina
  - iPad Air
  - iPad Air 2
- iOS 9.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPhone 6s
  - iPhone 6s Plus
  - iPad 2
  - iPad Retina
  - iPad Air
  - iPad Air 2
  - iPad Pro
- watchOS 2.0
  - Apple Watch - 38mm
  - Apple Watch - 42mm
- tvOS 9.0
  - Apple TV 1080p


### Xcode 7

Xcode 7.0.1 GM is available by adding `osx_image: xcode7` to your .travis.yml.

Our Xcode 7.0.1 image has the following SDKs preinstalled:

- macosx10.11
- iphoneos9.0
- iphonesimulator9.0
- watchos2.0
- watchsimulator2.0

In addition, the following simulators are installed:

- iOS 8.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.2
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.3
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.4
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 9.0
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6
  - iPhone 6 Plus
  - iPad 2
  - iPad Retina
  - iPad Air
  - iPad Air 2
- watchOS 2.0
  - Apple Watch - 38mm
  - Apple Watch - 42mm



### Xcode 6.4

Xcode 6.4 is available by adding `osx_image: xcode6.4` to your .travis.yml.

Our Xcode 6.4 image has the following SDKs preinstalled:

- macosx10.9
- macosx10.10
- iphoneos8.4
- iphonesimulator8.4

In addition, the following simulators are installed:

- iOS 7.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad
- iOS 8.2
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad
- iOS 8.3
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad
- iOS 8.3
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad


### Xcode 6.3.1

Xcode 6.3.1 is available by adding `osx_image: beta-xcode6.3` to your .travis.yml.

Our Xcode 6.3.1 image has the following SDKs preinstalled:

- macosx10.9
- macosx10.10
- iphoneos8.3
- iphonesimulator8.3

In addition, the following simulators are installed:

- iOS 7.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad
- iOS 8.2
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad
- iOS 8.3
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad



### Xcode 6.2

Xcode 6.2 is available by adding `osx_image: beta-xcode6.2` to your .travis.yml.

Our Xcode 6.2 image has the following SDKs preinstalled:

- macosx10.9
- macosx10.10
- iphoneos8.2
- iphonesimulator8.2

In addition, the following simulators are installed:

- iOS 7.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad
- iOS 8.2
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad


### Xcode 6.1

Xcode 6.1 is the default Xcode version if you don't specify an `osx_image`
setting in your .travis.yml.

Our Xcode 6.1 image has the following SDKs preinstalled:

- macosx10.9
- macosx10.10
- iphoneos8.1
- iphonesimulator7.0
- iphonesimulator7.1
- iphonesimulator8.1

In addition, the following simulators are installed:

- iOS 7.0
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 7.1 --
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPad 2
  - iPad Retina
  - iPad Air
- iOS 8.1
  - iPhone 4s
  - iPhone 5
  - iPhone 5s
  - iPhone 6 Plus
  - iPhone 6
  - iPad 2
  - iPad Retina
  - iPad Air
  - Resizable iPhone
  - Resizable iPad


## Default Test Script

Travis CI runs [xctool](https://github.com/facebook/xctool) by default to
execute your tests. In order for xctool to work, you need to tell it where to
find your project or workspace and what scheme you would like to build. For
example:

    language: objective-c
    xcode_project: MyNewProject.xcodeproj # path to your xcodeproj folder
    xcode_scheme: MyNewProjectTests

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

    pod install

Note that this is only run when we detect a Podfile in the project's root
directory. If the Podfile is in a different directory, you can use the `podfile`
setting in the *.travis.yml*:

    podfile: path/to/Podfile

Also, `pod install` is not run if the Pods directory is vendored and there have
been no changes to the Podfile.lock file.

If you want to use a different means of handling your project's dependencies,
you can override the `install` command.

    install: make get-deps

## Build Matrix

For Objective-C projects, `env`, `rvm`, `gemfile`, `xcode_sdk`, and
`xcode_scheme` can be given as arrays to construct a build matrix.
