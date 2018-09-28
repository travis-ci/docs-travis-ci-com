---
title: Using Docker in Builds
layout: en

---



Travis CI builds can run and build Docker images, and can also push images to
Docker repositories or other remote storage.

To use Docker add the following settings to your `.travis.yml`:

```yaml
sudo: required

services:
  - docker
```
{: data-file=".travis.yml"}

Then you can add `- docker` commands to your build as shown in the following
examples.

> Travis CI automatically routes builds to run on our Trusty sudo-enabled infrastructure when `services: docker` is configured.
> We do not currently support use of Docker on OS X.

> For information on how to use Docker on Travis CI Enterprise check out [Enabling Docker Builds](https://docs.travis-ci.com/user/enterprise/build-images/#Enabling-Docker-Builds).

## Using a Docker Image from a Repository in a Build

This [example repository](https://github.com/travis-ci/docker-sinatra) runs two
Docker containers built from the same image:

- a Sinatra application
- the Sinatra application test suite

After specifying in the `.travis.yml` that the worker is using the Docker
enabled environment (with `sudo: required` AND `services: - docker`) and is
using ruby, the `before_install` build step pulls a Docker image from
[carlad/sinatra](https://registry.hub.docker.com/u/carlad/sinatra/) then runs

```bash
cd /root/sinatra; bundle exec foreman start;
```

in a container built from that image after mapping some ports and paths. Read
the [Docker User Guide](https://docs.docker.com/) if you need a
refresher on how to use Docker.

The full `.travis.yml` looks like this

```yaml
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
{: data-file=".travis.yml"}

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

## Building a Docker Image from a Dockerfile

Instead of downloading the Docker image from
[carlad/sinatra](https://registry.hub.docker.com/u/carlad/sinatra/) you can
build it directly from the Dockerfile in the [GitHub
repository](https://github.com/travis-ci/docker-sinatra/blob/master/Dockerfile).

To build the Dockerfile in the current directory, and give it the same
`carlad/sinatra` label, change the `docker pull` line to:

```bash
docker build -t carlad/sinatra .
```

The full `.travis.yml` looks like this

```yaml
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
{: data-file=".travis.yml"}

## Pushing a Docker Image to a Registry

In order to push an image to a registry, one must first authenticate via `docker
login`.  The email, username, and password used for login should be stored in
the repository settings environment variables, which may be set up through the
web or locally via the Travis CLI, e.g.:

```bash
travis env set DOCKER_USERNAME myusername
travis env set DOCKER_PASSWORD secretsecret
```

Be sure to [encrypt environment variables](/user/environment-variables#Encrypting-environment-variables)
using the travis gem.

Within your `.travis.yml` prior to attempting a `docker push` or perhaps before
`docker pull` of a private image, e.g.:

```bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
```

### Branch Based Registry Pushes

To push a particular branch of your repository to a remote registry,
use the custom deploy section of your `.travis.yml`:

```yaml
deploy:
  provider: script
  script: bash docker_push
  on:
    branch: master
```
{: data-file=".travis.yml"}

Where `docker_push` is a script in your repository containing:

```bash
#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push USER/REPO
```
{: data-file="docker_push"}


### Private Registry Login

When pushing to a private registry, be sure to specify the hostname in the
`docker login` command, e.g.:

```bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin registry.example.com
```

## Using Docker Compose

The [Docker Compose](https://docs.docker.com/compose/) tool is also [installed in the Docker enabled environment](/user/reference/trusty/#Docker).

If needed, you can easily replace this preinstalled version of `docker-compose`
by adding the following `before_install` step to your `.travis.yml`:

```yaml
env:
  - DOCKER_COMPOSE_VERSION=1.4.2

before_install:
  - sudo rm /usr/local/bin/docker-compose
  - curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  - chmod +x docker-compose
  - sudo mv docker-compose /usr/local/bin
```
{: data-file=".travis.yml"}

## Installing a newer Docker version

You can upgrade to the latest version and use any new Docker features by manually
updating it in the `before_install` step of your `.travis.yml`:

**Updating from download.docker.com**
```yaml
before_install:
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  - sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - sudo apt-get update
  - sudo apt-get -y install docker-ce
```
{: data-file=".travis.yml"}

Alternatively, you can use `addons` instead of `before_install` to update via `apt` as well:
```yaml
addons:
  apt:
    packages:
      - docker-ce
```
{: data-file=".travis.yml"}

> Check what version of Docker you're running with `docker --version`

## Examples

- [heroku/logplex](https://github.com/heroku/logplex/blob/master/.travis.yml) (Heroku log router)
- [kartorza/docker-pg-backup](https://github.com/kartoza/docker-pg-backup/blob/master/.travis.yml) (A cron job that will back up databases running in a docker PostgreSQL container)
