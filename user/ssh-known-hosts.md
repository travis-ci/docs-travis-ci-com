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

### Background

What is the basis for such a scenario?
It lies in the fact that the `ssh_known_hosts` option updates SSH's `known_hosts` file for every new build by retrieving and trusting whatever public key an SSH or git server, legitimate or not, presents.

In a non-CI environment, SSH can detect this with the `known_hosts` file permanently storing the public keys of SSH servers after first connecting to them.
While a 3rd party may at some later stage be able to redirect an SSH-based `git clone` request to a git server they control (e.g., via DNS spoofing), they would typically not be able to spoof the SSH key of the legitimate git server.
Therefore, the public key of the spoofed git server would differ from that stored in `known_hosts`.
A `git clone` request would make SSH compare the two keys and reject a connection to the spoofed server given the key mismatch.

However, in a CI environment, the `ssh_known_hosts` option makes every build obtain a fresh copy of the server's public key.
When the build proceeds to clone a repository or submodule, it compares the key of the repository server against the key that the `ssk_known_hosts` option triggered it to retrieve from the same server seconds earlier.
Effectively, the `ssh_known_hosts` option makes a build trust any SSH key that a server presents at the beginning of the build, even if the server is being spoofed by a third party.

### Mitigations and Workarounds

#### Git Cloning

Currently, the simplest mitigation is to host all your repositories and submodules on one of the `github.com`, `gist.github.com`, or `ssh.github.com` domains.
They can be considered trustworthy because their actual SSH server keys are preconfigured in the Travis CI build images.
A build can therefore detect when a spoofed repository server presents an invalid key.

A potential work-around for repositories or submodules on other domains can consist of the following three-step approach.
How successfully it can be employed heavily depends on the complexity of your existing Travis CI configuration.

1. Set up `.travis.yml` to clone a boot-strap git repository from `github.com`, `gist.github.com`, or `ssh.github.com`.

2. In the installation phase of the boot-strap repository, configure the build instance with the public SSH keys of your application git repositories and submodules.
This is described in more detail in the next section.

3. Configure the boot-strap repository to clone the application repositories and submodules explicitly and then proceed with the rest of the installation and test phases of the application.

#### Other SSH Connections

Depending on its configuration, your build may establish further SSH connections beyond git cloning, e.g., during deployment.
If you use the `ssh_known_hosts` option for such connections, the same security implications as outlined above apply.

To make your builds reject spoofed SSH servers, you configure them with known good SSH keys.
Say your build instance connects to the SSH server *ssh.example.com*:

1. Remove the `ssh_known_hosts` option.

2. Obtain the public key of the SSH server:

    - Ideally (but rarely), the owner of *ssh.example.com* can provide you with the server's public SSH key through e-mail or some other channel.

    - If you have previously connected to *ssh.example.com* from a trusted local computer, run `ssh-keygen -F ssh.example.com` to display its public key.

    - If you have not yet connected to *ssh.example.com*, run `ssh-keyscan ssh.example.com` to retrieve it and `ssh-keygen -F ssh.example.com` to display it.
    Ideally, you would double-check with the owner of *ssh.example.com* that that is indeed the server's public key and not the key of a spoofed instance of *ssh.example.com*.

3. Configure Travis CI to use the public key of the SSH server:
Add the key *KEY* to the `known_hosts` file, e.g., with the following addition to the installation phase:

```yaml
install:
  - echo 'KEY' >> $HOME/.ssh/known_hosts
```
{: data-file=".travis.yml"}

Make sure to replace *KEY* with the complete line of text containing the public key of the SSH server as obtained in the previous step.
