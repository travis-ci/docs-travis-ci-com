---
title: Enterprise Installation
layout: en

---

This guide covers installing the Travis CI Enterprise Platform and Travis CI
Enterprise Worker. Please check our [system prerequisites](#) guide if you have
any questions about whether your configuration will be supported.

<div id="toc"></div>

## Setting up the Travis CI Enterprise Platform

The Travis CI Enterprise Platform handles licensing, coordinates worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed on it's own machine instance, separate from that of the Travis CI
Enterprise worker. Because Enterprise is optimized for EC2, the following guide
recommends steps geared toward this provider, but you can certainly modify to
use your provider of choice.

### Creating a Security Group

If you're setting up your AMI for the first time you will need to create
a Security Group. From the EC2 management console, create an entry for
each port in the table below:

| Port | Service | Description |
| -- | -- | -- |
| 8800 | Custom TCP Rule | This port is to access the admin dashboard for your Enterprise installation. |
| 5672 | Custom TCP Rule | For RabbitMQ Non-SSL. |
| 4567 | Custom TCP Rule | For RabbitMQ SSL. | 
| 443 | HTTPS | Web application over HTTPS access. | 
| 80 | HTTP | Web application access. | 
| 22 | SSH  | SSH access. | 

## Platform Installation

The recommended installation of the Platform host is done through
running the following script on the host:

```         
  curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install
  sudo bash /tmp/installer.sh
```          

**Note: We recommend downloading and reading the script before running
it**

This will install the management application, which takes care of
downloading and installing the Travis CI Platform, as well as providing
a simple web interface for setting up the platform, and for viewing
runtime metrics.

Once the script has run you can navigate to `https://:8800` (your Enterprise
installation's hostname, port 8800) to complete the setup.

From here you can upload your [trial license key](https://enterprise.travis-ci.com/signup), 
add your GitHub OAuth details, upload an SSL certificate and enter SMTP details 
(both optional).

If you are running the Platform host on EC2, we recommend using an image
that uses EBS for the root volume, as well as allocating 40 gigs of
space to it. It is also recommended to not destroy the volume on
instance termination.

If you are behind a web proxy you can run the following install
commands:

```
  curl -sSL -x http://: -o /tmp/installer.sh https://enterprise.travis-ci.com/install
  sudo bash /tmp/installer.sh http-proxy=http://:
```

## Setting up a Travis CI Enterprise Worker

The Travis CI Enterprise Worker manages build containers and reports build
statuses back to the platform. It must be installed on a separate machine
instance from the Platform.

### Creating a Security Group

If you're setting up your AMI for the first time you will need to create
a Security Group. From the EC2 management console, create an entry for
each port in the table below:

| Port | Service | Description |
| -- | -- | -- |
| 22 | SSH  | SSH access. |

## Worker Installation

For setting up a Worker host you'll need the RabbitMQ password, which you can
retrieve from the Travis CI Enterprise Platform management UI under Settings.
You will also need the hostname for your Travis CI Enterprise installation,
which must match the name set in your license.

Before running the following commands, please make sure you are **logged
in as a user who has sudo access.**

```
curl -sSL https://enterprise.travis-ci.com/install/worker -o /tmp/installer
```

If the Worker host is running on EC2 please edit the following command to
include the proper credentials, and run on the Worker host:

```      
  sudo bash /tmp/installer \
  --travis_enterprise_host="travis.myhostname.com" \
  --travis_enterprise_security_token="my-rabbitmq-password" \
  --aws=true
```      
          
For all other hosts, please edit and run:
```      
  sudo bash /tmp/installer \
  --travis_enterprise_host="travis.myhostname.com" \
  --travis_enterprise_security_token="my-rabbitmq-password"
```           
Once the installation is complete, please reboot your Worker host to finish. 

### Worker Installation Behind Web Proxies

If you are behind a web proxy and Docker fails to download the image(s),
edit `/etc/default/docker` and set your proxy there. Re-run the script
above. In addition, if you need Docker to use an HTTP proxy, it can also be 
specified as follows:

``` 
  export http_proxy="http://proxy.mycompany.corp:8080/"
```

## Backups

We recommend a weekly machine snapshot and weekly backups of `/etc/travis` and
`/var/travis`.

Doing a machine snapshot and backing up those directories before performing an
update is recommended as well.
