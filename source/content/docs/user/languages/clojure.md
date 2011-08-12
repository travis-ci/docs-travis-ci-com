---
title: Building a Clojure project
kind: article
layout: article
---

## Provided tools

Travis VMs provide

* 32-bit OpenJDK 6
* [Leiningen](https://github.com/technomancy/leiningen) 1.6.x.


## Setting up a Clojure project on travis-ci.org

Clojure projects on travis-ci.org are managed with [Leiningen](https://github.com/technomancy/leiningen), so add the following line to .travis.yml:

    before_script: "lein deps"
    script: "lein test"


The first command installs the project's [dependencies as listed in the project.clj file](https://github.com/technomancy/leiningen/blob/master/sample.project.clj). The second command runs the test suite.


## Examples

 * [michaelklishin/langohr](https://github.com/michaelklishin/langohr/blob/master/.travis.yml)