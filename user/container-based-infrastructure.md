---
title: Using container-based infrastructure
layout: en
permalink: container-based-infrastructure/
---

<div id="toc"></div>

This document describes how to build your projects on the newer
container-based infrastructure.

This infrastructure differs from the current one in the following ways.

Jobs running on container-based infrastructure:

1. start up faster
2. allow use of [caches](/user/caching)
3. disallow use of `sudo`, setuid and setgid executables, as well as [Firefox addon](/user/firefox)
  and `hhvm-nightly` (which uses `sudo` under the hood to install additional software).


## Routing Your Build to Container-based infrastructure

To send your builds to container-based infrastructure, add this to the top level of `.travis.yml`:

```yaml
sudo: false
```

Also, [Education Pack](https://education.travis-ci.com/) users' builds are
routed to container-based infrastructure.

## Reporting issues

If you run into problems, check our [issue tracker](https://github.com/travis-ci/travis-ci)
(in particular, [Docker-specific issues](https://github.com/travis-ci/travis-ci/labels/docker))
first.
If it is not reported, please open a new issue.
