---
title: "Build Stages: Defining steps using YAML aliases"

layout: en
---

This example has 3 build stages:

* Two jobs that run tests against Ruby 2.2 and 2.3
* One job that deploys to staging
* Three jobs that runs test against staging

Here's what the `.travis.yml` config could look like:

```yaml
rvm:
  - 2.2
  - 2.3

script: bundle exec rspec

jobs:
  include:
    - stage: deploy to staging
      rvm: 2.3
      install: skip # bundle install is not required
      script: ./deploy.sh
    - &test-staging
      stage: test staging
      rvm: 2.3
      install: skip
      script: ./test-staging.sh one
    - <<: *test-staging
      script: ./test-staging.sh two
    - <<: *test-staging
      script: ./test-staging.sh three
```
{: data-file=".travis.yml"}

This is how the build matrix might look:

![image](https://cloud.githubusercontent.com/assets/2208/25947019/f68d7c9c-364d-11e7-80c2-e4c549910dbc.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch define-steps](https://github.com/travis-ci/build-stages-demo/tree/using-yaml-aliases/)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/using-yaml-aliases/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/231120211)
