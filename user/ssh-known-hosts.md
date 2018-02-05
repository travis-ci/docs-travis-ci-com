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

Both hostnames and IP addresses are supported, as the keys are
added via `ssh-keyscan`.  A single host may be specified like so:

```yaml
addons:
  ssh_known_hosts: git.example.com
```
{: data-file=".travis.yml"}

Multiple hosts or IPs may be added as a list:

```yaml
addons:
  ssh_known_hosts:
  - git.example.com
  - 111.22.33.44
```
{: data-file=".travis.yml"}

Hosts with ports can also be specified:

```yaml
addons:
  ssh_known_hosts: git.example.com:1234
```
{: data-file=".travis.yml"}

## Security Implications

Note that the `ssh_known_hosts` option may introduce a risk of man-in-the-middle attacks for your builds.
(Also see the _Security_ section of the [ssh-keyscan man page](https://linux.die.net/man/1/ssh-keyscan "man page for ssh-keyscan").)
For example, it may prevent a build from detecting that an illegitimate 3rd party attempts to inject a modified git repository or submodule into the build.
This possibility might be of particular relevance where Travis CI build outputs are used for release packages or production deployments.

### Mitigations and Workarounds

Currently, Travis CI only detects the above attacks out-of-the-box for repositories on `github.com`, `gist.github.com`, or `ssh.github.com`.
If you host your code on other domains, there is currently no straightforward alternative to using the `ssh_known_hosts` option and its security implications.

However, you can protect other SSH connections that occur after the cloning phase in your build, e.g., when deploying build outputs.
To make your builds reject spoofed SSH servers for such connections, you configure them with known good SSH keys.
Say your build instance connects to the SSH server *ssh.example.com*:

1. Remove the `ssh_known_hosts` option for *ssh.example.com*.

2. Obtain the public key of the SSH server at *ssh.example.com*:

    - Ideally (but rarely), the owner of *ssh.example.com* can provide you with the server's public SSH key through e-mail or some other trusted channel.

    - If you have previously connected to *ssh.example.com* from a trusted local computer, run `ssh-keygen -F ssh.example.com` to display its public key.

    - If you have not yet connected to *ssh.example.com*, run `ssh-keyscan ssh.example.com` to retrieve it and `ssh-keygen -F ssh.example.com` to display it.
    Ideally, you would double-check with the owner of *ssh.example.com* that that is indeed the server's public key and not the key of a spoofed instance of *ssh.example.com*.

3. Configure Travis CI to use the public key of the SSH server:
Add the key server's public key *KEY* to the SSH `known_hosts` file, e.g., with the following addition to the installation phase:

```yaml
install:
  - echo 'KEY' >> $HOME/.ssh/known_hosts
```
{: data-file=".travis.yml"}

Make sure to replace *KEY* with the complete line of text containing the public key of the SSH server as obtained in the previous step.
