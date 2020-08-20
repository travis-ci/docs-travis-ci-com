---
title: The Ubuntu 20.04 (Focal Fossa) Build Environment
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

### Third party apt-repositories removed

While third party apt-repositories are used during the image provisioning, they are all removed from the build image. This has two benefits; a) reduced risk of unrelated interference and b) faster apt-get updates.

To specify a third party apt-repository, you can [add the source with the apt addon](/user/installing-dependencies/#adding-apt-sources) and specify the packages. For example:

```yaml
dist: focal
addons:
  apt:
    sources:
      - sourceline: 'ppa:chris-lea/redis-server'
    packages:
    - redis-tools
    - redis-server
```
{: data-file=".travis.yml"}

If you depend on these repositories in your build, you can use the following `source` line to get them back:

| package              | source                       |
|:---------------------|:-----------------------------|
| couchdb              | `deb https://apache.bintray.com/couchdb-deb $(lsb_release -cs) main`         |
| docker               | `deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable`              |
| google-chrome-stable | `deb http://dl.google.com/linux/chrome/deb/ stable main`              |
| git-ppa              | `ppa:git-core/ppa`           |
| haskell              | `ppa:hvr/ghc`                |
| mongodb              | `deb https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.4 multiverse`         |
| pollinate            | `ppa:pollinate/ppa`          |
| redis                | `ppa:chris-lea/redis-server` |
{: style="width: 80%" }

### Services disabled by default

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
| git     | `2.28.0` |
| git-lfs | `2.9.2`  |
| hg      | `5.3`    |
| svn     | `1.13.0` |
{: style="width: 30%" }

### Compilers and Build toolchain

| package | version  |
|:--------|:---------|
| clang      | `7.0.0`  |
| llvm       | `10.0.0` |
| cmake      | `3.16.8` |
| gcc        | `9.3.0`  |
| ccache     | `3.7.7`  |
| shellcheck | `0.7.0`  |
| shfmt      | `2.6.3`  |
{: style="width: 30%" }

### Docker

* Docker `19.03.8` is installed.
* docker-compose `1.23.1` is also available.

## Ruby support

* Pre-installed Rubies: `2.5.7`, `2.5.8`, `2.6.5`, `2.6.6`, `2.7.0` and `2.7.1`.
* The default ruby is `2.7.1`.
* Other ruby versions can be installed during build time.

## Python support

* Supported Python version is: `3.6` or higher as `2.7` has been sunsetted.
* Python `3.6.10` will be used by default when no language version is explicitly set.
* The following Python versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| `3.6`  | `3.6.10` |
{: style="width: 30%" }

If you're getting errors about PyPy `pypy is not installed; attempting download`, use one of the more recent versions such as `PyPy3.6 v7.3.1`.

## JavaScript and Node.js support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time. For other builds, the stable version at image build time has been selected, which is `0.35.3`.
* The following NodeJS versions are preinstalled: `4.9.1`, `6.17.1`, `8.9`, `8.17.0`, `10.16.0`, `10.22.0`, `12.7.0` and `12.18.3`.

## Go support

* Pre-installed Go: `1.11.1`.

* Other Go versions can be installed during build time by specifying the language versions with the `go:`-key.

## JVM (Clojure, Groovy, Java, Scala) support

* Pre-installed JVMs: `openjdk8`,`openjdk10`, and `openjdk11` on x86, default
is `openjdk11`.

* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.

* The following table summarizes the Pre-installed JVM tooling versions:

| package | version |
|:--------|:--------|
| gradle  | `5.1.1` |
| maven   | `3.6.3` |
| groovy  | `2.4.5` |
{: style="width: 30%" }

## PHP support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| `7.4`  |  `7.4.6` |
{: style="width: 30%" }

## Databases and services

The following services and databases are preinstalled but but do not run by default.
To use one in your build, add it to the services key in your `travis.yml` :

| service    | version        |
|:-----------|:---------------|
| mongodb    | `3.6.9`        |
| mysql      | `8.0.21`       |
| redis      | `6.0.6`        |
| postgresql | `12.2`         |
{: style="width: 30%" }

## Other Ubuntu Linux Build Environments

You can have a look at the [Ubuntu Linux overview page](/user/reference/linux) for the different Ubuntu Linux build environments you can use.
