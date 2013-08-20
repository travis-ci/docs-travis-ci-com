---
title: Building a Java project
layout: en
permalink: java/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Java projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## Overview

Travis CI environment provides OpenJDK 7, OpenJDK 6, Oracle JDK 7, Gradle 1.4, Maven 3 and Ant. Java project builder has reasonably good defaults for projects that use Gradle, Maven or Ant, so quite often you won't have to configure anything beyond

    language: java

in your `.travis.yml` file.

## Projects Using Maven

### Default Test Command

if your project has `pom.xml` file in the repository root but no `build.gradle`, Travis Java builder will use Maven 3 to build it. By default it will use

    mvn test

to run your test suite. This can be overridden as described in the [general build configuration](/docs/user/build-configuration/) guide.

### Dependency Management

Before running tests, Java builder will execute

    mvn install -DskipTests=true

to install your project's dependencies with Maven.

## Projects Using Gradle

### Default Test Command

if your project has `build.gradle` file in the repository root, Travis Java builder will use Gradle to build it. By default it will use

    gradle check

to run your test suite. This can be overridden as described in the [general build configuration](/docs/user/build-configuration/) guide.

### Dependency Management

Before running tests, Java builder will execute

    gradle assemble

to install your project's dependencies with Gradle.

## Projects Using Ant

### Default Test Command

If Travis could not detect Maven or Gradle files, Travis Java builder will use Ant to build it. By default it will use

    ant test

to run your test suite. This can be overridden as described in the [general build configuration](/docs/user/build-configuration/) guide.

### Dependency Management

Because there is no single standard way of installing project dependencies with Ant, Travis CI Java builder does not have any default for it. You need to specify the exact command to run using `install:` key in your `.travis.yml`, for example:

    language: java
    install: ant deps


## Testing Against Multiple JDKs

To test against multiple JDKs, use the `jdk:` key in `.travis.yml`. For example, to test against Oracle JDK 7 (which is newer than OpenJDK 7 on Travis CI) and OpenJDK 6:

    jdk:
      - oraclejdk7
      - openjdk6

To test against OpenJDK 7 and Oracle JDK 7:

    jdk:
      - openjdk7
      - oraclejdk7

Travis CI provides OpenJDK 6, OpenJDK 7 and Oracle JDK 7. Sun JDK 6 is not provided and because it is EOL as of November 2012.

JDK 7 is backwards compatible, we think it's time for all projects to start testing against JDK 7 first and JDK 6 if resources permit.

## Examples

* [JRuby](https://github.com/jruby/jruby/blob/master/.travis.yml)
* [Riak Java client](https://github.com/basho/riak-java-client/blob/master/.travis.yml)
* [Cucumber JVM](https://github.com/cucumber/cucumber-jvm/blob/master/.travis.yml)
* [Symfony 2 Eclipse plugin](https://github.com/pulse00/Symfony-2-Eclipse-Plugin/blob/master/.travis.yml)
* [RESThub](https://github.com/resthub/resthub-spring-stack/blob/master/.travis.yml)
* [Joni](https://github.com/jruby/joni/blob/master/.travis.yml), JRuby's regular expression implementation
* [Android](https://github.com/leviwilson/android-travis-ci-example/blob/master/.travis.yml), using the [maven-android-plugin](http://code.google.com/p/maven-android-plugin/)
* [Android](http://blog.crowdint.com/2013/05/24/android-builds-on-travis-ci-with-gradle.html), using the [new build system with Gradle](http://tools.android.com/tech-docs/new-build-system)
