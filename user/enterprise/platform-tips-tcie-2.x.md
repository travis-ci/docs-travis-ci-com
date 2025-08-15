---
title: TCIE 2.x Platform Administration Tips
layout: en_enterprise

---

This section collects FAQs and day-to-day Travis CI Enterprise (TCIE) Platform maintenance scripts and tools. 

Please connect to your Platform machine via SSH before getting started.

## Platform Logs in TCIE 2.x

On the Platform, you can find the main log file at
`/var/travis/log/travis.log`. They are also symlinked to
`/var/log/travis.log` for convenience.

## Container and Console access in TCIE 2.x 

`travis bash`: This will get you into the running container on the
Platform.

`travis console`: This will get you into a Ruby IRB session on the
Platform.

## Cancel or Reset Jobs

Occasionally, jobs can get stuck in a `queued` state on the worker. To cancel or
reset a large number of jobs, please execute the following steps:

**TCIE 2.x**: `$ travis console` *on Platform host*

Then, run:

```
>> stuck_jobs = Job.where(queue: 'builds.linux', state: 'queued').where('queued_at < NOW() - interval \'60 minutes\'').all
>> # Cancels all stuck jobs
>> stuck_jobs.each(&:cancel!)
>> # Or reset them
>> stuck_jobs.each(&:reset!)
```

## Clear Redis Archive Queue (V2.1.7 and prior)

In Enterprise releases before 2.1.7, jobs were enqueued in the archive queue
for log aggregation. Currently, this feature is available only for the hosted
versions of Travis CI.

This results in the queue growing bigger and bigger but not getting worked
off. Because of that, Redis' memory consumption increases over time and can
lead to decreased performance of the whole platform. The solution is to clear the `archive` queue to free system resources.

To clear it, please execute the following command:

**TCIE 2.x**: `$ travis console` *on Platform host*

Then, run:

```
>> require 'sidekiq/api'
>> Sidekiq::Queue.new('archive').clear
```

## Reset the RabbitMQ Certificate in TCIE 2.x

After an upgrade of Replicated 2.8.0 to a newer version, occasionally, the service
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
if the specified host path exists and is the expected type.
```

To address this, remove the RabbitMQ cert from `/etc/travis/ssl/`:

```
$ sudo rm -r /etc/travis/ssl/rabbitmq.cert
```
After this, do a full reboot of the system, and everything should start properly again.

## View Sidekiq Queue Statistics

In the past, there have been reported cases where the system became unresponsive. It took quite a while until jobs were worked off or they weren't picked up. We found out that full Sidekiq queues often played a part in this. To get some insight, it helps to retrieve some basic statistics in the Ruby console:

**TCIE 2.x**: `$ travis console` *on Platform host*

Then, run:

```
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

## Uninstall Travis CI Enterprise 2.x

If you wish to uninstall Travis CI Enterprise 2.x from your platform and worker
machines, please follow the instructions below. You
need to run the following commands on the platform machine in order. <small>(Instructions copied over
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

### With Ubuntu 14.04 as host operating system

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

Additionally, please use the following command to clean up all Docker build images:

```
$ sudo docker images | grep travis | awk '{print $3}' | xargs sudo docker rmi -f
```

## Discover the Maximum Available Concurrency

To find out how much concurrency is available in your Travis CI Enterprise setup:

**TCIE 2.x**: connect to your platform machine via SSH and run `$ travis bash`

Then, please run:

```
root@te-main:/# rabbitmqctl list_consumers -p travis | grep builds.trusty | wc -l
```

The number that's returned here is equal to the maximum number of concurrent jobs that are available. To adjust concurrency, please follow the instructions [here](/user/enterprise/worker-configuration/#configuring-the-number-of-concurrent-jobs) for each worker machine.

## Discover how many Worker Machines are Connected

If you wish to find out how many worker machines are currently connected, please follow these steps:

**TCIE 2.x**: connect to your platform machine via SSH and run: `$ travis bash`

Then, run:

```
root@te-main:/# rabbitmqctl list_consumers -p travis | grep amq.gen- | wc -l
```

If you need to boot more worker machines, please see our docs about [installing new worker machines](/user/enterprise/setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine).

## Create Data Directories backup in TCIE 2.x
The data directories are located on the platform machine and are mounted into the Travis CI container. In these directories, you'll find files from RabbitMQ, Postgres, Slanger, Redis, and log files from the various applications inside the container.

The files are located at `/var/travis` on the platform machine. Please run `sudo tar -czvf travis-enterprise-data-backup.tar.gz /var/travis` to create a compressed archive from this folder. After this has finished, copy this file off the machine to a secure location.

## Migrate from GitHub Services to Webhooks

Travis CI Enterprise initially used GitHub Services to connect your repositories with GitHub.com (or GitHub Enterprise). As of January 31st, 2019, [services have been disabled on github.com](https://developer.github.com/changes/2019-01-29-life-after-github-services/). Services will also be disabled on GitHub Enterprise starting with GitHub Enterprise v2.17.0.

Starting with [Travis CI Enterprise v2.2.5](https://enterprise-changelog.travis-ci.com/release-2-2-5-77988), all repositories that are activated use [webhooks](https://developer.github.com/webhooks/) to connect and manage communication with GitHub.com/GitHub Enterprise.

> Repositories activated before Travis CI Enterprise v2.2.5 may need to be updated.

To perform an automatic migration, please follow these steps:

1. **TCIE 2.x only**: Open an SSH connection to the platform machine.
2. Run the following command:
```
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks <optional-year>"
```
This will search for all active repositories still using GitHub Services and migrate them to webhooks instead.

You can provide a year argument (e.g., `2017`) in the above command to only migrate repositories activated on Travis CI Enterprise during that year.

If you have a large number of repositories activated on your Travis CI Enterprise installation, please run the migration several times, breaking it down per year. For example:

```
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2019"
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2018"
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2017"
```

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
