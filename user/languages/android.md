---
title: Building an Android Project
layout: en

---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Android projects. Please make sure to read our [Tutorial](/user/tutorial/) and [general build configuration](/user/customizing-the-build/) guides first.

Android builds are not available on the macOS environment.



## CI Environment for Android Projects

### Overview

Travis CI environment provides a large set of build tools for JVM languages with [multiple JDKs, Ant, Gradle, Maven](/user/languages/java/#overview), [sbt](/user/languages/scala#projects-using-sbt) and [Leiningen](/user/languages/clojure).

Here is an example `.travis.yml` for an Android project without emulator configuration:

```yaml
dist: focal
language: java
jdk: openjdk11

env:
  global:
  # Android command line tools, check for updates here https://developer.android.com/studio/#command-tools
  - COMMAND_LINE_TOOLS_VERSION=7583922
  - ANDROID_HOME=$HOME/android-sdk
  # The build tools version used by your project
  - BUILD_TOOLS_VERSION=30.0.3
  # The target SDK version used by your project
  - TARGET_SDK_VERSION=31

before_cache:
  # Do not cache a few Gradle files/directories (see https://docs.travis-ci.com/user/languages/java/#caching)
  - rm -f  $HOME/.gradle/caches/modules-2/modules-2.lock
  - rm -fr $HOME/.gradle/caches/*/plugin-resolution/

cache:
  directories:
    # Android SDK
    - $HOME/android-cmdline-tools
    - $HOME/android-sdk

    # Gradle dependencies
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/

install:
  - mkdir -p $HOME/android-cmdline-tools
  # Download and unzip the Android command line tools (if not already there thanks to the cache mechanism)
  - if test ! -e $HOME/android-cmdline-tools/cmdline-tools.zip ; then curl "https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_LINE_TOOLS_VERSION}_latest.zip" > $HOME/android-cmdline-tools/cmdline-tools.zip ; fi
  - unzip -qq -n $HOME/android-cmdline-tools/cmdline-tools.zip -d $HOME/android-cmdline-tools
  - echo y | $HOME/android-cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=$HOME/android-sdk "platform-tools"
  - echo y | $HOME/android-cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=$HOME/android-sdk "build-tools;${BUILD_TOOLS_VERSION}"
  - echo y | $HOME/android-cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=$HOME/android-sdk "platforms;android-${TARGET_SDK_VERSION}"

script:
  - ./gradlew clean test assembleDebug
```
{: data-file=".travis.yml"}

### How to install Android SDK components

In order to install the latest SDK components you need to use the Android command line tools. The latest SDK components are no longer preinstalled.
In your `.travis.yml` you can define the download and unpacking in the `install` step, as illustrated in the following except:

```yaml
install:
  - mkdir -p $HOME/android-cmdline-tools
  # Download the Android command line tools (if not already there thanks to the cache mechanism)
  - if test ! -e $HOME/android-cmdline-tools/cmdline-tools.zip ; then curl "https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_LINE_TOOLS_VERSION}_latest.zip" > $HOME/android-cmdline-tools/cmdline-tools.zip ; fi
  # Unzip the Android command line tools
  - unzip -qq -n $HOME/android-cmdline-tools/cmdline-tools.zip -d $HOME/android-cmdline-tools
  # Confirm the license for each component
  - echo y | $HOME/android-cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=$HOME/android-sdk "platform-tools"
  - echo y | $HOME/android-cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=$HOME/android-sdk "build-tools;${BUILD_TOOLS_VERSION}"
  - echo y | $HOME/android-cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=$HOME/android-sdk "platforms;android-${TARGET_SDK_VERSION}"
```
{: data-file=".travis.yml"}

### How to Create and Start an Emulator

**Warning:** At the moment, these steps are not fully supported by Travis CI Android builder.

If you feel adventurous, you may use the script [`/usr/local/bin/android-wait-for-emulator`](https://github.com/travis-ci/travis-cookbooks/blob/precise-stable/ci_environment/android-sdk/files/default/android-wait-for-emulator) and adapt your `.travis.yml` to make this emulator available for your tests. For example:

```yaml
# Emulator Management: Create, Start and Wait
before_script:
  - echo no | android create avd --force -n test -t android-22 --abi armeabi-v7a -c 100M
  - emulator -avd test -no-audio -no-window &
  - android-wait-for-emulator
  - adb shell input keyevent 82 &
```
{: data-file=".travis.yml"}

## Dependency Management

Travis CI Android builder assumes that your project is built with a JVM build tool like Maven or Gradle that will automatically pull down project dependencies before running tests without any effort on your side.

If your project is built with Ant or any other build tool that does not automatically handle dependencies, you need to specify the exact command to run using `install:` key in your `.travis.yml`, for example:

```yaml
language: android
dist: focal
install: ant deps
```
{: data-file=".travis.yml"}

## Default Test Command for Maven

If your project has `pom.xml` file in the repository root but no `build.gradle`, Maven 3 will be used to build it. By default it will use

```bash
mvn install -B
```

to run your test suite. This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide.

## Default Test Command for Gradle

If your project has `build.gradle` file in the repository root, Gradle will be used to build it. By default it will use

```bash
gradle build connectedCheck
```

to run your test suite. If your project also includes the `gradlew` wrapper script in the repository root, Travis Android builder will try to use it instead. The default command will become:

```bash
./gradlew build connectedCheck
```

This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide.

### Caching

A peculiarity of dependency caching in Gradle means that to avoid uploading the cache after every build you need to add the following lines to your `.travis.yml`:

```yaml
before_cache:
  - rm -f  $HOME/.gradle/caches/modules-2/modules-2.lock
  - rm -fr $HOME/.gradle/caches/*/plugin-resolution/
cache:
  directories:
    # Android
    - $HOME/android-cmdline-tools
    - $HOME/android-sdk
    - $HOME/.android/build-cache

    # Gradle
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
```
{: data-file=".travis.yml"}

## Default Test Command

If Travis CI could not detect Maven or Gradle files, Travis CI Android builder will try to use Ant to build your project. By default it will use

```bash
ant debug install test
```

to run your test suite. This can be overridden as described in the [general build configuration](/user/customizing-the-build/) guide.

## Testing Against Multiple JDKs

As for any JVM language, it is also possible to [test against multiple JDKs](/user/languages/java/#testing-against-multiple-jdks).

## Build Matrix

For Android projects, `env` and `jdk` can be given as arrays to construct a build matrix.

## Examples

- [EventFahrplan/EventFahrplan](https://github.com/EventFahrplan/EventFahrplan/blob/master/.travis.yml)
- [roboguice/roboguice](https://github.com/roboguice/roboguice/blob/master/.travis.yml) (Google Guide on Android)
- [ruboto/ruboto](https://github.com/ruboto/ruboto/blob/master/.travis.yml) (A platform for developing apps using JRuby on Android)
- [RxJava in Android Example Project](https://github.com/andrewhr/rxjava-android-example/blob/master/.travis.yml)
- [Gradle Example Project](https://github.com/pestrada/android-tdd-playground/blob/master/.travis.yml)
- [Maven Example Project](https://github.com/embarkmobile/android-maven-example/blob/master/.travis.yml)
- [Ionic Cordova Example Project](https://github.com/samlsso/Calc/blob/master/.travis.yml)

## Build Config Reference

You can find more information on the build config format for [Android](https://config.travis-ci.com/ref/language/android) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).
