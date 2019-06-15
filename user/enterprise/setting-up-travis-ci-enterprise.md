---
title: Setting up Travis CI Enterprise
layout: en_enterprise
redirect_from:
  - /user/enterprise/installation/
  - /user/enterprise/prerequisites/
  - /user/enterprise/install-on-xenial/

---

Travis CI Enterprise works with your GitHub.com or GitHub Enterprise setup.

## Prerequisites

  * A valid Travis CI Enterprise license or [trial license](https://enterprise.travis-ci.com/signup). If you're interested in using [High Availability](/user/enterprise/high-availability/), [please let us know](mailto:enterprise@travis-ci.com) so we can get your trial license configured.

  * At least two virtual machines on your private cloud that meet the [system requirements](#system-requirements)
  * The `secret` and `clientid` of a GitHub.com or GitHub Enterprise [OAuth application](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) configured with:

    - *Homepage URL* - `https://<your-travis-ci-enterprise-domain>`
    - *Authorization callback URL* - `https://<your-travis-ci-enterprise-domain>/api`
    +
    URLs must include https or http at the beginning and cannot have trailing slashes.

### System Requirements

The standard setup consists of the *Travis CI Enterprise
Platform* which hosts the web UI and related services, and one or more
*Worker hosts* which run the tests/jobs in isolated containers using LXC
and Docker.

Each dedicated host or hypervisor (VMWare, OpenStack using KVM, or EC2) should run **Ubuntu 16.04**, ideally using Linux 3.16 and have at least **16 gigs of RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c4.2xlarge** instance type for both **Platform** and **Worker**. We also recommend using an image that uses EBS for the root volume, as well as allocating 40 gigs of space to it.

For [high availability (HA)](/user/enterprise/high-availability/) configurations, you will also need:

* [Redis](https://redis.io/),
* [RabbitMQ](https://www.rabbitmq.com/)
* [Postgres](https://www.postgresql.org/)

You can also try services like [compose.com](https://compose.com/) if you would like these services hosted outside your organization.

## 1. Setting up Enterprise Platform virtual machine

The Travis CI Enterprise Platform handles licensing, coordinates worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed on it's own machine instance, separate from that of the Travis CI
Enterprise worker. We recommend using AWS' `c4.2xlarge` instance running
Ubuntu 16.04 LTS or later as the underlying operating system.

1. *On your virtual machine management platform*, create a Travis CI Platform Security Group.

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

1. If you're using a hostname and not just an IP address, this would be a time to configure it.

1. *On your new virtual machine*, download and run the installation script:


    ```
    curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install
    sudo bash /tmp/installer.sh
    ```

3. *In your browser*, navigate to `https://<your-travis-ci-enterprise-domain>:8800` (your Enterprise
installation's hostname, port 8800) to complete the setup:

   1. Add a secure certificate or configure a trusted one.
   1. Upload your Travis CI Enterprise license.
   1. Configure access to the Admin Console with a password or using openLDAP. This controls access to the Admin Console itself, not to the Travis CI Enterprise instance.
   1. Connect your GitHub Enterprise or GitHub.com with Travis CI enterprise.
   1. Optionally, configure Email, Metrics and Caches.
   1. Copy the *RabbitMQ password* for the Worker setup.

> If you have decided to use a self-signed certificate there may be additional configuration steps required. Please see our page on [SSL Certificate Management](/user/enterprise/ssl-certificate-management) for more information.

## 2. Setting up the Enterprise Worker virtual machine

The Travis CI Enterprise Worker manages build containers and reports build
statuses back to the platform. It must be installed on a separate machine
instance from the Platform. We recommend using AWS' `c4.2xlarge` instance running Ubuntu 16.04 LTS or later as the underlying operating system.

Make sure you have already [set up the Enterprise Platform](/user/enterprise/setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-virtual-machine) and have the *RabbitMQ password* and the *hostname* from the Platform Dashboard.


1. *On your virtual machine management platform*, create a Travis CI Worker Security Group

    If you're setting up your AMI for the first time you will need to create
    a Security Group. From the EC2 management console, create an entry for
    each port in the table below:

    | Port | Service | Description |
    |:-----|:--------|:------------|
    | 22   | SSH     | SSH access. |

1. *On your new virtual machine*, download and run the installation script:

    ```
    $ curl -sSL -o /tmp/installer.sh https://raw.githubusercontent.com/travis-ci/travis-enterprise-worker-installers/master/installer.sh
    $ sudo bash /tmp/installer.sh --travis_enterprise_host="<enterprise host>" --travis_enterprise_security_token="<rabbitmq password>"
    ```

### Installing workers behind a web proxy

If you are behind a web proxy and Docker fails to download the image(s), when you run the worker installation script, edit `/etc/default/docker` and set your proxy there.
Then rerun the installation script.  

If you need Docker itself to use an HTTP proxy, export it before each docker command:

```
export http_proxy="http://proxy.mycompany.corp:8080/" docker <COMMAND>
```

### Older versions of Travis CI Enterprise

| Travis CI Enterprise Version | Default Worker Version                               | Alternative Worker Versions                          |
|:-----------------------------|:-----------------------------------------------------|:-----------------------------------------------------|
| Enterprise 2.2+              | [Trusty (14.04)](/user/enterprise/trusty/)           | [Precise (Legacy, 12.04)](/user/enterprise/precise/) |
| Enterprise 2.1.9+            | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | [Trusty (14.04)](/user/enterprise/trusty/)           |
| Enterprise 2.0+              | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | --                                                   |

After setting up a new instance for the worker, please follow the [Trusty (14.04)](/user/enterprise/trusty/) or [Precise (Legacy, 12.04)](/user/enterprise/precise/) guides for your Travis CI Enterprise version.


## 3. Running builds!

 Skip over to the [Getting Started Guide](https://docs.travis-ci.com/user/tutorial/) and connect some repositories to your new Travis CI Setup!

<!-- TODO

## 4. What next?

High Availability
Java config
Proxies

-->
