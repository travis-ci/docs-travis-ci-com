---
title: Building a Scala project
kind: content
---

## What This Guide Covers

This guide covers build environment and configuration topics specific to Scala projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.


## Choosing Scala versions to test against

Travis Scala VMs provide SBT 0.11.x and OpenJDK 6. Thanks to SBT 0.11.x ability to perform actions against multiple Scala versions,
it is possible to test your projects against Both Scala 2.8.x and 2.9.x.
To specify Scala versions you want your project to be tested against, use the `scala` key:

    language: scala
    scala:
       - 2.8.2
       - 2.9.1



## Default Test Command

Travis CI by default assumes your project is built using SBT. The exact command Scala builder
will use by default is

    sbt +$SCALA_VERSION test

if your project has `project` directory or `build.sbt` file in the repository root. If this is not the case, Scala builder will fall back to

    mvn test




## Dependency Management

Because Scala builder on travis-ci.org assumes SBT dependency management is used by default, it naturally will pull down project
dependencies before running tests without any effort on your side.



## Examples

 * [twitter/scalding](https://github.com/twitter/scalding/blob/master/.travis.yml)
 * [gildegoma/scalatra](https://github.com/gildegoma/scalatra/blob/add-travis-ci/.travis.yml)
 * [gildegoma/salat](https://github.com/gildegoma/salat/blob/add-travis-ci/.travis.yml)
