---
title: Setting up Travis CI Enterprise
layout: en_enterprise
---

Travis CI Enterprise works with your GitHub.com or GitHub Enterprise setup.

## Prerequisites

  * A valid Travis CI Enterprise license or [trial license](https://enterprise.travis-ci.com/signup). If you're interested in using [High Availability](/user/enterprise/high-availability/), [please let us know](mailto:enterprise@travis-ci.com) so we can get your trial license configured.

  * At least two virtual machines on your private cloud that meet the [system requirements](#system-requirements)
  * The `secret` and `clientid` of a GitHub.com or GitHub Enterprise [OAuth application](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) configured with:
    - *Homepage URL* - `https://travis-ci.<your-domain>.com`
    - *Authorization callback URL* - `https://travis-ci.<your-domain>.com/api`

### System Requirements

The standard setup consists of the *Travis CI Enterprise
Platform* which hosts the web UI and related services, and one or more
*Worker hosts* which run the tests/jobs in isolated containers using LXC
and Docker.

Each dedicated host or hypervisor (VMWare, OpenStack using KVM, or EC2) should
run **Ubuntu 14.04** or **Ubuntu 16.04**, ideally using Linux 3.16 and have at least **16 gigs of
RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c4.2xlarge** instance type for both **Platform** and **Worker**. We also recommend using an image that uses EBS for the root volume, as well as allocating 40 gigs of space to it. It is also recommended _not_ to destroy the volume on instance termination.

For [high availability (HA)](/user/enterprise/high-availability/) configurations, you will also need:

* [Redis](https://redis.io/),
* [RabbitMQ](https://www.rabbitmq.com/)
* [Postgres](https://www.postgresql.org/)

You can also try services like [compose.com](https://compose.com/) if you would like these services hosted outside your organization.

## 1. Setting up the Travis CI Enterprise Platform virtual machine

The Travis CI Enterprise Platform handles licensing, coordinates worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed on it's own machine instance, separate from that of the Travis CI
Enterprise worker. We recommend using AWS' `c4.2xlarge` instance running
Ubuntu 16.04 LTS as the underlying operating system.

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

2. *On your new virtual machine*, download and run the installation script:


    ```
    curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install
    sudo bash /tmp/installer.sh
    ```

3. *In your browser*, navigate to `https://<hostname>:8800` (your Enterprise
installation's hostname, port 8800) to complete the setup.

    From here you can upload your license key, add your GitHub OAuth details, and
optionally upload an SSL certificate and enter SMTP details.


## 2. Setting up the Travis CI Enterprise Worker virtual machine

The Travis CI Enterprise Worker manages build containers and reports build
statuses back to the platform. It must be installed on a separate machine
instance from the Platform. We recommend using AWS' `c4.2xlarge` instance running
Ubuntu 16.04 LTS (beta) as the underlying operating system.

* From the Travis CI Enterprise Platform management UI under Settings, retrieve the RabbitMQ password and the hostname for your Travis CI Enterprise installation.
* If this is the first time you're setting up a worker machine with Trusty build images, please enable [this feature flag](/user/enterprise/trusty#enabling-the-trusty-beta-feature-flag) on your platform machine.

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

### Using Precise workers

TODO: do we need this?

If you need to use Precise build images, please pass in the `--travis_legacy_build_images=true` flag during installation:

```
$ sudo bash /tmp/installer.sh --travis_enterprise_host="<enterprise host>" --travis_enterprise_security_token="<rabbitmq password>" --travis_legacy_build_images=true
```

This installs Precise build images and also configures the queue to `builds.linux`.

### Installing workers behind a web proxy

TODO: do we still need this?

If you are behind a web proxy and Docker fails to download the image(s), when you run the worker installation script, edit `/etc/default/docker` and set your proxy there.
Then rerun the installation script.  

If you need Docker itself to use an HTTP proxy, export it before each docker command:

```
export http_proxy="http://proxy.mycompany.corp:8080/" docker <COMMAND>
```

### Older versions of Travis CI Enterprise

TODO: do we need this?

| Travis CI Enterprise Version | Default Worker Version                               | Alternative Worker Versions                          |
|:-----------------------------|:-----------------------------------------------------|:-----------------------------------------------------|
| Enterprise 2.2+              | [Trusty (14.04)](/user/enterprise/trusty/)           | [Precise (Legacy, 12.04)](/user/enterprise/precise/) |
| Enterprise 2.1.9+            | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | [Trusty (14.04)](/user/enterprise/trusty/)           |
| Enterprise 2.0+              | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | --                                                   |

After setting up a new instance for the worker, please follow the [Trusty (14.04)](/user/enterprise/trusty/) or [Precise (Legacy, 12.04)](/user/enterprise/precise/) guides for your Travis CI Enterprise version.


## 3. Running builds!









<!--



1. Set up the Travis CI Enterprise platform
   1.1.  [ON YOUR CLUSTER THINGIE] Provision the virtual machines in your private cloud: AWS, GCE or [whatevs]
   - You want to start a new Virtual machine that has Ubuntu 16.04 or later and 16 gigs of RAM and 8 CPUs.
   - Get this machine in your security group / local firewall (including origin restrictions?)
   - Configure the domain name [dashboard or places] and save it (you'll use this domain name on step 1.2.)

   1.2. [ON your new virtual machine (ssh in)]  
   - Install the Travis CI Enterprise Platform component, [details here: curls and scripts]

1.3. [Go to your private host 192.168.1.1 / travis-ci.enterprise.com]
  - Add a secure certificate / configure a trusted one [HTTPS Replicated page]
  - Upload your license - [Validaing license file]
  - Configure access to the Admin Console (password / openldap)

  - -> See the wonderous list of checks, and skip past them quickly! [click continue]


2. Connect your GitHub Enterprise or GitHub.com with Travis CI enterprise -
 > Only users with Admin permissions can do these steps
   https://docs.travis-ci.com/user/enterprise/prerequisites/#oauth-app
    2.1. - Configure the GH settings and secret
    2.2. - Optionally, configure.... Email, Metrics, Caches
    2.3 - Get the RabitMQ password for the Worker setup

[SKIP this because no workers]
    Will restart and show the dashboard
    -> Authorize with GH

3. Set up Worker machine

3.1.  [ON YOUR CLUSTER THINGIE] Provision the virtual machines in your private cloud: AWS, GCE or [whatevs], recent ubuntu

3.2 [ON YOUR NEW MACHINE] curl install

   -> instert rabbitmq pass and platform hostname

   and done...


4. Skip over to the Getting Started Guide and connect some repositories to your new Travis CI Setup!


## What next?

High Availability
Java config
Proxies

-->
