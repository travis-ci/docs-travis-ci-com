---
title: Build Environment Overview
layout: en
permalink: /user/reference/overview/
redirect_from:
  - /user/ci-environment/
  - /user/migrating-from-legacy/
---

### What This Guide Covers

This guide provides an overview on the different environments in which Travis CI can run your builds, and why you might want to pick one over another.

## Virtualization environments

Each build runs in one of the following virtual environments.

### Linux

Travis CI supports two virtualization types for Linux builds: ‘full VM’ and ‘LXD’. On top of that, Linux builds can be run on [multiple CPU architectures](/user/multi-cpu-architectures/#multi-cpu-availaibility).

#### Full VM

This is sudo enabled, full virtual machine per build, that runs Linux

* Slow spin-up (increased build time compared to LXD container) yet without any [limitations](/user/reference/overview/#linux-security-and-lxd-container).
* It has a fixed amount of vCPUs and RAM assigned.

#### LXD container

This is sudo enabled LXD container build environment, as close to a virtual machine as you can get in containers world. A Linux environment is run within an unprivileged LXD container. 

* Fast spin-up (decreased build time when compared to full VM) yet some [limitations](/user/reference/overview/#linux-security-and-lxd-container) do apply
* It starts with min 2 vCPUs and if there is more computing time available, the host can dynamically assign it to speed up your build

#### Which one do I use?

For the majority of cases, whenever available, we recommend to use LXD-based containers. 

Use full VM only if LXD is not available or you need 
* privileged fs access
* specific system call interception
* hugepages support (subject to changes on short notice)

The table below sums up the available Ubuntu environments and virtualization type per CPU architecture:

| Ubuntu version       | Linux Virtualization Type    |
| :------------------- | :---------------------       |
| [Ubuntu Focal 20.04](/user/reference/focal/) | `arch: amd64`: full VM only, default option<br />`arch: arm64`: LXD only<br />`arch: arm64-graviton2`: LXD and full VM<br/>`arch: ppc64le`: LXD only<br/>`arch: s390x`: LXD only |
| [Ubuntu Bionic 18.04](/user/reference/bionic/) | `arch: amd64`: full VM only, default option<br />`arch: arm64`: LXD only<br />`arch: arm64-graviton2`: LXD only<br/>`arch: ppc64le`: LXD only<br/>`arch: s390x`: LXD only  |
| [Ubuntu Xenial 16.04](/user/reference/xenial/) **default** | `arch: amd64`: full VM only, default option<br />`arch: arm64`: LXD only<br />`arch: arm64-graviton2`: LXD only<br/>`arch: ppc64le`: LXD only<br/>`arch: s390x`: LXD only  |
| [Ubuntu Trusty 14.04](/user/reference/trusty/) | `arch: amd64`: full VM only, default option  |
| [Ubuntu Precise 12.04](/user/reference/precise/) | `arch: amd64`: full VM only, default option  |


LXD compliant OS images for arm64 are run on [AWS](https://aws.amazon.com/) and in [Packet](https://www.packet.com/). LXD compliant OS images for IBM Power and Z are run in [IBM Cloud](https://www.ibm.com/cloud). For more information see [Building on Multiple CPU Architectures](/user/multi-cpu-architectures).

You can select Linux virtualization type by setting a `virt` tag to either `vm` or `lxd`. See relevant `.travis.yml` examples [below](/user/reference/overview/#for-a-particular-travisyml-configuration).

### macOS

A [macOS](/user/reference/osx/) environment for Objective-C and other macOS specific projects

### Windows

A [Windows](/user/reference/windows/) environment running Windows Server, version 1803.

### Virtualisation Environment vs Operating System

The following table summarizes the differences across virtual environments and operating systems:

|                      | Ubuntu Linux  ([Focal](/user/reference/focal/), [Bionic](/user/reference/bionic/), [Xenial](/user/reference/xenial/) , [Trusty](/user/reference/trusty/), [Precise](/user/reference/precise/)) | [macOS](/user/reference/osx/) | [Windows](/user/reference/windows) | Ubuntu Linux / LXD container ([Focal](/user/reference/focal/), [Bionic](/user/reference/bionic/), [Xenial](/user/reference/xenial/)) |
|:---------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------|:-----------------------------------|:-------------------------------------------------------|
| Name                 | Ubuntu                                                                                                                                                        | macOS                         | Windows                            | Ubuntu                                                 |
| Status               | Current                                                                                                                                                       | Current                       | Early release                      | Beta                                          |
| Infrastructure       | Virtual machine on GCE or AWS                                                                                                                                       | Virtual machine               | Virtual machine on GCE             | ARM: LXD container on Packet or AWS<br />IBM Power: LXD container on IBM Cloud<br />IBM Z: LXD container on IBM Cloud                             |
| CPU architecture     | amd64<br />arm64-graviton2                                                                                                                                                         | amd64                         | amd64                              | arm64 (armv8)<br />arm64-graviton2<br />ppc64le (IBM Power)<br />s390x (IBM Z)                                          |
| `.travis.yml`        | See [examples](/user/reference/overview/#linux-travisyml-examples)                                                                                         | `os: osx`                     | `os: windows`                      | See [examples](/user/reference/overview/#linux-travisyml-examples)                             |
| Allows `sudo`        | Yes                                                                                                                                                           | Yes                           | No                                 | Yes                                                    |
| <a name="approx-boot-time"></a>Approx boot time     | 20-50s                                                                                                                                                        | 60-90s                        | 60-120s                            | <10s                                                   |
| File system          | EXT4                                                                                                                                                          | HFS+                          | NTFS                               | EXT4                                                   |
| Operating system     | Ubuntu Linux                                                                                                                                                  | macOS                         | Windows Server 2016                | Ubuntu Linux                                           |
| Memory               | 7.5 GB                                                                                                                                                        | 4 GB                          | 8 GB                               | ~4 GB                                                  |
| Cores                | 2                                                                                                                                                             | 2                             | 2                                  | 2                                                      |
| IPv4 network         | IPv4 is available                                                                                                                                             | IPv4 is available             | IPv4 is available                  | IPv4 is available                                      |
| IPv6 network         | IPv6 is not available                                                                                                                                         | IPv6 is not available         | IPv6 is not available              | IPv6 is available                                      |
| Available disk space | approx 50GB                                                                                                                                                   | approx 41GB                   | approx 40 GB                       | approx 18GB (Arm, IBM Power, IBM Z)                                           |


> Available disk space is approximate and depends on the base image and language selection of your project.
  The best way to find out what is available on your specific image is to run `df -h` as part of your build script.


## What infrastructure is my environment running on?

Usually, knowing the virtualization environment characteristics from the [table above](#virtualisation-environment-vs-operating-system) is sufficient.

But, if you do need more detail, you have one of these two questions:

* you want to see what infrastructure a [finished build](#for-a-finished-build) ran on.
* you want to determine what infrastructure a [particular `.travis.yml` configuration](#for-a-particular-travisyml-configuration) will run on.

### For a finished build

To see what infrastructure a finished build ran on, look at the *hostname* at the top of the build log:

![Infrastructure shown in hostname](/images/ui/what-infrastructure.png "Infrastructure shown in hostname")

if it contains:

* `aws` → the build ran on Amazon Web Services (AWS).
* `gce` → the build ran in a virtual machine on Google Compute Engine.
* `wjb` → the build ran on macOS.
* `1803-containers` → the build ran on Windows.
* `lxd-arm64` → the build ran within an LXD container on Arm64-based infrastructure (currently delivered by Packet)
* `lxd-ppc64le` → the build ran within an LXD container on Power-based infrastructure (currently delivered by IBM)
* `lxd-s390x` → the build ran within an LXD container on Z-based infrastructure (currently delivered by IBM)

If *instance*, right under the *hostname* contains `ec2` → the build ran within an LXD container or as a 'full VM' on AWS Arm64 Graviton2 infrastructure

### For a particular .travis.yml configuration

* Our default infrastructure is an Ubuntu Linux (`os: linux`) virtual machine running on AMD64 architecture (`arch: amd64`), on Google Compute Engine. You can specify which version of Ubuntu using the `dist` key.

* Using `os: osx`, setting a version of Xcode using `osx_image:`, or using a macOS specific language such as `language: objective-c` routes your build to macOS infrastructure.

* Using `os: windows` routes your build to Windows infrastructure.

* Using `arch: arm64` routes your build to Arm-based LXD containers. You can specify which version of Ubuntu using the `dist` key.

* Using `arch: arm64-graviton2` routs your build to Arm-based infrastructure. You must specify target virtualization environment (virtual machine or LXD container) using `virt` key.

* Using `arch: ppc64le` routes your build to IBM Power-based LXD containers. You can specify which version of Ubuntu using the `dist` key.

* Using `arch: s390x` routes your build to IBM Z-based LXD containers. You can specify which version of Ubuntu using the `dist` key.

* Using `arch: arm64-graviton2` routes you to the AWS environment powered by Arm64 Graviton2 CPUs. Available Ubuntu versions depend on the virtualization type (lxd/vm). 

* If you have set `os:` key to target Linux environment, you can further specify the environment type using the `virt:` key. 

> To avoid mistreated keys you can validate your `.travis.yml` file using the [Build Config Validation](/user/build-config-validation).

### Linux: .travis.yml examples

#### The AMD64 builds

```yaml
arch: amd64          # optional, this is default, routes to a full VM
os: linux            # optional, this is default
dist: focal          # or bionic | xenial | trusty | precise with xenial as default
```
{: data-file=".travis.yml"}

#### The Arm64 builds

```yaml
arch: arm64           # LXD container based build for OSS only
os: linux             # required for arch different than amd64
dist: focal           # or bionic | xenial with xenial as default
```
{: data-file=".travis.yml"}

```yaml
arch: arm64-graviton2 # in AWS over Graviton2 CPU
virt: lxd             # required, routes to an LXD container
os: linux             # required for arch different than amd64
dist: focal           # or bionic | xenial with xenial as default
group: edge
```
{: data-file=".travis.yml"}

```yaml
arch: arm64-graviton2 # in AWS over Graviton2 CPU
virt: vm              # required, routes to a 'full VM' instance 
os: linux             # required for arch different than amd64
dist: focal
group: edge
```
{: data-file=".travis.yml"}

#### The IBM Power and Z builds

```yaml
arch: ppc64le         # The IBM Power LXD container based build for OSS only
os: linux             # required for arch different than amd64
dist: focal           # or bionic | xenial with xenial as default
```
{: data-file=".travis.yml"}

```yaml
arch: s390x           # The IBM Z LXD container based build for OSS only
os: linux             # required for arch different than amd64
dist: focal           # or bionic | xenial with xenial as default
```
{: data-file=".travis.yml"}


### Linux: Security and LXD Container

> These limitations are not applicable if your builds are run on `virt: vm` (virtual machine) environment. However, please note that VMs start slower and have fixed computing power assigned compared to containers (LXD). 

#### Access to Privileged fs/Features (Apparmor)

> Due to security reasons, builds run in LXD containers will be denied access to privileged filesystems and paths - a privileged container with write access to e.g. /sys/kernel/debugfs might muddle an LXD host.

As a result, for instance a command in `.travis.yaml` like:
```yaml
sudo docker run --privileged --rm -t -v /sys/kernel/debug:/sys/kernel/debug:rw
```
{: data-file=".travis.yml"}

would result in an error.

Also have a look at the [Github issue relevant to the topic](https://github.com/lxc/lxd/issues/2661) and the [LXD apparmor setup](https://github.com/lxc/lxd/blob/master/lxd/apparmor/apparmor.go) for more details.

#### System Calls Interception

If you run into a message like:

> System doesn't support syscall interception

It most probably means a system call interception is outside of the list of the ones considered to be safe (LXD can allow system call interception [if it's considered to be safe](https://github.com/lxc/lxd/blob/master/doc/syscall-interception.md)). 

### Linux: Hugepages Support from within LXD Container

As of now, Travis CI is not configured to allow hugepages within unprivileged containers. This may change on short notice.

The unprivileged containers access to hugepages is added by the great Linux and LXD teams. To understand what needs to be addressed in order to avoid memory issues with LXD containers, please look at the resources below:
* [LXD 3.22 release notes](https://discuss.linuxcontainers.org/t/lxd-3-22-has-been-released/7027)
* [LXD configuration](https://linuxcontainers.org/lxd/docs/master/instances#hugepage-limits-via-limitshugepagessize)



## Deprecated Virtualization Environments

Historically, Travis CI has provided the following virtualization environments.

- **Trusty Container-based environment**: was available between [July, 2017](https://blog.travis-ci.com/2017-07-11-trusty-as-default-linux-is-coming) and [December, 2018](https://blog.travis-ci.com/2018-10-04-combining-linux-infrastructures).
- **Precise Container-based environment**: was available between [December, 2014](https://blog.travis-ci.com/2014-12-17-faster-builds-with-container-based-infrastructure/) and [September, 2017](https://blog.travis-ci.com/2017-08-31-trusty-as-default-status).
- **Legacy Linux environment**: was available until [December, 2015](https://blog.travis-ci.com/2015-11-27-moving-to-a-more-elastic-future).

If you're trying to use `sudo: false` or `dist: precise` keys in your `travis.yml`, we recommend you remove them and switch to our current [Xenial Linux infrastructure](/user/reference/xenial/).

## Build Config Reference

You can find more information on the build config format for [Operating Systems](https://config.travis-ci.com/ref/os) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).
