---
title: Travis CI Enterprise Operations manual
layout: en_enterprise

---

The Operations Manual is a guideline which helps you to resolve problems with your Travis CI Enterprise instance. Our plan is to  enhance this document with frequently occuring support topics over the time. If you would like to see a specific problem case covered here as well, please get in touch with us via [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com).

This document has multiple entrypoints. Each entrypoint is a common problem which we've seen ocurring on a regular basis over the time. The section will guide you through it helping you to resolve it. If the problem couldn't be resolved you'll find instructions on how to proceed at the bottom of the document.

Throughout this document we'll be using the following terms to refer to the two components of your Travis CI Enterprise installation:

- `Platform machine`: The virtual machine that runs most of the Travis web components. This is the machine your domain is pointing to.
- `Worker machine`: The worker machine(s) run your builds.

## Backups

This section explains how you integrate Travis CI Enterprise in your backup strategy. Here, we'll talk about two topics:

- The encryption key
- The data directories

### Encryption key

Without the encryption key you cannot access the information in your production database. To make sure that you can always recover your database, make a backup of this key:

1. open a ssh connection to the platform machine
2. run `travis bash`. This will open a bash session with `root` privileges into the Travis container.
3. Then run `cat /usr/local/travis/etc/travis/config/travis.yml | grep -A1 encryption:`. Create a backup of the value returned by that command by either writing it down on a piece of paper or storing it on a different computer.

> Without this key the information in the database is not recoverable.

### Create a backup of the data directories

The data directories are located on the platform machine and get mounted into the Travis container. In these directories you'll find files from RabbitMQ, Postgres, Slanger, Redis and also log files from the applications inside the container.

The files are located at `/var/travis` on the platform machine. Please run `sudo tar -czvf travis-enterprise-data-backup.tar.gz /var/travis` to create compressed archive from this folder. After this has finished, copy this file off the machine to a secure location.

## Builds don't get worked off

### Symptoms

In the Travis CI Web UI you see none of the builds getting worked off. They're either in no or the `queued` state. Cancelling and restarting them doesn't make any difference.

### Strategies

Below you will find different strategies to resolve the problem. They're meant to be followed in order. After you've completed the steps for a strategy please restart a build in the Travis CI Web UI to see if it gets picked up. If that's not happening, please advance to next strategy.

#### Connection to RabbitMQ got lost

We're using RabbitMQ to schedule builds for the worker machine(s). Sometimes it can happen that the worker machine(s) lose the connection to RabbitMQ and therefore don't run any new builds anymore. This is a known problem on our side and we're working on resolving this. To get everything back to normal, restarting the machines usually suffices. To do that, connect via `ssh` and run the following command:

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

#### Ports are not open Security groups / firewall

A source for the problem could be that the worker machine is not able to talk to the platform machine.
Here we're distinguishing between an AWS EC2 installation and an installation running on other hardware. For the former, security groups need to be configured per machine. To do so, please follow our installation instructions [here](https://docs.travis-ci.com/user/enterprise/installation/#1.1.-Create-a-Security-Group). If you're not using AWS EC2, please make sure that the ports listed [in the docs](https://docs.travis-ci.com/user/enterprise/installation/#1.1.-Create-a-Security-Group) are open in your firewall.

If none of the steps above lead to results for you, please follow the steps in [#Contact-support](#Contact-support) to move forward.

## Contact support

To get in touch with us, please write a message to [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com). In your message we'd like to ask you to answer the questions below.

- What is the problem?
- Which steps did you try already?
- A support bundle (You can get it from https://yourdomain:8800/support)
- Worker log files (They can be found at `/var/log/upstart/travis-worker.log`) - If you're using multiple worker machines, we need the log files from all of them.

Is anything special with your setup? There are certain information we can already see, such as the hostname, which IaaS provider you're using, but there are lots of other things we can't see which could lead to something not working. Therefore we'd like to ask you to also answer the questions below in your support request (if applicable):

- How many machines are you using?
- Do you use configuration management tools (Chef, Puppet)?
- Which other services do interface with Travis CI Enterprise?
- Do you use Travis CI Enterprise together with github.com or GitHub Enterprise?
- If you're using GitHub Enterprise, which version of it?

Please write your support request to [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com). We're looking forward hearing from you!