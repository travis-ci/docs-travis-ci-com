---
title: Enterprise Worker Start & Debug Containers
layout: en_enterprise

---



## Stopping and Starting the Worker

### With Ubuntu 16.04 as host operating system

The Travis CI Worker is installed as an systemd service. The following commands can be used to check the status and start/stop the service:

```sh
$ sudo systemctl status travis-worker
```

```sh
$ sudo systemctl start travis-worker
```

```sh
$ sudo systemctl stop travis-worker
```

### With Ubuntu 14.04 as host operating system

The Travis CI Worker is installed as an upstart service. The following
commands can be used to check the status of the service and to start or
stop it.

```sh
$ sudo status travis-worker
travis-worker start/running, process 9622
```

```sh
$ sudo stop travis-worker
travis-worker stop/waiting
```

```sh
$ sudo start travis-worker
travis-worker start/running, process 16339
```

When the worker is stopped with `sudo stop travis-worker`, it is shut
down with a `KILL` signal. This stops all currently running build jobs
and will enqueue them when the worker starts again. If you'd like to
wait until some or all jobs are being worked off successfully, you can
issue a `SIGINT` instead. This together with a `sleep` ensures that
either some or all active jobs can finish (depending on how
long your queue is). After `sleep` finished, the worker has to be
shut down via `sudo stop travis-worker`.

## Example Worker Stop and Start

travis-worker behaves differently based on the signals it receives. For instance, a `SIGINT` drains the queue, it gives travis-worker enough time to work off all jobs which are still in progress, but it doesn't accept any new ones.

`SIGKILL` on the other hand shuts down travis-worker immediately and cancels all currently running jobs. If you start the worker again afterwards, all previously enqueued and running jobs are re-queued again so they'll be worked off as usual.

### With Ubuntu 16.04 as host operating system

With Ubuntu 16.04 as the host operating system, travis-works runs inside a Docker container, so starting and stopping the worker now works via `systemctl`:

```sh
$ sudo systemctl start travis-worker
```

```sh
$ sudo systemctl stop travis-worker
```

```sh
$ sudo systemctl status travis-worker
```

To send a `SIGINT` signal, please run the following:

```sh
sudo docker kill -s SIGINT travis-worker
```

### With Ubuntu 14.04 as host operating system

In this example, a `sleep 60` is used to allow jobs to complete before the
worker is stopped. The actual value depends on how long your current job queue
is and how long it takes in average for a job to finish, so you may wish to
adjust accordingly.

```sh
$ sudo status travis-worker
travis-worker start/running, process 5671
$ sudo kill -s INT 5671
$ sleep 60
$ sudo status travis-worker
travis-worker start/post-stop, process 9405
$ sudo stop travis-worker
```

## Starting Worker Debug Containers

In order to start a build container on a Travis CI Enterprise Worker
host you can do the following:

```sh
# start a container and grab the port
id=$(docker -H tcp://0.0.0.0:4243 run -d -p 22 travis:php /sbin/init)
port=$(docker -H tcp://0.0.0.0:4243 port $id 22 | sed 's/.*://')

# ssh into the container (the default password is travis)
ssh travis@localhost -p $port

# stop and remove the container
docker -H tcp://0.0.0.0:4243 kill $id
docker -H tcp://0.0.0.0:4243 rm $id
```

_(If travis-worker runs on Ubuntu 16.04, `-H tcp://0.0.0.0:4243` is not necessary anymore)_

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
