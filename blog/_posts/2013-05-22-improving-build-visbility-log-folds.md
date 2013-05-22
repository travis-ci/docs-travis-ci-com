---
title: Improving Build Visibility with Log Folds
author: Mathias Meyer
twitter: roidrage
created_at: Web 22 May 2013 16:00 CEST
layout: post
permalink: blog/2013-05-22-improving-build-visibility-log-folds
---
The log output is an integral part of a build, and we've done quite a few
iterations on how to display it in the best possible way.

The most recent addition, available on <https://travis-ci.org> for a while
already, and now fully rolled out on <https://travis-ci.com>, brings a few
noteworthy improvements to make it easier to pin-point problems with the build.

There's a bigger story at play here about the logs in general, but we'll focus
on the new log viewer for now.

<a href="https://travis-ci.org/travis-ci/travis-web/jobs/7388311"><img
src="http://s3itch.paperplanes.de/logviewer_20130522_144147.jpg"/></a>

To start with, we made the contrast a bit easier to read, with a darker
background.

More noteworthy though, we added more prominent folds, that hide common commands
whose output usually isn't relevant to the overall build, unless they fail.

![](http://s3itch.paperplanes.de/folds_20130522_150215.jpg)

We fold all commands other than the ones specified in the `script` section of
your .travis.yml.

To make the build phase more visible in the output, they're also nicely labeled
on the righthand side.

If a folded command fails, returning a non-zero exit code, we don't fold the
section so you can immediately investigate what the problem was.
