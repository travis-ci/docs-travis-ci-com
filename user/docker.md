---
title: Docker workers on Travis CI
layout: en
permalink: docker/
---

<div id="toc"></div>

Travis CI offers two different kinds of build workers.
The one we traditionally offered is backed by OpenVZ,
and we have recently started offering Docker-backed workers.

This document describes the latter.

## Routing Your Build to Docker Workers

To send your builds to Docker workers, add this to the top level of `.travis.yml`:

```yaml
sudo: false
```

Also, [Education Pack](https://education.travis-ci.com/) users' builds are
routed to Docker workers.

## How Docker workers differ from the traditional workers

Docker images:

1. Boot faster
2. Allow use of [caches](/user/caching)
3. Disallow use of `sudo`, setuid and setgid executables, as well as [Firefox addon](/user/firefox)
  (which uses `sudo` under the hood to install additional version of Firefox).

## Known issues

If you run into problems, check our [issue tracker](https://github.com/travis-ci/travis-ci)
(in particular, [Docker-specific issues](https://github.com/travis-ci/travis-ci/labels/docker)).
