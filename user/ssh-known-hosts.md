---
title: Adding to SSH Known Hosts
layout: en
permalink: /user/ssh-known-hosts/
---

<div id="toc">
</div>

Travis CI can add entries to `~/.ssh/known_hosts` prior to cloning
your git repository, which is necessary if there are git submodules
from domains other than `github.com`, `gist.github.com`, or
`ssh.github.com`.

Both hostnames and IP addresses are supported, as the keys are
added via `ssh-keyscan`.  A single host may be specified like so:

```yaml
addons:
  ssh_known_hosts: git.example.com
```

Multiple hosts or IPs may be added as a list:

```yaml
addons:
  ssh_known_hosts:
  - git.example.com
  - 111.22.33.44
```
