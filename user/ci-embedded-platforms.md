---
title: CI for Embedded Platforms
layout: en
permalink: /user/ci-embedded-platforms/
---

## Overview

[PlatformIO](http://platformio.org/) is a cross-platform code builder and the
missing library manager for embedded development. PlatformIO is written in
pure Python and doesn't depend on any additional libraries/toolchains from an
operation system. Thanks to it, you can test your embedded projects on
[Multiple Operating Systems](/user/multi-os/).

## Supported Embedded Platforms, Frameworks and Boards

### Embedded Platforms

PlatformIO has pre-built different development platforms for the most popular
host OS (Mac OS X, Windows, Linux 32/64bit, Linux ARMv6+). Each of them
includes compiler, debugger, uploader and many other useful tools.

<ul class="list-language">
  <li>Atmel AVR</li>
  <li>Atmel SAM</li>
  <li>Espressif</li>
  <li>Freescale Kinetis</li>
  <li>Nordic nRF51</li>
  <li>NXP LPC</li>
  <li>Silicon Labs EFM32</li>
  <li>ST STM32</li>
  <li>Teensy</li>
  <li>TI MSP430</li>
  <li>TI TIVA</li>
</ul>

For the actual list, please follow to
[PlatformIO Development Platforms](http://platformio.org/#!/platforms).

### Embedded Frameworks

PlatformIO has pre-configured build scripts for the popular embedded frameworks.

<ul class="list-language">
  <li>Arduino</li>
  <li>CMSIS</li>
  <li>libOpenCM3</li>
  <li>Energia</li>
  <li>SPL</li>
  <li>mbed</li>
</ul>

For the actual list, please follow to
[PlatformIO Frameworks](http://platformio.org/#!/frameworks).

### Embedded Boards

PlatformIO has pre-defined compilation profiles for a variety of embedded
boards. For more details, please follow to
[PlatformIO Embedded Boards Explorer](http://platformio.org/#!/boards).

## Setting `.travis.yml`

Please make sure to read official
[PlatformIO & Travis CI](http://docs.platformio.org/en/latest/ci/travis.html) documentation first.

PlatformIO is written in Python and is recommended to be run within [Travis CI
Python isolated environment](/user/languages/python/#Travis-CI-Uses-Isolated-virtualenvs):

```
language: python
python:
    - "2.7"

env:
    - PLATFORMIO_CI_SRC=path/to/test/file.c
    - PLATFORMIO_CI_SRC=examples/file.ino
    - PLATFORMIO_CI_SRC=path/to/test/directory

install:
    # install the latest stable PlatformIO
    - python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"

script:
    - platformio ci --board=TYPE_1 --board=TYPE_2 --board=TYPE_N

```

For the board types please go to [Embedded Boards](#Embedded-Boards) section.

### Project as a library

When project is written as a library (where own examples or testing code use
it), please use `--lib="."` option for [platformio ci](http://docs.platformio.org/en/latest/userguide/cmd_ci.html#cmdoption-platformio-ci-l) command

```
script:
    - platformio ci --lib="." --board=TYPE_1 --board=TYPE_2 --board=TYPE_N
```

### Library dependecies

There 2 options to test source code with dependent libraries:

#### Install dependent library using [PlatformIO Library Manager](http://platformio.org/#!/lib)

```
install:
    - python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"

    # OneWire Library with ID=1 http://platformio.org/#!/lib/show/1/OneWire
    platformio lib install 1

script:
    - platformio ci --board=TYPE_1 --board=TYPE_2 --board=TYPE_N
```

#### Manually download dependent library and include in build process via `--lib` option

```
install:
    - python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"

    # download library to the temporary directory
    wget https://github.com/PaulStoffregen/OneWire/archive/master.zip -O /tmp/onewire_source.zip
    unzip /tmp/onewire_source.zip -d /tmp/

script:
    - platformio ci --lib="/tmp/OneWire-master" --board=TYPE_1 --board=TYPE_2 --board=TYPE_N
```

### Custom Build Flags

PlatformIO allows to specify own build flags using
[PLATFORMIO_BUILD_FLAGS](http://docs.platformio.org/en/latest/envvars.html#envvar-PLATFORMIO_BUILD_FLAGS) environment

```
language: python
python:
    - "2.7"

env:
    - PLATFORMIO_CI_SRC=path/to/test/file.c PLATFORMIO_BUILD_FLAGS="-D SPECIFIC_MACROS_PER_TEST_ENV -I/extra/inc"
    - PLATFORMIO_CI_SRC=examples/file.ino
    - PLATFORMIO_CI_SRC=path/to/test/directory

install:
    - python -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"

    export PLATFORMIO_BUILD_FLAGS=-D GLOBAL_MACROS_FOR_ALL_TEST_ENV

script:
    - platformio ci --board=TYPE_1 --board=TYPE_2 --board=TYPE_N

```

For the more details, please follow to [available build flags/options](http://docs.platformio.org/en/latest/projectconf.html#build-flags).


### Advanced configuration

PlatformIO allows to configure multiple build environments for the single
source code using Project Configuration File [platformio.ini](http://docs.platformio.org/en/latest/projectconf.html).

Instead of `--board` option, please use [platformio ci --project-conf](http://docs.platformio.org/en/latest/userguide/cmd_ci.html#cmdoption-platformio-ci--project-conf).

```
script:
    - platformio ci --project-conf=/path/to/platoformio.ini
```

## Examples `.travis.yml`

- [Custom build flags #1](https://github.com/felis/USB_Host_Shield_2.0/blob/master/.travis.yml)
- [Custom build flags #2](https://github.com/z3t0/Arduino-IRremote/blob/master/.travis.yml)
- [Dependency on external libraries](https://github.com/jcw/ethercard/blob/master/.travis.yml)
- [Dynamic testing boards](https://github.com/valeros/Time/blob/master/.travis.yml)
- [Test with multiple desktop platforms](https://github.com/smartanthill/smartanthill-commstack-server/blob/develop/.travis.yml)
