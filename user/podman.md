---
title: Use Podman in Builds
layout: en
---

Travis CI builds can run and build container images with Podman, and can also push images to container repositories or other remote storage. Podman provides a Docker-compatible command-line interface, making it a suitable alternative that doesn't require a daemon to run.

To use Podman add the following settings to your `.travis.yml`:

```yaml
services:
  - podman
```
{: data-file=".travis.yml"}

Then you can add `- podman` commands to your build as shown in the following examples.

> We do not currently support use of Podman on macOS.

> For information on how to use Podman on Travis CI Enterprise, check out [Enabling Container Builds](/user/enterprise/build-images/#enabling-container-builds).

## Use a Container Image from a Repository

This example runs two container instances built from the same image:

- a web application
- the application test suite

After specifying in the `.travis.yml` to use Podman (with `services: - podman`) and your language of choice, the `before_install` build step pulls a container image then runs it with appropriate parameters.

The full `.travis.yml` might look like this:

```yaml
language: ruby

services:
  - podman

before_install:
- podman pull docker.io/nginx:latest
- podman run -d -p 127.0.0.1:80:8080 docker.io/nginx:latest
- podman ps -a
- podman run --rm docker.io/nginx:latest /bin/sh -c "nginx -v"

script:
- bundle exec rake test
```
{: data-file=".travis.yml"}

## Build a Container Image from a Containerfile

Instead of downloading the container image from a registry, you can build it directly from a Containerfile (equivalent to a Dockerfile) in your repository.

To build the Containerfile in the current directory and give it a label, use the following command:

```bash
podman build -t myusername/myapp .
```

The full `.travis.yml` would look like this:

```yaml
language: ruby

services:
  - podman

before_install:
  - podman build -t myusername/myapp .
  - podman run -d -p 127.0.0.1:80:8080 myusername/myapp /bin/sh -c "cd /app; ./start.sh;"
  - podman ps -a
  - podman run myusername/myapp /bin/sh -c "cd /app; ./run_tests.sh"

script:
  - bundle exec rake test
```
{: data-file=".travis.yml"}

## Push a Container Image to a Registry

To push an image to a container registry, one must first authenticate via `podman login`. The username and password used for login should be stored in the repository settings environment variables, which may be set up through the repository settings web page or locally via the Travis CLI, e.g.:

```bash
travis env set REGISTRY_USERNAME myusername
travis env set REGISTRY_PASSWORD secretsecret
```

Be sure to [encrypt environment variables](/user/environment-variables/#encrypting-environment-variables) using the travis gem.

Within your `.travis.yml` prior to attempting a `podman push` or perhaps before `podman pull` of a private image, e.g.:

```bash
echo "$REGISTRY_PASSWORD" | podman login -u "$REGISTRY_USERNAME" --password-stdin quay.io
```

### Branch-Based Registry Pushes

To push a particular branch of your repository to a remote registry, use the custom deploy section of your `.travis.yml`:

```yaml
deploy:
  provider: script
  script: bash container_push
  on:
    branch: master
```
{: data-file=".travis.yml"}

Where `container_push` is a script in your repository containing:

```bash
#!/bin/bash
echo "$REGISTRY_PASSWORD" | podman login -u "$REGISTRY_USERNAME" --password-stdin quay.io
podman push myusername/myapp
```
{: data-file="container_push"}

### Private Registry Login

When pushing to a private registry, be sure to specify the hostname in the `podman login` command, e.g.:

```bash
echo "$REGISTRY_PASSWORD" | podman login -u "$REGISTRY_USERNAME" --password-stdin registry.example.com
```

## Use Podman Compose

The Podman Compose tool allows you to run multi-container applications. You can install it in your build environment by adding the following to your `.travis.yml`:

```yaml
before_install:
  - pip install podman-compose
```
{: data-file=".travis.yml"}

## Install a specific Podman version

You can install a specific version of Podman by manually updating it in the `before_install` step of your `.travis.yml`:

```yaml
before_install:
  - source /etc/os-release
  - echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
  - curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
  - sudo apt-get update
  - sudo apt-get -y install podman=<specific-version>
```
{: data-file=".travis.yml"}

> Check what version of Podman you're running with `podman --version`

## Examples

- [example/podman-web-app](https://github.com/example/podman-web-app/blob/master/.travis.yml) (A web application using Podman for container management)
- [example/podman-backup](https://github.com/example/podman-backup/blob/master/.travis.yml) (A cron job that backs up databases running in Podman containers)
