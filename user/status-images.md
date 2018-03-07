---
title: Embedding Status Images
layout: en

---

You can embed status images (also known as badges or icons) that show the
status of your build into your README or website.

For example, this badge shows the build status of the `travis-web` repository:
[![Build Status](https://travis-ci.org/travis-ci/travis-web.svg?branch=master)](https://travis-ci.org/travis-ci/travis-web)

The URLs for status images are shown on your Travis CI Repository page:

1. Click the status image in the top right to open a dialog box containing common
   templates for the status image URL in markdown, html, etc.

   ![add to Github](/images/add_Markdown_bade_github.jpg)

2. Select the branch and template in the dialog box.

3. Copy the text and paste it into your README or website. You should now be able to view the

Build status images for public repositories are publicly available on Travis CI.

Build status images for [private repositories](https://travis-ci.com) include
a security token.

![Screenshot of private repository badge](/images/status_image_private.jpg)

This token is only used to access the build status image, but we recommend you
not use it on a publicly available site.

## Travis CI pages show the default branch's result

On the pages on Travis CI, we show the result of the most recent
build on its default branch.
For example, for [docs-travis-ci-com](https://travis-ci.org/travis-ci/docs-travis-ci-com/builds),
this is the `master` branch.

If the default branch does not have any build, the status will remain
unknown, and shows:

![unknown status image](https://raw.githubusercontent.com/travis-ci/travis-api/master/public/images/result/unknown.png)
