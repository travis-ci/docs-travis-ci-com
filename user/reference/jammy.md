---
title: The Ubuntu 22.04 (Jammy Jellyfish) Build Environment
layout: en
---

## What This Guide Covers

This guide provides an overview of the packages, tools and settings available in the Jammy Jellyfish environment.

## Using Ubuntu 22.04 (Jammy Jellyfish)

To route your builds to Ubuntu 22.04 LTS, Jammy, add the following to your `.travis.yml`:

```yaml
dist: jammy
```
{: data-file=".travis.yml"}

## Environment common to all Ubuntu 22.04 images

All preinstalled software not provided by the distro is installed from an official release — either a prebuilt binary if available, or a source release built with default options.
For preinstalled language interpreters, a standard version manager like `rvm` is used if available for the language.

### Version Control

| package  | version   |
|:---------|:----------|
| git      | `2.48.1`  |
| git-lfs  | `3.0.2`   |
| hg       | `6.5.2`   |
| svn      | `1.14.1`  |
{: style="width: 30%" }

### Compilers and Build Toolchain

| package    | version   |
|:-----------|:----------|
| clang      | `18.1.8`  |
| cmake      | `3.29.0`  |
| gcc        | `11.4.0`  |
| ccache     | `4.5.1`   |
| shellcheck | `0.10.0`  |
| shfmt      | `3.8.0`   |
{: style="width: 30%" }

### Docker and Container Tools

* Docker `28.0.1` (build 068a01e) is installed.
* docker-compose `v2.27.1` is also available.
* Podman `3.4.4` is installed as an alternative container engine.

### Ruby Support

* Pre-installed Rubies: `3.0.4` and `3.1.2`.
* The default ruby is `3.1.2`.
* Other ruby versions can be installed during build time.

### Python Support

* Supported Python version is: **3.8 or higher** as Python 2.7 has been sunset.
* The following Python versions are available via pyenv:

| alias  | version   |
|:-------|:----------|
| `3.8`  | `3.8.18`  |
| `3.12` | `3.12.4`  |
{: style="width: 30%" }

### JavaScript and Node.js Support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time.
* The default Node.js version available on the machine is:
  * `v18.20.3`

### Go Support

* Pre-installed Go:  
  * `go version go1.23.6 linux/amd64`  
Additional Go versions can be installed during build time by specifying the language version with the `go:` key.

### JVM (Clojure, Groovy, Java, Scala) Support

* Pre-installed JVMs:  
  * Default Java:  
    * `openjdk version "11.0.21" 2023-10-17 LTS`
* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.
* The following JVM tooling is preinstalled:

| package | version   |
|:--------|:----------|
| gradle  | `8.3`     |
| maven   | `3.9.4`   |
| groovy  | `4.0.15`  |
{: style="width: 30%" }

### Perl Support

* Default version on Jammy is `5.34.0`.
* Supported versions (e.g. `5.33`) can be installed using the `perl:` key.

### PHP Support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

| alias | version  |
|:------|:---------|
| `8.1` | `8.1.2`  |
{: style="width: 30%" }

### Databases and Services

The following services and databases are preinstalled but do not run by default.
To use one in your build, add it to the `services` key in your `.travis.yml`:

| service      | version   |
|:-------------|:----------|
| mongodb      | `6.0.20`  |
| mysql        | `8.0.41`  |
| redis        | `7.4.2`   |
| postgresql   | `14.17`   |
{: style="width: 30%" }

### Android Support

For Android builds, the environment provides comprehensive support with the following pre-installed components:

- **Android SDK Components** – Installed components include:
  - `tools`
  - `platform-tools`
  - `build-tools;30.0.0`
  - `platforms;android-30`
  - `extras;google;google_play_services`
  - `extras;google;m2repository`
  - `extras;android;m2repository`

To use Android, specify `language: android` in your `.travis.yml` and refer to the [Android Build Environment Guide](/user/languages/android/) for additional configuration details.

## Other Ubuntu Linux Build Environments

For details on other Ubuntu Linux build environments available on Travis CI, please refer to the [Ubuntu Linux overview page](/user/reference/linux/).
