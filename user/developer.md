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

We've created an [API Explorer](https://developer.travis-ci.org/) that closely
integrates with V3, updating automatically when new endpoints are added, and
includes a useful tool for exploring endpoints.

## API V2

We're not yet ready to deprecate [API V2](/api). We use V2 with our web frontend
application and have spent the last 6 months switching gradually from V2 to V3.
We'll complete this transition in the coming months, but plan to continue
supporting V2 until the end of 2017. We'll naturally give developers ample
notice before switching V2 off, and provide detailed instructions for making the
transition to V3.

## Ruby Library

The [Ruby Library](https://github.com/travis-ci/travis#ruby-library) uses the
API V2.
