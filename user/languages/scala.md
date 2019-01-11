---
title: Building a Scala project
layout: en

---

### What This Guide Covers

<aside markdown="block" class="ataglance">

| Scala                        | Default                                                                                                                                                                                                                 |
|:-----------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Default `install`            | [sbt](#sbt-dependency-management), [Gradle](/user/languages/java/#gradle-dependency-management), [Maven](/user/languages/java/#maven-dependency-management), [Ant](/user/languages/java/#ant-dependency-management)     |
| Default `script`             | [sbt](#sbt-default-script-command), [Gradle](/user/languages/java/#gradle-default-script-command), [Maven](/user/languages/java/#maven-default-script-command), [Ant](/user/languages/java/#ant-default-script-command) |
| [Matrix keys](#build-matrix) | `scala`,`jdk`, `env`                                                                                                                                                                                                    |
| Support                      | [Travis CI](mailto:support@travis-ci.com)                                                                                                                                                                               |

Minimal example:

```yaml
  language: scala
```
</aside>

{{ site.data.snippets.trusty_note_no_osx }}

Scala builds are not available on the macOS environment.

The rest of this guide covers configuring Scala projects in Travis CI. If you're
new to Travis CI please read our [Tutorial](/user/tutorial/) and
[build configuration](/user/customizing-the-build/) guides first.

## Overview

Travis CI environment provides a large set of build tools for JVM languages with
[multiple JDKs, Ant, Gradle, Maven](/user/languages/java/#overview) and
[sbt](http://www.scala-sbt.org).

## Specifying Scala versions

To specify Scala versions in your build:

```yaml
language: scala
scala:
   - 2.9.3
   - 2.10.6
   - 2.11.11
   - 2.12.2
```
{: data-file=".travis.yml"}

On Ubuntu Precise, to use Scala 2.12.X you need to enable Oracle JDK 8 by adding `jdk: oraclejdk8` to your `.travis.yml`.

## Projects using sbt

If your project has a `project` directory or `build.sbt` file in the repository
root, the Travis CI uses `sbt` to build it.

Thanks to [paulp/sbt-extras](https://github.com/paulp/sbt-extras) the sbt
version of your project is dynamically detected and used.

### sbt Dependency Management

Travis CI automatically pulls down `sbt` dependencies before running
tests during the `script` phase of your build.

### sbt Default Script Command

The default `script` command is:

```bash
sbt ++$TRAVIS_SCALA_VERSION test
```

to run your test suite.

To use a different `script` command, customize the
[build step](/user/job-lifecycle/#customizing-the-build-phase).

### Custom sbt Arguments

You can override [sbt and JVM options](https://github.com/paulp/sbt-extras#sbt--h)
by passing extra arguments to `sbt`.

For example, to run `compile` and `test` with different JVM parameters:

```yaml
script:
  - sbt -jvm-opts travis/jvmopts.compile ... compile
  - sbt -jvm-opts travis/jvmopts.test ... test
```
{: data-file=".travis.yml"}

You can also specify [extra
arguments](https://github.com/paulp/sbt-extras#sbt--h) to be passed to the
default build script with the `sbt_args` key in your `.travis.yml`.

For example

```yaml
sbt_args: -no-colors -J-Xss2m
```
{: data-file=".travis.yml"}

will generate

```bash
script: sbt -no-colors -J-Xss2m ++$TRAVIS_SCALA_VERSION test
```

## Projects Using Gradle, Maven or Ant

If your project is not configured for sbt, the build process behaves like a
typical [Java Project](/user/languages/java).

## Testing Against Multiple JDKs

As for any JVM language, it is also possible to [test against multiple
JDKs](/user/languages/java/#testing-against-multiple-jdks).

### Using Java 10 and Up

For testing with OpenJDK and OracleJDK 10 and up, see
[Java documentation](/user/languages/java/#using-java-10-and-later).

## Build Matrix

For Scala projects, `env`, `scala`, and `jdk` can be given as arrays
to construct a build matrix.

## Environment Variable

The version of Scala a job is using is available as:

```
TRAVIS_SCALA_VERSION
```

## Examples

- [twitter/scalding](https://github.com/twitter/scalding/blob/master/.travis.yml)
- [twitter/summingbird](https://github.com/twitter/summingbird/blob/master/.travis.yml)
- [novus/salat](https://github.com/novus/salat/blob/master/.travis.yml)
- [scalaz/scalaz](https://github.com/scalaz/scalaz/blob/scalaz-seven/.travis.yml)
- [spray/spray](https://github.com/spray/spray/blob/master/.travis.yml) (using a custom [`.jvmopts`](https://github.com/spray/spray/blob/master/.jvmopts) to override Travis CI defaults)
