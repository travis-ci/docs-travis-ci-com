---
title: Enterprise Installation
layout: en_enterprise

---

This guide covers installing the Travis CI Enterprise Platform and Travis CI
Enterprise Worker. Because Travis CI Enterprise is optimized for EC2, the following guide
recommends steps geared toward this provider, but you can certainly modify it to
use your provider of choice.

**Before getting started:** please check our [system prerequisites](/user/enterprise/prerequisites/) for
[expected system specs](/user/enterprise/prerequisites/#host-machine-specs),
notes on setting up the required [OAuth app](/user/enterprise/prerequisites/#oauth-app),
and information on obtaining a [license](/user/enterprise/prerequisites/#license).



## Setting up the Travis CI Enterprise Platform

The Travis CI Enterprise Platform handles licensing, coordinates worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed on it's own machine instance, separate from that of the Travis CI
Enterprise worker. We recommend using AWS' `c4.2xlarge` instance running
Ubuntu 14.04 LTS or 16.04 LTS (beta) as the underlying operating system.

### Create a Travis CI Platform Security Group

If you're setting up your AMI for the first time you need to create
a Security Group. From the EC2 management console, create an entry for
each port in the table below:

| Port | Service         | Description                                                                  |
|:-----|:----------------|:-----------------------------------------------------------------------------|
| 8800 | Custom TCP Rule | This port is to access the admin dashboard for your Enterprise installation. |
| 5672 | Custom TCP Rule | For RabbitMQ Non-SSL.                                                        |
| 4567 | Custom TCP Rule | For RabbitMQ SSL.                                                            |
| 443  | HTTPS           | Web application over HTTPS access.                                           |
| 80   | HTTP            | Web application access.                                                      |
| 22   | SSH             | SSH access.                                                                  |

### Install Travis CI Enterprise Platform

Before running the installation script, we recommend downloading and reading it.
When you're ready to run it on the host, run the following commands to install the
Travis CI Enterprise Platform and web interface:

```
curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install
sudo bash /tmp/installer.sh
```

Once the script has run ,navigate to `https://<hostname>:8800` (your Enterprise
installation's hostname, port 8800) to complete the setup.

From here you can upload your license key, add your GitHub OAuth details, and
optionally upload an SSL certificate and enter SMTP details.

New trials and installations will always install with the latest Travis CI Enterprise version.

## Install Travis CI Enterprise Worker

The Travis CI Enterprise Worker manages build containers and reports build
statuses back to the platform. It must be installed on a separate machine
instance from the Platform. We recommend using AWS' `c4.2xlarge` instance running
Ubuntu 14.04 LTS or Ubuntu 16.04 LTS (beta) as the underlying operating system.

### Create a Travis CI Worker Security Group

If you're setting up your AMI for the first time you will need to create
a Security Group. From the EC2 management console, create an entry for
each port in the table below:

| Port | Service | Description |
|:-----|:--------|:------------|
| 22   | SSH     | SSH access. |

## Install Travis CI Worker

Travis CI Enterprise currently supports two different build environments, Trusty (Ubuntu 14.04) and Precise (Legacy, Ubuntu 12.04). Each version of Travis CI Enterprise expects a default version of `travis-worker`. Travis CI Enterprise will direct jobs to the default worker type, unless the behavior is overriden. However, different versions of Enterprise treat different worker versions as default:

| Travis CI Enterprise Version | Default Worker Version | Alternative Worker Versions |
| -- | -- | -- |
| Enterprise 2.2+ | [Trusty (14.04)](/user/enterprise/trusty/) | [Precise (Legacy, 12.04)](/user/enterprise/precise/) |
| Enterprise 2.1.9+ | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | [Trusty (14.04)](/user/enterprise/trusty/) |
| Enterprise 2.0+ | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | -- |

After setting up a new instance for the worker, please follow the [Trusty (14.04)](/user/enterprise/trusty/) or [Precise (Legacy, 12.04)](/user/enterprise/precise/) guides for your Travis CI Enterprise version. 

You can find the RabbitMQ password, which is needed in the installation, either in your Admin Dashboard --> "Settings" page, or in your own RabbitMQ installation for [high availability mode](/user/enterprise/high-availability/).

### Worker Installation Behind Web Proxies

<!-- TODO does this apply to the curl command or the bash tmp installer? -->

If you are behind a web proxy and Docker fails to download the image(s),
edit `/etc/default/docker` and set your proxy there. Re-run the script
above. In addition, if you need Docker to use an HTTP proxy, it can also be
specified as follows:

```
  export http_proxy="http://proxy.mycompany.corp:8080/"
```

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
