---
title: Building an Android Project (beta)
layout: en
permalink: /user/languages/android/
---

### Warning

The features described here are still in development and are subject to change without backward compatibility or migration support.

### What This Guide Covers

This guide covers build environment and configuration topics specific to Android projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/customizing-the-build/) guides first.

<div id="toc"></div>

## CI Environment for Android Projects

### Overview

Travis CI environment provides a large set of build tools for JVM languages with [multiple JDKs, Ant, Gradle, Maven](/user/languages/java/#Overview), [sbt](/user/languages/scala#Projects-using-sbt) and [Leiningen](/user/languages/clojure).

By setting

    language: android

in your `.travis.yml` file, your project will be built in the Android environment which provides [Android SDK Tools](http://developer.android.com/tools/sdk/tools-notes.html) 24.0.0 (December 2014).

Here is an example `.travis.yml` for an Android project:

    language: android
    android:
      components:
        # Uncomment the lines below if you want to
        # use the latest revision of Android SDK Tools
        # - platform-tools
        # - tools

        # The BuildTools version used by your project
        - build-tools-19.1.0

        # The SDK version used to compile your project
        - android-19

        # Additional components
        - extra-google-google_play_services
        - extra-google-m2repository
        - extra-android-m2repository
        - addon-google_apis-google-19

        # Specify at least one system image,
        # if you need to run emulator(s) during your tests
        - sys-img-armeabi-v7a-android-19
        - sys-img-x86-android-17


### How to install Android SDK components

In your `.travis.yml` you can define the list of SDK components to be installed, as illustrated in the following example:

    language: android
    android:
      components:
        - build-tools-18.1.1
        - android-18
        - extra

The exact component names must be specified (filter aliases like `add-on` or `extra` are also accepted). To get a list of available exact component names and descriptions run the command `android list sdk --no-ui --all --extended` (preferably in your local development machine).

#### Dealing with Licenses

By default, Travis CI will accept all the requested licenses, but it is also possible to define a white list of licenses to be accepted, as shown in the following example:

    language: android
    android:
      components:
        - build-tools-20.0.0
        - android-L
        - sys-img-x86-android-tv-l
        - add-on
        - extra
      licenses:
        - 'android-sdk-preview-license-52d11cd2'
        - 'android-sdk-license-.+'
        - 'google-gdk-license-.+'


For more flexibility, the licenses can also be referenced with regular expressions (using Tcl syntax as `expect` command is used to automatically respond to the interactive prompts).


### Pre-installed components

While the following components are preinstalled, the exact list may change without prior notice. To ensure the stability of your build environment, we recommend that you explicitly specify the required components for your project.

- platform-tools
- build-tools-21.1.1
- android-21
- sys-img-armeabi-v7a-android-21
- android-20
- sys-img-armeabi-v7a-android-wear-20
- android-19
- sys-img-armeabi-v7a-android-19
- android-18
- sys-img-armeabi-v7a-android-18
- android-17
- sys-img-armeabi-v7a-android-17
- android-16
- sys-img-armeabi-v7a-android-16
- android-15
- sys-img-armeabi-v7a-android-15
- android-10
- extra-android-support
- extra-google-google_play_services
- extra-google-m2repository
- extra-android-m2repository

### How to Create and Start an Emulator

**Warning:** At the moment, these steps are not fully supported by Travis CI Android builder.

If you feel adventurous, you may use the script [`/usr/local/bin/android-wait-for-emulator`](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/android-sdk/files/default/android-wait-for-emulator) and adapt your `.travis.yml` to make this emulator available for your tests. For example:

    # Emulator Management: Create, Start and Wait
    before_script:
      - echo no | android create avd --force -n test -t android-19 --abi armeabi-v7a
      - emulator -avd test -no-skin -no-audio -no-window &
      - android-wait-for-emulator
      - adb shell input keyevent 82 &


## Dependency Management

Travis CI Android builder assumes that your project is built with a JVM build tool like Maven or Gradle that will automatically pull down project dependencies before running tests without any effort on your side.

If your project is built with Ant or any other build tool that does not automatically handle dependences, you need to specify the exact command to run using `install:` key in your `.travis.yml`, for example:

    language: android
    install: ant deps

## Default Test Command for Maven

If your project has `pom.xml` file in the repository root but no `build.gradle`, Maven 3 will be used to build it. By default it will use

    mvn install -B

to run your test suite. This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide.

## Default Test Command for Gradle

If your project has `build.gradle` file in the repository root, Gradle will be used to build it. By default it will use

    gradle build connectedCheck

to run your test suite. If your project also includes the `gradlew` wrapper script in the repository root, Travis Android builder will try to use it instead. The default command will become:

    ./gradlew build connectedCheck

This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide.

### Caching

A peculiarity of dependency caching in Gradle means that to avoid uploading the cache after every build you need to add the following lines to your `.travis.yml`:

```
before_cache:
  - rm -f $HOME/.gradle/caches/modules-2/modules-2.lock
cache:
  directories:
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
```

## Default Test Command

If Travis CI could not detect Maven or Gradle files, Travis CI Android builder will try to use Ant to build your project. By default it will use

    ant debug install test

to run your test suite. This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide.

## Testing Against Multiple JDKs

As for any JVM language, it is also possible to [test against multiple JDKs](/user/languages/java/#Testing-Against-Multiple-JDKs).

## Build Matrix

For Android projects, `env` and `jdk` can be given as arrays to construct a build matrix.

## Examples

* [roboguice/roboguice](https://github.com/roboguice/roboguice/blob/master/.travis.yml) (Google Guice on Android)
* [ruboto/ruboto](https://github.com/ruboto/ruboto/blob/master/.travis.yml) (A platform for developing apps using JRuby on Android)
* [RxJava in Android Example Project](https://github.com/andrewhr/rxjava-android-example/blob/master/.travis.yml)
* [Gradle Example Project](https://github.com/pestrada/android-tdd-playground/blob/master/.travis.yml) (the wait for the emulator must be fixed)
* [Maven Example Project](https://github.com/embarkmobile/android-maven-example/blob/master/.travis.yml)
