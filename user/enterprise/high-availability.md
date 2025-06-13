---
title: Enterprise High Availability Mode
layout: en_enterprise

---

## Travis CI Enterprise 3.x

Travis CI Enterprise (TCIE) 3.x typically runs in **a Kubernetes cluster** with one or multiple workers. Services are split into several pods in the cluster. This enables a High Availability setup out of the box which you can customize based on your needs.

### Install the Platform in High Availability Mode

Please make sure to configure your [Kubernetes](https://kubernetes.io/) cluster with redundant pods for each service and secure appropriate resources and configuration (see below) to run it or choose to self-host several services. You must modify several service configurations to achieve High Availability and adjust them to your requirements.

Select one of the options depending on your planned setup, deployment, data backup policies, the volume of users, and the number of build jobs. See also the regular [installation instructions for TCIE 3.x](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform).

#### Self-hosting services for High Availability Mode

You may need to consider self-hosting of

* [Redis](https://redis.io/), [RabbitMQ](https://www.rabbitmq.com/) and [Postgres](https://www.postgresql.org/) instances along with it's mirrors/redundant instances
* Common Logs Target Location

Once TCIE 3.x is installed, go to the Dashboard, Configs, and format *self-hosted* options according to your planned setup. See an example of a self-hosted configuration for database access in TCIE 3.x below:

![Self-hosted config example](/images/tcie-3.x-self-hosted-db.png)

Similar configuration options are available for self-hosted logs, Insights, Redis, and Rabbit MQ. The self-hosted solution for these services allows you to fully deploy and configure their High-Availability compliant setup as per your requirements.

#### Kubernetes cluster services

Another option is to modify the configuration for the aforementioned services (PostgreSQL, Redis, and RabbitMQ), considering service-specific details. These details can be found in the tools documentation. Since there are multiple possible variations, we suggest only general guidelines that should be treated as a starting point for developing your specific high-availability configuration.

* Postgresql: most probably you may want to start looking at primary/standby service pods behind a service load balancing the traffic. Automatic failover switching is at your discretion.

* Redis: you may want to look at setup with Redis Master, Sentinel, and Replicas with Sentinel as an entry point for every pod utilizing Redis

* RabbitMQ: RabbitMQ has an extensive [guide for clustering](https://www.rabbitmq.com/clustering.html), which may help you select an appropriate solution for your case.

Please mind that in basic installation logs are put on stdout of each pod, therefore you will still need redirect them to a common logs target location and store them using a tool of your choice.



## Install the Worker in High Availability Mode (all versions)

The worker installation works the same as for non-HA installations, as do the build environment compatibility defaults per the Enterprise version. Check out the docs for which version of Enterprise handles different OS's([TCIE 2.x](/user/enterprise/setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine) or [TCIE 3.x](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise/#2-setting-up-the-enterprise-worker-virtual-machine) and other information regarding the installation. You must retrieve your RabbitMQ password from your installation rather than from the Travis CI Enterprise Admin Dashboard.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
