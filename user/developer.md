---
title: Travis CI APIs
layout: en
---

<div id="toc"></div>

## API V3

The Travis CI API V3 was released on 6th April 2017. It is a discoverable and
self-documenting RESTful API, and includes all the hypermedia features expected
from a modern API.

Our API can be used to automate many of your Travis CI build processes:

- get build info
- get organization info
- get nested resources
- restart builds or jobs
- cancel builds or jobs
- trigger debug builds
- deal with pagination
- edit environment variables
- validate the `.travis.yml` file

We've created an [API Explorer](https://developer.travis-ci.com/) that closely
integrates with V3, updating automatically when new endpoints are added, and
includes a useful tool for exploring endpoints.

## API V2.1

We've released an update to the Travis CI API V2, which is API V2.1. This update essentially makes HTTP status codes more consistent between travis-ci.org and travis-ci.com.

> If you are building both Open Source and Private projects on travis-ci.com, please use API V2.1.

For users of Travis CI using the deprecated platform for Open Source projects at travis-ci.org, built at api-travis-ci.org, there is no change in API.

API V2.1 is identical to API V2 **except for the following breaking changes**:

* For public repositories, unauthenticated requests receive an HTTP 200 or an HTTP 404 error in some cases like for repo cahces or settings.
* For private repositories, unauthenticated requests receive an HTTP 401 or 404 error.
* For private repositories, authenticated requests by users that do not have permission to view the repository receive an HTTP 400 error or HTTP 200 for empty responses.

Previous behavior for V2 is that these requests receive an 401 error.

A similar pattern of HTTP response codes applies to other endpoints such us `/builds`, `/branches`, `/jobs` and `/requests`.

To use API V2.1 set the `Accept` header of your API request to `application/vnd.travis-ci.2.1+json`.

## API V2

We're not yet ready to deprecate [API V2](/api/). We use V2 with our web frontend
application and have spent the last 6 months switching gradually from V2 to V3.
We'll complete this transition in the coming months, but plan to continue
supporting V2 until the end of 2017. We'll naturally give developers ample
notice before switching V2 off, and provide detailed instructions for making the
transition to V3.

## Ruby Library

The [Ruby Library](https://github.com/travis-ci/travis#ruby-library) uses the
API V2.
