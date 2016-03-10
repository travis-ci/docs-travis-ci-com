---
title: Using container-based infrastructure
layout: en
permalink: /user/workers/container-based-infrastructure/
---

<div id="toc"></div>

This document describes Travis CI's newer container-based infrastructure
and how to build your projects on it.

This infrastructure differs from the current default in following ways.

Jobs running on container-based infrastructure:

1. start up faster
2. allow the use of [caches](/user/caching) for public repositories
3. disallow the use of `sudo`, setuid and setgid executables


## Routing your build to container-based infrastructure

The default behavior, when no `sudo` usage is detected in any customizable build phases, depends on the date when the repository is first recognized by Travis CI:

* For repos we recognize before 2015-01-01, linux builds are sent to our standard infrastructure.
* For repos we recognize on or after 2015-01-01, linux builds are sent to our container-based infrastructure.

If you prefer to explicitly send your builds to the container-based infrastructure, add this to the top level of `.travis.yml`:

```yaml
sudo: false
```

Also, [Education Pack](https://education.travis-ci.com/) users' builds are
routed to this container-based infrastructure.

## File system

The container-based images use AUFS.

## Reporting issues

If you run into problems, be sure to check our
[issue tracker](https://github.com/travis-ci/travis-ci/issues?q=is%3Aissue+is%3Aopen+label%3Adocker+).
If it is not reported, please open a new issue.
