---
title: "Build Stages: Share files via S3"
layout: en
---

This example has 2 build stages:

* Two jobs that set up files on S3.
* One job that uses both files from stage 1.

Here's what the `.travis.yml` config could look like:

```yaml
env:
  global:
    # include $HOME/.local/bin for `aws`
    - PATH=$HOME/.local/bin:$PATH

before_install:
  # set up awscli packages
  - pip install --user awscli
  - mkdir -p ~/$TRAVIS_BUILD_NUMBER
  - aws s3 sync s3://travis-build-stages-shared-storage-test/$TRAVIS_BUILD_NUMBER ~/$TRAVIS_BUILD_NUMBER

jobs:
  include:
    - stage: setup files
      script: echo one | tee > ~/$TRAVIS_BUILD_NUMBER/one
    - stage: setup files
      script: echo two | tee > ~/$TRAVIS_BUILD_NUMBER/two
    - stage: use shared files
      script:
        - cat ~/$TRAVIS_BUILD_NUMBER/*
      after_success:
        - aws s3 rm --recursive s3://travis-build-stages-shared-storage-test/$TRAVIS_BUILD_NUMBER # clean up after ourselves

after_success:
  - aws s3 sync ~/$TRAVIS_BUILD_NUMBER s3://travis-build-stages-shared-storage-test/$TRAVIS_BUILD_NUMBER
```
{: data-file=".travis.yml"}

This is how the build matrix would look like:

![image](https://cloud.githubusercontent.com/assets/2208/25853601/afbe5c4a-34cd-11e7-9b38-6223ec85c5e5.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch master](https://github.com/travis-ci/build-stages-demo/tree/shared-storage-with-s3)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/shared-storage-with-s3/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/230349354)
