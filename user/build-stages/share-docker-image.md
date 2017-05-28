---
title: "Build Stages: Sharing a Docker image"
permalink: /user/build-stages/share-docker-image/
layout: en
---

This example has 2 build stages:

* One job builds and pushes a Docker image
* Two jobs that pull and test the image

Here's what the `.travis.yml` config could look like:

```yaml
sudo: true
dist: trusty

jobs:
  include:
    - stage: build docker image
      script:
      - docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
      - docker build -t travis-ci-build-stages-demo .
      - docker images
      - docker tag travis-ci-build-stages-demo $DOCKER_USERNAME/travis-ci-build-stages-demo
      - docker push $DOCKER_USERNAME/travis-ci-build-stages-demo
    - stage: test
      script: docker run --rm $DOCKER_USERNAME/travis-ci-build-stages-demo cat hello.txt
    - script: docker run --rm $DOCKER_USERNAME/travis-ci-build-stages-demo cat hello.txt
```

This is how the build matrix might look:

![image](https://cloud.githubusercontent.com/assets/2208/25949325/71c2de58-3657-11e7-84d6-8eebd9661ba3.png)

You can find the code for this example on our [demo repository](https://github.com/travis-ci/build-stages-demo):

* [Branch define-steps](https://github.com/travis-ci/build-stages-demo/tree/share-docker-image/)
* [.travis.yml file](https://github.com/travis-ci/build-stages-demo/blob/share-docker-image/.travis.yml)
* [Build on Travis CI](https://travis-ci.org/travis-ci/build-stages-demo/builds/231145680)
