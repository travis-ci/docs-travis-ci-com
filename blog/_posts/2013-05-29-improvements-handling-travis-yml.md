---
title: Improved Handling of Faulty or Missing .travis.yml Files
author: Mathias Meyer
twitter: roidrage
created_at: Wed 29 May 2013 19:00 CEST
layout: post
permalink: blog/2013-05-29-improvemed-handling-travis-yml
---
Until recently we've been handling issues with parsing .travis.yml files rather
poorly. YAML is a finicky beast, and when there was a problem parsing it, we
didn't communicate that at all.

On top of that, when a project or a branch is missing, we're still assuming the
defaults and run commands focused on Ruby, which can be confusing as well.

To improve both scenarios, you will now see messages in your builds logs should
we fail to parse your .travis.yml or should there be no .travis.yml available
for the commit we're currently building.

![](http://s3itch.paperplanes.de/yamlnotfound_20130529_172653.jpg)

In case of a parsing issue we stop the build immediately and end it marked with
an error.

![](http://s3itch.paperplanes.de/parsing_error_20130529_114125.jpg)

We're still improving on this front, but this at least gives a bit more
transparency into why we run default commands, and we prevent your build from
running with the defaults when there's a problem with your .travis.yml.
