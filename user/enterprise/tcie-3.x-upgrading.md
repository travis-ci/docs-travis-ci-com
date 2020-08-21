---
title: Upgrading Travis CI Enterprise 3.x
layout: en_enterprise

---

## Backups

> Before upgrading, we **strongly recommend** making a backup of PostgreSQL database, Redis and RabbitMQ data.

### Encryption Key

Without the encryption key you cannot access the information in your production database. To make sure that you can always recover your database, make a backup of this key.

> Without the encryption key the information in the database is not recoverable.

To make a backup, please follow these steps:

1. Make sure you have appropriate access to the kubernetes cluster
2. run `kubectl exec -it [travis-api-pod] cat /app/config/travis.yml |grep -A 2 encryption`. Create a backup of the value returned by that command by either writing it down on a piece of paper or storing it on a different computer.

## Updating your Travis CI Enterprise Platform

Run `kubectl kots admin-console -n [namspace]` to access admin console on `http://localhost:8800`.

Click *Check for updates* in *Version history* menu:

![Check for updates](/images/tcie-3.x-check-updates.png)

If there’s a new version it will appear in *all versions* list. Click *deploy* to replace current installation with a new version:

![All versions](/images/tcie-3.x-list-of-versions.png)

> There will be a small amount of downtime while an update is installed. For this reason we recommend that you perform each update during a maintenance window.

## Updating Replicated on the Platform

To update Replicated KOTS version on the Platform installation you'll want to run
following command:

`curl https://kots.io/install | bash`


## Updating your Travis CI Enterprise Worker

### On Ubuntu 16.04 and later

On Ubuntu 16.04 and later, travis-worker ships inside a Docker container. To update travis-worker, please follow the steps below.

  1. Configure the new image by editing the Docker tag in `/etc/systemd/system/travis-worker.service.d/env.conf`:
  ```
  [Service]
  Environment="TRAVIS_WORKER_SELF_IMAGE=travisci/worker:v4.6.1"
  ```
  1. Reload the configuration and restart the service:
  ```
  $ sudo systemctl daemon-reload
  $ sudo systemctl restart travis-worker
  ```

### On Ubuntu 14.04

In order to update the Worker, you can run the following on each worker
host:

```
$ sudo apt-get update
$ sudo apt-get install travis-worker
```

## Restoring from Backups

In the rare event something goes wrong and/or you'd like to restore from a backup, please use the following steps:

1. Make sure you have backed up PostgreSQL database, Redis and RabbitMQ data - these services should be separate pods in Kubernetes cluster or run by you externally to TCIE 3.x installation
2. Make a fresh install of Travis CI
3. Restore the data in aforementioned tools in respective pods using their specific restore commands

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
