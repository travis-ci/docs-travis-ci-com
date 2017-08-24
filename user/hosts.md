---
title: Setting Custom Host Names
layout: en

---

If your build requires custom hostnames, you can specify a single host or a
list of them in your `.travis.yml`. Travis CI will automatically configure the
hostnames in `/etc/hosts` and resolve them to `127.0.0.1`.

```yaml
addons:
  hosts:
    - travis.dev
    - joshkalderimis.com
```
