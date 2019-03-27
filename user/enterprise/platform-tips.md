---
title: Enterprise Platform Administration Tips
layout: en_enterprise

---

This page collects FAQs and day-to-day Enterprise Platform maintenance scripts
and tools. Please connect to your Platform machine via SSH before getting
started.

## Inspecting logs and running services

### Platform logs

On the Platform you can find the main log file at
`/var/travis/log/travis.log`. They are also symlinked to
`/var/log/travis.log` for convenience.

### Worker logs

#### With Ubuntu 16.04 as host operating system

On the Worker you can obtain the worker logs by running:

```sh
$ sudo journalctl -u travis-worker
```

#### With Ubuntu 14.04 as host operating system

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
from <a href="https://help.replicated.com/docs/native/customer-installations/installing-via-script/">Replicated</a>)</small>

### With Ubuntu 16.04 as host operating system

```sh
sudo systemctl stop replicated
sudo systemctl stop replicated-ui
sudo systemctl stop replicated-operator
sudo docker ps | grep "replicated" | awk '{print $1}' | xargs sudo docker stop
sudo docker ps | grep "quay.io-travisci-te-main" | awk '{print $1}' | xargs sudo docker stop
sudo docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd
sudo docker images | grep "replicated" | awk '{print $3}' | xargs sudo docker rmi -f
sudo docker images | grep "te-main" | awk '{print $3}' | xargs sudo docker rmi -f
sudo rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
```

On the worker machine, you need to run this command to remove travis-worker and all build images:

```sh
$ sudo docker images | grep travis | awk '{print $3}' | xargs sudo docker rmi -f
```

#### With Ubuntu 14.04 as host operating system

```sh
sudo service replicated stop
sudo service replicated-ui stop
sudo service replicated-operator stop
sudo docker stop replicated-premkit
sudo docker stop replicated-statsd
sudo docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd
sudo docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
sudo apt-get remove -y replicated replicated-ui replicated-operator
sudo apt-get purge -y replicated replicated-ui replicated-operator
sudo rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
```

On the worker machine, you need to run this command to remove travis-worker:

```
$ sudo apt-get autoremove travis-worker
```

Additionally, please the following command to clean up all Docker build images:

```
$ sudo docker images | grep travis | awk '{print $3}' | xargs sudo docker rmi -f
```

## Find out maximum available concurrency

To find out how much concurrency is available in your Travis CI Enterprise setup, connect to your platform machine via ssh and run:

```
$ travis bash
root@te-main:/# rabbitmqctl list_consumers -p travis | grep builds.trusty | wc -l
```

The number that's returned here is equal to the maximum number of concurrent jobs that are available. To adjust concurrency, please follow the instructions [here](/user/enterprise/worker-configuration/#configuring-the-number-of-concurrent-jobs) for each worker machine.

## Find out how many worker machines are connected

If you wish to find out how many worker machines are currently connected, please connect to your platform machine via ssh and follow these steps:

```
$ travis bash
root@te-main:/# rabbitmqctl list_consumers -p travis | grep amq.gen- | wc -l
```

If you need to boot more worker machines, please see our docs about [installing new worker machines](/user/enterprise/setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine).

## Integrate Travis CI Enterprise into your monitoring

To check if your Travis CI Enterprise installation is up and running, query the `/api/uptime` endpoint of your instance.

```
$ curl -H "Authorization: token XXXXX" https://<your-travis-ci-enterprise-domain>/api/uptime
```

If everything is up and running, it answers with a `HTTP 200 OK`, or in case of failure with a `HTTP 500 Internal Server Error`.


## Configuring Backups

This section explains how you integrate Travis CI Enterprise in your backup strategy. Here, we'll talk about two topics:

- [The encryption key](#encryption-key)
- [The data directories](#create-a-backup-of-the-data-directories)

### Encryption key

Without the encryption key you cannot access the information in your production database. To make sure that you can always recover your database, make a backup of this key.

> Without the encryption key the information in the database is not recoverable.

To make a backup, please follow these steps:

1. Open a ssh connection to the platform machine.
2. Open a bash session with `root` privileges on the Travis CI container by running `travis bash`.
3. Run the following command to obtain the key: `grep -A1 encryption: /usr/local/travis/etc/travis/config/travis.yml`.
4. Create a backup of the value returned by the previous command by either writing it down on a piece of paper or storing it on a different computer.

### Create a backup of the data directories

The data directories are located on the platform machine and are mounted into the Travis CI container. In these directories you'll find files from RabbitMQ, Postgres, Slanger, Redis, and also log files from the various applications inside the container.

The files are located at `/var/travis` on the platform machine. Please run `sudo tar -czvf travis-enterprise-data-backup.tar.gz /var/travis` to create compressed archive from this folder. After this has finished, copy this file off the machine to a secure location.

## Migrating from GitHub services to webhooks

Travis CI Enterprise initially used GitHub Services to connect your repositories with GitHub.com (or GitHub Enterprise). As of January 31st, 2019 [services have been disabled on github.com](https://developer.github.com/changes/2019-01-29-life-after-github-services/). Services will also be disabled on GitHub Enterprise starting with GitHub Enterprise v2.17.0.

Starting with [Travis CI Enterprise v2.2.5](https://enterprise-changelog.travis-ci.com/release-2-2-5-77988) all repositories that are activated use [webhooks](https://developer.github.com/webhooks/) to connect and manage communication with GitHub.com/GitHub Enterprise.

Repositories that were activated prior to Travis CI Enterprise v2.2.5 may need to be updated.

Starting with Travis CI Enterprise v2.2.8, a migration tool to automatically update repositories is available. The migration tool will update repositories that are using the deprecated GitHub services to instead use webhooks.

To perform an automatic migration please follow these steps:

1. Open a ssh connection to the platform machine.
2. Run the following command:

```
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks <optional-year>"
```

This will search for all active repositories that are still using GitHub Services and migrate them to use webhooks instead.

You can provide a year argument (e.g. `2017`) in the above command to only migrate repositories activated on Travis CI Enterprise during that year. 

If you have a large number of repositories activated on your Travis CI Enterprise installation, please run the migration several times, breaking it down per year. For example: 

```
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2019"
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2018"
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2017"
```

You should see no behavior change with your repositories after the migration is complete.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
