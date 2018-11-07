---
title: The Xenial Build Environment
layout: en
---

## What This Guide Covers

On this page, you can find what is included on the Xenial build environment.

## Using Xenial
The following configuration will get your builds to run on a Xenial image:

```yaml
dist: xenial
```
{: data-file=".travis.yml"}

Please note that Xenial is available on our fully virtualized
infrastructure. If you are running an Enterprise installation, please reach out
to [enterprise@travis-ci.com](mailto:entereprise@travis-ci.com) to see how you can use the Xenial Docker images.

## Image differences from Trusty
Apart from version bumps of software, and new defaults for language
environment, the Xenial image contains the following changes:

### Non-core apt-repositories removed
On Trusty, apt repositories that have been used to install images have been
removed after installation. Intent is to speed up runs of `apt-get update`. In
case an apt repository is missing, you can [add the source with the apt addon](/user/installing-dependencies/#adding-apt-sources). For
example:

```yaml
dist: xenial
addons:
  apt:
    sources:
      - ppa:chris-lea/redis-server
```
{: data-file=".travis.yml"}

Packages from the following repositories are available, even if the source is
not:

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
default. On Xenial, they have been disabled. You can enable them again by
specifying the services that you require. An example:

```yaml
services:
  - mysql
  - redis
```
{: data-file=".travis.yml"}

## Environment common to all Xenial images
In total, three different Xenial images are available for use. They selection
process takes place based on the language and services specified in the
configuration. The minimal image `stevonnie` supports docker, bash, and has the
tools for dynamic language runtime download and activation, say `rvm` for ruby.

The other two images have different language runtimes installed by default, and
have an array of different databases and services available.

This section describes what is available on the minimal image, and common to
all images.

### Version control
git: 2.19.1
git-lfs: 2.6.0
hg: 4.8
svn: 1.9.3

### Compilers and Build toolchain
clang and llvm 7 are installed. 
cmake 3.12.4

### Docker
Docker 18.06.0-ce is installed, and docker-compose 1.23.1.

## Ruby images
The following rubies are pre-installed: 2.4.5, 2.5.3. Other ruby versions may be
acquired by specifying e.g. `rvm: 2.5.2` in your configuration.

## Python images
The following pythons are pre-installed: `2.7.15`, `3.6.5`, and `3.7.1`.

Python 2.7.15 will be used when no version is explicitly set.

## JavaScript and Node.js images
The newest nvm is available to all images. NodeJS 11.0.0 and 8.12.0 are
installed by default.

## Go images

## JVM (Clojure, Groovy, Java, Scala) images
The following JVMs are preinstalled: `openjdk10`, and `openjdk11`. Any other
jdk, including Oracle's, can be acquired if available by specifying `jdk`. For
the JVM tooling, the following versions are installed:

| package | version |
+---------+---------+
| gradle  | 4.10.2  |
| maven   | 3.5.4   |

## Databases and services


| service    | version        |
+------------+----------------+
| mongodb    | 4.0            |
| mysql      | 5.7            |
| redis      | 5.5            |
| postgresql | 9.4 9.5 9.6 10 |

