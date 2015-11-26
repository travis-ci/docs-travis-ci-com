---
title: PlatformIO Deployment
layout: en
permalink: /user/deployment/platformio/
---

<div id="toc"></div>

## Overview

[PlatformIO](http://platformio.org/) is a cross-platform code-builder and library manager for embedded development with no external dependencies. By deploying to PlatformIO you can test on multiple platforms, frameworks and boards:

* *Platforms* - pre-built different development platforms for the most popular host OS (Mac OS X, Windows, Linux 32/64bit, Linux ARMv6+). Each of them
includes compiler, debugger, uploader, etc:

    + Atmel AVR
    + Espressif
    + Nordic nRF51
    + Teensy
    + [Full list](http://platformio.org/#!/platforms) at PlatformIO

* *Frameworks* - pre-configured build scripts for the popular embedded frameworks:

    + Arduino
    + libOpenCM3
    + SPL
    + [Full list](http://platformio.org/#!/frameworks) at PlatformIO

* *Embedded* - pre-defined compilation profiles for a variety of embedded
boards.
    + [Full list](http://platformio.org/#!/boards) at PlatformIO

## .travis.yml Settings

Please read the official
[PlatformIO & Travis CI](http://docs.platformio.org/en/latest/ci/travis.html) documentation before deploying to PLatformIO.

PlatformIO is written in Python and is recommended to be run within a [Travis CI
Python isolated environment](/user/languages/python/#Travis-CI-Uses-Isolated-virtualenvs):

```yaml
language: python
python:
    - "2.7"

# Cache PlatformIO packages using Travis CI container-based infrastructure
sudo: false
cache:
    directories:
        - "~/.platformio"

env:
    - PLATFORMIO_CI_SRC=path/to/test/file.c
    - PLATFORMIO_CI_SRC=examples/file.ino
    - PLATFORMIO_CI_SRC=path/to/test/directory

install:
    - pip install -U platformio

script:
    - platformio ci --board=TYPE_1 --board=TYPE_2 --board=TYPE_N

```

### Testing Libraries

If the project you are testing is a library, please use the  `--lib="."` option for the [platformio ci](http://docs.platformio.org/en/latest/userguide/cmd_ci.html#cmdoption-platformio-ci-l) command

```yaml
script:
    - platformio ci --lib="." --board=TYPE_1 --board=TYPE_2 --board=TYPE_N
```

### Managing dependencies

There are two options for testing projects with external dependencies:

* using the PlatformIO Library Manager
* installing dependencies manually

#### PlatformIO Library Manager

For the dependencies available in the PlatformIO Library Registry:

```yaml
install:
    - pip install -U platformio

    #
    # Libraries from PlatformIO Library Registry:
    #
    # http://platformio.org/#!/lib/show/1/OneWire
    platformio lib install 1
```

#### Installing dependencies manually

For the dependencies not available in the PlatformIO Library Registry:

```yaml
install:
    - pip install -U platformio

    # download library to the temporary directory
    wget https://github.com/PaulStoffregen/OneWire/archive/master.zip -O /tmp/onewire_source.zip
    unzip /tmp/onewire_source.zip -d /tmp/

script:
    - platformio ci --lib="/tmp/OneWire-master" --board=TYPE_1 --board=TYPE_2 --board=TYPE_N
```

### Custom Build Flags

To specify custom build flags using the
[PLATFORMIO_BUILD_FLAGS](http://docs.platformio.org/en/latest/envvars.html#envvar-PLATFORMIO_BUILD_FLAGS) environment:

```yaml
env:
    - PLATFORMIO_CI_SRC=path/to/test/file.c PLATFORMIO_BUILD_FLAGS="-D SPECIFIC_MACROS_PER_TEST_ENV -I/extra/inc"
    - PLATFORMIO_CI_SRC=examples/file.ino
    - PLATFORMIO_CI_SRC=path/to/test/directory

install:
    - pip install -U platformio
    export PLATFORMIO_BUILD_FLAGS=-D GLOBAL_MACROS_FOR_ALL_TEST_ENV

```

More details available at [build flags/options](http://docs.platformio.org/en/latest/projectconf.html#build-flags).


### Advanced configuration

You can configure multiple build environments using a [platformio.ini](http://docs.platformio.org/en/latest/projectconf.html) Project Configuration file, and specifying a [--project-conf](http://docs.platformio.org/en/latest/userguide/cmd_ci.html#cmdoption-platformio-ci--project-conf) instead of `--board`.

```yaml
script:
    - platformio ci --project-conf=/path/to/platoformio.ini
```

## Examples

- [Custom build flags #1](https://github.com/felis/USB_Host_Shield_2.0/blob/master/.travis.yml)
- [Custom build flags #2](https://github.com/z3t0/Arduino-IRremote/blob/master/.travis.yml)
- [Dependency on external libraries](https://github.com/jcw/ethercard/blob/master/.travis.yml)
- [Dynamic testing boards](https://github.com/valeros/Time/blob/master/.travis.yml)
- [Test with multiple desktop platforms](https://github.com/smartanthill/smartanthill-commstack-server/blob/develop/.travis.yml)
