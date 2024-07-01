---
title: Enterprise High Availability Mode
layout: en_enterprise

---

## Travis CI Enterprise 3.x 

Travis CI Enterprise (TCIE) 3.x typically runs in **a Kubernetes cluster** with one or multiple workers. Services are split into several pods in the cluster. This enables a High Availability setup out of the box which you are able to customize based on your needs. 

### Installing the Platform in High Availability Mode

Please make sure to configure your [Kubernetes](https://kubernetes.io/) cluster with redundant pods for each service and secure appropriate resources and configuration (see below) to run it or choosing to self-host several services. You will need to modify several services configuration on your own to achieve High Availability adjusted to your requirements.

Select one of the options depending on your planned setup, deployment, data backup policies, the volume of users, and the number of build jobs. See also the regular [installation instructions for TCIE 3.x](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise#1-setting-up-enterprise-platform).

#### Self hosting services for High Availability Mode 

You may need to consider self-hosting of

* [Redis](https://redis.io/), [RabbitMQ](https://www.rabbitmq.com/) and [Postgres](https://www.postgresql.org/) instances along with it's mirrors/redundant instances
* Common Logs Target Location

Once TCIE 3.x is installed, go to the Dashboard, Configs and format *self-hosted* options according to your planned setup. See an example of a self-hosted configuration for database access in TCIE 3.x below:

![Self-hosted config example](/images/tcie-3.x-self-hosted-db.png)

Similar configuration options are available for self-hosted logs, Insights, Redis and Rabbit MQ. The self-hosted solution for these services allows you to fully deploy and configure their High Availability compliant setup as per your requirements.

#### Utilizing services in Kubernetes cluster

Another option is to modify the configuration for the aforementioned services (PostgreSQL, Redis, and RabbitMQ) taking into account service specific details. These details can be found in the documentation for the tools. Since there are multiple possible variations, we suggest only general guidelines that should be treated as a starting point for developing your specific High Availability configuration.

* Postgresql: most probably you may want to start looking at primary / standby service pods behind a service load balancing the traffic. Automatic failover switching is at your discretion.

* Redis: you may want to look at setup with Redis Master, Sentinel and Replicas with Sentinel as an entry point for every pod utilizing Redis

* RabbitMQ: RabbitMQ has an extensive [guide for clustering](https://www.rabbitmq.com/clustering.html) which may help to select appropriate solution for your case.

Please mind that in basic installation logs are put on stdout of each pod, therefore you will still need redirect them to a common logs target location and store them using a tool of your choice.



## Travis CI enterprise 2.x 

Travis CI Enterprise 2.x typically runs as a single container instance communicating with one or multiple workers, but we also offer a High Availability configuration so you can run your installation with redundancy. Particularly for customers with large-volume licenses, High Availability Mode is a helpful way to have additional stability.

If you're interested, or might be interested, in running Travis CI Enterprise in High Availability mode, please email us at [enterprise@travis-ci.com](mailto:enterprise@travis-cicom?subject:HA%20Mode) and we can discuss options and help you get started.

### Overview of Installation

The platform installation is similar to the standard [Enterprise installation](/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine), and the [worker installation](#installing-the-worker-in-high-availability-mode) is identical. However, there are some additional [system prerequisites](/user/enterprise/high-availability/), which means that to install in HA mode, you will need the following:
 * 3+ **16 gigs of RAM, 8 CPUs, 40GB HDD**, i.e. `c4.2xlarge` with a 40GB HDD. - 2+ for the VMs running the Platform, and 1+ for the VMs running the Worker
 * [Redis](https://redis.io/), [RabbitMQ](https://www.rabbitmq.com/),
and [Postgres](https://www.postgresql.org/) instances
 * [GitHub OAuth app](/user/enterprise/setting-up-travis-ci-enterprise/#prerequisites), [trial license](/user/enterprise/setting-up-travis-ci-enterprise/#prerequisites) -- enabled for HA
 * Internet connection -- note, this installation is _not_ airgapped by default. Let [us know](mailto:enterprise@travis-ci.com) if you are interested in one.

### Installing the Platform in High Availability Mode

HA is configured entirely on the Enterprise platform instance, but installing an HA platform is quite similar to installing a standard platform. The steps for HA are as follows.

1. Contact [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com?subject=HA%20Installation) to have your Enterprise license configured for HA mode.
1. Set up your [platform instance using the standard installation steps](/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine)
1. Sign into your Admin Dashboard (at `https://<your-travis-ci-enterprise-domain>:8800`)
   1. Go to 'Settings' and click 'Enable HA'.
   1. Paste in the URLs where you have [Postgres](https://www.postgresql.org/), [Redis](https://redis.io/), and [RabbitMQ](https://www.rabbitmq.com/) hosted. The connection strings should be in the format of:
   ```
   postgres://user:password@url:port
   redis://user:password@url:port
   amqps://user:password@url:port
   ```
   1. Optional: Upload a RabbitMQ Client Certificate (`.crt`). This allows RabbitMQ to use TLS.
   1. Scroll down to the bottom of the page.
   1. Click 'Save' and restart.

Once your first platform instance is fully configured, you should be able to see the UI and request a build - your build will only run correctly, if a worker is installed. Try out your new platform, and [please let us know](mailto:enterprise@travis-ci.com?subject=HA%20Troubleshooting) if you have questions.

#### Adding More Platform Installations

We recommend at least two Platform containers for HA mode and you can install more Enterprise containers in the same way you [installed](/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine) the first.

Once your second platform is installed, it will also need its HA settings configured. Go to the Admin Dashboard for your new platform container at `https://<your-second-travis-ci-enterprise-domain>:8800` to configure these as you did for [the first platform installation](#installing-the-platform-in-high-availability-mode).



## Installing the Worker in High Availability Mode (all versions)

The worker installation works the same as for non-HA installations, as do the build environment compatibility defaults per Enterprise version. Check out the docs for which version of Enterprise handle different OS's([TCIE 2.x](/user/enterprise/setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine) or [TCIE 3.x](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise#2-setting-up-the-enterprise-worker-virtual-machine) and other information regarding the installation. You will need to retrieve your RabbitMQ password from your own installation, rather than from the Travis CI Enterprise Admin Dashboard.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
