---
title: Enterprise High Availability Mode
layout: en_enterprise

---

Travis CI Enterprise typically runs as a single container instance communicating with one or multiple workers and generally, this setup is quite stable and maintainable. However, in some cases -- especially volume licensing or by corporate requirement -- you might need to install Travis CI in High Availability (HA) mode. If you're interested, or might be interested, in HA, please let [sales@travis-ci.com](mailto:sales@travis-cicom?subject:HA%2FMode) sales know and we'll help you clarify and get started. 

## Overview of Installation

The platform installation is quite similar to the standard [Enterprise installation](/user/enterprise/installation#Setting-up-the-Travis-CI-Enterprise-Platform), and the [worker installation is identical](#Setting-up-the-Travis-CI-Enterprise-Worker). However, there are some additional [system prerequisites](/user/enterprise/prerequisites/#High-Availability-Mode), which mean that to install in HA mode, you will need the following:
 * 3+ **16 gigs ofRAM and 8 CPUs**, i.e.`c3.2xlarge`'s - 2+ for the VMs running the Platform, and 1+ for the VMs running the Worker
 * [Redis](https://redis.io/), [RabbitMQ](https://www.rabbitmq.com/), 
and [Postgres](https://www.postgresql.org/) instances
 * [GitHub OAuth app](/user/enterprise/prerequisites#OAuth-App), [trial license](/user/enterprise/prerequisites#License) -- enabled for HA
 * Internet connection -- note, this installation is _not_ airgapped by default. Contact [sales](mailto:sales@travis-ci.com) if you need an airgapped installation

 Once you have all these things, you should be able and ready to get started.

## Installing the Platform

The initial steps to installing High Availability-supporting Travis CI Enterprise are identical to the steps installing the standard offering. Have a look at [installation ] 