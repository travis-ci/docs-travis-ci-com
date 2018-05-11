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

### Ubuntu Trusty build environments

For Ubuntu Trusty build environments we ship three Docker images in total. Depending on the user's `.travis.yml` configuration we will pick the corresponding image to run the build.

We're shipping the same Docker build images as we use on travis-ci.com. The base image, `connie` contains all databases and frameworks preinstalled, such as postgresql, mysql, memcached, pyenv, rvm, gimme. Though there are no interpreters available. Based on `connie` there is `garnet`, which adds the following programming languages:

- Ruby
- Node.js
- Go
- PHP
- Python
- Java / JVM

The third image, `amethyst`, additionaly ships with Android, Erlang, Haskell and Perl preinstalled.

> Any modification to one of these images will be available for other languages as well.

### Ubuntu Precise build environments (deprecated)

In the Ubuntu Precise environment we're shipping a separate Docker image for each language we support. There we support the same languages as in our current Trusty environment.

### How to customize

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

### Worker machine configuration

To build docker images on Travis CI Enterprise, add the following to `/etc/default/travis-worker` on all your Workers:

```
    export TRAVIS_WORKER_DOCKER_PRIVILEGED="true"
```

#### Configuration for Docker Builds in Trusty Build Environments

With Trusty build images a few additional steps are required. Since `docker-ce` can't run on its own inside another Docker container, it'll connect to the Host's Docker daemon to execute the respective commands.

> For non-AWS deployments, please make sure that the worker machine has a private IP address configured on one of its interfaces.

On Amazon EC2 each machine has a private IP address by default. That address will be used to connect to the Docker daemon.

To get the address, please run `ifconfig` in your terminal. For EC2 Virtual Machines, usually `eth0` interface is correct.

Now the Docker daemon needs to listen to that address. Please open `/etc/default/docker`. In this file, you'll find the `DOCKER_OPTS` variable. This is read by Docker during service startup. In there please configure the additional host like this (We're using `172.31.7.199` as example here):

```
DOCKER_OPTS="-H tcp://172.31.7.199:4243 -H tcp://127.0.0.1:4243 -H unix:///var/run/docker.sock ..."
```

After that, both Docker and travis-worker have to be restarted. For Docker, please run:

```
$ sudo restart docker
```

For travis-worker, you can find the instructions [here](https://docs.travis-ci.com/user/enterprise/worker-cli-commands/#Stopping-and-Starting-the-Worker).


### Updates to your .travis.yml files

#### Trusty build containers

> Please note: This solution utilizes the Docker daemon from the host machine - any containers and images you pull and run through your build need to be cleaned up manually.

Add the following to your `.travis.yml` configuration:

```
install:
  - sudo apt-get update
  - sudo apt-get install -y curl software-properties-common apt-transport-https ca-certificates
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  - sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu trusty stable"
  - sudo apt-get update
  - sudo apt-get install -y docker-ce
  - sudo docker -H <IP>:4243 pull ubuntu
script:
  - sudo docker -H <IP>:4243 run ubuntu date

```

#### Precise build containers (legacy)

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

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}