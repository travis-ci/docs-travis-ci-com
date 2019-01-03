---
title: Customizing Enterprise Worker Configuration
layout: en_enterprise

---



## Credentials for Connecting to the Platform

### With Ubuntu 16.04 as host operating system

The configuration for connecting to the Travis CI Enterprise platform can be found in `/etc/default/travis-worker`.
If you need to change the hostname the Worker should connect to, or the
RabbitMQ password, you can do so by updating:

```sh
export AMQP_URI="amqp://travis:<rabbitmq password>@<Travis CI Enterprise platform hostname>/travis"
```

### With Ubuntu 14.04 as host operating system

The configuration for connecting to the Travis CI Enterprise Platform,
including the RabbitMQ password, can be found in
`/etc/default/travis-enterprise`.

If you need to change the hostname the Worker should connect to, or the
RabbitMQ password, you can do so by updating:

```sh
export TRAVIS_ENTERPRISE_HOST="enterprise.hostname.corp"
export TRAVIS_ENTERPRISE_SECURITY_TOKEN="super-secret-password"
```

## Setting Timeouts

The following options can be customized in `/etc/default/travis-worker`.
It is recommended to have all Workers use the same config.

By default Jobs can run for a maximum of 50 minutes. You can increase or
decrease this using the following setting:

```sh
export TRAVIS_WORKER_HARD_TIMEOUT="50m"
```

If no log output has been received over 10mins the job is cancelled as
it is assumed the job stalled. You can customize this timeout using the
following setting:

```sh
export TRAVIS_WORKER_LOG_TIMEOUT="10m"
```

## Configuring the Number of Concurrent Jobs

The number of concurrent jobs run by the worker and the number of CPUs
allowed for a job to use are configured with the
`TRAVIS_WORKER_POOL_SIZE` and `TRAVIS_WORKER_DOCKER_CPUS` environment
variables, respectively. Each Job requires a minimum of 2 CPUs, and by
default, each Worker runs 2 Jobs. The product of
`TRAVIS_WORKER_POOL_SIZE * TRAVIS_WORKER_POOL_SIZE` cannot exceed the
number of CPUs the worker machine has, otherwise jobs will error and
requeue.

To change the number of concurrent jobs allowed for a worker to use,
please update the following setting:

```sh
export TRAVIS_WORKER_POOL_SIZE="2"
```


To change the number of CPUs a job is allowed to use, please change the
following setting:

```sh
export TRAVIS_WORKER_DOCKER_CPUS=2
```

To completely disable this setting have the value set to 0. Then
resources will be used as needed, which means a single job can for
example use all CPU cores.

```sh
export TRAVIS_WORKER_DOCKER_CPUS=0
```


## Changing the Worker Hostname

Each Worker should have a unique hostname, making it easier to determine
where jobs ran. By default this is set to the `hostname` of the host the
Worker is running on.

```sh
export TRAVIS_WORKER_HOSTNAME=""
```


## Disable SSL Verification Messages

The Platform comes setup with a self signed SSL certificate, this option
allows the Worker to talk to the Platform via SSL but ignore the
verification warnings.

```sh
export TRAVIS_WORKER_BUILD_API_INSECURE_SKIP_VERIFY="false"
```

## Enabling S3 Dependency Caching

If you would like to setup S3 dependency caching for your builds, you
can use the following example config:

```sh
export TRAVIS_WORKER_BUILD_CACHE_FETCH_TIMEOUT="10m"
export TRAVIS_WORKER_BUILD_CACHE_PUSH_TIMEOUT="60m"
export TRAVIS_WORKER_BUILD_CACHE_S3_ACCESS_KEY_ID=""
export TRAVIS_WORKER_BUILD_CACHE_S3_SECRET_ACCESS_KEY=""
export TRAVIS_WORKER_BUILD_CACHE_S3_BUCKET=""
export TRAVIS_WORKER_BUILD_CACHE_S3_REGION="us-east-1"
export TRAVIS_WORKER_BUILD_CACHE_S3_SCHEME="https"
export TRAVIS_WORKER_BUILD_CACHE_TYPE="s3"
```

## Configuring Jobs' Allowed Memory Usage

The Worker comes configured with the RAM defaulted to 4G. If you want to
change it you can add the following. To completely disable it have the
value set to 0.

```sh
export TRAVIS_WORKER_DOCKER_MEMORY=4G
# OR
export TRAVIS_WORKER_DOCKER_MEMORY=0
```

## Setting Maximum Log Length

The Worker comes configured with `defaultMaxLogLength = 4500000` which
is 4.5MB. The setting is measured in bytes, so to get 40MB you need
40000000.

```sh
export TRAVIS_WORKER_MAX_LOG_LENGTH=40000000
```

## Mounting volumes across worker jobs on Enterprise

You can use [Docker bind mounts](https://docs.docker.com/storage/bind-mounts/)
when the worker launches the container of a job. This lets you share files or directories
across all jobs ran by a worker. Multiple binds can be provided
as _space separated_ strings.

For example, the setting below shows how to share the `/tmp` directory in read/write mode,
as well as the `/var/log` directory in read-only mode (`:r` is the default):

```sh
export TRAVIS_WORKER_DOCKER_BINDS="/tmp:/tmp:rw /var/log"
```

A full list of options and mount modes is listed in the official
 [Docker documentation](https://docs.docker.com/storage/bind-mounts/).

## Worker behind an HTTP(S) Proxy

If you're using Travis CI Enterprise behind an HTTP(S) proxy, we've got you covered. Since travis-worker 4.6 it is possible to run builds behind a proxy.

### How do I find out if I have the correct travis-worker version installed?

#### Ubuntu 16.04+

Connect to your worker machine via ssh and run:

```
$ sudo docker images | grep worker
travisci/worker        v4.6.1                      ef7a3419050c        17 hours ago        44.7MB
```

#### Ubuntu 14.04

Connect to your worker machine via ssh and run:

```
$ travis-worker -v
travis-worker v=v4.6.1 rev=73392421d0ca807b83d4d459ad3dd484820fd181 d=2018-10-30T16:13:39+0000 go=go1.11.1
```

#### Upgrade travis-worker

If you need to install a newer version of travis-worker, please follow the instructions in our [Updating your Travis CI Worker docs](/user/enterprise/upgrading/#updating-your-travis-ci-enterprise-worker).

### Configuring an HTTP Proxy

On the worker machine, please open `/etc/default/travis-worker` in your editor and add the two lines from the example below. The value for `TRAVIS_WORKER_DOCKER_API_VERSION` depends on the installed Docker version.

```
export TRAVIS_WORKER_DOCKER_HTTP_PROXY="<YOUR PROXY URL>"
export TRAVIS_WORKER_DOCKER_API_VERSION=1.35
```

In this example we've used Docker-CE 17.12. According to the [API mismatch table](https://docs.docker.com/develop/sdk/#docker-ee-and-ce-api-mismatch) we need to choose `1.35` for `TRAVIS_WORKER_DOCKER_API_VERSION`.

Below you find the full list of available environment variables and how they're accessible during the build:

Environment variable | Available as:
`TRAVIS_WORKER_DOCKER_HTTP_PROXY` | `HTTP_PROXY`, `http_proxy`
`TRAVIS_WORKER_DOCKER_HTTPS_PROXY` | `HTTPS_PROXY`, `https_proxy`
`TRAVIS_WORKER_DOCKER_NO_PROXY` | `NO_PROXY`, `no_proxy`
`TRAVIS_WORKER_DOCKER_FTP_PROXY` | `FTP_PROXY`, `ftp_proxy`

Please note, that all `apt-get` commands by default respect `TRAVIS_WORKER_DOCKER_HTTP_PROXY` and `TRAVIS_WORKER_DOCKER_HTTPS_PROXY` which means that all package installs will go via the HTTP Proxy as well. If you don't want this to happen, please whitelist your apt package mirror by adding it to TRAVIS_WORKER_DOCKER_NO_PROXY` like this:

```
export TRAVIS_WORKER_DOCKER_NO_PROXY='.ubuntu.com,packagecloud.io,.postgresql.org'
```


## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
