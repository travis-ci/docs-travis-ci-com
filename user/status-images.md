---
title: Status Images
layout: en
permalink: status-images/
---
With Travis CI, you can embed little status icons into your project's README or
general documentation. That way, visitors of your projects or site can
immediately see its build status.

Here's an example from one of our repositories. Fingers crossed it's green when
you're reading this:

[![Build Status](https://travis-ci.org/travis-ci/travis-web.svg?branch=master)](https://travis-ci.org/travis-ci/travis-web)

### Fetching the Build Status Embed Code

The URLs for status images are available on your repositories' page on Travis
CI.

You'll find the most current status image in the top right.

!["Build Passing" status image on the travis-ci/travis-rubies repository builds page.](http://s3itch.paperplanes.de/statusimage_20140320_112129.jpg)

Clicking that will reveal a dialog that allows you to copy and paste the URL and
ready to use templates for common markup formats, like Markdown or Textile.

![The modal window for building repository status images on travis-ci.org.](http://s3itch.paperplanes.de/Travis_CI__Free_Hosted_Continuous_Integration_Platform_for_the_Open_Source_Community_20140320_112210_20140320_112214.jpg)

Make sure to select the right branch in the dropdown. The default URL, without
the `branch` parameter, will return the status for the latest build, on any
branch. Selecting the desired branch makes sure your image only displays the
status for the branch whose stability is most relevant.

You can manually change the branch later, when pasting it into your
documentation, should the right branch not show up in the branch dropdown.

### Build Status Images on Travis CI Pro

Build status images for public repositories are publicly available on Travis CI.

But for [private repositories](https://travis-ci.com), make sure to fetch the
full URL shown in the dialog, as we include a little token for security reasons.

![The modal window for building authenticated repository status images on travis-ci.com.](http://s3itch.paperplanes.de/Travis_CI__Hosted_Continuous_Integration_That_Just_Works_20140320_112255_20140320_112334.jpg)

This token is only used to access the build status image, but we recommend you
not use it on a publicly available site.
