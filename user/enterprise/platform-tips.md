---
title: Enterprise Platform Administration Tips
layout: en_enterprise

---

This page collects FAQs and day-to-day Enterprise Platform maintenance scripts
and tools. Please connect to your Platform machine via SSH before getting
started.

<div id="toc"></div>

## Inspecting logs and running services

On the Platform you can find the main log file at
`/var/travis/log/travis.log`. They are also symlinked to
`/var/log/travis.log` for convenience.

On the Worker you can find the main log file at
`/var/log/upstart/travis-worker.log`

## Accessing Travis Container and Console on the Platform

`travis bash`: This will get you into the running container on the
Platform.

`travis console`: This will get you into a Ruby IRB session on the
Platform.

## Cancel or Reset Stuck Jobs

Occasionally, jobs can get stuck in a `queued` state on the worker. To cancel or
reset a large number of jobs, please execute the following steps:

```
$ travis console
>> stuck_jobs = Job.where(queue: 'builds.linux', state: 'queued').where('queued_at < NOW() - interval \'60 minutes\'').all
>> # Cancels all stuck jobs
>> stuck_jobs.each(&:cancel!)
>> # Or reset them
>> stuck_jobs.each(&:reset!)
```

## Clear Redis Archive Queue (for releases < 2.1.7)

In releases of Enterprise before 2.1.7 jobs where enqueued in the archive queue
for log aggregation. This feature however is only available for the hosted
versions of Travis CI so far.

This results in the queue growing bigger and bigger, but not getting working
off. Because of that, Redis' memory consumption increases over the time and can
lead to decreased performance of the whole platform. The solution to this is
rather simple, the `archive` queue has to be cleared to free system resources.
To clear it, please execute the following commands:

```
$ travis console
>> require 'sidekiq/api'
>> Sidekiq::Queue.new('archive').clear
```

## Reset the RabbitMQ certificate

After an upgrade of Replicated 2.8.0 to a newer version occasionally the service
restarts with the following error:

```
$ docker inspect --format '{% raw  %}{{.State.Error}}{% endraw  %}' focused_yalow
oci runtime error: container_linux.go:247: starting container process
caused "process_linux.go:359: container init caused
\"rootfs_linux.go:54: mounting
\\\"/var/lib/replicated-operator/44c648980d1e4b1c5a97167046f32f11/etc/travis/ssl/rabbitmq.cert\\\"
to rootfs
\\\"/var/lib/docker/aufs/mnt/a00833d25e72b761e2a0e72b1015dd2b2f3a32cafd2851ba408b298f73b37d37\\\"
at
\\\"/var/lib/docker/aufs/mnt/a00833d25e72b761e2a0e72b1015dd2b2f3a32cafd2851ba408b298f73b37d37/etc/travis/ssl/rabbitmq.cert\\\"
caused \\\"not a directory\\\"\""
: Are you trying to mount a directory onto a file (or vice-versa)? Check
if the specified host path exists and is the expected type
```

To address this, remove the RabbitMQ cert from `/etc/travis/ssl/`:

```
$ sudo rm -r /etc/travis/ssl/rabbitmq.cert
```
After this, do a full reboot of the system and everything should start again properly.

## View Sidekiq queue statistics

In the past there have been reported cases where the system became unresponsive,
it took long until jobs where worked off or weren't picked up at all. We found
out that oftentimes full Sidekiq queues played a part in this. To get some
insight about it helps to get some basics statistics in the Ruby console:

```
  $ travis console
  >> require 'sidekiq/api'
  => true
  >> stats = Sidekiq::Stats.new
  >> stats.queues
  => {"sync.low"=>315316,
      "archive"=>7900,
      "repo_sync"=>193,
      "webhook"=>0,
      "keen_events"=>0,
      "scheduler"=>0,
      "github_status"=>0,
      "build_requests"=>0,
      "build_restarts"=>0,
      "hub"=>0,
      "slack"=>0,
      "pusher"=>0,
      "pusher-live"=>0,
      "build_cancellations"=>0,
      "sync"=>0,
      "user_sync"=>0}
```
## Uninstall Travis CI Enterprise

If you wish to uninstall Travis CI Enterprise from your platform and worker
machines, please follow the instructions below. On the platform machine, you
need to run the following commands in order. <small>(Instructions copied over
from <a href="https://www.replicated.com/docs/distributing-an-application/installing-via-script/#removing-replicated">Replicated</a>)</small>

```
service replicated stop
service replicated-ui stop
service replicated-operator stop
docker stop replicated-premkit
docker stop replicated-statsd
docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd
docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
apt-get remove -y replicated replicated-ui replicated-operator
apt-get purge -y replicated replicated-ui replicated-operator
rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
```

On the worker machine, you need to run this command:

```
$ sudo apt-get autoremove travis-worker
```
