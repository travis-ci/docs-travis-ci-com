---
title: Building an Android Project (beta)
layout: en
permalink: android/
---

### Warning

The features described here are still in development and are subject to change without backward compatibility or migration support.

### What This Guide Covers

This guide covers build environment and configuration topics specific to Android projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/build-configuration/) guides first.

## CI Environment for Android Projects

### Overview

Travis CI environment provides a large set of build tools for JVM languages with [multiple JDKs, Ant, Gradle, Maven](/user/languages/java/#Overview), [sbt](/user/languages/scala#Projects-using-sbt) and [Leiningen](/user/languages/clojure).

By setting

    language: android

in your `.travis.yml` file, your project will be built in the Android environment which provides [Android SDK](http://developer.android.com/sdk) 22.6.2 with following preinstalled components:

- platform-tools
- build-tools-19.0.3
- android-19
- sysimg-19 (ARM)
- android-18
- sysimg-18 (ARM)
- android-17
- sysimg-17 (ARM)
- android-16
- sysimg-16 (ARM)
- android-15
- sysimg-15 (ARM)
- android-10
- extra-android-support
- extra-google-google_play_services
- extra-google-m2repository
- extra-android-m2repository

### How to install or update Android SDK components

In your `.travis.yml` you can optionally define the SDK **components** to be installed and the **licenses** to be accepted, as illustrated in the following example:

    language: android
    android:
      components:
        - tools
        - build-tools-19.0.1
        - android-19
        - sysimg-19
        - extra-android-support
      licenses:
        - android-sdk-license-bcbbd656
        - '.*intel.+'

The exact component names must be specified, while the licenses can also be referenced with regular expressions (using Tcl syntax as `expect` command is used to automatically interact with the interactive prompts).

If no license is specified, Travis CI will only accept `android-sdk-license-bcbbd656` by default:

    language: android
    android:
      components:
        - build-tools-18.1.1
        - android-8

## Dependency Management

Travis CI Android builder assumes that your project is built with a JVM build tool like Maven or Gradle that will automatically pull down project dependencies before running tests without any effort on your side.

If your project is built with Ant or any other build tool that does not automatically handle dependences, you need to specify the exact command to run using `install:` key in your `.travis.yml`, for example:

    language: android
    install: ant deps

## Default Test Command for Maven

If your project has `pom.xml` file in the repository root but no `build.gradle`, Maven 3 will be used to build it. By default it will use

    mvn install -B

to run your test suite. This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

## Default Test Command for Gradle

If your project has `build.gradle` file in the repository root, Gradle will be used to build it. By default it will use

    gradle build connectedCheck

to run your test suite. If your project also includes the `gradlew` wrapper script in the repository root, Travis Android builder will try to use it instead. The default command will become:

    ./gradlew build connectedCheck

This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

## Default Test Command

If Travis CI could not detect Maven or Gradle files, Travis CI Android builder will try to use Ant to build your project. By default it will use

    ant debug installt test

to run your test suite. This can be overridden as described in the [general build configuration](/user/build-configuration/) guide.

## Testing Against Multiple JDKs

As for any JVM language, it is also possible to [test against multiple JDKs](/user/languages/java/#Testing-Against-Multiple-JDKs).

## Build Matrix

For Android projects, `env` and `jdk` can be given as arrays to construct a build matrix.

## Examples

* [roboguice/roboguice](https://github.com/roboguice/roboguice/blob/master/.travis.yml) (Google Guice on Android)
* [ruboto/ruboto](https://github.com/ruboto/ruboto/blob/master/.travis.yml) (A platform for developing apps using JRuby on Android)
* [Gradle Example Project](https://github.com/pestrada/android-tdd-playground/blob/master/.travis.yml)
* [Maven Example Project](https://github.com/embarkmobile/android-maven-example/blob/master/.travis.yml) (still using `language: java`, see https://github.com/embarkmobile/android-maven-example/pull/7)
