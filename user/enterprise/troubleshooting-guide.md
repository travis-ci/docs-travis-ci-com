---
title: Travis CI Enterprise Troubleshooting Guide
layout: en_enterprise
redirect_from:
  - /user/enterprise/operations-manual/
---

This document provides guidelines and suggestions for troubleshooting your Travis CI Enterprise installation. Each topic contains a common problem and strategies for solving it. If you have questions about a specific scenario or have an issue that is not covered, please contact us at [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com) for assistance.

## Travis CI Enterprise (TCIE) 3.x 

The TCIE 3.x is deployed as Kubernetes cluster. Thus `travis bash` and `travis console` working previously with single Docker installation will not work anymore. They're replaced with specific `kubectl` command line commands.

The term `Worker machine` still means the worker instance(s) that process and run the builds. 

## Travis CI Enterprise (TCIE) 2.x 

Throughout this document we'll be using the following terms to refer to the two components of your Travis CI Enterprise 2.x installation:

- `Platform machine`: The instance that runs the main Travis components, including the web frontend.
- `Worker machine`: The worker instance(s) that process and run the builds.

> Please note that this guide is geared towards non-High Availability (HA) setups. Please contact us at [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com) if you require support for your HA setup.

## Builds Are not Starting

### The problem

In the Travis CI Web UI you see no builds are starting. The builds either have no visible state or have a state of `queued`. Canceling and restarting builds has no effect.

### Strategies

There are a few different potential approaches which may help to get builds running again. Please try each one in order.

#### Connection to RabbitMQ was lost

The Enterprise Platform uses RabbitMQ to communicate with worker machine(s) in order to process builds. In certain circumstances it is possible for the worker machine(s) to lose connection with RabbitMQ and therefore become unable to process builds successfully. This is a known problem and we're working on it to deliver a permanent solution.

In the meantime, to return everything back to a normal working state, you can restart the worker machine(s) manually. This can be done by connecting to the worker(s) via `ssh` and running the following command:

```bash
$ sudo shutdown -r 0
```

This will immediately restart the machine. The program that processes worker builds (`travis-worker`) is configured to start automatically on system startup and should reestablish its connection to RabbitMQ.

#### Configuration Issues

Please check if the worker machine has all relevant configurations in order. To do so, please use SSH to log into the worker machine(s) and open `/etc/default/travis-enterprise`. This is the main configuration file `travis-worker` uses to connect to the platform machine.

Here is an example:

```
# Default ENV variables for Travis Enterprise
# Uncomment and set, then restart `travis-worker` for
# them to take effect.

export TRAVIS_ENTERPRISE_BUILD_ENDPOINT="__build__"
export TRAVIS_ENTERPRISE_HOST="<your-travis-ci-enterprise-domain>"
export TRAVIS_ENTERPRISE_SECURITY_TOKEN="abc12345"
# export TRAVIS_WORKER_DOCKER_PRIVILEGED="true"
```

The relevant variables are `TRAVIS_ENTERPRISE_HOST` and `TRAVIS_ENTERPRISE_SECURITY_TOKEN`. The former needs to contain the primary domain you use to access the Travis CI Enterprise Web UI. The `travis-worker` process uses this domain to reach the platform machine. The value of the latter needs to match the `RabbitMQ Password` found at `https://<your-travis-ci-enterprise-domain>:8800/settings`.

If you have made changes to this file, please run the following so they take effect:

```bash
$ sudo restart travis-worker
```

#### Ports are not open in Security groups / Firewall

A source for the problem could be that the worker machine is not able to communicate with the platform machine.

Here we're distinguishing between an AWS EC2 installation and an installation running on other hardware. For the former, security groups need to be configured per machine. To do so, please follow our installation instructions [here](/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine). If you're not using AWS EC2, please make sure that the ports listed [in the docs](/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine) are open in your firewall.

#### SSL Verification Issues

It is possible that there are SSL verification errors occuring when Github is attempting to trigger new builds with Travis CI Enterprise.

To verify that webhook payloads are being successfully delivered by Github:

1. Go to the repository in Github from which you expected a build to be triggered.
2. Click on 'Settings' in the top menu.
3. To view webhooks set up for this repository, click on 'Hooks'.
4. Find the webhook created for your Travis CI Enterprise domain and click 'Edit'.
5. Scroll to the bottom of the page to the section labeled 'Recent Deliveries'.

All recent payload attempts to Travis CI Enterprise should be present. If any have failed with a message such as 'Peer certificate cannot be authenticated with given CA certificates', the root cause is most likely your SSL Certificate setup on your installation.

Depending on your configuration, there may be multiple ways to solve this problem. Our page on [SSL Certificate Management](/user/enterprise/ssl-certificate-management) contains instructions for the various setups available in Travis CI Enterprise.

#### Docker Version Mismatch

This issue sometimes occurs after maintenance on workers that were originally installed before November 2017 or on systems running a `docker version` before `17.06.2-ce`. When this happens, the `/var/log/upstart/travis-worker.log` file will contain the following line: `Error response from daemon:client and server don't have same version`. For this issue, we recommend [re-installing each worker from scratch](/user/enterprise/setting-up-worker) on a fresh instance.

> Please note that the default build environment images will be pulled and you may need to apply customizations again as well.

#### You are running Enterprise v2.2 or higher

By default, the Enterprise Platform v2.2 or higher will attempt to route builds to the `builds.trusty` queue. This could lead to build issues, if you are not running a Trusty worker to process those builds or if you are targeting a different distribution (e.g. `xenial`).

To address this, either:

- Ensure that you have installed a Trusty worker on a new virtual machine instance: [Trusty installation guide](/user/enterprise/trusty/)
- Override the default queuing behavior to specify a new queue. To override the default queue you must access the Admin Dashboard at `https://<your-travis-ci-enterprise-domain>:8800/settings#override_default_dist_enable` and toggle the 'Override Default Build Environment' button. This will allow you to specify the new default based on your needs and the workers that you have available.

#### You are running Enterprise v3.x or higher

Verify if default queue configured in Enterprise Platform 3.x routes builds to a matching, existing workers. You may choose to alter the default queue setting by running admin console UI on `http://loclahost:8800`, navigating to Configuration and altering the option 'Set Default Build Environment' by selecting one of available options. 


## Enterprise Container Fails to Start due to 'context deadline exceeded' Error

> This issue occurs only for TCIE 2.x. The TCIE 3.x is deployed as Kubernetes/microk8s cluster.

### The problem

After a fresh installation or configuration change the Enterprise container doesn't start and the following error is visible in the Admin Dashboard found at `https://<your-travis-ci-enterprise-domain>:8800/dashboard`:

```
Ready state command canceled: context deadline exceeded
```

### Strategies

#### GitHub OAuth app configuration

The above mentioned error can be caused by a configuration mismatch in [the GitHub OAuth Application](/user/enterprise/setting-up-travis-ci-enterprise/#prerequisites). Please check that _both_ website and callback URL contain the Travis CI Enterprise's hostname. If you have discovered a mismatch here, please restart the Travis container from within the Admin Dashboard.


## travis-worker on Ubuntu 16.04 Does not Start

### The problem

`travis-worker` was installed on a fresh installation of Ubuntu 16.04 (Xenial) with no issues. However, the command `sudo systemctl status travis-worker` shows that it is not running.

In addition, the command `sudo journalctl -u travis-worker` contains the following error:

```
/usr/local/bin/travis-worker-wrapper: line 20: /var/tmp/travis-run.d/travis-worker: No such file or directory
```

### Strategy

One possible reason that travis-worker is not running is that `systemctl` cannot create a temporary directory for environment files. To fix this, please create the directory `/var/tmp/travis-run.d/travis-worker` and assign write permissions via:

```sh
$ mkdir -p /var/tmp/travis-run.d/
$ chown -R travis:travis /var/tmp/travis-run.d/
```

## Builds Fail with Curl Certificate Errors

### The problem

A build fails with a long `curl` error message similar to:

```
curl: (60) SSL certificate problem: unable to get local issuer certificate
```

This can have various causes, including an automatic nvm update or a caching error.

### Strategy

This error is most likely caused by a self-signed certificate. During the build, the worker container attempts to fetch different files from the platform machine. If the server was originally provisioned with a self-signed certificate, curl doesn't trust this certificate and therefore fails. While we're working on resolving this in a permanent way, currently the only solution is to install a certificate issued by a trusted Certificate Authority (CA). This can be a free Let's Encrypt certificate or any other trusted CA of your choice. We have a section in our [SSL Certificate Management](/user/enterprise/ssl-certificate-management/#using-a-lets-encrypt-ssl-certificate) page that walks you through the installation process using Let's Encrypt as an example.

## User Accounts are Stuck in Syncing State

### The problem

One or more user accounts are stuck in the `is_syncing = true` state. When you query the database, the number of users which are currently syncing does not decrease over the time. Example:

```sql
travis_production=> select count(*) from users where is_syncing=true;
 count
-------
  1027
(1 row)
```

### Strategy

You can reset the `is_syncing` flag for user accounts that are stuck by running:

**TCIE 3.x**: Run `$ kubectl exec -it [travis-api-pod]j /app/script/console` *on your local machine*

**TCIE 2.x**: Log into the platform machine via SSH. Run `$ travis console`

Next, regardless of TCIE version, run:

```bash
>> User.where(is_syncing: true).count
>> ActiveRecord::Base.connection.execute('set statement_timeout to 60000')
>> User.update_all(is_syncing: false)
```

It can happen that organizations are also stuck in the syncing state. Since an organization itself does not have a `is_syncing` flag, all users that do belong to it have to be successfully synced.

## Logs contain many GitHub API 422 errors

### The Problem

On every commit made when a build runs, a commit status is created for a given SHA. Due to GitHub’s limitations at 1,000 statuses per SHA and context within a repository, if more than 1,000 statuses are created this leads to a validation error.
This issue should no longer be present in GitHub Apps integrations but will be present in Webhooks integrations.

### Strategy

The workaround for this issue is to manually re-sync the user account with GitHub. This will generate a fresh token for the user account that has not reached any GitHub API limits.

There are two options listed below to initiate a sync between your Travis CI Enterprise instance and GitHub instance.

#### Sync account from Travis CI web interface

Ask the owner of **the affected account** (usually printed in the logs) to sync it with your GitHub instance. To do so they should:

1. Open `https://<your-travis-ci-enterprise-domain>`.
2. In the upper right corner of the page, hover over the user icon and select 'Profile' from the dropdown menu.
3. In the upper right corner of the profile page, click on 'Sync account'.

####  Sync account from the CLI with administrator privileges

An administrator can also initiate a sync on behalf of someone else: 

**TCIE 3.X**: via manually forcing the github-sync to re-run synchronization

`kubectl exec -it [travis-github-sync-pod] bundle exec bin/schedule users [login if single user] `

**TCIE 2.x**: via the `travis` CLI tool on the platform machine:

> If `—logins=<GITHUB-LOGIN>` is not provided then this command will trigger a sync on every user. This could result in long runtimes and may impact production operations if you have a large number of total users on your Travis CI Enterprise instance.

1. Open a SSH connection to the platform machine.
2. Initiate a sync by running `travis sync_users —logins=<GITHUB-LOGIN>`

## RabbiMQ AMQPS issue causes build jobs to never enqueue

> This issue occurs only in TCIE 3.x. The TCIE 2.x Rabbit does not contain any AMQPS support.

### The problem

When using self-signed certificate, the Rabbit MQ AMQPS will not work which will result in jobs queueing forever. Worker logs will indicate security issues when connecting to Rabbit using AMQPS.

### Startegy 

Relax security contraints by explicitly marking that self-sgined certificates are allowed.

SSH to the worker machine. Add `export AMQP_INSECURE=true` to `/etc/default/travis-worker`. Restart the worker instance.
