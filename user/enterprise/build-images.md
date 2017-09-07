---
title: Customizing Travis CI Enterprise Build Images
layout: en_enterprise

---

With Travis CI Enterprise, you can configure your build images to suit your
development process and improve the build environment and performance.

<div id="toc"></div>

## Customizing build images

After pulling the build images from
[quay.io](https://quay.io/organization/travisci) either through
[installation](/user/enterprise/installation) or manually, make sure
they've been re-tagged to `travis:[language]`. Once this configuration is in
place, you can fully customize these images according to your needs.

**Note**: you'll need to re-apply your customizations after
upgrading build images from [quay.io](https://quay.io/organization/travisci).

The process is to:

-   start a Docker container based on one of the default build images
    `travis:[language]`,
-   run your customizations inside that container, and
-   commit the container to a Docker image with the original
    `travis:language name (tag)`.

For example, in order to install a particular Ruby version which is not
available on the default `travis:ruby` image, and make it persistent,
you can run:

```    
      docker -H tcp://0.0.0.0:4243 run -it --name travis_ruby travis:ruby su travis -l -c 'rvm install [version]'
      docker -H tcp://0.0.0.0:4243 commit travis_ruby travis:ruby
      docker -H tcp://0.0.0.0:4243 rm travis_ruby
```

## Enabling Docker Builds

In order to build other docker images, the Worker needs to be setup to support Docker Builds. To get started, please add the following to `/etc/default/travis-worker` on all your Workers:

```
    export TRAVIS_WORKER_DOCKER_PRIVILEGED="true"
```       

You will then need to restart each Worker, you can find more information on this here: https://docs.travis-ci.com/user/enterprise/worker-cli-commands/#Stopping-and-Starting-the-Worker.

### Updates to your .travis.yml files

Add the following to any `.travis.yml` files for repositories which would like to use Docker:

```
    install:
          - sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
          - echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" | sudo tee /etc/apt/sources.list.d/docker.list
          - sudo apt-get update
          - sudo apt-get install docker-engine
```

For example, if you want to create a new repository and test out Docker support, you can create a `.travis.yml` file which looks like the following:

```
    install:
          - sudo apt-get update
          - sudo apt-get install apt-transport-https ca-certificates
          - sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
          - echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" | sudo tee /etc/apt/sources.list.d/docker.list
          - sudo apt-get update
          - sudo apt-get install docker-engine
          - sudo docker pull ubuntu

          script:
          - sudo docker run ubuntu date
```
