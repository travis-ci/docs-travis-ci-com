---
title: Building a Groovy project
layout: en

---

## What This Guide Covers

<aside markdown="block" class="ataglance">

| Groovy                       | Default                                                                                                           |
|:-----------------------------|:------------------------------------------------------------------------------------------------------------------|
| Default `install`            | [Gradle](#Gradle-Dependency-Management), [Maven](#Maven-Dependency-Management), [Ant](#Ant-Dependency-Management) |
| Default `script`             | [Gradle](#Gradle-Default-Test-Command), [Maven](#Maven-Default-Test-Command), [Ant](#Ant-Default-Test-Command)    |
| [Matrix keys](#Build-Matrix) | `env`,`jdk`                                                                                                       |
| Support                      | [Travis CI](mailto:support@travis-ci.com)                                                                         |

Minimal example:

```yaml
language: groovy
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.trusty_note_no_osx }}

The rest of this guide covers configuring Groovy projects on Travis CI. If you're
new to Travis CI please read our [Tutorial](/user/tutorial/) and
[build configuration](/user/customizing-the-build/) guides first.

Groovy builds are not available on the OS X environment.

## Overview

The Travis CI environment contains various versions of OpenJDK, Oracle JDK,
Gradle, Maven and Ant, along with reasonable defaults, so quite often you won't
have to configure anything beyond:

```yaml
language: groovy
```
{: data-file=".travis.yml"}

## Projects Using Gradle

### Gradle Dependency Management

If your project has `build.gradle` file in the repository root, Travis CI runs:

```bash
gradle assemble
```

to install your project's dependencies.

### Gradle Default Test Command

If your project has `build.gradle` file in the repository root, Travis CI runs:

```bash
gradle check
```

### Gradle Caching

A peculiarity of dependency caching in Gradle means that to avoid uploading the
cache after every build you need to add the following lines to your
`.travis.yml`:

```yaml
before_cache:
  - rm -f $HOME/.gradle/caches/modules-2/modules-2.lock
cache:
  directories:
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
```
{: data-file=".travis.yml"}

### Gradle daemon is disabled by default

[As recommended](https://docs.gradle.org/current/userguide/gradle_daemon.html) by the Gradle team,
the Gradle daemon is disabled by default.
If you would like to run `gradle` with daemon, add `--daemon` to the invocation.

## Projects Using Maven

### Maven Dependency Management

If your project has `pom.xml` file in the repository root and does not have a
`build.gradle`, Travis CI uses Maven 3 to install your project's dependencies:

```bash
mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
```

### Maven Default Test Command

If your project has `pom.xml` file in the repository root and does not have a
`build.gradle`, Travis CI uses Maven 3 to run your build script:

```bash
mvn test -B
```

## Projects Using Ant

### Ant Default Test Command

If Groovy project does not have Gradle or Maven configuration files, Travis CI
uses Ant to build your project:

```bash
ant test
```

### Ant Dependency Management

Because there is no single standard way of installing project dependencies with
Ant you need to specify a custom command using the `install:` key in your
`.travis.yml`:

```yaml
language: groovy
install: ant deps
```
{: data-file=".travis.yml"}

## Testing Against Multiple JDKs

To test against multiple JDKs, use the `:jdk` key in `.travis.yml`. For example,
to test against Oracle JDK 8 and
OpenJDK 7:

```yaml
jdk:
  - oraclejdk8
  - openjdk7
```
{: data-file=".travis.yml"}

### Using Java 10 and Up

For testing with OpenJDK and OracleJDK 10 and up, see
[Java documentation](/user/languages/java/#using-java-10-and-later).

## Build Matrix

For Groovy projects, `env` and `jdk` can be given as arrays
to construct a build matrix.
