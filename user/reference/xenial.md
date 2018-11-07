---
title: The Xenial Build Environment
layout: en
---

## What This Guide Covers

On this page, you can find what is included on the Xenial build environment.

## Using Xenial

To get your builds using Ubuntu Xenial 16.04, add the following to your `.travis.yml`:

```yaml
dist: xenial
```
{: data-file=".travis.yml"}

Please note that Xenial is available on our fully virtualized
infrastructure. If you are running an Enterprise installation, please reach out
to [enterprise@travis-ci.com](mailto:entereprise@travis-ci.com) to see how you can use the Xenial Docker images.

## Image updates from Trusty

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

### Third party packages available in Xenial

The following table outlines the third party packages available in Xenial, along with their original source.

| package       | source                     |
+---------------+----------------------------+
| redis         | ppa:chris-lea/redis-server |
| haskell       | ppa:hvr/ghc                |
| mongodb       | "deb http://repo.mongodb.org/apt/ubuntu xenial/mogodb-org/4.0 multiverse" |
| couchdb       | ppa:couchdb/stable         |
| docker        | "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" |
| git-lfs       | "deb https://packagecloud.io/github/git-lfs/ubuntu/ xenial main" |
| git-ppa       | ppa:git-core/ppa           |
| google_chrome | "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" |
| pollinate     | ppa:pollinate/ppa          |

### Services disabled by default

On Trusty, some services that you might or might not use, were running by
default. On Xenial, to optimize the use of the virtual machine resources, they come disabled by default.

You can start them by specifying the services that you require. For example:

```yaml
services:
  - mysql
  - redis
```
{: data-file=".travis.yml"}

## Environment common to all Xenial images

In total, three different Xenial images are available for use. The selection
process takes place based on the language and services specified in your `travis.yml` configuration.

The minimal image `stevonnie` supports docker, bash, and has the tools for dynamic language runtime download and activation, for example, `rvm` for ruby.

The other two images have different language runtimes installed by default, and
have an array of different databases and services available.

You can find below the environment common to all Xenial images. The environment specifications below are also the ones for our `language: minimal` Xenial image.

### Version control

| package | version |
+---------+---------+
| git     | 2.19.1  |
| git-lfs | 2.6.0   |
| hg      | 4.8     |
| svn     | 1.9.3   |

### Compilers and Build toolchain

* clang and llvm 7 are installed.
* cmake 3.12.4 is available. The gcc toolchain is available from the Ubuntu
repositories.

### Docker

* Docker 18.06.0-ce is installed
* docker-compose 1.23.1.

## Ruby images

* Pre-installed Rubies: `2.4.5` and `2.5.3`.
* Other ruby versions can be installed during build time.

## Python images

* Pre-installed Python versions: `2.7.15`, `3.6.5`, and `3.7.1`.

* Python `2.7.15` will be used when no language version is explicitly set.

## JavaScript and Node.js images

* The newest nvm is available to all images. (FIX: is there a version we can use here?)

* Pre-installed NodeJS versions: `11.0.0` and `8.12.0`.

## Go images

* * Pre-installed Go: `1.11.1`

* * Other ruby versions can be installed during build time by specifying the language versions with the `go:`-key.

## JVM (Clojure, Groovy, Java, Scala) images

* Pre-installed JVMs: `openjdk10`, and `openjdk11`.

* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.

* The following table summarizes the Pre-installed JVM tooling versions:

| package | version |
+---------+---------+
| gradle  | 4.10.2  |
| maven   | 3.5.4   |

## Databases and services

* Pre-installed Databases and services:

| service    | version        |
+------------+----------------+
| mongodb    | 4.0            |
| mysql      | 5.7            |
| redis      | 5.5            |
| postgresql | 9.4 9.5 9.6 10 |
