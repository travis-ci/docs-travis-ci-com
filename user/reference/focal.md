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

## Environment common to all Ubuntu 20.04 images

The following versions of Docker, version control software and compilers are present on all Ubuntu 20.04 builds, along with more language specific software described in more detail in each language section.

All preinstalled software not provided by the distro is installed from an official release — either a prebuilt binary if available, or a source release built with default options.
For preinstalled language interpreters, a standard version manager like `rvm` is used if available for the language.

### Version Control

| package  | version   |
|:---------|:----------|
| git      | `2.50.1`  |
| git-lfs  | `2.9.2`   |
| hg       | `7.0.3`   |
| svn      | `1.13.0`  |
{: style="width: 30%" }

### Compilers and Build Toolchain

| package      | version   |
|:-------------|:----------|
| clang        | `18.1.8`  |
| cmake        | `4.2.0`  |
| gcc          | `9.4.0`   |
| ccache       | `3.7.7`   |
| shellcheck   | `0.11.0`  |
| shfmt        | `3.12.0`   |
{: style="width: 30%" }

To use the IBM Advance Toolchain v14 compilers under `ppc64le` architecture in Focal LXD image, use the following paths in your `.travis.yml`:

- **GCC compiler**
  - Path: `/opt/at14.0/bin/gcc`
  - Command: `/opt/at14.0/bin/gcc hello_world.c -o hello_world`

- **g++ compiler**
  - Path: `/opt/at14.0/bin/g++`
  - Command: `/opt/at14.0/bin/g++ hello_world.cpp -o hello_world`

- **Go compiler**
  - Path: `/opt/at14.0/bin/gccgo`
  - Command: `/opt/at14.0/bin/gccgo hello_world.go -o hello_world`

- **Python**
  - First, compile Python 3.8.0 using the `python_interpreter.sh` script.
  - Python Interpreter Path: `/opt/python380-at14/python3.8`
  - Build Python Command: `sudo sh python_interpreter.sh`

To use the IBM Advance Toolchain v14 compilers under `amd64` architecture in Focal LXD image, use the following paths in your `.travis.yml`:

- **GCC compiler**
  - Path: `/opt/at14.0/bin/powerpc64le-linux-gnu-gcc`
  - Command: `/opt/at14.0/bin/powerpc64le-linux-gnu-gcc hello_world.c -o hello_world`

- **g++ compiler**
  - Path: `/opt/at14.0/bin/powerpc64le-linux-gnu-g++`
  - Command: `/opt/at14.0/bin/powerpc64le-linux-gnu-g++ hello_world.cpp -o hello_world`

- **Go compiler**
  - Path: `/opt/at14.0/bin/powerpc64le-linux-gnu-gccgo`
  - Command: `/opt/at14.0/bin/powerpc64le-linux-gnu-gccgo hello_world.go -o hello_world`

- **Python**
  - First, compile Python 3.8.0 using the `python_interpreter.sh` script.
  - Python Interpreter Path: `/opt/python380-amd64/python3.8`
  - Build Python Command: `sudo sh python_interpreter.sh`

### Docker and Container Tools

* Docker `28.1.1` is installed.
* docker-compose `v2.35.1` is also available.
* Podman `3.4.2` is installed as an alternative container engine.

## Ruby support

* Pre-installed Rubies: `2.7.8` and `3.3.5`.
* The default ruby is `3.3.10`.
* Other ruby versions can be installed during build time.

## Python support

* Supported Python version is: `3.8` or higher as `2.7` has been sunset.
* Python `3.8.20` will be used by default when no language version is explicitly set.
* The following Python versions are preinstalled:

| alias  | version   |
| :----- | :-------- |
| `3.8`  | `3.8.20`  |
| `3.9`  | `3.9.24`  |
| `3.12` | `3.12.12`  |
{: style="width: 30%" }

## JavaScript and Node.js support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time. For other builds, the stable version at image build time has been selected.
* The following NodeJS versions are preinstalled: `4.9.1`, `6.17.1`, `8.17.0`, `10.24.1`, `12.22.12`, `14.21.3`, `16.15`, `16.20.2`, `18.20.3` and `20.19.5`.

## Go support

* Pre-installed Go: `1.25.3`.

* Other Go versions can be installed during build time by specifying the language versions with the `go:` key.

## JVM (Clojure, Groovy, Java, Scala) support

* Pre-installed JVMs: `openjdk8`, `openjdk9`, `openjdk10`, `openjdk11` and `openjdk17` on x86, default is `openjdk11`.
* Other JDKs, including Oracle's, can be acquired if available by specifying `jdk`.
* The following table summarizes the pre-installed JVM tooling versions:

| package | version  |
|:--------|:---------|
| gradle  | `9.1.0`    |
| maven   | `3.9.11`  |
| groovy  | `4.0.28` |
{: style="width: 30%" }

## Perl support

* Default version on Focal is `5.30.0`
* Supported versions `5.32` and `5.33` can be installed by using the `perl:` key.
* `TAP::Harness` v3.42 and `cpanm` (App::cpanminus) version 1.7044 are also pre-installed.

## PHP support

* For dynamic runtime selection, `phpenv` is available.
* The following PHP versions are preinstalled:

| alias  | version  |
| :----- | :------- |
| `8.3`  | `8.3.27`  |
{: style="width: 30%" }

## Databases and services

The following services and databases are preinstalled but do not run by default.
To use one in your build, add it to the services key in your `travis.yml`:

| service    | version  |
|:-----------|:---------|
| mongodb    | `8.2.1` |
| mysql      | `8.0.42` |
| redis      | `8.0.3`  |
| postgresql | `13.21`  |
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

