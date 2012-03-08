---
title: Building a Clojure project
layout: en
permalink: clojure/
---

### What This Guide Covers

This guide covers build environment and configuration topics specific to Clojure projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.

## CI environment for Clojure Projects

Travis VMs currently provide

* 32-bit OpenJDK 6
* Standalone [Leiningen](https://github.com/technomancy/leiningen) 1.7.0.

Clojure projects on travis-ci.org assume you use [Leiningen](https://github.com/technomancy/leiningen) by default.

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

    :dev-dependencies [[midje "1.3.1" :exclusions [org.clojure/clojure]]
                       [lein-midje "1.0.7"]])

For real world example, see [Knockbox](https://github.com/reiddraper/knockbox).

### Precompiling Java sources In Your Clojure Projects

If you need to AOT compile Java sources, for example, it is possible to override this in your `.travis.yml`:

    install: lein javac, deps

See [general build configuration guide](/docs/user/build-configuration/) to learn more.

## Testing Against Multiple Versions of Clojure

Leiningen has an excellent plugin called [lein-multi](https://github.com/maravillas/lein-multi) that lets you effortlessly test against multiple versions of Clojure (including pre-release versions like 1.4.0-beta1). Because leiningen can run tests against any version of Clojure (not necessary the same version as Leiningen itself uses), there is no need for runtime switchers (like RVM) for Clojure.

To use lein-multi on travis-ci.org, add it to `:plugins` in project.clj and override `script:` to run `lein multi test` instead of default `lein test`:

    language: clojure
    script: lein multi test

For a real world example, see [Monger](https://github.com/michaelklishin/monger).

## Examples

* [leiningen's .travis.yml](https://github.com/technomancy/leiningen/blob/stable/.travis.yml)
* [monger's .travis.yml](https://github.com/michaelklishin/monger/blob/stable/.travis.yml)
* [langohr's .travis.yml](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
* [momentum's .travis.yml](https://github.com/carllerche/momentum/blob/master/.travis.yml)
* [Knockbox's .travis.yml](https://github.com/reiddraper/knockbox/blob/master/.travis.yml)
* [Sumo's .travis.yml](https://github.com/reiddraper/sumo/blob/master/.travis.yml)
