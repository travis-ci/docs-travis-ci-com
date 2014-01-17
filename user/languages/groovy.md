---
title: Building a Groovy project
layout: en
permalink: groovy/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Groovy projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Overview

Travis CI environment provides OpenJDK 7, OpenJDK 6, Oracle JDK 7u4, Gradle 1.4, Maven 3 and Ant. Groovy project builder has reasonably good defaults for
projects that use Gradle, Maven or Ant, so quite often you won't have to configure anything beyond

    language: groovy

in your `.travis.yml` file.

Support for multiple JDKs will be available in the future.

## Projects Using Gradle

### Default Test Command

if your project has `build.gradle` file in the repository root, Travis Groovy builder will use Gradle to build it. By default it will use

    gradle check

to run your test suite. This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

### Dependency Management

Before running tests, Groovy builder will execute

    gradle assemble

to install your project's dependencies with Gradle.

## Projects Using Maven

### Default Test Command

if your project has `pom.xml` file in the repository root but no `build.gradle`, Travis Groovy builder will use Maven 3 to build it. By default it will use

    mvn test

to run your test suite. This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

### Dependency Management

Before running tests, Groovy builder will execute

    mvn install -DskipTests=true

to install your project's dependencies with Maven.

## Projects Using Ant

### Default Test Command

If Travis could not detect Maven or Gradle files, Travis Groovy builder will use Ant to build it. By default it will use

    ant test

to run your test suite. This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.


### Dependency Management

Because there is no single standard way of installing project dependencies with Ant, Travis CI Groovy builder does not have any default for it. You need to specify the exact commend to run using `install:` key in your `.travis.yml`, for example:

    language: groovy
    install: ant deps


## Testing Against Multiple JDKs

To test against multiple JDKs, use the `:jdk` key in `.travis.yml`. For example, to test against Oracle JDK 7 (which is newer than OpenJDK 7 on Travis CI) and OpenJDK 6:

    jdk:
      - oraclejdk7
      - openjdk6

To test against OpenJDK 7 and Oracle JDK 7:

    jdk:
      - openjdk7
      - oraclejdk7

Travis CI provides OpenJDK 6, OpenJDK 7 and Oracle JDK 7. Sun JDK 6 is not provided and because it is EOL in November 2012,
will not be provided.

JDK 7 is backwards compatible, we think it's time for all projects to start testing against JDK 7 first and JDK 6 if resources permit.


## Build Matrix

For Groovy projects, `env` and `jdk` can be given as arrays
to construct a build matrix.
