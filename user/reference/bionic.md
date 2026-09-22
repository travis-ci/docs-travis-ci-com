---
title: The Ubuntu 18.04 Build Environment
layout: en
---

> Bionic LTS Standard is EOL by Canonical, try updating to a newer image. It will be in use in Travis CI for some time more, but it's time to consider migration of your builds to a newer build environment image.
Additionally, Bionic won't be receiving any new updates.

## What This Guide Covers

This guide provides an overview of the packages, tools, and settings available in the Bionic environment.

## Using Ubuntu 18.04 (Bionic Beaver)

To route your builds to Ubuntu 18.04 LTS, Bionic, add the following to your `.travis.yml`:

```yaml
dist: bionic
```
{: data-file=".travis.yml"}

## Environment Common to All Ubuntu 18.04 Images

All Ubuntu 18.04 builds include the following versions of Docker: version control software, compilers, and language support. All preinstalled software not provided by the distro is installed from an official release—either a prebuilt binary, if available, or a source release built with default options.

### Version Control

| Package      | Version   |
|:-------------|:----------|
| **git**      | `2.43.0`  |
| **git-lfs**  | `2.3.4`   |
| **hg**       | `5.3`     |
| **svn**      | `1.9.7`   |
{: style="width: 30%" }

### Compilers and Build Toolchain

| Tool           | Version    |
|:---------------|:-----------|
| **clang**      | `18.1.8`   |
| **cmake**      | `3.26.3`   |
| **gcc**        | `7.5.0`    |
| **ccache**     | `3.4.1`    |
| **ShellCheck** | `0.10.0`   |
| **shfmt**      | `3.8.0`    |
{: style="width: 30%" }

### Docker and Container Tools

| Package            | Version                           |
|:-------------------|:----------------------------------|
| **Docker**         | `24.0.2` (build cb74dfc)          |
| **docker-compose** | `v2.20.3`                         |
| **Podman**         | `3.4.2`                            |
{: style="width: 30%" }

### Ruby Support

* **Pre-installed Ruby**:  
  * `ruby 3.3.5`
* Other Ruby versions (e.g., 2.7.x, 3.1.x) can be installed during build time.

### Python Support

* **Supported Python versions:** 3.6 or higher.

The following Python versions are directly callable:

| Alias    | Version   |
|:---------|:----------|
| **3.6**  | `3.6.9`   |
| **3.7**  | `3.7.17`  |
| **3.8**  | `3.8.18`  |
| **3.12** | `3.12.4`  |
  
### JavaScript and Node.js Support

* For builds specifying `language: node_js`, `nvm` is automatically updated to the latest version at build time.  
* The default Node.js version available on the machine is:
  * `v16.15.1`
* Additional Node.js versions are available through nvm if configured.

### Go Support

* **Pre-installed Go:**  
  * `go version go1.23.6 linux/amd64`  
Additional Go versions can be installed during build time by specifying the language version with the `go:` key.

### JVM (Clojure, Groovy, Java, Scala) Support

* **Pre-installed JVMs:**  
  * Default Java:  
    * `openjdk version "11.0.21" 2023-10-17 LTS`
* Other JDKs, including Oracle's, can be acquired if available by specifying the `jdk` key.
* The following JVM tooling is preinstalled:

| Package    | Version   |
|:-----------|:----------|
| **Gradle** | `8.3`     |
| **Maven**  | `3.9.4`   |
| **Groovy** | `4.0.15`  |
{: style="width: 30%" }

### Perl Support

* The default Perl version on Ubuntu 18.04 is provided by the system.
* Additional Perl versions can be installed using the `perl:` key.
* Tools like `TAP::Harness` and `cpanm` are also available.

### PHP Support

* For dynamic runtime selection, `phpenv` is available.
* The preinstalled PHP version on this image is:
  * `PHP 7.2.27` (CLI)
* If a different version is required, it can be installed during the build.

#### Extensions for PHP 7.2 and Higher

The following extensions are preinstalled for PHP builds:

- [apcu.so](http://php.net/apcu)
- [memcached.so](http://php.net/memcached) (Not preinstalled for > PHP8.0)
- [mongodb.so](https://php.net/mongodb)
- [amqp.so](http://php.net/amqp)
- [zmq.so](http://zeromq.org/bindings:php)
- [xdebug.so](http://xdebug.org)
- [redis.so](http://pecl.php.net/package/redis)

> **Note:** With the exception of xdebug, these extensions are not enabled by default.

### Databases and Services

The following services and databases are preinstalled but do not run by default. To use any in your build, add the service to your `.travis.yml`:

| Service        | Version / Notes                                                         |
|:---------------|:------------------------------------------------------------------------|
| **MongoDB**    | `v4.4.29`                                                              |
| **MySQL**      | `5.7.42`                                                               |
| **Redis**      | `7.2.5`                                                                |
| **PostgreSQL** | *`psql` is not installed by default. Install using `apt-get install postgresql-client-common` if needed.* |
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
```
