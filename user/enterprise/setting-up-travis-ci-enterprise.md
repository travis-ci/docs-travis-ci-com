---
title: Setting up Travis CI Enterprise
layout: en_enterprise
---

Travis CI Enterprise works with your GitHub.com or GitHub Enterprise setup.

## Prerequisites

  * A valid Travis CI Enterprise license, [get in touch](mailto:....) with our Sales Team to get a trial license
  * Have your repositories on GitHub.com or GitHub Enterprise
  * Get the GH client secret (or the following 4 settings ... bla bla )
  * Virtual machines available on your private cloud

## Steps

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



Before [installing Travis CI Enterprise](/user/enterprise/installation/), make
sure that you have all of the following prerequisites:  

- At least two dedicated [hosts or hypervisors](#host-machine-specs)
- A GitHub [OAuth app](#oauth-app) - either for GitHub Enterprise or GitHub.com
- A valid [Travis CI Enterprise license](#license)

## Host Machine Specs

The standard setup consists of **two hosts**, the *Travis CI Enterprise
Platform* which hosts the web UI and related services, and one or more
*Worker hosts* which run the tests/jobs in isolated containers using LXC
and Docker.

### System Requirements

Each dedicated host or hypervisor (VMWare, OpenStack using KVM, or EC2) should
run **Ubuntu 14.04** or **Ubuntu 16.04**, ideally using Linux 3.16 and have at least **16 gigs of
RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c4.2xlarge** instance type for both **Platform** and **Worker**. We also recommend using an image that uses EBS for the root volume, as well as allocating 40 gigs of space to it. It is also recommended _not_ to destroy the volume on instance termination.

For [high availability (HA)](/user/enterprise/high-availability/) configurations, you will also need to
provide your own [Redis](https://redis.io/), [RabbitMQ](https://www.rabbitmq.com/),
and [Postgres](https://www.postgresql.org/) instances. You can also try services like
[compose.com](https://compose.com/) if you would like these services hosted outside
your organization.

## OAuth App

Travis CI Enterprise connects to either GitHub.com or GitHub Enterprise via an OAuth app. Check out GitHub's docs on[registering an OAuth app](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) to get started. The URLs you will need will be in the formats as below:

- *Homepage URL* - `https://travis-ci.<your-domain>.com`
- *Authorization callback URL* - `https://travis-ci.<your-domain>.com/api`

Note: URLs must include `https` or `http` at the beginning and cannot have trailing slashes

## License

To register for a 30 day trial please visit
[our signup page](https://enterprise.travis-ci.com/signup) to receive a trial license. Please email [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com) for
more information on pricing.

### High Availability Mode

If you're interested in using High Availability, [please let us know](mailto:enterprise@travis-ci.com) so we can get your trial license configured. Check out the [HA docs](/user/enterprise/high-availability/) for more information.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}








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

Travis CI Enterprise currently supports two different build environments, Trusty (Ubuntu 14.04) and Precise (Legacy, Ubuntu 12.04). Each version of Travis CI Enterprise expects a default version of `travis-worker`. Travis CI Enterprise will direct jobs to the default worker type, unless the behavior is overridden. However, different versions of Enterprise treat different worker versions as default:

| Travis CI Enterprise Version | Default Worker Version                               | Alternative Worker Versions                          |
|:-----------------------------|:-----------------------------------------------------|:-----------------------------------------------------|
| Enterprise 2.2+              | [Trusty (14.04)](/user/enterprise/trusty/)           | [Precise (Legacy, 12.04)](/user/enterprise/precise/) |
| Enterprise 2.1.9+            | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | [Trusty (14.04)](/user/enterprise/trusty/)           |
| Enterprise 2.0+              | [Precise (Legacy, 12.04)](/user/enterprise/precise/) | --                                                   |

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

> Note: This is a BETA feature. If you have any questions, suggestions, or run into any trouble, please email [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com?subject=Install%20on%20Xenial). We look forward to your feedback!
{: .beta}

This guide walks you through the installation of Travis CI Enterprise on Ubuntu 16.04 (Xenial) systems.

## Install Platform machine

To install the platform machine the steps are exactly the same as for Ubuntu 14.04.
Please follow the instructions for the [installation here](/user/enterprise/installation#setting-up-the-travis-ci-enterprise-platform).

## Install worker machine

1. From the Travis CI Enterprise Platform management UI under Settings, retrieve the RabbitMQ password and the hostname for your Travis CI Enterprise installation.
1. Log in to the worker machine as **as a user who has sudo access** and run
    ```
    $ curl -sSL -o /tmp/installer.sh https://raw.githubusercontent.com/travis-ci/travis-enterprise-worker-installers/master/installer.sh
    ```
1. Then, run the installer:
    ```
    $ sudo bash /tmp/installer.sh --travis_enterprise_host="<enterprise host>" --travis_enterprise_security_token="<rabbitmq password>"
    ```

This installs all necessary components, such as Docker and `travis-worker`. It also downloads Trusty build images by default. If this is the first time you're setting up a worker machine with Trusty build images, please enable [this feature flag](/user/enterprise/trusty#enabling-the-trusty-beta-feature-flag) on your platform machine.

If you need to use Precise build images, please pass in the `--travis_legacy_build_images=true` flag during installation:

```
$ sudo bash /tmp/installer.sh --travis_enterprise_host="<enterprise host>" --travis_enterprise_security_token="<rabbitmq password>" --travis_legacy_build_images=true
```

This installs Precise build images and also configures the queue to `builds.linux`.
