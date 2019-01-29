---
title: The Xenial Build Environment
layout: en
---

## What This Guide Covers

This guide provides an overview of the packages, tools and settings available in the Xenial environment.

## Using Xenial

To route your builds to Ubuntu Xenial 16.04, add the following to your `.travis.yml`:

```yaml
dist: xenial
```
{: data-file=".travis.yml"}

Please note that Xenial is available on our hosted fully virtualized
infrastructure. If you are running an Enterprise installation, please reach out
to [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com?subject=Try%20out%20Xenial) to see how you can use the Xenial Docker images.

## Differences from the Trusty images

Xenial includes the following changes and improvements:

### Third party apt-repositories removed

While third party apt-repositories are used during the Xenial image provisioning, they are all removed from the Xenial build image. This has two benefits; a) reduced risk of unrelated interference and b) faster apt-get updates.

To specify a third party apt-repository, you can [add the source with the apt addon](/user/installing-dependencies/#adding-apt-sources) and specify the packages. For example:

```yaml
dist: xenial
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
| couchdb              | `ppa:couchdb/stable`         |
| docker               | `docker-xenial`              |
| google-chrome-stable | `google-chrome`              |
| git-lfs              | `github-git-lfs-xenial`      |
| git-ppa              | `ppa:git-core/ppa`           |
| haskell              | `ppa:hvr/ghc`                |
| mongodb              | `mongodb-4.0-xenial`         |
| pollinate            | `ppa:pollinate/ppa`          |
| redis                | `ppa:chris-lea/redis-server` |
{: style="width: 80%" }

### Services disabled by default

On our Xenial infrastructure, to speed up boot time and improve performance we've disabled all services, including the ones that are started by default on Trusty.
Add any services that you want to start by default to your `.travis.yml`:


```yaml
services:
  - mysql
  - redis
```
{: data-file=".travis.yml"}

## Environment common to all Xenial images

The following versions of Docker, version control software and compilers are present on all builds, along with more language specific software described in more detail in each language section.


### Version control

| package | version  |
|:--------|:---------|
| git     | `2.20.1` |
| git-lfs | `2.6.1`  |
| hg      | `4.8`    |
| svn     | `1.9.3`  |
{: style="width: 30%" }

### Compilers and Build toolchain

* clang and llvm 7
* cmake 3.12.4
* gcc 5.4.0
* ccache 3.2.4
* shellcheck 0.6.0
* shfmt 2.6.2

### Docker

* Docker 18.06.0-ce is installed
* docker-compose 1.23.1.

## Ruby support

* Pre-installed Rubies: `2.4.5` and `2.5.3`.
* The default ruby is `2.5.3p105`.
* Other ruby versions can be installed during build time.

## Python support

* Pre-installed Python versions: `2.7.15`, `3.6.5`, and `3.7.1`.

* Python `2.7.15` will be used when no language version is explicitly set.

## JavaScript and Node.js support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time. For other builds, the stable version at image build time has been selected, which is 0.33.11.
* The following NodeJS versions are preinstalled: `11.0.0` and `8.12.0`.

## Go support

* Pre-installed Go: `1.11.1`

* Other Go versions can be installed during build time by specifying the language versions with the `go:`-key.

## JVM (Clojure, Groovy, Java, Scala) support

* Pre-installed JVMs: `openjdk10`, and `openjdk11`.

* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.

* The following table summarizes the Pre-installed JVM tooling versions:

| package | version |
|:--------|:--------|
| gradle  | 4.10.2  |
| maven   | 3.5.4   |
{: style="width: 30%" }

## PHP support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

  | alias | version |
  |:----- |:------- |
  | 5.6   | 5.6.36  |
  | 7.1   | 7.1.19  |
  | 7.2   | 7.2.7   |
  {: style="width: 30%" }

## Databases and services

The following services and databases are preinstalled but but do not run by default.
To use one in your build, add it to the services key in your `travis.yml` :

| service    | version        |
|:-----------|:---------------|
| mongodb    | 4.0            |
| mysql      | 5.7            |
| redis      | 5.5            |
| postgresql | 9.4 9.5 9.6 10 |
{: style="width: 30%" }
