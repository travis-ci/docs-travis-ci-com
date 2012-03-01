---
title: Status Images
layout: default
---

After adding your project to Travis, you can use the status buttons to show the current status of your projects in your `README` file on Github or your project website.

Your status button is available at the following URL:

    http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png

So, when using textile, showing your status button (including a link to your Travis project page) is as simple as adding this to your `README`:

    "!http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png!":http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME]

Or if you're using markdown:

    [![Build Status](http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png)](http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME])

Or RDoc:

    {<img src="http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png" />}[http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME]]

Travis CI's own status button looks like this: [![Build Status](https://secure.travis-ci.org/travis-ci/travis-ci.png)](http://travis-ci.org/travis-ci/travis-ci)	
 

### Specifying branches

You can limit the impact of this button to certain branches only. For example, you might not want to include feature branches, which might fail but don't mean the project itself fails.

Specify a `?branch=` parameter in the URI. Split branches with a comma if you want to specify several.

    http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png?branch=master,staging,production

### Using SSL enabled status images on Github

**Please note :** If you are placing this image on a GitHub project status page we recommend you use the SSL enabled url for the image so that GitHub does not proxy and cache it.

The SSL url is:

    https://secure.travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png


