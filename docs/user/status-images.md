---
title: Status Images
kind: content
---

## What This Guide Covers

This guide covers build status images feature of Travis CI. Status images are part of the HTTP API that render build status information
(passing or failing) as a PNG image. Developers are encouraged to add them to project sites, README files and so on both to link to
continuous integration page for the project and to demonstrate their commitment to good software development practices.

We recommend you start with the [Getting Started](/docs/user/getting-started/) and [Build Configuration](/docs/user/build-configuration/) guides before reading this one.


## Status Image URLs

After adding your project to Travis, you can use the status buttons to show the current status of your projects in your `README` file on Github or your project website.

    https://secure.travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png

HTTPS is used so that GitHub does not cache the image.


## Adding Status Images to README Files

So, when using Textile, showing your status button (including a link to your Travis project page) is as simple as adding this to your `README`:

    "!https://secure.travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png!":http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME]

Or if you're using markdown:

    [![Build Status](https://secure.travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png)](http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME])

Or RDoc:

    {<img src="https://secure.travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png" />}[http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME]]

Travis CI's own status button looks like this: [![Build Status](https://secure.travis-ci.org/travis-ci/travis-ci.png)](http://travis-ci.org/travis-ci/travis-ci)


## Build Status For Specific Branches

You can limit the impact of this button to certain branches only. For example, you might not want to include feature branches, which might fail but don't mean the project itself fails.

Specify a `?branch=` parameter in the URI. Split branches with a comma if you want to specify several.

    https://secure.travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png?branch=master,staging,production
