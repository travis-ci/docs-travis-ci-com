---
title: Using Docker in Builds
layout: en
permalink: /user/docker/
---

<div id="toc"></div>

Travis CI builds can run and build Docker images, and can also push images to
Docker repositories or other remote storage.

To use Docker add the following settings to your `.travis.yml`:

```
sudo: required

services:
  - docker
```

Then you can add `- docker` commands to your build as shown in the following
examples.

### Using a Docker Image from a Repository in a Build

This [example repository](https://github.com/travis-ci/docker-sinatra) runs two
Docker containers built from the same image:

* a Sinatra application
* the Sinatra application test suite

After specifying in the `.travis.yml` that the worker is using the Docker
enabled environment (with `sudo: required` AND `services: - docker`) and is
using ruby, the `before_install` build step pulls a Docker image from
[carlad/sinatra](https://registry.hub.docker.com/u/carlad/sinatra/) then runs

```
cd /root/sinatra; bundle exec foreman start;
```

in a container built from that image after mapping some ports and paths. Read
the [Docker User Guide](https://docs.docker.com/userguide/) if you need a
refresher on how to use Docker.

The full `.travis.yml` looks like this

```
sudo: required

language: ruby

services:
  - docker

before_install:
- docker pull carlad/sinatra
- docker run -d -p 127.0.0.1:80:4567 carlad/sinatra /bin/sh -c "cd /root/sinatra; bundle exec foreman start;"
- docker ps -a
- docker run carlad/sinatra /bin/sh -c "cd /root/sinatra; bundle exec rake test"

script:
- bundle exec rake test
```

and produces the following [build
output](https://travis-ci.org/travis-ci/docker-sinatra):

```
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND                CREATED                  STATUS                  PORTS                    NAMES
e376792bce99        carlad/sinatra:latest   "/bin/sh -c 'cd /roo   Less than a second ago   Up Less than a second   127.0.0.1:80->4567/tcp   condescending_galileo
before_install.4
1.30s$ docker run carlad/sinatra /bin/sh -c "cd /root/sinatra; bundle exec rake test"
/usr/local/bin/ruby -I"lib:test" -I"/usr/local/lib/ruby/2.2.0" "/usr/local/lib/ruby/2.2.0/rake/rake_test_loader.rb" "test/test_app.rb"
Loaded suite /usr/local/lib/ruby/2.2.0/rake/rake_test_loader
Started
.
Finished in 0.022952763 seconds.
------
1 tests, 1 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
100% passed
------
43.57 tests/s, 43.57 assertions/s
```

### Building a Docker Image from a Dockerfile

Instead of downloading the Docker image from
[carlad/sinatra](https://registry.hub.docker.com/u/carlad/sinatra/) you can
build it directly from the Dockerfile in the [GitHub
respository](https://github.com/travis-ci/docker-sinatra/blob/master/Dockerfile).

To build the Dockerfile in the current directory, and give it the same
`carlad/sinatra` label, change the `docker pull` line to:

``` bash
docker build -t carlad/sinatra .
```

The full `.travis.yml` looks like this

``` yaml
sudo: required

language: ruby

services:
  - docker

before_install:
  - docker build -t carlad/sinatra .
  - docker run -d -p 127.0.0.1:80:4567 carlad/sinatra /bin/sh -c "cd /root/sinatra; bundle exec foreman start;"
  - docker ps -a
  - docker run carlad/sinatra /bin/sh -c "cd /root/sinatra; bundle exec rake test"

script:
  - bundle exec rake test
```

### Pushing a Docker Image to a Registry

In order to push an image to a registry, one must first authenticate via `docker
login`.  The email, username, and password used for login should be stored in
the repository settings environment variables, which may be set up through the
web or locally via the Travis CLI, e.g.:

``` bash
travis env set DOCKER_EMAIL me@example.com
travis env set DOCKER_USERNAME myusername
travis env set DOCKER_PASSWORD secretsecret
```

Within your `.travis.yml` prior to attempting a `docker push` or perhaps before
`docker pull` of a private image, e.g.:

``` bash
docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
```

#### Branch Based Registry Pushes

To push a particular branch of your repository to a remote registry,
use the `after_success` section of your `.travis.yml`:

```yaml

after_success:
  - if [ "$TRAVIS_BRANCH" == "master" ]; then
    docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
    docker push USER/REPO;
    fi
```

#### Private Registry Login

When pushing to a private registry, be sure to specify the hostname in the
`docker login` command, e.g.:

``` bash
docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD" registry.example.com
```

### Using Docker Compose

The [Docker Compose](https://docs.docker.com/compose/) tool is also [installed in the Docker enabled environment](/user/trusty-ci-environment/#Docker).

If needed, you can easily replace this preinstalled version of `docker-compose` by adding the following `before_install` step to your `.travis.yml`:

```yaml
env:
  DOCKER_COMPOSE_VERSION: 1.4.2

before_install:
  - sudo rm /usr/local/bin/docker-compose
  - curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  - chmod +x docker-compose
  - sudo mv docker-compose /usr/local/bin
```

#### Examples

* [heroku/logplex](https://github.com/heroku/logplex/blob/master/.travis.yml) (Heroku log router)
* [kartorza/docker-pg-backup](https://github.com/kartoza/docker-pg-backup/blob/master/.travis.yml) (A cron job that will back up databases running in a docker PostgreSQL container)
