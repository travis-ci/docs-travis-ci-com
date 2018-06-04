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

## Installing the Platform in High Availability Mode

The initial steps to installing High Availability-supporting Travis CI Enterprise are identical to the steps installing the standard offering. Once your [Platform instance is installed](/user/enterprise/installation#Setting-up-the-Travis-CI-Enterprise-Platform), then you can configure it for HA mode:

1. Sign into your Admin Dashboard (at `your-domain.tld:8800`)
1. Go to "Settings" and click "Enable HA"
1. Paste in the urls where you have [Postgres](https://www.postgresql.org/), [Redis](https://redis.io/), an [RabbitMQ](https://www.rabbitmq.com/) hosted
1. Upload a RabbitMQ Client Certificate (`.crt`), if you will be using one
1. Scroll down to the bottom of the page, "Save" and restart

Once your first platform instance is fulling configured, you should be able to see the UI and request a build -- your build will only run correctly though if a worker is installed. Try out your new platform, and [please let us know](mailto:enterprise@travis-ci.com?subject=HA%2FTroubleshooting) if you have questions. 

### Adding More Platform Installations

We recommend at least two Platform containers for HA mode. Installation for additional enterprise containers work the same as the first [Platform instance is installed](/user/enterprise/installation#Setting-up-the-Travis-CI-Enterprise-Platform). 

Once your second platform is installed, it will also need its HA settings configured. Go to the Admin Dashboard for your new platform container at `secondIP:8800` or `second-platform-public-dns.tld:8800` to complete this the same way as [the first platform installation](#Installing-the-PLatform-in-High-Availability-Mode)

## Installing the Worker

The worker installation works the same as for non-HA installations, as does the build environment compatibility defaults per Enterprise version. Check out the [docs for which version of Enterprise handle different OS's](/user/enterprise/installation#Install-Travis-CI-Worker) and other information regarding installation. You will need to retrieve your RabbitMQ password from your own installation, rather than from the Travis CI Enterprise Admin Dashboard.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
