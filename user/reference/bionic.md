---
title: The Ubuntu 18.04 Build Environment
layout: en
---

> Bionic LTS Standard is EOL by Canonical, try updating to a newer image. It will be in use in Travis CI for some time more, but it's time to consider migration of your builds to a newer build environment image.

## What This Guide Covers

This guide provides an overview of the packages, tools and settings available in the Bionic environment.

## Using Ubuntu 18.04 (Bionic Beaver)

To route your builds to Ubuntu 18.04 LTS, Bionic, add the following to your `.travis.yml`:

```yaml
dist: bionic
```
{: data-file=".travis.yml"}


## Differences from the previous release images

Travis CI Ubuntu 18.04, Bionic, includes the following changes and improvements:

### Third party apt-repositories removed

While third party apt-repositories are used during the image provisioning, they are all removed from the Bionic build image. This has two benefits; a) reduced risk of unrelated interference and b) faster apt-get updates.

To specify a third party apt-repository, you can [add the source with the apt addon](/user/installing-dependencies/#adding-apt-sources) and specify the packages. For example:

```yaml
dist: bionic
addons:
  apt:
    sources:
      - ppa:chris-lea/redis-server
    packages:
    - redis-tools
    - redis-server
```
{: data-file=".travis.yml"}

If you depend on these repositories in your build, you can use the following `source` line to get them back:

| package              | source                       |
|:---------------------|:-----------------------------|
| couchdb              | `https://couchdb.apache.org/repo/`         |
| docker               | `docker`              |
| google-chrome-stable | `google-chrome`              |
| git-lfs              | `github-git-lfs-bionic`      |
| git-ppa              | `ppa:git-core/ppa`           |
| haskell              | `ppa:hvr/ghc`                |
| mongodb              | `mongodb-4.4-bionic`         |
| pollinate            | `ppa:pollinate/ppa`          |
{: style="width: 80%" }

### Services disabled by default

On the Ubuntu 18.04 based environment, to speed up boot time and improve performance we've disabled all services by default.
Add any services that you want to start to your `.travis.yml`:


```yaml
services:
  - mysql
  - redis
```
{: data-file=".travis.yml"}

## Environment common to all Ubuntu 18.04 images

The following versions of Docker, version control software and compilers are present on all Ubuntu 18.04 builds, along with more language specific software described in more detail in each language section.

All preinstalled software not provided by distro is installed from an official release --
either a prebuilt binary if available, or a source release built with default options.
For preinstalled language interpreters, a standard version manager like `rvm` is used if available for the language.

### Version control

| package | version  |
|:--------|:---------|
| git     | `2.43.0` |
| git-lfs | `2.3.4`  |
| hg      | `5.3`    |
| svn     | `1.9.7`  |
{: style="width: 30%" }

### Compilers and Build toolchain

* clang and llvm 16
* cmake 3.26.3
* gcc 7.5.0
* ccache 3.4.1
* shellcheck 0.10.0
* shfmt 3.8.0

To use the IBM Advance Toolchain v14 compilers under `ppc64le` architecture in Focal LXD image, use the following paths in your `.travis.yml`:

- GCC compiler
  - Path: `/opt/at14.0/bin/gcc`
  - Command: `/opt/at14.0/bin/gcc hello_world.c -o hello_world`

- g++ compiler
  - Path: `/opt/at14.0/bin/g++`
  - Command: `/opt/at14.0/bin/g++ hello_world.cpp -o hello_world`

- Go compiler
  - Path: `/opt/at14.0/bin/gccgo`
  - Command: `/opt/at14.0/bin/gccgo hello_world.go -o hello_world`

- Python
  - First, compile Python 3.8.0 using the `python_interpreter.sh script`.
  - Python Interpreter Path: `/opt/python380-at14/python3.8`
  - Build Python Command: `sudo sh python_interpreter.sh`

To use the IBM Advance Toolchain v14 compilers under `amd64` architecture in Focal LXD image, use the following paths in your `.travis.yml`:

- GCC compiler
  - Path: `/opt/at14.0/bin/powerpc64le-linux-gnu-gcc`
  - Command: `/opt/at14.0/bin/powerpc64le-linux-gnu-gcc hello_world.c -o hello_world`

- g++ compiler
  - Path: `/opt/at14.0/bin/powerpc64le-linux-gnu-g++`
  Command: `/opt/at14.0/bin/powerpc64le-linux-gnu-g++ hello_world.cpp -o hello_world`

- Go compiler
  - Path: `/opt/at14.0/bin/powerpc64le-linux-gnu-gccgo`
  - Command: `/opt/at14.0/bin/powerpc64le-linux-gnu-gccgo hello_world.go -o hello_world`

- Python
  - First, compile Python 3.8.0 using the `python_interpreter.sh script`.
  - Python Interpreter Path: `/opt/python380-amd64/python3.8`
  - Build Python Command: `sudo sh python_interpreter.sh`

### Docker

* Docker 24.0.2 is installed
* docker-compose 2.18.1

## Ruby support

* Pre-installed Rubies: `2.5.9`, `2.7.6` and `3.3.0`.
* The default ruby is `3.3.0`.
* Other ruby versions can be installed during build time.

## Python support

* Supported Python versions: `3.6` or higher.
* Python `3.12.0` will be used when no language version is explicitly set.
* The following Python versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| 3.6    | 3.6.15   |
| 3.7    | 3.7.17   |
| 3.8    | 3.8.18   |
| 3.12    | 3.12.0  |
{: style="width: 30%" }

If you're getting errors about PyPy `pypy is not installed; attempting download`, use one of the more recent versions.

## JavaScript and Node.js support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time. For other builds, the stable version at image build time has been selected, which is 0.10.48.
* The following NodeJS versions are preinstalled: `20.14.0`, `18.20.3`, `16.20.2`, `16.15.1`, `16.15`, `12.22.12`, `10.24.1`, `8.17.0`, `6.17.1` and `4.9.1`.

## Go support

* Pre-installed Go: `1.18.1`

* Other Go versions can be installed during build time by specifying the language versions with the `go:`-key.

## JVM (Clojure, Groovy, Java, Scala) support

* Pre-installed JVMs: `openjdk8`, `openjdk9`, `opnejdk10` and `openjdk11` on x86, default
is `openjdk11`.

* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.

* The following table summarizes the Pre-installed JVM tooling versions:

| package | version |
|:--------|:--------|
| gradle  | 8.3     |
| maven   | 3.9.4   |
| groovy  | 4.0.15  |
{: style="width: 30%" }

## Perl support

* Default version on Bionic is `5.33`
* Supported versions `5.32` and `5.33` can be installed by using the `perl:`-key.
* `TAP::Harness` v3.38 and `cpanm` (App::cpanminus) version 1.7044 are also pre-installed.

## PHP support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| 7.1    | 7.1.33   |
| 7.2    | 7.2.27   |
| 7.3    | 7.3.14   |
| 7.4    | 7.4.2    |
{: style="width: 30%" }

### Extensions

#### PHP 7.1 and higher

The following extensions are preinstalled for PHP 7.1 and higher builds:

-   [apcu.so](http://php.net/apcu)
-   [memcached.so](http://php.net/memcached) (Not preinstalled for > PHP8.0)
-   [mongodb.so](https://php.net/mongodb)
-   [amqp.so](http://php.net/amqp)
-   [zmq.so](http://zeromq.org/bindings:php)
-   [xdebug.so](http://xdebug.org)
-   [redis.so](http://pecl.php.net/package/redis)

Please note that these extensions are not enabled by default with the exception
of xdebug.

## Databases and services

The following services and databases are preinstalled but but do not run by default.
To use one in your build, add it to the services key in your `travis.yml` :

| service    | version        |
|:-----------|:---------------|
| mongodb    | 4.4.29         |
| mysql      | 5.7.42         |
| redis      | 7.2.5          |
| postgresql | 9.3 9.4 9.5 9.6 10 11 |
{: style="width: 30%" }

## Other Ubuntu Linux Build Environments

You can have a look at the [Ubuntu Linux overview page](/user/reference/linux/) for the different Ubuntu Linux build environments you can use.
