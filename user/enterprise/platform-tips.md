---
title: Enterprise Platform Administration Tips
layout: en_enterprise

---

This page collects FAQs and day-to-day Travis CI Enterprise (TCIE) Platform maintenance scripts
and tools. 

**TCIE 3.x**: Please use `kubectl` *on your local machine* to access your Platform pods

## Inspect Logs and Run Services

The following section describes how to inspect logs on different platforms and how to run the services. 

### Platform logs in TCIE 3.x

In TCIE 3.x, each service is deployed in a separate pod. The service logs are
not stored within a pod and are delivered to stdout.

In order to obtain live logs from a specific running pod, one can run *on your local machine*

`kubectl logs [pod-name]`

> We strongly recommend setting up an instance of grabbing live logs from pods stdout and storing them in the logging storage of your choice. These stored logs can be useful when diagnosing or troubleshooting situations for pods that were killed and/or re-deployed. The size of the logs depends strictly on your usage, thus please adjust to your needs. As a rule of thumb, a 4-weeks of log storage would be recommended.

### Worker logs

This section describes how to obtain worker logs with Ubuntu as the host operating system. 

#### With Ubuntu 16.04 and higher 

On the Worker, you can obtain the worker logs by running:

```sh
$ sudo journalctl -u travis-worker
```

#### With Ubuntu 14.04 

On the Worker, you can find the main log file at
`/var/log/upstart/travis-worker.log`

## Access Travis Container and Console on the Platform

### Console access in TCIE 3.x

For TCIE 3.x, you gain access to individual pods through the `kubectl` command (The equivalent to `travis bash` in Enterprise 2.x versions)
In order to run console commands, run the console in `travis-api-pod`:

`kubectl exec -it [travis-api-pod] /app/script/console`

## Cancel or Reset Stuck Jobs

Occasionally, jobs can get stuck in a `queued` state on the worker. To cancel or
reset a large number of jobs, please execute the following steps:

**TCIE 3.x**: `kubectl exec -it [travis-api-pod]j /app/script/console` *on your local machine*

Then, please run:

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

**TCIE 3.x**: `kubectl exec -it [travis-api-pod]j /app/script/console` *on your local machine*

Then, please run:

```
>> require 'sidekiq/api'
>> Sidekiq::Queue.new('archive').clear
```

## Manage RabbitMQ in TCIE 3.x

RabbitMQ is now deployed in a separate pod named `travisci-platform-rabbitmq-ha-0`, and all Rabbit-related maintenance should be done there.
In order to access the RabbitMQ pod, execute 

`kubectl exec -it travisci-platform-rabbitmq-ha-0 bash`

and perform any necessary actions.

The RabbitMQ management UI is available under `https://[platform-hostname]/amqp_ui`.


## View Sidekiq Queue Statistics

In the past, there have been reported cases where the system became unresponsive. It took quite a while until jobs were worked off, or they weren't picked up at all. We found out that full Sidekiq queues often played a part in this. To get some insight, it helps to retrieve some basic statistics in the Ruby console:

**TCIE 3.x**: `kubectl exec -it [travis-api-pod]j /app/script/console` *on your local machine*

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

## Uninstall Travis CI Enterprise 3.x

If you wish to uninstall Travis CI Enterprise 3.x from your Kubernetes cluster, please execute:

`kubectl delete ns [namespace]` *on your local machine*

On the worker machine, you need to run this command to remove travis-worker and all build images:

```sh
$ sudo docker images | grep travis | awk '{print $3}' | xargs sudo docker rmi -f
```

## Discover the Maximum Available Concurrency

To find out how much concurrency is available in your Travis CI Enterprise setup:


**TCIE 3.x**: `kubectl exec -it travisci-platform-rabbitmq-ha-0 bash` *on your local machine*

Then, please run:

```
root@te-main:/# rabbitmqctl list_consumers -p travis | grep builds.trusty | wc -l
```

The number that's returned here is equal to the maximum number of concurrent jobs that are available. To adjust concurrency, please follow the instructions [here](/user/enterprise/worker-configuration/#configuring-the-number-of-concurrent-jobs) for each worker machine.

## Discover how many Worker Machines are Connected

If you wish to find out how many worker machines are currently connected, please follow these steps:

**TCIE 3.x**: `kubectl exec -it travisci-platform-rabbitmq-ha-0 bash`

Then, please run:

```
root@te-main:/# rabbitmqctl list_consumers -p travis | grep amq.gen- | wc -l
```

If you need to boot more worker machines, please see our docs about [installing new worker machines](/user/enterprise/setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine).

## Integrate Travis CI Enterprise into your Monitoring

To check if your Travis CI Enterprise 3.x installation is up and running, query the `/api/uptime` endpoint of your instance.

```
$ curl -H "Authorization: token XXXXX" https://<your-travis-ci-enterprise-domain>/api/uptime
```

If everything is up and running, it answers with a `HTTP 200 OK`, or in case of failure with an `HTTP 500 Internal Server Error`.


## Configure Backups

This section explains how you integrate Travis CI Enterprise into your backup strategy. Here, we'll talk about two topics:

- [The encryption key](#encryption-key)
- [The data directories](#create-a-backup-of-the-data-directories)

### Encryption key

Without the encryption key, you cannot access the information in your production database. To ensure you can always recover your database, make a backup of this key.

> Without the encryption key, the information in the database is not recoverable.

{{ site.data.snippets.enterprise_3_encryption_key_backup }}

{{ site.data.snippets.enterprise_2_encryption_key_backup }}

### Create a backup of the data directories

Unless you run self-hosted PostgreSQL, RabbitMQ, and Redis instances, the respective data is held in pods hosting these services.

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

Also, you need to connect to the **Redis** and **RabbitMQ** pods, perform data dumps, and copy them out of the cluster in a similar way, using tools available for these services. See the respective parts of [Redis documentation](https://redis.io/documentation) and [RabbitMQ Backup & Restore guide](https://www.rabbitmq.com/backup.html) for exact instructions on how to snapshot/backup the current state of data.


## Migrate from GitHub Services to Webhooks

Travis CI Enterprise initially used GitHub Services to connect your repositories with GitHub.com (or GitHub Enterprise). As of January 31st, 2019, [services have been disabled on github.com](https://developer.github.com/changes/2019-01-29-life-after-github-services/). Services will also be disabled on GitHub Enterprise starting with GitHub Enterprise v2.17.0.

Starting with [Travis CI Enterprise v2.2.5](https://enterprise-changelog.travis-ci.com/release-2-2-5-77988), all repositories that are activated use [webhooks](https://developer.github.com/webhooks/) to connect and manage communication with GitHub.com/GitHub Enterprise.

> Repositories activated before Travis CI Enterprise v2.2.5 may need to be updated.

Starting with Travis CI Enterprise v2.2.8, a migration tool to automatically update repositories is available. The migration tool will update repositories using the deprecated GitHub services instead of webhooks.

To perform an automatic migration, please follow these steps:

```bash
kubectl exec -it [travis-api-pod] bash
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks <optional-year>
```

This will search for all active repositories still using GitHub Services and migrate them to webhooks instead.

You can provide a year argument (e.g., `2017`) in the above command to only migrate repositories activated on Travis CI Enterprise during that year.

If you have a large number of repositories activated on your Travis CI Enterprise installation, please run the migration several times, breaking it down per year. For example:

```bash
kubectl exec -it [travis-api-pod] bash
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks 2019
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks 2018
root@[travis-api-pod]:/# bundle exec /app/bin/migrate_hooks 2017
```

You should not experience any behavior change with your repositories after the migration is complete.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
