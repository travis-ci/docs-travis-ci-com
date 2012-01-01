---
title: Building a Clojure project
kind: content
---

## What This Guide Covers

This guide covers build environment and configuration topics specific to Clojure projects. Please make sure to read our [Getting Started](/docs/user/getting-started/) and [general build configuration](/docs/user/build-configuration/) guides first.


## Choosing Clojure versions to test against

Travis VMs currently provide

* 32-bit OpenJDK 6
* Standalone [Leiningen](https://github.com/technomancy/leiningen) 1.6.x.

If you want to test your project against multiple Clojure versions, use the excellent [lein multi](https://github.com/maravillas/lein-multi) plugin.
Because leiningen can run tests against any version of Clojure (not necessary the one available as `clojure` in the PATH), there is no need for runtime
switchers (like RVM) for Clojure.


## Default Test Script

Clojure projects on travis-ci.org are managed with [Leiningen](https://github.com/technomancy/leiningen). Naturally, the default command Travis CI will use to
run your project test suite is

    lein test

Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: clojure


### Using Midje on travis-ci.org

If your project uses [Midje](https://github.com/marick/Midje), make sure [lein-midje](https://github.com/marick/Midje/wiki/Lein-midje) is on your `project.clj` development dependencies list and override `script:` in `.travis.yml` to
run Midje task:

    script: lein midje


For real world example, see [Knockbox](https://github.com/reiddraper/knockbox).



## Dependency Management

the default command Travis CI will use
to install your project dependencies is

    lein deps

This will install [dependencies as listed in the project.clj file](https://github.com/technomancy/leiningen/blob/master/sample.project.clj).


### Precompiling Java sources

If you need to AOT compile Java sources, for example, it is possible to override this in your `.travis.yml`:

    install: lein javac, deps

See [general build configuration guide](/docs/user/build-configuration/) to learn more.


### Examples

 * [leiningen's .travis.yml](https://github.com/technomancy/leiningen/blob/stable/.travis.yml)
 * [langohr's .travis.yml](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
 * [momentum's .travis.yml](https://github.com/carllerche/momentum/blob/master/.travis.yml)
 * [Knockbox's .travis.yml](https://github.com/reiddraper/knockbox/blob/master/.travis.yml)
 * [Sumo's .travis.yml](https://github.com/reiddraper/sumo/blob/master/.travis.yml)
 
