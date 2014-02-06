---
title: Building a Clojure project
layout: en
permalink: clojure/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Clojure projects. Please make sure to read our [Getting Started](/user/getting-started/) and [general build configuration](/user/build-configuration/) guides first.

## CI environment for Clojure Projects

Travis VMs currently provide

* 32-bit OpenJDK 7, OpenJDK 6, Oracle JDK 7
* Standalone [Leiningen](http://leiningen.org) 1.7.x.
* Standalone [Leiningen 2.0.0](https://github.com/technomancy/leiningen/wiki/Upgrading) (new previews are provisioned within a couple of days after release).
* Maven 3

Clojure projects on travis-ci.org assume you use [Leiningen](https://github.com/technomancy/leiningen) by default.

## Dependency Management

If you use Leiningen, it will automatically install any dependencies you need
as long as they are listed in the `project.clj` file.

### Alternate Install Step

If you need to perform special tasks before your tests can run, you should set up the proper `:hooks` in project.clj. If for some reason you can't use hooks, it is possible to override the install step in your `.travis.yml`. For example if you use the [clojure-protobuf](https://github.com/flatland/clojure-protobuf) library:

    install: lein protobuf install

See [general build configuration guide](/user/build-configuration/) to learn more.



## Default Test Script

Because Clojure projects on travis-ci.org assume [Leiningen](https://github.com/technomancy/leiningen) by default, naturally, the default command Travis CI will use to
run your project test suite is

    lein test

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: clojure

### Using Midje on travis-ci.org

If your project uses [Midje](https://github.com/marick/Midje), make sure [lein-midje](https://github.com/marick/Midje/wiki/Lein-midje) is on your `project.clj` development dependencies list and override `script:` in `.travis.yml` to run Midje task:

    script: lein midje

Please note that for projects that only support Clojure 1.3.0 and later versions, you may need to exclude transient `org.clojure/clojure` for Midje in project.clj:

    :dev-dependencies [[midje "1.4.0" :exclusions [org.clojure/clojure]]
                       [lein-midje "1.0.10"]])

For real world example, see [Knockbox](https://github.com/reiddraper/knockbox).


## Using Leiningen 2.0 (Preview)

Leiningen 2.0 (preview) is provided side by side with 1.7. To use it, specify `lein` key in `.travis.yml`:

    lein: lein2

In case you need to use `lein` binary in `before_script`, `install:`, `script:` commands and so on, use `lein2`:

    before_install:
      - lein2 bootstrap

Task chaining requires using the `do` task as of Leiningen 2.0 Preview 7:

    script: lein2 do javac, test


## Testing Against Multiple JDKs

To test against multiple JDKs, use the `:jdk` key in `.travis.yml`. For example, to test against Oracle JDK 7 (which is newer than OpenJDK 7 on Travis CI) and OpenJDK 6:

    jdk:
      - oraclejdk7
      - openjdk6

To test against OpenJDK 7 and Oracle JDK 7:

    jdk:
      - openjdk7
      - oraclejdk7

Travis CI provides OpenJDK 7, OpenJDK 6 and Oracle JDK 7. Sun JDK 6 is not provided and because it is EOL in November 2012,
will not be provided.

JDK 7 is backwards compatible, we think it's time for all projects to start testing against JDK 7 first and JDK 6 if resources permit.

### Examples

 * [Monger](https://github.com/michaelklishin/monger/blob/master/.travis.yml)
 * [Welle](https://github.com/michaelklishin/welle/blob/master/.travis.yml)
 * [Langohr](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
 * [Neocons](https://github.com/michaelklishin/neocons/blob/master/.travis.yml)


## Testing Against Multiple Versions of Clojure

### With Leiningen 1

Leiningen has an excellent plugin called [lein-multi](https://github.com/maravillas/lein-multi) that lets you effortlessly test against multiple versions of 
Clojure (for example, 1.3, 1.4 and alphas/betas/snapshots of the most recent development version). Because leiningen can run tests against any version of Clojure (not necessary the same version as Leiningen itself uses),
there is no need for runtime switchers (like RVM) for Clojure.

To use lein-multi on travis-ci.org, add it to `:plugins` in project.clj (note, this feature is only available starting with Leiningen 1.7.0) and
override `script:` to run `lein multi test` instead of default `lein test`:

    language: clojure
    script: lein multi test

For a real world example, see [Monger](https://github.com/michaelklishin/monger).


### With Leiningen 2

Leiningen 2 has a core feature that replaces `lein-multi`: [Profiles](https://github.com/technomancy/leiningen/blob/master/doc/TUTORIAL.md). To run your tests against
multiple profiles (and thus, multiple dependency sets or Clojure versions), use `lein2 with-profile` command like so:


    lein: lein2
    script: lein2 with-profile dev:1.4 test

where `dev:1.4` is a colon-separated list of profiles to run `test` task against. Use `lein2 profiles` to list your project's profiles
and `lein2 help with-profile` to learn more about the `with-profiles` task.

For a real world example, see [Neocons](https://github.com/michaelklishin/neocons).


## Build Matrix

For Clojure projects, `env`, `lein`, and `jdk` can be given as arrays
to construct a build matrix.

## Examples

* [leiningen's .travis.yml](https://github.com/technomancy/leiningen/blob/stable/.travis.yml)
* [monger's .travis.yml](https://github.com/michaelklishin/monger/blob/master/.travis.yml)
* [welle's .travis.yml](https://github.com/michaelklishin/welle/blob/master/.travis.yml)
* [langohr's .travis.yml](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
* [neocons' .travis.yml](https://github.com/michaelklishin/neocons/blob/master/.travis.yml)
* [momentum's .travis.yml](https://github.com/momentumclj/momentum/blob/master/.travis.yml)
* [Knockbox's .travis.yml](https://github.com/reiddraper/knockbox/blob/master/.travis.yml)
* [Sumo's .travis.yml](https://github.com/reiddraper/sumo/blob/master/.travis.yml)
