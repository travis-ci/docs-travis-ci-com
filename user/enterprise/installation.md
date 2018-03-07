---
title: Enterprise Installation
layout: en_enterprise

---

This guide covers installing the Travis CI Enterprise Platform and Travis CI
Enterprise Worker. Because Travis CI Enterprise is optimized for EC2, the following guide
recommends steps geared toward this provider, but you can certainly modify it to
use your provider of choice.

**Before getting started:** please check our [system prerequisites](/user/enterprise/prerequisites/) for
[expected system specs](/user/enterprise/prerequisites/#Host-Machine-Specs), 
notes on setting up the required [OAuth app](/user/enterprise/prerequisites/#OAuth-App),
and information on obtaining a [license](/user/enterprise/prerequisites/#License).



<div id="toc"></div>

## Setting up the Travis CI Enterprise Platform

The Travis CI Enterprise Platform handles licensing, coordinates worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed on it's own machine instance, separate from that of the Travis CI
Enterprise worker.

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
When you're ready to run it on the host, run one of the following pairs of
commands to install the Travis CI Enterprise Platform and web interface:

```         
# not behind a web proxy

curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install
sudo bash /tmp/installer.sh

# behind a web proxy
curl -sSL -x http://: -o /tmp/installer.sh https://enterprise.travis-ci.com/install
sudo bash /tmp/installer.sh http-proxy=http://:
```          

Once the script has run ,navigate to `https://<hostname>:8800` (your Enterprise
installation's hostname, port 8800) to complete the setup.

From here you can upload your license key, add your GitHub OAuth details, and
optionally upload an SSL certificate and enter SMTP details.

## Install Travis CI Enterprise Worker

The Travis CI Enterprise Worker manages build containers and reports build
statuses back to the platform. It must be installed on a separate machine
instance from the Platform.

### Create a Travis CI Worker Security Group

If you're setting up your AMI for the first time you will need to create
a Security Group. From the EC2 management console, create an entry for
each port in the table below:

| Port | Service | Description |
|:-----|:--------|:------------|
| 22   | SSH     | SSH access. |

## Install Travis CI Worker

1. From the Travis CI Enterprise Platform management UI under Settings, retrieve
   the RabbitMQ password and the hostname for your Travis CI Enterprise
   installation.

1. Log in to the second host as **as a user who has sudo access** and run

    ```
    curl -sSL https://enterprise.travis-ci.com/install/worker -o /tmp/installer
    ```

1. Run one of the following commands:

   - If the Worker host is running on EC2 please edit the following command to
     include the proper credentials:

      ```      
        sudo bash /tmp/installer \
        --travis_enterprise_host="travis.myhostname.com" \
        --travis_enterprise_security_token="my-rabbitmq-password" \
        --aws=true
      ```      

   - For all other hosts, please edit and run:
      ```      
        sudo bash /tmp/installer \
        --travis_enterprise_host="travis.myhostname.com" \
        --travis_enterprise_security_token="my-rabbitmq-password"
      ```           
1. When the installation is complete, please reboot your Worker host to finish.

### Worker Installation Behind Web Proxies

<!-- TODO does this apply to the curl command or the bash tmp installer? -->

If you are behind a web proxy and Docker fails to download the image(s),
edit `/etc/default/docker` and set your proxy there. Re-run the script
above. In addition, if you need Docker to use an HTTP proxy, it can also be
specified as follows:

```
  export http_proxy="http://proxy.mycompany.corp:8080/"
```
