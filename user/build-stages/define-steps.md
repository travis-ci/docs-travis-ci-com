---
title: "Build Stages: Defining different steps on different stages"

layout: en
---

This example has 2 build stages:

* Two jobs that run different suites of tests against Ruby 2.3.1
* One job that runs a custom deploy script that doesn't require running the default `install` or `script` steps

Here's what the `.travis.yml` config could look like:

```yaml
env:
- TEST_SUITE=integration_tests
- TEST_SUITE=unit_tests

script: bundle exec rake test:$TEST_SUITE

jobs:
  include:
    - stage: deploy
      env: TEST_SUITE=none
      install: skip # bundle install is not required
      script: ./deploy.sh
```

This is how the build matrix might look:

![image](https://cloud.githubusercontent.com/assets/2208/25947006/db306676-364d-11e7-89f7-81299ba8e630.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch define-steps](https://github.com/travis-ci/build-stages-demo/tree/define-steps/)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/define-steps/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/231120401)
