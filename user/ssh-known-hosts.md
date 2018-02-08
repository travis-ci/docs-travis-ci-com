---
title: Adding to SSH Known Hosts
layout: en

---

<div id="toc">
</div>

Travis CI can add entries to `~/.ssh/known_hosts` prior to cloning
your git repository, which is necessary if there are git submodules
from domains other than `github.com`, `gist.github.com`, or
`ssh.github.com`.

Each entry in the configuration is one of the following:

1. a hash with `host`, `type`, `key`
1. a hostname
1. a numeric IP address

In the first case, we write key directly to `~/.ssh/known_hosts`.

In the last two cases, we run `ssh-keyscan` to add the host key.
See [Security Implications](#Security-Implications) below to understand what this means.

## Examples

Hosts may be given in various ways.

### A single hash with `host`, `type`, `key`

In the case where a host is defined with `host`, `type`, and `key`,

```yaml
addons:
  ssh_known_hosts:
    host: ssh.example.com
    type: ssh-ed25519
    key: AAAAC3NzaC1lZDI1NTE5AAAAIOd6AtszfjD3nI7WvvnN+B39XsrjPzAMCByYO1hwUGf9
```
{: data-file=".travis.yml" }

a line of the form

    HOST TYPE KEY

is added to `$HOME/.ssh/known_hosts`.

Each of `host`, `type`, and `key` is required. If any is missing, the entry is ignored.

### Multiple hashes

Multiple hashes can also be specified in an array (alongside other means of specifying SSH hosts):

```yaml
addons:
  ssh_known_hosts:
    - host: ssh.example.com
      type: ssh-ed25519
      key: AAAAC3NzaC1lZDI1NTE5AAAAIOd6AtszfjD3nI7WvvnN+B39XsrjPzAMCByYO1hwUGf9
    - host: ssh2.example.com
      type: ssh-ed25519
      key: AAAAC3NzaC1lZDI1NTE5AAAAIOd6AtszfjD3nI7WvvnN+B39XsrjPzAMCByYO1hwUGf0
    - ssh3.example.com
```
{: data-file=".travis.yml" }

### A single hostname

```yaml
addons:
  ssh_known_hosts: git.example.com
```
{: data-file=".travis.yml"}


### Multiple hosts or IPs in a list

```yaml
addons:
  ssh_known_hosts:
  - git.example.com
  - 111.22.33.44
```
{: data-file=".travis.yml"}

### Nonstandard SSH port

If the host is listening on a nonstandard port, it may be specified as follows:

```yaml
addons:
  ssh_known_hosts: git.example.com:1234
```
{: data-file=".travis.yml"}

## Security Implications

Note that the `ssh_known_hosts` option may introduce a risk of man-in-the-middle attacks for your builds.
(Also see the the [SECURITY section of the `ssh-keyscan` man page](http://man7.org/linux/man-pages/man1/ssh-keyscan.1.html#SECURITY "man page for ssh-keyscan").)
For example, it may prevent a build from detecting that an illegitimate 3rd party attempts to inject a modified git repository or submodule into the build.
This possibility might be of particular relevance where Travis CI build outputs are used for release packages or production deployments.

We recommend using the first form.
