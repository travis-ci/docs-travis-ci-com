---
title: Travis CI Enterprise Operations manual
layout: en_enterprise

---

This document is meant as a guideline to follow in case your Travis CI Enterprise production installation becomes unresponsive or unavailable.

If this happens, we'd like to ask you to follow the steps outlined in this document first before you get in touch with us to save important data and collect as much evidence as possible. This will help us to provide you the best support possible and focus completely on resolving the problem.

## First: Don't panic

The first thing you should do is: keep calm. We're here to help and we're confident that we can bring it back online together with you!

## Prerequisites

Please make sure that you have root access on all machines Travis CI Enterprise is running on. This is crucial because we will ask you to perform operations where you either need to be root or you need to have the appropriate `sudo` privileges. If you don't have direct root privileges, please make sure that a person who has is available.

## Coordinating with Support

We are here to help troubleshoot and fix any problems that may arise with your Travis CI Enterprise installation. For efficiency, though, we would request you minimize making changes to your setup that are not directly recommended by support, or document these steps and notify support accordingly.

## Terminology

To make sure that there are no confusions, we'd like to define a couple of terms:

- `Platform machine`: The machine that runs most of the Travis web components. This is the machine your domain is pointing to.
- `Worker machine`: The worker machine(s) run your builds.

## Backup your encryption key

This key is a very important building block in Travis CI Enterprise. It is used to encrypt certain parts of your production database. _Without this key the information in the database is not recoverable._ To make sure that the database remains accessible we ask you to make a backup of this key by following the steps below:

- open a ssh connection to the platform machine
- run `travis bash`. This will open a bash session with `root` privileges into the Travis container.
- Then run `cat /usr/local/travis/etc/travis/config/travis.yml | grep -A1 encryption:`. Create a backup of value getting printed on the screen by either  writing it down on a piece of paper or storing it on a different computer.

## Create a backup of the data directories

The data directories are located on the platform machine and get mounted into the Travis container. In there you'll find files from RabbitMQ, Postgres, Slanger and Postgresql.

These files are located at `/var/travis`. Please run `sudo tar -czvf travis-enterprise-data-backup.tar.gz /var/travis` to create compressed archive from this folder. After this has finished, copy this file off the machine to a secure location.

## Pull a Support bundle

Please head over to https://<your domain>:8800/support and create a support bundle. If you're writing us, please include that file. It'll include all important log files which will help us to diagnose the problem.

Also please include the worker log files as well. They're located on your worker machine(s) at `/var/log/upstart/travis-worker.log`. If you run multiple worker machines, please grab this file from all machines.

## What exactly is not running?

What unusual behaviour are you seeing right now?

- A build does not get picked up?
- A build does not get enqueued after a `git push` or a freshly created Pull Request?
- ...

When you're writing to us, please include this information. We're also interested in recent changes in your IT landscape. For instance: Did your GitHub Enterprise Installation receive an update recently?

## Firewall

Are all machines online? Can they talk to each other? Please check this beforehand. If you're using a firewall, please make sure that these ports are open and the machines accept traffic on these:

__Worker:__

- Port 22 for SSH access

__Platform machine__:

- Port 22 for SSH access
- Port 443 for HTTPS traffic
- Port 80 for HTTP traffic
- Port 4567 & 5672 for RabbitMQ traffic
- Port 8800 for management dashboard https traffic

## Hardware

Our platform machine has these hardware requirements:

- Minimum 16GB of RAM
- 8 CPU cores
- Min. 40GB of available disk space

When you run `top` on the platform machine, please check if enough RAM is available and that the system load is not too high.
Did you notice an increased system load recently?

## Docker

We use a tool called [Replicated](https://www.replicated.com/) to distribute Travis CI Enterprise. It also provides the management dashboard you're using to configure certain things.

Replicated and Travis CI Enterprise are both shipped as Docker containers. Therefore we have to rely on a perfectly working Docker installation. In the past we've seen incidents where the customers production system became unavailable because Docker related configuration has changed for various reasons.

Therefore we need to have some things in line:

- Your currently used Docker version needs to be at least 1.7 on both platform and worker machines.
- For the platform machine, these port bindings have to be in place (run `sudo docker ps -a` and look for a container whose name starts with `quay.io-travisci-te-main`):
	- 0.0.0.0:80->80/tcp
	- 0.0.0.0:443->443/tcp
	- 0.0.0.0:4567->4567/tcp
	- 0.0.0.0:5672->5672/tcp
	- 0.0.0.0:32770->22/tcp
- If the above port bindings are not there, please let us know. Then we'll figure out how to get them back.
- An important topic is the used storage driver. In the past we've heavily relied on the `devicemapper` storage driver. At some point Docker changed their default storage driver to `overlay`. However this only works well if your Linux kernel is at least version 3.18. Below it *can* work but there's no definite guarantee. To find out the used storage driver, please run `sudo docker info | grep "Storage Driver"`. If your current driver is `overlay`, please check your Linux kernel version via `uname -a`.

## Worker
The `travis-worker` binary on the worker machine(s) must be up to date.
Please run `sudo apt-get install --only-upgrade travis-worker`. This will update it to the latest version.

__Docker__:

Since the worker machine runs all your builds in Docker containers, the Docker version must be up to date and properly configured. We also need to have the `devicemapper` or `overlay` storage driver configured here, together with Linux kernel 3.18 or later.

Please also check the worker configuration in `/etc/default/travis-enterprise`:

- Please make sure that `TRAVIS_ENTERPRISE_BUILD_ENDPOINT` is not commented out and has the value `__build__`.
- Also make sure that `TRAVIS_ENTERPRISE_SECURITY_TOKEN` has the same value as being shown under RabbitMQ password at https://<your domain>:8800/settings
- The hostname in `TRAVIS_ENTERPRISE_HOST` must have the platform machine's hostname as value.

It is possible to adjust travis-worker so for example it assigns  more resources to a container or runs more of them concurrently. This configuration has to be done in `/etc/default/travis-worker`. There are some things worth to check:

- `TRAVIS_WORKER_POOL_SIZE` cannot exceed the number of available CPUs the machine has.

## GitHub Enterprise

If you're using GitHub Enterprise, please let us know which version you're using and if you've updated recently. This is important because we had some cases in the past where a GitHub Enterprise behaves differently than github.com.

## Your setup

Last but not least, please tell us as much as you can about your setup. What is different from our recommended setup? Did you change anything lately (software / hardware upgrades)? This will help us a lot to work out a solution together with you.
