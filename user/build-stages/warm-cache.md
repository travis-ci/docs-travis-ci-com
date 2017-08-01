---
title: "Build Stages: Warm up cache"

layout: en
---

This example has 2 build stages:

* One job that installs dependencies and warms up the cache for the given branch.
* Three jobs that run tests, using the cache.

Here's what the `.travis.yml` config could look like:

```yaml
cache: bundler

jobs:
  include:
    - stage: prepare cache
      script: true
      rvm: 2.3
    - stage: test
      script: bundle show
      rvm: 2.3
    - stage: test
      script: bundle show
      rvm: 2.3
    - stage: test
      script: bundle show
      rvm: 2.3
```

This is how the build matrix would look like:

![image](https://cloud.githubusercontent.com/assets/2208/25852101/79a071f2-34c8-11e7-9d20-c518e6874b04.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/pre-caching-dependencies)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/pre-caching-dependencies/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/224025125)
