---
title: Building a Java project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| Java                         | Default                                                                                                              |
|:-----------------------------|:---------------------------------------------------------------------------------------------------------------------|
| Default `install`            | [Gradle](#Gradle-Dependency-Management), [Maven](#Maven-Dependency-Management), [Ant](#Ant-Dependency-Management)    |
| Default `script`             | [Gradle](#Gradle-Default-Script-Command), [Maven](#Maven-Default-Script-Command), [Ant](#Ant-Default-Script-Command) |
| [Matrix keys](#Build-Matrix) | `jdk`, `env`                                                                                                         |
| Support                      | [Travis CI](mailto:support@travis-ci.com)                                                                            |

Minimal example:

```yaml
  language: java
```
</aside>

{{ site.data.snippets.trusty_note }}

The rest of this guide covers configuring Java projects in Travis CI. If you're
new to Travis CI please read our [Getting Started](/user/getting-started/) and
[build configuration](/user/customizing-the-build/) guides first.

## Overview

The Travis CI environment contains various versions of OpenJDK, Oracle JDK,
Gradle, Maven and Ant.

To use the Java environment, add the following to your `.travis.yml`:

```yaml
language: java
```
{: data-file=".travis.yml"}

## Projects Using Maven

### Maven Dependency Management

Before running the build, Travis CI installs dependencies:

```bash
mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
```

or if your project uses the `mvnw` wrapper script:

```bash
./mvnw install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
```

> Note that the Travis CI build lifecycle and the Maven build lifecycle use similar
terminology for different build phases. For example, `install` in a Travis CI
build comes much earlier than `install` in the Maven build lifecycle. More details
can be found about the [Travis Build Lifecycle](/user/customizing-the-build/#The-Build-Lifecycle)
and the [Maven Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html).

### Maven Default Script Command

If your project has `pom.xml` file in the repository root but no `build.gradle`,
Travis CI builds your project with Maven 3:

```bash
mvn test -B
```

If your project also includes the `mvnw` wrapper script in the repository root,
Travis CI uses that instead:

```bash
./mvnw test -B
```

> The default command does not generate JavaDoc (`-Dmaven.javadoc.skip=true`).

To use a different `script` command, customize the [build step](/user/customizing-the-build/#Customizing-the-Build-Step).

## Projects Using Gradle

### Gradle Dependency Management

Before running the build, Travis CI installs dependencies:

```bash
gradle assemble
```

or

```bash
./gradlew assemble
```

To use a different `install` command, customize the [installation step](/user/customizing-the-build/#Customizing-the-Installation-Step).

### Gradle Default Script Command

If your project contains a `build.gradle` file in the repository root, Travis CI
builds your project with Gradle:

```bash
gradle check
```

If your project also includes the `gradlew` wrapper script in the repository
root, Travis CI uses that wrapper instead:

```bash
./gradlew check
```

To use a different `script` command, customize the [build step](/user/customizing-the-build/#Customizing-the-Build-Step).

### Caching

A peculiarity of dependency caching in Gradle means that to avoid uploading the
cache after every build you need to add the following lines to your
`.travis.yml`:

```yaml
before_cache:
  - rm -f  $HOME/.gradle/caches/modules-2/modules-2.lock
  - rm -fr $HOME/.gradle/caches/*/plugin-resolution/
cache:
  directories:
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
```
{: data-file=".travis.yml"}

> Note that if you use Gradle with `sudo` (i.e. `sudo ./gradlew assemble`), the caching configuration above will have no effect, since the depencencies will be in `/root/.gradle` which the `travis` user account does not have write access to.

### Gradle daemon is disabled by default

[As recommended](https://docs.gradle.org/current/userguide/gradle_daemon.html)
by the Gradle team, the Gradle daemon is disabled by default.
If you would like to run `gradle` with daemon, add `--daemon` to the invocation.

## Projects Using Ant

### Ant Dependency Management

Because there is no single standard way of installing project dependencies with
Ant, you need to specify the exact command to run using `install:` key in your
`.travis.yml`, for example:

```yaml
language: java
install: ant deps
```
{: data-file=".travis.yml"}

### Ant Default Script Command

If Travis CI does not detect Maven or Gradle files it runs Ant:

```bash
ant test
```

To use a different `script` command, customize the [build step](/user/customizing-the-build/#Customizing-the-Build-Step).

## Testing Against Multiple JDKs

To test against multiple JDKs, use the `jdk:` key in `.travis.yml`. For example,
to test against Oracle JDKs 8 and 9, as well as OpenJDK 8:

```yaml
jdk:
  - oraclejdk8
  - oraclejdk9
  - openjdk8
```
{: data-file=".travis.yml"}

> Note that testing against multiple Java versions is not supported on OS X. See
the [OS X Build Environment](/user/reference/osx/#JDK-and-OS-X) for more
details.

The list of available JVMs for different dists are at

  * [JDKs installed for **Trusty**](/user/reference/trusty/#jvm-clojure-groovy-java-scala-images)
  * [JDKs installed for **Precise**](/user/reference/precise/#jvm-clojure-groovy-java-scala-vm-images)

### Switching JDKs (Java 8 and below) Within One Job

If your build needs to switch JDKs (Java 8 and below) during a job, you can do so with
`jdk_switcher use …`.

```yaml
script:
  - jdk_switcher use oraclejdk8
  - # do stuff with Java 8
  - jdk_switcher use openjdk8
  - # do stuff with open Java 8
```
{: data-file=".travis.yml"}

Use of `jdk_switcher` also updates `$JAVA_HOME` appropriately.

### Updating Oracle JDK 8 to a recent release

Your repository may require a newer release of Oracle JDK than the pre-installed
version.
(You can consult [the list of published Oracle JDK packages](https://launchpad.net/~webupd8team/+archive/ubuntu/java).)

The following example will use the latest Oracle JDK 8:

```yaml
sudo: false
addons:
  apt:
    packages:
      - oracle-java8-installer
```
{: data-file=".travis.yml"}

## Using Java 10 and later

OracleJDK 10 and later are supported on Linux, and
OpenJDK 10 and later are supported on Linux and macOS using
[`install-jdk.sh`](https://github.com/sormuras/bach#install-jdksh).

```yaml
jdk:
  - oraclejdk8
  - oraclejdk10
  - oraclejdk-ea
  - openjdk10
  - openjdk11
```
{: data-file=".travis.yml"}

### Switching JDKs (to Java 10 and up) Within One Job

If your build needs to switch JDKs (Java 8 and up) during a job, you can do so with
`install-jdk.sh`.

```yaml
jdk: openjdk10
script:
  - jdk_switcher use openjdk10
  - # do stuff with OpenJDK 10
  - export JAVA_HOME=$HOME/openjdk11
  - $TRAVIS_BUILD_DIR/install-jdk.sh --install openjdk11 --target $JAVA_HOME
  - # do stuff with open OpenJDK 11
```
{: data-file=".travis.yml"}

## Build Matrix

For Java projects, `env` and `jdk` can be given as arrays
to construct a build matrix.

## Examples

- [JRuby](https://github.com/jruby/jruby/blob/master/.travis.yml)
- [Riak Java client](https://github.com/basho/riak-java-client/blob/master/.travis.yml)
- [Cucumber JVM](https://github.com/cucumber/cucumber-jvm/blob/master/.travis.yml)
- [Symfony 2 Eclipse plugin](https://github.com/pulse00/Symfony-2-Eclipse-Plugin/blob/master/.travis.yml)
- [RESThub](https://github.com/resthub/resthub-spring-stack/blob/master/.travis.yml)
- [Joni](https://github.com/jruby/joni/blob/master/.travis.yml), JRuby's regular expression implementation
