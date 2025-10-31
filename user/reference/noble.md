---
title: The Ubuntu 24.04 (Noble Numbat) Build Environment
layout: en
---

## What This Guide Covers

This guide provides an overview of the packages, tools and settings available in the Noble Numbat environment.

## Using Ubuntu 24.04 (Noble Numbat)

To route your builds to Ubuntu 24.04 LTS, Noble, add the following to your `.travis.yml`:

```yaml
dist: noble
```
{: data-file=".travis.yml"}

## Environment common to all Ubuntu 24.04 images

All preinstalled software not provided by the distro is installed from an official release — either a prebuilt binary if available, or a source release built with default options.
For preinstalled language interpreters, a standard version manager like `rvm` is used if available for the language.

### Version Control

| package | version  |
|:--------|:---------|
| git     | `2.51.2` |
| git-lfs | `3.4.1`  |
| hg      | `6.7.2`    |
| svn     | `1.14.3` |
{: style="width: 30%" }

### Compilers and Build toolchain

| package | version  |
|:--------|:---------|
| clang      | `18.1.3` |
| cmake      | `4.1.2` |
| gcc        | `13.3.0` |
| ccache     | `4.9.1`  |
| shellcheck | `0.11.0`  |
| shfmt      | `3.12.0`  |
{: style="width: 30%" }


### Docker

* Docker `28.5.1` is installed.
* docker-compose `2.40.2` is also available.
* Podman `3.4.4` is installed as an alternative container engine.


## Ruby Support

* Pre-installed Rubies: `3.3.10`.
* The default ruby is `3.3.10`.
* Other ruby versions can be installed during build time.

## Python Support

* Supported Python version is: `3.X` or higher.
* Python `3.12.12` will be used by default when no language version is explicitly set.
* The following Python versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| `3.12` | `3.12.12`|
| `3.13` | `3.13.9` |
| `3.14` | `3.14.0` |
{: style="width: 30%" }


## JavaScript and Node.js support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time.
* The following NodeJS versions are preinstalled: `18.20.6`, `20.18.3` and `22.14.0`.

## Go support

* Pre-installed Go version: `1.25.3`.

* Additional Go versions can be installed during build time by specifying the language version with the `go:` key.

## JVM (Clojure, Groovy, Java, Scala) support

* Pre-installed JVMs: `openjdk17`, `openjdk21` and `openjdk24` on x86, default is `openjdk17`.

* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.

* The following JVM tooling is preinstalled::

| package | version |
|:--------|:--------|
| gradle  | `9.1.0` |
| maven   | `3.9.11` |
| groovy  | `4.0.28`|
{: style="width: 30%" }

## Perl Support

* Default version on Noble is `5.38.2`.

## PHP Support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| `8.3`  |  `8.3.27` |
{: style="width: 30%" }

## Databases and Services

The following services and databases are preinstalled but but do not run by default.
To use one in your build, add it to the `services` key in your `.travis.yml` :

| service    | version        |
|:-----------|:---------------|
| mysql      | `8.0.43`       |
| redis      | `8.2.2`        |
| postgresql | `16.10`         |
{: style="width: 30%" }

## Other Ubuntu Linux Build Environments

You can have a look at the [Ubuntu Linux overview page](/user/reference/linux/) for the different Ubuntu Linux build environments you can use.
