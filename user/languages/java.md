---
title: Building a Java project
layout: en
permalink: /user/languages/java/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Java projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/build-configuration/) guides first.

## Overview

Travis CI environment provides Oracle JDK 7 (default), Oracle JDK 8, OpenJDK 6, OpenJDK 7, OpenJDK 8, Gradle 2.2.1, Maven 3.2 and Ant 1.8.
Java project builder has reasonably good defaults for projects that use Gradle, Maven or Ant,
so quite often you won't have to configure anything beyond

    language: java

in your `.travis.yml` file.

## Projects Using Maven

### Default Test Command

if your project has `pom.xml` file in the repository root but no `build.gradle`, Travis CI Java builder will use Maven 3 to build it. By default it will use

    mvn test

to run your test suite. This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

### Dependency Management

Before running tests, Java builder will execute

    mvn install -DskipTests=true

to install your project's dependencies with Maven.

## Projects Using Gradle

### Default Test Command

if your project has `build.gradle` file in the repository root, Travis CI Java builder will use Gradle to build it. By default it will use

    gradle check

to run your test suite. If your project also includes the `gradlew` wrapper script in the repository root, Java builder will try to use it instead. The default command will become:

    ./gradlew check

This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

### Dependency Management

Before running tests, Java builder will execute

    gradle assemble


to install your project's dependencies with Gradle. Again, if you include the wrapper script, the command will be defaulted to

    ./gradlew assemble


## Projects Using Ant

### Default Test Command

If Travis CI could not detect Maven or Gradle files, Travis CI Java builder will use Ant to build it. By default it will use

    ant test

to run your test suite. This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

### Dependency Management

Because there is no single standard way of installing project dependencies with Ant, Travis CI Java builder does not have any default for it. You need to specify the exact command to run using `install:` key in your `.travis.yml`, for example:

    language: java
    install: ant deps


## Testing Against Multiple JDKs

To test against multiple JDKs, use the `jdk:` key in `.travis.yml`. For example, to test against Oracle JDK 7 (which is newer than OpenJDK 7 on Travis CI) and OpenJDK 6:

    jdk:
      - oraclejdk8
      - oraclejdk7
      - openjdk8
      - openjdk6

To test against OpenJDK 7 and Oracle JDK 7:

    jdk:
      - openjdk7
      - oraclejdk7

Travis CI provides OpenJDK 6, OpenJDK 7, OpenJDK 8, Oracle JDK 7, and Oracle JDK 8. Sun JDK 6 is not provided, because it is EOL as of November 2012.

JDK 7 is backwards compatible, we think it's time for all projects to start testing against JDK 7 first and JDK 6 if resources permit.

## Build Matrix

For Java projects, `env` and `jdk` can be given as arrays
to construct a build matrix.

## Switching JDKs Within One Job

If your build needs to switch JDKs during a job, you can do so with `jdk_switcher use …`.

    script:
      - jdk_switcher use oraclejdk8
      - # do stuff with Java 8
      - jdk_switcher use oraclejdk7
      - # do stuff with Java 7

Use of `jdk_switcher` will update `$JAVA_HOME appropriately.

## Examples

* [JRuby](https://github.com/jruby/jruby/blob/master/.travis.yml)
* [Riak Java client](https://github.com/basho/riak-java-client/blob/master/.travis.yml)
* [Cucumber JVM](https://github.com/cucumber/cucumber-jvm/blob/master/.travis.yml)
* [Symfony 2 Eclipse plugin](https://github.com/pulse00/Symfony-2-Eclipse-Plugin/blob/master/.travis.yml)
* [RESThub](https://github.com/resthub/resthub-spring-stack/blob/master/.travis.yml)
* [Joni](https://github.com/jruby/joni/blob/master/.travis.yml), JRuby's regular expression implementation
