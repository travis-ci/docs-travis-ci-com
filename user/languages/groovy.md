---
title: Build a Groovy project
layout: en

---


<aside markdown="block" class="ataglance">

| Groovy                       | Default                                                                                                            |
|:-----------------------------|:-------------------------------------------------------------------------------------------------------------------|
| Default `install`            | [Gradle](#gradle-dependency-management), [Maven](#maven-dependency-management), [Ant](#ant-dependency-management ) |
| Default `script`             | [Gradle](#gradle-default-test-command), [Maven](#maven-default-test-command), [Ant](#ant-default-test-command)     |
| [Matrix keys](#build-matrix) | `env`,`jdk`                                                                                                        |
| Support                      | [Travis CI](mailto:support@travis-ci.com)                                                                          |

Minimal example:

```yaml
language: groovy
```
{: data-file=".travis.yml"}

</aside>

{{ site.data.snippets.linux_note }}

The rest of this guide covers configuring Groovy projects on Travis CI. If you're
new to Travis CI, please read our [Onboarding](/user/onboarding/) and
[General Build configuration](/user/customizing-the-build/) guides first.

Groovy builds are not available on the macOS environment.

## Overview

The Travis CI environment contains various versions of OpenJDK, Oracle JDK,
Gradle, Maven and Ant, along with reasonable defaults, so quite often you won't
have to configure anything beyond:

```yaml
language: groovy
```
{: data-file=".travis.yml"}

## Gradle Projects 

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

## Maven Projects 

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

## Ant Projects

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

## Test against Multiple JDKs

To test against multiple JDKs, use the `:jdk` key in `.travis.yml`. For example,
to test against Oracle JDK 8 and
OpenJDK 7:

```yaml
jdk:
  - oraclejdk8
  - openjdk7
```
{: data-file=".travis.yml"}

### Use Java 10 and higher

For testing with OpenJDK and OracleJDK 10 and up, see
[Java documentation](/user/languages/java/#using-java-10-and-later).

## Build Config Reference

You can find more information on the build config format for [Groovy](https://config.travis-ci.com/ref/language/groovy) in our [Travis CI Build Config Reference](https://config.travis-ci.com/).
