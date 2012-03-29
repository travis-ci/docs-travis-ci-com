---
title: Building a Groovy project
layout: en
permalink: groovy/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Groovy projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Overview

Travis CI environment provides OpenJDK 6, Gradle 1.0-milestone 7, Maven 3 and Ant 1.7. Groovy project builder has reasonably good defaults for
projects that use Gradle, Maven or Ant, so quite often you won't have to configure anything beyond

    language: groovy

in your `.travis.yml` file.

Support for multiple JDKs will be available in the future.

## Projects Using Gradle

### Default Test Command

if your project has `build.gradle` file in the repository root, Travis Groovy builder will use Gradle to build it. By default it will use

    gradle check

to run your test suite. This can be overriden as described in the [general build configuration](/docs/user/build-configuration/) guide.

### Dependency Management

Before running tests, Groovy builder will execute

    gradle assemble

to install your project's dependencies with Gradle.

## Projects Using Maven

### Default Test Command

if your project has `pom.xml` file in the repository root but no `build.gradle`, Travis Groovy builder will use Maven 3 to build it. By default it will use

    mvn test

to run your test suite. This can be overriden as described in the [general build configuration](/docs/user/build-configuration/) guide.

### Dependency Management

Before running tests, Groovy builder will execute

    mvn install -DskipTests=true

to install your project's dependencies with Maven.

## Projects Using Ant

### Default Test Command

If Travis could not detect Maven or Gradle files, Travis Groovy builder will use Ant to build it. By default it will use

    ant test

to run your test suite. This can be overriden as described in the [general build configuration](/docs/user/build-configuration/) guide.


### Dependency Management

Because there is no single standard way of installing project dependencies with Ant, Travis CI Groovy builder does not have any default for it. You need to specify the exact commend to run using `install:` key in your `.travis-yml`, for example:

    language: groovy
    install: ant deps
