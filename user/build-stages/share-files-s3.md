---
title: "Build Stages: Share files via S3"
permalink: /user/build-stages/share-files-s3/
layout: en
---

This example has 2 build stages:

* One job that installs dependencies and warms up the cache for the given branch.
* Three jobs that run tests, using the cache.

Here's what the `.travis.yml` config could look like:

```yaml
env:
  global:
    # include $HOME/.local/bin for `aws`
    - PATH=$HOME/.local/bin:$PATH

before_install:
  # set up awscli packages
  - pip install --user awscli
  - mkdir -p ~/shared
  - aws s3 sync s3://travis-build-stages-shared-storage-test/shared ~/shared

jobs:
  include:
    - stage: setup files
      script: echo one | tee > ~/shared/one
    - stage: setup files
      script: echo two | tee > ~/shared/two
    - stage: use shared files
      script:
        - cat ~/shared/*

after_success:
  - aws s3 sync ~/shared s3://travis-build-stages-shared-storage-test/shared
```

This is how the build matrix would look like:

![image](https://cloud.githubusercontent.com/assets/2208/25853601/afbe5c4a-34cd-11e7-9b38-6223ec85c5e5.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/shared-storage-with-s3)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/shared-storage-with-s3/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/230349354)
