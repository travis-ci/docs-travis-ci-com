---
title: Enterprise Platform Administration Tips
layout: en_enterprise

---

This page collects FAQs and day-to-day Travis CI Enterprise (TCIE) Platform maintenance scripts
and tools. 

**TCIE 3.x**: Please use `kubectl` *on your local machine* to access your Platform pods

**TCIE 2.x**: Please connect to your Platform machine via SSH before getting
started.

## Inspecting Logs and Running Services

### Platform logs

#### Logs in TCIE 3.x

In TCIE 3.x each service is deployed in separate pod. The service logs are
not stored within a pod and are delivered to stdout.

In order to obtain live logs from specific running pod, one can run *on your local machine*

`kubectl logs [pod-name]`

> We strongly recommend to set up an instance grabbing live logs from pods stdout and storing them in logging storage of your choice. These stored logs can be useful when diagnosing or troubleshooting situations for pods which were killed and/or re-deployed. The size of the logs depends strictly on your usage, thus please adjust to your needs. As a rule of thumb, a 4-weeks of log storage would be recommended.


#### Logs in TCIE 2.x

On the Platform you can find the main log file at
`/var/travis/log/travis.log`. They are also symlinked to
`/var/log/travis.log` for convenience.

### Worker logs

#### With Ubuntu 16.04 and later as host operating system

On the Worker you can obtain the worker logs by running:

```sh
$ sudo journalctl -u travis-worker
```

#### With Ubuntu 14.04 as host operating system

On the Worker you can find the main log file at
`/var/log/upstart/travis-worker.log`

## Accessing Travis Container and Console on the Platform

### Console access in TCIE 3.x

For TCIE 3.x, you gain access to individual pods through the `kubectl` command (The equivalent to `travis bash` in Enterprise 2.x versions)
In order to run console commands, run console in `travis-api-pod` :

`kubectl exec -it [travis-api-pod] /app/script/console`


### Container and Console access in TCIE 2.x 

`travis bash`: This will get you into the running container on the
Platform.

`travis console`: This will get you into a Ruby IRB session on the
Platform.

## Cancelling or Resetting Stuck Jobs

Occasionally, jobs can get stuck in a `queued` state on the worker. To cancel or
reset a large number of jobs, please execute the following steps:

**TCIE 3.x**: `kubectl exec -it [travis-api-pod]j /app/script/console` *on your local machine*

**TCIE 2.x**: `$ travis console` *on Platform host*

Then, please run:

```
>> stuck_jobs = Job.where(queue: 'builds.linux', state: 'queued').where('queued_at < NOW() - interval \'60 minutes\'').all
>> # Cancels all stuck jobs
>> stuck_jobs.each(&:cancel!)
>> # Or reset them
>> stuck_jobs.each(&:reset!)
```

## Clearing Redis Archive Queue (for releases < 2.1.7)

In releases of Enterprise before 2.1.7, jobs where enqueued in the archive queue
for log aggregation. Currently, this feature is available only for the hosted
versions of Travis CI.

This results in the queue growing bigger and bigger, but not getting worked
off. Because of that, Redis' memory consumption increases over the time and can
lead to decreased performance of the whole platform. The solution is to clear the `archive` queue to free system resources.

To clear it, please execute the following commands:

**TCIE 3.x**: `kubectl exec -it [travis-api-pod]j /app/script/console` *on your local machine*

**TCIE 2.x**: `$ travis console` *on Platform host*

Then, please run:

```
>> require 'sidekiq/api'
>> Sidekiq::Queue.new('archive').clear
```

## Managing RabbitMQ in TCIE 3.x

RabbitMQ is now deployed in separate pod named `travisci-platform-rabbitmq-ha-0` and all Rabbit-related maintenance should be done there.
In order to access RabbitMQ pod execute 

`kubectl exec -it travisci-platform-rabbitmq-ha-0 bash`

and perform any necessary actions.

The RabbitMQ management UI is available under `https://[platform-hostname]/amqp_ui`.

## Resetting the RabbitMQ Certificate in TCIE 2.x

After an upgrade of Replicated 2.8.0 to a newer version, occasionally the service
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


## Viewing Sidekiq Queue Statistics

In the past there have been reported cases where the system became unresponsive. It took quite a while until jobs where worked off or they weren't picked up at all. We found out that often full Sidekiq queues played a part in this. To get some insight, it helps to retrieve some basics statistics in the Ruby console:

**TCIE 3.x**: `kubectl exec -it [travis-api-pod]j /app/script/console` *on your local machine*

**TCIE 2.x**: `$ travis console` *on Platform host*

Then, please run:

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

## Uninstalling Travis CI Enterprise 3.x

If you wish to uninstall Travis CI Enterprise 3.x from your Kubernetes cluster, please execute:

`kubectl delete ns [namespace]` *on your local machine*

On the worker machine, you need to run this command to remove travis-worker and all build images:

```sh
$ sudo docker images | grep travis | awk '{print $3}' | xargs sudo docker rmi -f
```


## Uninstalling Travis CI Enterprise 2.x

If you wish to uninstall Travis CI Enterprise 2.x from your platform and worker
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

Additionally, please use the following command to clean up all Docker build images:

```
$ sudo docker images | grep travis | awk '{print $3}' | xargs sudo docker rmi -f
```

## Finding out about the Maximum Available Concurrency

To find out how much concurrency is available in your Travis CI Enterprise setup:


**TCIE 3.x**: `kubectl exec -it travisci-platform-rabbitmq-ha-0 bash` *on your local machine*

**TCIE 2.x**: connect to your platform machine via SSH and run `$ travis bash`

Then, please run:

```
root@te-main:/# rabbitmqctl list_consumers -p travis | grep builds.trusty | wc -l
```

The number that's returned here is equal to the maximum number of concurrent jobs that are available. To adjust concurrency, please follow the instructions [here](/user/enterprise/worker-configuration/#configuring-the-number-of-concurrent-jobs) for each worker machine.

## Finding out how Many Worker Machines are Connected

If you wish to find out how many worker machines are currently connected, please follow these steps:

**TCIE 3.x**: `kubectl exec -it travisci-platform-rabbitmq-ha-0 bash`

**TCIE 2.x**: connect to your platform machine via SSH and run: `$ travis bash`

Then, please run:

```
root@te-main:/# rabbitmqctl list_consumers -p travis | grep amq.gen- | wc -l
```

If you need to boot more worker machines, please see our docs about [installing new worker machines](/user/enterprise/setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine).

## Integrating Travis CI Enterprise into Your Monitoring

To check if your Travis CI Enterprise 2.x/3.x installation is up and running, query the `/api/uptime` endpoint of your instance.

```
$ curl -H "Authorization: token XXXXX" https://<your-travis-ci-enterprise-domain>/api/uptime
```

If everything is up and running, it answers with a `HTTP 200 OK`, or in case of failure with an `HTTP 500 Internal Server Error`.


## Configuring Backups

This section explains how you integrate Travis CI Enterprise in your backup strategy. Here, we'll talk about two topics:

- [The encryption key](#encryption-key)
- [The data directories](#create-a-backup-of-the-data-directories)

### Encryption key

Without the encryption key you cannot access the information in your production database. To make sure that you can always recover your database, make a backup of this key.

> Without the encryption key the information in the database is not recoverable.

{{ site.data.snippets.enterprise_3_encryption_key_backup }}

{{ site.data.snippets.enterprise_2_encryption_key_backup }}

### Creating a backup of the data directories

#### Data backup in TCIE 3.x

Unless you are running self-hosted instances of PostgreSQL, RabbitMQ and Redis, the respective data is held in pods hosting these services.

In order to back up the Postgres database, you need the database credentials and connection string. On the TCIE 3.x Platform pod, please run:

`kubectl exec -it [travis-api-pod] bash`

Once you're connected to the pod, grab the database configuration data:

`root@[travis-api-pod]:/app# cat /app/config/travis.yml | grep database -A 10`

You are looking for nodes `database:` and `logs_database:`. Note down from the result:

```yml
database:
  # ....
  host: [main db host name]
  port: [main db port]
  database: [main db name]
  username: [user name]
  password: [password]
#...
logs_database:
  urls: postgres://[username]:[password]@[logs db host name]:[port]/[database name]
```

Next, connect to the database pod and perform data dumps for each database:

```bash
root@[travis-api-pod]:/# pg_dump -U travis -h [main database pod] -p [main database port] -C -d [main db name] > [Main DB].sql
root@[travis-api-pod]:/# pg_dump -U travis -h [logs database pod] -p [logs database port] -C -d [logs db name] > [Logs DB].sql
```

Afterward, copy the dumped data from your cluster, running on *your local machine*:

```bash
kubectl cp [travis-api-pod]:/[location of [Main DB].sql] [local_file] 
kubectl cp [travis-api-pod]:/[location of [Logs DB].sql] [local_file] 
```

> In case you would like to run pg_dump straight from the DB pod: Database pods in TCIE 3.x cluster in non-HA deployment should be named `travisci-platform-platform-postgresql-0` and `travisci-platform-logs-postgresql-0`

Also, you need to connect to the **Redis** and **RabbitMQ** pods, perform data dumps and copy them out of the cluster in a similar way, using tools available for these services. See the respective parts of [Redis documentation](https://redis.io/documentation) and [RabbitMQ Backup & Restore guide](https://www.rabbitmq.com/backup.html) for exact instructions on how to snapshot/backup current state of data.


#### Data backup in TCIE 2.x
The data directories are located on the platform machine and are mounted into the Travis CI container. In these directories you'll find files from RabbitMQ, Postgres, Slanger, Redis, and also log files from the various applications inside the container.

The files are located at `/var/travis` on the platform machine. Please run `sudo tar -czvf travis-enterprise-data-backup.tar.gz /var/travis` to create a compressed archive from this folder. After this has finished, copy this file off the machine to a secure location.

## Migrating from GitHub Services to Webhooks

Travis CI Enterprise initially used GitHub Services to connect your repositories with GitHub.com (or GitHub Enterprise). As of January 31st, 2019 [services have been disabled on github.com](https://developer.github.com/changes/2019-01-29-life-after-github-services/). Services will also be disabled on GitHub Enterprise starting with GitHub Enterprise v2.17.0.

Starting with [Travis CI Enterprise v2.2.5](https://enterprise-changelog.travis-ci.com/release-2-2-5-77988), all repositories that are activated use [webhooks](https://developer.github.com/webhooks/) to connect and manage communication with GitHub.com/GitHub Enterprise.

> Repositories that were activated prior to Travis CI Enterprise v2.2.5 may need to be updated.

Starting with Travis CI Enterprise v2.2.8, a migration tool to automatically update repositories is available. The migration tool will update repositories that are using the deprecated GitHub services instead of webhooks.

To perform an automatic migration, please follow these steps:

1. **TCIE 2.x only**: Open an SSH connection to the platform machine.
2. Run the following command:

**TCIE 3.x**:

```bash
kubectl exec -it [travis-api-pod] bash
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks <optional-year>
```

**TCIE 2.x**:
```
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks <optional-year>"
```


This will search for all active repositories that are still using GitHub Services and migrate them to use webhooks instead.

You can provide a year argument (e.g. `2017`) in the above command to only migrate repositories activated on Travis CI Enterprise during that year.

If you have a large number of repositories activated on your Travis CI Enterprise installation, please run the migration several times, breaking it down per year. For example:

**TCIE 3.x**:

```bash
kubectl exec -it [travis-api-pod] bash
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks 2019
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks 2018
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks 2017
```

**TCIE 2.x**:
```
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2019"
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2018"
travis bash -c ". /etc/profile; cd /usr/local/travis-api && ENV=production bundle exec ./bin/migrate-hooks 2017"
```

You should not experience any behavior change with your repositories after the migration is complete.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
