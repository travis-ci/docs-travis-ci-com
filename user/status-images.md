---
title: Embedding Status Images
layout: en
permalink: /user/status-images/
---

You can embed status images (also known as badges or icons) that show the
status of your build into your README or website.

For example, this badge shows the build status of the `travis-web` repository:
[![Build Status](https://travis-ci.org/travis-ci/travis-web.svg?branch=master)](https://travis-ci.org/travis-ci/travis-web)

The URLs for status images are shown on your Travis CI Repository page:

1. Click the status image in the top right to open a dialog box containing common
templates for the status image URL in markdown, html, etc.

	![Screenshot of repository badge](http://s3itch.paperplanes.de/statusimage_20140320_112129.jpg)

2. Select the branch and template in the dialog box.

3. Copy the text and paste it into your README or website.

Build status images for public repositories are publicly available on Travis CI.

Build status images for [private repositories](https://travis-ci.com) include
a security token.

![Screenshot of private repository badge](http://s3itch.paperplanes.de/Travis_CI__Hosted_Continuous_Integration_That_Just_Works_20140320_112255_20140320_112334.jpg)

This token is only used to access the build status image, but we recommend you
not use it on a publicly available site.
