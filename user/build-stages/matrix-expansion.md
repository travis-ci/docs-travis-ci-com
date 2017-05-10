---
title: "Build Stages: Matrix expansion"
permalink: /user/build-stages/matrix-expansion/
layout: en
---

This example has 2 build stages:

* Four test jobs that have been expanded from `rvm` and `env` matrix keys.
* One deploy job.

Here's what the `.travis.yml` config could look like:

```yaml
rvm:
  - 2.2
  - 2.3

env:
  - FOO=foo
  - FOO=bar

script: echo $FOO

jobs:
  include:
    - stage: deploy
      script: echo Deploy
      # Keep in mind to overwrite these here
      rvm: 2.3
      env: FOO=foo
```

This is how the build matrix would look like:

![image](https://cloud.githubusercontent.com/assets/2208/25853030/a3a41708-34cb-11e7-9560-bcec60350342.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/matrix-expansion)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/matrix-expansion/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/230344299)
