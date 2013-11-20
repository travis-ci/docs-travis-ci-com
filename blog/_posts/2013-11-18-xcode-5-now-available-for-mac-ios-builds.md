---
title: Xcode 5 and iOS 7 now available for Mac and iOS Builds!
created_at: Mon 19 Nov 2013 20:00:00 CET
author: Mathias Meyer
twitter: roidrage
permalink: blog/2013-11-18-xcode-5-now-available-for-mac-ios-builds
layout: post
---
<figure class="smaller right">
  <img src="http://upload.wikimedia.org/wikipedia/commons/c/c2/IOS_7_Logo.png"/>
</figure>

We're thrilled to announce that our Mac platform is now running on Mac OS X
10.8.5, with **Xcode 5 and iOS 7** installed.

On top of that, we offer **five different iOS SDKs**: 5.0, 5.1, 6.0, 6.1, and, of
course, 7.0.

With this long-overdue upgrade, we're also deprecating a few things.

Projects running on the Mac platform are now required to specify the scheme and
project or the workspace in their .travis.yml. If your project didn't have this
set up before, you will have to update your configuration.

Now go, get started and upgrade your projects. Your new commits will be built on
our new platform.

Happy shipping!

Please note that RubyMotion is currently not available on the Mac environment,
we're working on bringing it back. Sorry for the inconvenience. When the Mac
environment has been updated, RubyMotion will be available in the currently
latest version.

If you find any issues or having troubles upgrading, file [an
issue](https://github.com/travis-ci/travis-ci/issues/new) or [contact
support](mailto:support@travis-ci.com).

Our thanks to [Sauce Labs](http://saucelabs.com) for continuing to provide us
with the infrastructure and the resources to get this update done and out. Much
<3 from the Travis CI team!

### What else is new?

The usual suspects, you know, Ruby, have been updated to their newest releases.
Homebrew is up-to-date as well, so you can install dependencies to your heart's
content.

### What took you so long with the update?

We'd like to apologize for the long delays in getting this upgrade out the door.

As part of the upgrade, we had to change the underlying virtualization. We
switched from a setup based on kvm/qemu to a VMware-based setup.

This required a complete resetup of the entire environment. 

Unfortunately we ran into some issues porting everything over, and we have to
work on improving this entire setup over time to make sure future upgrades are
going smoother than this one.
