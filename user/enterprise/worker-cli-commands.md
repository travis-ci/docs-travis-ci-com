---
title: Enterprise Worker Start & Debug Containers
layout: en_enterprise

---

<div id="toc"></div>

## Stopping and Starting the Worker

The Travis CI Worker is installed as an upstart service. The following
commands can be used to check the status of the service, and to start or
stop it.

```            
      $ sudo status travis-worker
      travis-worker start/running, process 9622
```
```
      $ sudo stop travis-worker
      travis-worker stop/waiting
```
```
      $ sudo start travis-worker
      travis-worker start/running, process 16339
```        

When the worker gets stopped with `sudo stop travis-worker` it gets shut
down with a `KILL` signal. This stops all currently running build jobs
and will enqueue them when the worker starts again. If you'd like to
wait until some or all jobs are being worked off successfully, you can
issue a `SIGINT` instead. This together with a `sleep` ensures that
either at least some or all active jobs can finish (depending on how
long your queue is). After `sleep` finished the worker has to be
shutdown via `sudo stop travis-worker`.\

## Example Worker Stop and Start

In this example, a `sleep 60` is used to allow jobs to complete before the
worker is stopped. The actual value depends on how long your current job queue
is and how long it takes in average for a job to finish, so you may wish to
adjust accordingly.

```            
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

```
      # start a container and grab the port
      id=$(docker -H tcp://0.0.0.0:4243 run -d -p 22 travis:php /sbin/init)
      port=$(docker -H tcp://0.0.0.0:4243 port $id 22 | sed 's/.*://')

      # ssh into the container (the default password is travis)
      ssh travis@localhost -p $port

      # stop and remove the container
      docker -H tcp://0.0.0.0:4243 kill $id
      docker -H tcp://0.0.0.0:4243 rm $id
```
