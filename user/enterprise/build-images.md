---
title: Customizing Travis CI Enterprise Build Images
layout: en_enterprise

---

With Travis CI Enterprise, you can configure your build images to suit your
development process and improve the build environment and performance.



## Customizing Build Images

After pulling the build images from
[quay.io](https://quay.io/organization/travisci) either through
[installation](/user/enterprise/installation) or manually, make sure
they've been re-tagged to `travis:[language]`. Once this configuration is in
place, you can fully customize these images according to your needs.

> Note that you'll need to re-apply your customizations after
upgrading build images from [quay.io](https://quay.io/organization/travisci).

### Ubuntu Trusty build environments

For Ubuntu Trusty build environments we ship three Docker images in total. Depending on the user's `.travis.yml` configuration, we will pick the corresponding image to run the build.

We're shipping the same Docker build images as we use on travis-ci.com. The base image, `connie` contains all databases and frameworks preinstalled, such as postgresql, mysql, memcached, pyenv, rvm, gimme. Though there are no interpreters available. Based on `connie` there is `garnet`, which adds the following programming languages:

- Ruby
- Node.js
- Go
- PHP
- Python
- Java / JVM

The third image, `amethyst`, additionally ships with Android, Erlang, Haskell and Perl preinstalled.

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

We accomplish this by adding another configuration option to `/etc/default/travis-worker`:

```
export TRAVIS_WORKER_DOCKER_BINDS='/var/run/docker.sock:/var/run/docker.sock'
```

With this option we tell `travis-worker` to make the host's Docker socket available inside the build containers.

> Please restart travis-worker after you have saved the configuration file.


#### Restart travis-worker

To restart travis-worker, you can find the instructions [here](/user/enterprise/worker-cli-commands/#stopping-and-starting-the-worker).

### Updates to your .travis.yml files

#### Trusty build containers

Once the worker machine is [configured properly](/user/enterprise/build-images/#worker-machine-configuration), you can use Docker as usual in your build.

> Please note that on an Enterprise installation you don't need to add `services: docker` to the `.travis.yml`.

Since you're using the host's Docker daemon, all images and containers used in your build are stored on the host machine. To free up disk space, we recommend using the `--rm` flag when you use Docker run in your build.
To avoid race conditions when multiple builds start to remove containers and images at the same time, we recommend to clean them up manually on the machine directly while no build is running.

#### Precise build containers (legacy)

Add the following to any `.travis.yml` files for repositories which would like to use Docker:

```yaml
    install:
          - sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
          - echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" | sudo tee /etc/apt/sources.list.d/docker.list
          - sudo apt-get update
          - sudo apt-get install docker-engine
```

For example, if you want to create a new repository and test out Docker support, you can create a `.travis.yml` file which looks like the following:

```yaml
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
