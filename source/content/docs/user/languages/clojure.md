---
title: Building a Clojure project
kind: article
layout: article
---

Travis VMs includes Leinigen 1.6.x. You can use it to build and test your Clojure project. Add the following line to .travis.yml:

    before_script: "lein deps"
    script: "lein test"


The first command installs the project's dependencies as listed in the project.clj file). The second command runs the test suite.
