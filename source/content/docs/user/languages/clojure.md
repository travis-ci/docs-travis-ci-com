---
title: Building a Clojure project
kind: content
---

### Provided tools

Travis VMs provide

* 32-bit OpenJDK 6
* [Leiningen](https://github.com/technomancy/leiningen) 1.6.x.


### Setting up a Clojure project on travis-ci.org

Clojure projects on travis-ci.org are managed with [Leiningen](https://github.com/technomancy/leiningen). Typical build then has two operations:

 * lein deps
 * lein test

The first command installs the project's [dependencies as listed in the project.clj file](https://github.com/technomancy/leiningen/blob/master/sample.project.clj). The second command runs the test suite.
Projects that find this sufficient can use a very minimalistic .travis.yml file:

    language: clojure


### Overriding script, before_install, before_script and friends

If you need a more fine-grained setup, specify operations to use in your .travis.yml like this:

    language: clojure
    before_script: "lein deps && lein javac && lein build-jni-extensions"
    script: "lein test && lein test :integration && lein test :time-consuming"

See <a href="/docs/user/build-configuration/">Build configuration</a> to learn about *before_install*, *before_script*, branches configuration, email notification
configuration and so on.



### Examples

 * [leiningen's .travis.yml](https://github.com/technomancy/leiningen/blob/stable/.travis.yml)
 * [langohr's .travis.yml](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)
 * [momentum's .travis.yml](https://github.com/carllerche/momentum/blob/master/.travis.yml)
