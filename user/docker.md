---
title: Using Docker in Builds
layout: en
permalink: /user/docker/
---

<div id="toc"></div>

Travis CI builds can run and build Docker images, and can also push images to
Docker repositories or other remote storage.

<!-- @joshk -->

If you don't already have access to the beta workers running Ubuntu Trusty
Tahr, please [contact support](mailto:support@travis-ci.com) and let them know
which repository you'd like to use Docker in.

To use Docker you need the following settings in your `.travis.yml`:

```
sudo: required

dist: trusty
```

Then you can add `- docker` commands to your build as shown in the following
examples.

### Using a Docker Image from a Repository in a Build

This [example repository](https://github.com/travis-ci/docker-sinatra) runs two
Docker containers built from the same image:

* a Sinatra application
* the Sinatra application test suite

After specifying that the `.travis.yml` is using ruby, on the legacy
environment, using the beta Ubuntu Trusty Tahr image, the `before_install`
build step pulls a Docker image from
[carlad/sinatra](https://registry.hub.docker.com/u/carlad/sinatra/) then runs

```
cd /root/sinatra; bundle exec foreman start;
```

in a container built from that image after mapping some ports and paths. Read
the [Docker User Guide](https://docs.docker.com/userguide/) if you need a
refresher on how to user Docker.

The full `.travis.yml` looks like this

```
language: ruby

sudo: required

dist: trusty

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

```
- docker build -t carlad/sinatra .
```

The full `.travis.yml` looks like this

```
language: ruby

sudo: required

dist: trusty

before_install:
- docker build -t carlad/sinatra .
- docker run -d -p 127.0.0.1:80:4567 carlad/sinatra /bin/sh -c "cd /root/sinatra; bundle exec foreman start;"
- docker ps -a
- docker run carlad/sinatra /bin/sh -c "cd /root/sinatra; bundle exec rake test"

script:
- bundle exec rake test
```

<!--
### Pushing a Docker Image to a Registry
-->
