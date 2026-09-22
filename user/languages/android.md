---
title: Build an Android Project
layout: en

---

This guide covers the build environment and configuration topics specific to Android projects targeting API level 30 and above. Please review our [Onboarding](/user/onboarding/) and [General Build Configuration](/user/customizing-the-build/) guides before proceeding.

> **Note:** Android builds are not available on macOS environments.

---

## CI Environment for Android Projects

Android builds are supported on our Bionic, Focal, and Jammy build environments. Specify one of these in your `.travis.yml`:

```yaml
language: android
dist: focal  # Options: focal, jammy, or bionic
```

Travis CI provides a full suite of tools for JVM-based projects, including multiple JDKs, Ant, Gradle, Maven, sbt, and Leiningen.

---

## Sample Configuration for API Level 30+

Below is an example `.travis.yml` configured for Android projects targeting API level 30 and above. Notice that only the required extras (listed later) are included:

```yaml
language: android
dist: focal
android:
  components:
    # Uncomment these if you need the latest SDK tools:
    # - tools
    # - platform-tools

    # Build Tools for API 30
    - build-tools;30.0.0

    # Android SDK Platform for API 30
    - platforms;android-30

    # Android system image for API 30 with Google APIs (x86_64)
    - system-images;android-30;google_apis;x86_64 

    # Required extras
    - extras;android;m2repository         # Android Support Repository (v47.0.0)
    - extras;google;auto                  # Android Auto Desktop Head Unit Emulator (v2.0)
    - extras;google;google_play_services  # Google Play services (v49)
    - extras;google;instantapps           # Google Play Instant Development SDK (v1.9.0)
    - extras;google;m2repository          # Google Repository (v58)
    - extras;google;market_apk_expansion  # Google Play APK Expansion library (v1)
    - extras;google;market_licensing      # Google Play Licensing Library (v1)
    - extras;google;simulators            # Android Auto API Simulators (v1)
    - extras;google;webdriver             # Google WebDriver
```

---

## Installing Android SDK Components

In your `.travis.yml`, specify the exact SDK components to install:

```yaml
language: android
dist: focal
android:
  components:
    - build-tools;30.0.0
    - platforms;android-30
    - system-images;android-30;google_apis;x86_64 
    - extras;android;m2repository
    - extras;google;auto
    - extras;google;google_play_services
    - extras;google;instantapps
    - extras;google;m2repository
    - extras;google;market_apk_expansion
    - extras;google;market_licensing
    - extras;google;simulators
    - extras;google;webdriver
```

> **Tip:** Run `sdkmanager --list` on your local machine to view all available components and their exact names.

---

## Dealing with Licenses

Travis CI accepts requested licenses by default. To explicitly whitelist licenses, add the `licenses` key:

```yaml
language: android
dist: focal
android:
  components:
    - build-tools;30.0.0
    - platforms;android-30
    - extras;android;m2repository
    - extras;google;auto
    - extras;google;google_play_services
    - extras;google;instantapps
    - extras;google;m2repository
    - extras;google;market_apk_expansion
    - extras;google;market_licensing
    - extras;google;simulators
    - extras;google;webdriver
  licenses:
    - 'android-sdk-preview-license-52d11cd2'
    - 'android-sdk-license-.+'
    - 'google-gdk-license-.+'
```

Licenses can also be referenced using regular expressions.

---

## Pre-installed Components

The following components are pre-installed in the Travis CI Android build environments. However, for stable builds, explicitly list all required components:

- `tools`
- `platform-tools`
- `build-tools;30.0.0`
- `platforms;android-30`
- `extras;android;m2repository`
- `extras;google;m2repository`
- `extras;google;google_play_services`
---

## Creating and Starting an Emulator

If your tests require an emulator, use `avdmanager` to create an AVD and start the emulator:

```yaml
before_script:
  # Create an AVD named "test" using a system image for API 30
  - echo no | avdmanager create avd -n test -k "system-images;android-30;google_apis;x86_64" --force
  # Start the emulator without audio or window
  - emulator -avd test -no-audio -no-window &
  # Unlock the emulator screen
  - adb shell input keyevent 82 &
```

Adjust sleep durations as necessary.

---

## Dependency Management

Travis CI assumes that your project uses a JVM build tool (e.g., Gradle, Maven) that automatically manages dependencies.  
For projects using Ant or other tools, specify your dependency command:

```yaml
language: android
dist: focal
install: ant deps
```

---

## Default Test Commands

### Maven Projects

If your repository contains a `pom.xml` (and no `build.gradle`), Maven 3 is used with:

```bash
mvn install -B
```

### Gradle Projects

For repositories with a `build.gradle` file, Travis runs:

```bash
gradle build connectedCheck
```

If a Gradle wrapper (`gradlew`) exists, it uses:

```bash
./gradlew build connectedCheck
```

### Ant Projects

If neither Maven nor Gradle files are found, Travis defaults to:

```bash
ant debug install test
```

Override these defaults using our [General Build Configuration](/user/customizing-the-build/) guide if needed.

---

## Caching

To optimize builds and avoid uploading cache after every build, add:

```yaml
before_cache:
  - rm -f $HOME/.gradle/caches/modules-2/modules-2.lock
  - rm -fr $HOME/.gradle/caches/*/plugin-resolution/
cache:
  directories:
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
    - $HOME/.android/build-cache
```

---

## Testing Against Multiple JDKs

You can test against multiple JDKs as described in our [Testing Against Multiple JDKs](/user/languages/java/#testing-against-multiple-jdks) guide.

---

## Build Matrix

For Android projects, you can create a build matrix by providing arrays for both `env` and `jdk`.

---

## Building on Different Environments

Android projects are supported on `dist: bionic`, `dist: focal`, and `dist: jammy`. To build on a different environment, install the necessary packages and tools. For example:

```yaml
os: linux
language: java
jdk: openjdk17

env:
  global:
    - ANDROID_HOME=$HOME/travis-tools/android
    - ANDROID_SDK_ROOT=$HOME/travis-tools/android

before_install:
  # Set up the Android SDK command line tools
  - mkdir -p $ANDROID_HOME && mkdir $HOME/.android && touch $HOME/.android/repositories.cfg
  - cd $ANDROID_HOME && wget -q "https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip" -O commandlinetools.zip
  - unzip -q commandlinetools.zip && mkdir -p cmdline-tools && mv cmdline-tools/* cmdline-tools/tools
  - cd $TRAVIS_BUILD_DIR

  # Update PATH for command line tools, emulator, and platform-tools
  - export PATH=$ANDROID_HOME/cmdline-tools/tools/bin/:$PATH
  - export PATH=$ANDROID_HOME/emulator/:$PATH
  - export PATH=$ANDROID_HOME/platform-tools/:$PATH

install:
  # Install required SDK components
  - sdkmanager --sdk_root=$ANDROID_HOME --list | awk '/Installed/{flag=1; next} /Available/{flag=0} flag'
  - yes | sdkmanager --sdk_root=$ANDROID_HOME --install "platform-tools" "platforms;android-30" "build-tools;30.0.0" "emulator" "system-images;android-30;google_apis;x86_64"
  - sdkmanager --list --sdk_root=$ANDROID_HOME | awk '/Installed/{flag=1; next} /Available/{flag=0} flag'
  # Create an AVD for testing
  - echo "no" | avdmanager create avd --verbose --force --name "my_android_30" --package "system-images;android-30;google_apis;x86_64" --tag "google_apis" --abi "x86_64"
  - sudo chmod -R 777 /dev/kvm
  # Start the emulator in the background
  - adb kill-server && adb start-server &
  - sleep 15
  - emulator @my_android_30 -no-audio -no-window &
  - sleep 60

script:
  - sdkmanager --list --sdk_root=$ANDROID_HOME | awk '/Installed/{flag=1; next} /Available/{flag=0} flag'
  - adb devices
  # ... additional build/test commands
```

---

## Examples

Here are some example projects that use Travis CI with Android:

- [roboguice/roboguice](https://github.com/roboguice/roboguice/blob/master/.travis.yml)
- [ruboto/ruboto](https://github.com/ruboto/ruboto/blob/master/.travis.yml)
- [RxJava Android Example Project](https://github.com/andrewhr/rxjava-android-example/blob/master/.travis.yml)
- [Gradle Example Project](https://github.com/pestrada/android-tdd-playground/blob/master/.travis.yml)
- [Maven Example Project](https://github.com/embarkmobile/android-maven-example/blob/master/.travis.yml)
- [Ionic Cordova Example Project](https://github.com/samlsso/Calc/blob/master/.travis.yml)

---

## Build Config Reference

For more details, see the [Travis CI Build Config Reference for Android](https://config.travis-ci.com/ref/language/android).
