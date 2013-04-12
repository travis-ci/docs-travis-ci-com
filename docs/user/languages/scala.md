---
title: Building a Scala project
layout: en
permalink: scala/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Scala projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Overview

Travis CI environment provides OpenJDK 7, OpenJDK 6, Oracle JDK 7, Gradle 1.4, Maven 3, Ant and flexible SBT (..., 0.10, 0.11, 0.12,...) through sbt-extras script. Thanks to SBT ability to perform actions against multiple Scala versions, it is possible to test your projects against Scala 2.8.x, 2.9.x and 2.10.x. To specify Scala versions you want your project to be tested against, use the `scala` key:

    language: scala
    scala:
       - 2.8.2
       - 2.9.2

## Projects Using SBT

###Default Test Command

If your project has `project` directory or `build.sbt` file in the repository root, Travis Scala builder will use SBT to build it. By default, it will use

    sbt ++$TRAVIS_SCALA_VERSION test

to run your test suite. This can be overridden as described in the [general build configuration](/docs/user/build-configuration/) guide.

### Dependency Management

Because Travis Scala builder assumes SBT dependency management is used by default, it naturally will pull down project dependencies before running tests without any effort on your side.

## Projects Using Gradle

###Default Test Command

If your project has `build.gradle` file in the repository root, Travis Scala builder will use Gradle to build it. By default, it will use

    gradle check 

to run your test suite.

### Dependency Management

It naturally will pull down project dependencies before running tests without any effort on your side.

## Projects Using Maven

###Default Test Command

If Travis did not detect SBT or Gradle files, Travis Scala builder will use Maven to build it. By default it will use
 
    mvn test

to run your test suite.

### Dependency Management

It naturally will pull down project dependencies before running tests without any effort on your side.

## Testing Against Multiple JDKs

To test against multiple JDKs, use the `:jdk` key in `.travis.yml`. For example, to test against Oracle JDK 7 (which is newer than OpenJDK 7 on Travis CI) and OpenJDK 6:

    jdk:
      - oraclejdk7
      - openjdk6

To test against OpenJDK 7 and Oracle JDK 7:

    jdk:
      - openjdk7
      - oraclejdk7

Travis CI provides OpenJDK 7, OpenJDK 6 and Oracle JDK 7. Sun JDK 6 is not provided and because it is EOL in November 2012,
will not be provided.

JDK 7 is backwards compatible, we think it's time for all projects to start testing against JDK 7 first and JDK 6 if resources permit.

## Examples

* [twitter/scalding](https://github.com/twitter/scalding/blob/master/.travis.yml)
* [novus/salat](https://github.com/novus/salat/blob/master/.travis.yml)
* [scalaz/scalaz](https://github.com/scalaz/scalaz/blob/master/.travis.yml)

