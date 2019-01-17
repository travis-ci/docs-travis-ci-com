---
title: Travis CI Enterprise Operations Manual
layout: en_enterprise

---
Welcome to the Travis CI Enterprise Operations Manual! This document provides guidelines and suggestions for troubleshooting your Travis CI Enterprise instance. If you have questions about a specific situation, please get in touch with us via [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com).

This document provides guidelines and suggestions for troubleshooting your Travis CI Enterprise instance. Each topic contains a common problem, and a suggested solution. If the solution does not work, please [contact support](#contact-enterprise-support).

Throughout this document we'll be using the following terms to refer to the two components of your Travis CI Enterprise installation:

- `Platform machine`: The virtual machine that runs most of the Travis web components. This is the machine your domain is pointing to.
- `Worker machine`: The worker machine(s) run your builds.

> Please note that this guide is geared towards non-High Availability (HA) setups right now.

## Backups

This section explains how you integrate Travis CI Enterprise in your backup strategy. Here, we'll talk about two topics:

- The encryption key
- The data directories

### Encryption key

Without the encryption key you cannot access the information in your production database. To make sure that you can always recover your database, make a backup of this key.

> Without the encryption key the information in the database is not recoverable.

To make a backup, please follow these steps:

1. open a ssh connection to the platform machine
2. run `travis bash`. This will open a bash session with `root` privileges into the Travis container.
3. Then run `grep -A1 encryption: /usr/local/travis/etc/travis/config/travis.yml`. Create a backup of the value returned by that command by either writing it down on a piece of paper or storing it on a different computer.

### Create a backup of the data directories

The data directories are located on the platform machine and get mounted into the Travis container. In these directories you'll find files from RabbitMQ, Postgres, Slanger, Redis and also log files from the applications inside the container.

The files are located at `/var/travis` on the platform machine. Please run `sudo tar -czvf travis-enterprise-data-backup.tar.gz /var/travis` to create compressed archive from this folder. After this has finished, copy this file off the machine to a secure location.

## Builds are not starting

### The problem

In the Travis CI Web UI you see none of the builds are starting. They're either in no state or `queued`. Canceling and restarting them doesn't make any difference.

### Strategies

There are a few different potential approaches which may help get builds running again. Please try each one in order.

#### Connection to RabbitMQ got lost

We're using RabbitMQ to schedule builds for the worker machine(s). Sometimes the worker machine(s) lose the connection to RabbitMQ and therefore don't run any new builds anymore. This is a known problem on our side and we're working on resolving this. To get everything back to normal, restart the machines by connecting via `ssh` and running the following command:

```bash
$ sudo shutdown -r 0
```

This will immediately restart the machine. `travis-worker`, the program which actually runs the builds, is configured to start automatically on system startup.

#### Configuration

Please check if the worker machine has all relevant configuration in order. To do so, please use ssh to login to the machine, then open `/etc/default/travis-enterprise`. This is the main configuration file `travis-worker` uses to connect to the platform machine. Below you find an example:

```
# Default ENV variables for Travis Enterprise
# Uncomment and set, then restart `travis-worker` for
# them to take effect.

export TRAVIS_ENTERPRISE_BUILD_ENDPOINT="__build__"
export TRAVIS_ENTERPRISE_HOST="travisci.example.com"
export TRAVIS_ENTERPRISE_SECURITY_TOKEN="abc12345"
# export TRAVIS_WORKER_DOCKER_PRIVILEGED="true"
```

Relevant are `TRAVIS_ENTERPRISE_HOST` and `TRAVIS_ENTERPRISE_SECURITY_TOKEN`. The former needs to contain your primary domain you use to access the Travis CI Enterprise Web UI. `travis-worker` uses this domain to reach the platform machine. The value of the latter needs to match the `RabbitMQ Password` on `https://yourdomain.com:8800/settings`. If you have made changes to this file, please run the following so they take effect:

```bash
$ sudo restart travis-worker
```

#### Ports are not open Security groups / Firewall

A source for the problem could be that the worker machine is not able to communicate with the platform machine.

Here we're distinguishing between an AWS EC2 installation and an installation running on other hardware. For the former, security groups need to be configured per machine. To do so, please follow our installation instructions [here](http://localhost:4000/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine). If you're not using AWS EC2, please make sure that the ports listed [in the docs](http://localhost:4000/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine) are open in your firewall.

#### Docker Versions Mismatched

This issue sometimes occurs after maintenance on workers installed before November 2017 or systems running a `docker version` before `17.06.2-ce`. When this happens, the `/var/log/upstart/travis-worker.log` file contains a line: `Error response from daemon:client and server don't have same version`. For this issue, we recommend [re-installing worker from scratch](/user/enterprise/setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine) on a fresh instance. Please note: the default build environment images will be pulled and you may need to apply customizations again as well.

If none of the steps above lead to results for you, please follow the steps in the [Contact Enterprise Support](#contact-enterprise-support) section below to move forward.

#### Builds are not Starting on Enterprise Installation at Version 2.2+

If you are running version 2.2+ on your Platform, Travis CI will try to route builds to the `builds.trusty` queue by default. To address this, either:

1. Install a Trusty worker on a new virtual machine instance: [Trusty installation guide](/user/enterprise/trusty/)
1. Override the default queuing behavior: Go to Admin Dashboard at `https://your-domain.tld:8800/settings#override_default_dist_enable`, and toggle the the "Override Default Build Environment" button

## Enterprise container start fails with `Ready state command canceled: context deadline exceeded`

After a fresh installation or configuration change the Travis CI Enterprise container doesn't start and fails with the error `Ready state command canceled: context deadline exceeded` in the admin dashboard (`https://travis.example.com:8800/dashboard`).

### Strategies

#### GitHub OAuth app configuration

The above mentioned error can be caused by a configuration mismatch in [the GitHub OAuth Application](/user/enterprise/setting-up-travis-ci-enterprise/#prerequisites). Please check that _both_ website and callback URL contain the Travis CI Enterprise's hostname. If you have discovered a mismatch here, please restart the Travis container from within the admin dashboard.

#### Hostname does not match license's hostname

Your Travis CI Enterprise license has a hostname field which contains the hostname of your installation. When the license's hostname does not match the actual hostname, the container does not start. If this is the case or you suspect that this might be likely, please [get in touch with us](mailto:enterprise@travis-ci.com?subject=License%20Hostname%20Change) and we'll help you to get back on track.


## travis-worker on Ubuntu 16.04 does not start

travis-worker got installed on a fresh installation of Ubuntu 16.04 (Xenial). `sudo systemctl status travis-worker` shows that it is not running.

Either `sudo journalctl -u travis-worker` or `sudo systemctl status travis-worker` report `/usr/local/bin/travis-worker-wrapper: line 20: /var/tmp/travis-run.d/travis-worker: No such file or directory`.

### Strategy

One possible reason that travis-worker is not running is that `systemctl` cannot create a temporary directory for environment files. To fix this, please create the directory `/var/tmp/travis-run.d/travis-worker` and assign write permissions via:

```sh
$ mkdir -p /var/tmp/travis-run.d/
$ chown -R travis:travis /var/tmp/travis-run.d/
```

## Builds fail with curl certificate errors

A build fails with a long `curl` error message similar to:

```
curl: (60) SSL certificate problem: unable to get local issuer certificate
```

This can have various causes, including an automatic nvm update or a caching error.

### Strategy

This error is most likely caused by a self-signed certificate. During the build, the worker container attempts to fetch different files from the platform machine. If the server got provisioned with a self-signed certificate, curl doesn't trust this certificate and therefore fails. While we're working on resolving this in a permanent and sufficient way, currently the only solution is to install a certificate issued by a trusted Certificate Authority (CA). This can be a free Let's Encrypt certificate or any other trusted CA of your choice. We have a section in our [Platform Administration Tips](/user/enterprise/platform-tips/#use-a-lets-encrypt-ssl-certificate) page that walks you through the installation process using Let's Encrypt as an example.

## User accounts are stuck in syncing state

One or more user accounts are stuck in the `is_syncing = true` state. When you query the database, the number of users which are currently syncing does not decrease over the time. Example:

```sql
travis_production=> select count(*) from users where is_syncing=true;
 count
-------
  1027
(1 row)
```

### Strategy

Log into the platform machine via ssh. Then execute `travis console` to get into Travis' Ruby console. Reset the `is_syncing` flag for user accounts that are stuck by running:

```bash
$ travis console
>> User.where(is_syncing: true).count
>> ActiveRecord::Base.connection.execute('set statement_timeout to 60000')
>> User.update_all(is_syncing: false)
```

It can happen that organizations are also stuck in the syncing state. Since an organization itself does not have a `is_syncing` flag, all users that do belong to it have to be successfully synced.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
