---
title: The Ubuntu 20.04 Build Environment
layout: en
---

## What This Guide Covers

This guide provides an overview of the packages, tools and settings available in the Focal Fossa environment.

## Using Ubuntu 20.04 (Focal Fossa)

To route your builds to Ubuntu 20.04 LTS, Focal, add the following to your `.travis.yml`:

```yaml
dist: focal
```
{: data-file=".travis.yml"}


## Differences from the previous release images

Travis CI Ubuntu 20.04, Focal, includes the following changes and improvements:

### Third party apt-repositories removed - the paragraph needs to be checked and changed

While third party apt-repositories are used during the image provisioning, they are all removed from the Bionic build image. This has two benefits; a) reduced risk of unrelated interference and b) faster apt-get updates.

To specify a third party apt-repository, you can [add the source with the apt addon](/user/installing-dependencies/#adding-apt-sources) and specify the packages. For example:

```yaml
dist: focal
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
| couchdb              | `https://apache.bintray.com/couchdb-deb`         |
| docker               | `docker-bionic`              |
| google-chrome-stable | `google-chrome`              |
| git-lfs              | `github-git-lfs-bionic`      |
| git-ppa              | `ppa:git-core/ppa`           |
| haskell              | `ppa:hvr/ghc`                |
| mongodb              | `mongodb-4.0-bionic`         |
| pollinate            | `ppa:pollinate/ppa`          |
| redis                | `ppa:chris-lea/redis-server` |
{: style="width: 80%" }

### Services disabled by default - the paragraph needs to be checked and changed

On the Ubuntu 20.04 based environment, to speed up boot time and improve performance we've disabled all services by default.
Add any services that you want to start to your `.travis.yml`:


```yaml
services:
  - mysql
  - redis
```
{: data-file=".travis.yml"}

## Environment common to all Ubuntu 20.04 images

The following versions of Docker, version control software and compilers are present on all Ubuntu 20.04 builds, along with more language specific software described in more detail in each language section.

All preinstalled software not provided by distro is installed from an official release --
either a prebuilt binary if available, or a source release built with default options.
For preinstalled language interpreters, a standard version manager like `rvm` is used if available for the language.

### Version control

| package | version  |
|:--------|:---------|
| git     | `` |
| git-lfs | ``  |
| hg      | ``    |
| svn     | ``  |
{: style="width: 30%" }

### Compilers and Build toolchain

* clang and llvm 7
* cmake 3.16.3-1ubuntu1
* gcc 7.5.0
* ccache ???
* shellcheck 0.7.0
* shfmt ????

### Docker

* Docker 19.03.2 is installed???
* docker-compose 1.21.0.???

## Ruby support

* Pre-installed Rubies: `2.4.9?`, `2.5.3`, `2.5.7` and `2.6.5`.
* The default ruby is `2.6.5`.
* Other ruby versions can be installed during build time.

## Python support

* Supported Python versions: `2.7`, `3.6` or higher.
* Python `2.7.17` will be used when no language version is explicitly set.
* The following Python versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| 2.7    | 2.7.17   |
| 3.6    | 3.6.9    |
| 3.7    | 3.7.5    |
| 3.8    | 3.8.0    |
{: style="width: 30%" }

If you're getting errors about PyPy `pypy is not installed; attempting download`, use one of the more recent versions such as `pypy2.7-5.8.0` or `pypy3.5-5.8.0`.

## JavaScript and Node.js support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time. For other builds, the stable version at image build time has been selected, which is 0.10.48.
* The following NodeJS versions are preinstalled: `12.13.1`, `11.15.0`, `10.16.0`, and `8.16.2`.

## Go support

* Pre-installed Go: `1.11.1`???

* Other Go versions can be installed during build time by specifying the language versions with the `go:`-key.

## JVM (Clojure, Groovy, Java, Scala) support

* Pre-installed JVMs: `openjdk8`,`openjdk10`???, and `openjdk11` on x86, default
is `openjdk11`.

* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.

* The following table summarizes the Pre-installed JVM tooling versions:

| package | version |
|:--------|:--------|
| gradle  | 4.4.1   |
| maven   | 3.6.3   |
| groovy  | 2.4.16   |
{: style="width: 30%" }

## PHP support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

| alias  | version  |
| :----- | :------- |
|  |   |
|   |    |
| 7.3    | |
| 7.4    |    |
{: style="width: 30%" }

## Databases and services

The following services and databases are preinstalled but but do not run by default.
To use one in your build, add it to the services key in your `travis.yml` :

| service    | version        |
|:-----------|:---------------|
| mongodb    |             |
| mysql      | 8.0?           |
| redis      |            |
| postgresql | 12 |
{: style="width: 30%" }

## Other Ubuntu Linux Build Environments

You can have a look at the [Ubuntu Linux overview page](/user/reference/linux) for the different Ubuntu Linux build environments you can use.
