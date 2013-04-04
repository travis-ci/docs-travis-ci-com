---
title: Introducing Mac, iOS and RubyMotion Testing on Travis CI
created_at: Thu 2013 Apr 4 20:00:00 CEST
layout: post
author: Mathias Meyer
twitter: roidrage
permalink: blog/introducing-mac-ios-rubymotion-testing
---
Today we're very thrilled to announce official support for Mac, iOS and
RubyMotion applications and libraries on [Travis CI](http://travis-ci.org).

To make this possible, we've partnered with the great folks at [Sauce
Labs](http://saucelabs.com), who are providing us with the infrastructure to run
tests for your open source projects on the Mac platform.

Sauce Labs is a leading provider in cloud-based web application testing, and
they're sponsoring the Mac cloud that's powering this new part of Travis CI.
Thank you Sauce Labs, you're awesome and we love you!

We've been beta-testing the new platform for a while now, and thanks to projects
like [CocoaPods](http://travis-ci.org/CocoaPods/CocoaPods) and Sam Soffes'
[SSKeychain](https://travis-ci.org/soffes/sskeychain) we're confident that
you'll enjoy this new and exciting part of Travis CI.

You can also check out the iOS app
[LetterpressPlayer](https://travis-ci.org/jpsim/LetterpressPlayer) and
[DPMeterView](https://github.com/dulaccc/DPMeterView) for more examples of
projects running on the Mac platform.

For a RubyMotion example project, check out
[BubbleWrap](https://travis-ci.org/henrikhodne/BubbleWrap).

### How does it work?

[Henrik Hodne](https://twitter.com/henrikhodne) has worked hard on making the integration as simple as possible,
and did a great job on it too.

The build setup supports CocoaPods too, so if you have a Podfile in your
project, Travis CI runs `pod install` automatically.

We run Justin Spahr-Summers'
[objc-build-script](https://github.com/jspahrsummers/objc-build-scripts) by
default, a nice wrapper around `xcodebuild` with better error handling, but
you're of course free to customize the build however you see fit!

### How can I get started?

To get projects to run on our new Mac setup, we added a new language to our
already pretty large mix of supported platforms.

Just add the following line to your iOS library, Mac application or RubyMotion
project:

    language: objective-c

Boom, you're done!

For all the available options that customize the build and for the specifics of
the Mac build environment, check the
[documentation](http://about.travis-ci.org/docs/user/osx-ci-environment/) and the example projects
listed above!

### Can I test the same project on Mac and Linux?

At this point, you can only run projects on either platform. We're looking into
supporting multiple platforms for the same project in the future.

### When will this be available for private repositories?

Soon! Hit up [support](mailto:support@travis-ci.com) if you like to get in on
the early beta test for that.

Happy Mac and iOS testing! We're very excited about this new platform available
for the open source community. Thank you Sauce Labs for providing us and the
community with the infrastructure to enable more language and platform
communities with free continuous integration!

Make sure to read the [Sauce Labs blog
post](http://sauceio.com/index.php/2013/04/travis-ci-for-os-x-and-ios-powered-by-sauce/)
too!
