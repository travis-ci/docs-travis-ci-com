---
title: Setting Custom Host Names
layout: en
permalink: /user/hosts/
---

If your build requires setting up custom hostnames, you can specify a single host or a
list of them in your .travis.yml. Travis CI will automatically setup the
hostnames in `/etc/hosts` for both IPv4 and IPv6.

```yaml
addons:
  hosts:
    - travis.dev
    - joshkalderimis.com
```
