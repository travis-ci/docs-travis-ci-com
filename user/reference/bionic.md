---
title: The Ubuntu 18.04 Build Environment
layout: en
---

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
| couchdb              | `https://apache.bintray.com/couchdb-deb`         |
| docker               | `docker-bionic`              |
| google-chrome-stable | `google-chrome`              |
| git-lfs              | `github-git-lfs-bionic`      |
| git-ppa              | `ppa:git-core/ppa`           |
| haskell              | `ppa:hvr/ghc`                |
| mongodb              | `mongodb-4.0-binoic`         |
| pollinate            | `ppa:pollinate/ppa`          |
| redis                | `ppa:chris-lea/redis-server` |
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


### Version control

| package | version  |
|:--------|:---------|
| git     | `2.22.0` |
| git-lfs | `2.7.2`  |
| hg      | `4.8`    |
| svn     | `1.9.7`  |
{: style="width: 30%" }

### Compilers and Build toolchain

* clang and llvm 7
* cmake 3.12.4
* gcc 7.4.0
* ccache 3.4.1
* shellcheck 0.6.0
* shfmt 2.6.3

### Docker

* Docker 18.06.0-ce is installed
* docker-compose 1.23.1.

## Ruby support

* Pre-installed Rubies: `2.3.8`, `2.4.5`, `2.5.3` and `2.6.3`.
* The default ruby is `2.5.3p105`.
* Other ruby versions can be installed during build time.

## Python support

* Supported Python versions: `2.7`, `3.6` or higher.
* Pre-installed Python versions: `2.7.15`, `3.6.7`, and `3.7.1`.
* Python `2.7.15` will be used when no language version is explicitly set.

If you're getting errors about PyPy `pypy is not installed; attempting download`, use one of the more recent python versions such as `pypy2.7-6.0` or `pypy3.5-6.0`.

## JavaScript and Node.js support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time. For other builds, the stable version at image build time has been selected, which is 0.33.11.
* The following NodeJS versions are preinstalled: `11.0.0` and `8.12.0`.

## Go support

* Pre-installed Go: `1.11.1`

* Other Go versions can be installed during build time by specifying the language versions with the `go:`-key.

## JVM (Clojure, Groovy, Java, Scala) support

* Pre-installed JVMs: `openjdk8`, `openjdk10`, and `openjdk11` on x86, default
is `openjdk8`. 

* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.

* The following table summarizes the Pre-installed JVM tooling versions:

| package | version |
|:--------|:--------|
| gradle  | 5.1.1   |
| maven   | 3.6.0   |
| groovy  | 2.4.5   |
{: style="width: 30%" }

## PHP support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| 7.1    | 7.1.30   |
| 7.2    | 7.2.10   |
| 7.3    | 7.3.6    |
{: style="width: 30%" }

## Databases and services

The following services and databases are preinstalled but but do not run by default.
To use one in your build, add it to the services key in your `travis.yml` :

| service    | version        |
|:-----------|:---------------|
| mongodb    | 4.0            |
| mysql      | 5.7            |
| redis      | 5.5            |
| postgresql | 9.3 9.4 9.5 9.6 10 |
{: style="width: 30%" }
