---
title: Setting up Travis CI Enterprise with KOTS
layout: en_enterprise
redirect_from:
  - /user/enterprise/installation/
  - /user/enterprise/prerequisites/
  - /user/enterprise/install-on-xenial/

---

> Travis CI Enterprise works with your GitHub, Bitbucket and GitLab.

|Github	|||	
|---|---|---|---|
|Enterprise Server	|Enterprise Cloud	 |'regular organization/regular users' on github.com|
|Yes	|Yes	|Yes|

|Bitbucket|||
|---|---|---|---|
|Server|	Data Center	|bitbucket.org|
|No	|No	|Yes|

|GitLab|||
|---|---|---|---|
|GitLab self-managed|	Gitlab.com	||
|No	|Yes	||

## Prerequisites

  * A valid Travis CI Enterprise license or [trial license](https://enterprise.travis-ci.com/signup). 
  If you're interested in using [High Availability](/user/enterprise/high-availability/), 
  [please let us know](mailto:enterprise@travis-ci.com) so we can get your trial license configured.

  * At least two virtual machines on your private cloud that meet the [system requirements](#system-requirements)
  * The `secret` and `clientid` of a GitHub.com, GitHub Enterprise [OAuth application](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) 
  or Bitbucket [OAuth application]() configured with:

    - *Homepage URL* - `https://<your-travis-ci-enterprise-domain>`
    - *Authorization callback URL* - `https://<your-travis-ci-enterprise-domain>/api`
    +
    URLs must include https or http at the beginning and cannot have trailing slashes.
  * Your OAuth identification on GitHub or Bitbucket
  * A valid certificate (from authority or self-issued)


### System Requirements

The standard setup consists of the *Travis CI Enterprise
Platform* which hosts the web UI and related services, and one or more
*Worker hosts*.

Each dedicated host or hypervisor (VMWare, OpenStack using KVM, or EC2) should run **Ubuntu 16.04**, 
ideally using Linux 3.16 and have at least **16 gigs of RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c4.2xlarge** instance type for both **Platform** and **Worker**. 
We also recommend using an image that uses EBS for the root volume, as well as allocating 40 gigs of space to it.

For [high availability (HA)](/user/enterprise/high-availability/) configurations, you will also need:

* [Redis](https://redis.io/),
* [RabbitMQ](https://www.rabbitmq.com/)
* [Postgres](https://www.postgresql.org/)

You can also try services like [compose.com](https://compose.com/), if you would like these services hosted outside your organization.

## 1. Setting up Enterprise Platform virtual machine

The Travis CI Enterprise Platform handles licensing, coordinates worker processes, and maintains the Enterprise user and admin dashboard. 
It must be installed on it's own machine instance, separate from that of the Travis CI Enterprise worker. 
We recommend using AWS' `c4.2xlarge` instance running Ubuntu 16.04 LTS or later as the underlying operating system.

Follow the following installation steps: 
* Open your command line tool. 
* Enter `gcloud init` to start your glcoud session.
* Enter `curl https://kots.io/install | bash`. The installation starts.
* Enter `kubectl kots install tci-enterprise-kots`.
* Enter the namespace to deploy to, such as `travis`. The Admin Console is deployed and the namespace created.
* Set a password to be used for the Admin Console (which you will need later in the UI!).
* Go to your browser.
* Access localhost:8800. 
* Upload your license file. The license is installed and the UI is displayed.
* Enter values in the following fields:
** Platform host: enter the domain name of your platform such as `montana.travis-ci-enterprise.com`.
** GitHub type: hosted or enterprise
** OAuth Application: to obtain the necessary values, register a new OAuth app at GitHub/Bitbucket. For GitHub: go to your GitHub account > Developer settings > OAuth Apps > Register a new application 
*** Client ID: enter the value for the Client ID displayed after having clicked Register application.
*** Client Secret: enter the value obtained.
** GitHub Application: to obtain the necessary values, go to https://storage.googleapis.com/gatestxxx/app03.html and fill in the host field with the hostname and click Submit.
> Make sure to use SSL (Secure Socket Layer) in the GitHub app section!
*** Application Name: copy and paste the application name into this field
*** Application ID: copy and paste the application ID into this field
*** Application Private Key: copy and paste the application PEM into this field
** Set Default Build Environment: your default linux distribution for builds
** HTTPS Settings: select HTTPS disabled > 
*** HTTPS disabled: if you select this option, you have to fill in the values for HTTPS later on using the Config tab on the Travis CI Enterprise Dashboard
*** Letsencrypt HTTPS (currently not working)
*** HTTPS enabled: fill in the TLS Key and TLS Certificate (either self-issued or issued by an authority) for platform
** Email Server Settings: use default ‘disable SMTP’
** Build Cache UI Settings: use default ‘disable S3’
** Librato Metrics: use default ‘disable librato’
** Customer.io (beta): use default ‘disable customer.io’
** Advanced Settings
*** Disable SSL cert verification: required for self signed certificates
*** Use HTTPS: changes github cloning protocol to https
*** Log level: default ‘info’. If set, more debugs are in logs.
** APT Mirror
** Google Maven Mirror
** Self-hosted platform database
** Secrets
** Self-hosted logs database
** Self-hosted insights database
** Self-hosted redis
** Self-hosted RabbitMQ
** RabbitMQ settings
** Administration Panel
** SQL Schema from 2.2: only `yes`, if you upgrade from a previous Enterprise version.
* Click Continue. Checks are carried out and the rendered `.yaml` file is generated.
It contains all kubernetes components for the Travis CI Enterprise Platform that have to be applied on GKE.

Depending on the installation process, the `rendered.yaml` file is in your tmp folder or can be downloaded from the web.

To run Travis CI Enterprise Platform, the entire setup has to be applied on GKE.
On the terminal please run 
`kubectl apply -f rendered.yaml -n [NAMESPACE]`

> Replace [NAMESPACE] with the value set in the configuration form.
Please verify your GKE pods components are running.
Run:
`kubectl get pods -n [NAMESPACE]`

> Now you can copy the IP address from the load balancer and register it at your DNS provider and enter the DNS name on the Config tab of your Travis Dashboard!

## 2. Setting up Enterprise Workers

This installation process based on docker commands and the license id which have to be provided to the user. 
On your local machine run following command:
```
docker pull replicated/ship && \
docker run -it -p 8800:8800 --rm -v `pwd`:/out \
-v /var/run/docker.sock:/var/run/docker.sock \
-e HTTP_PROXY -e HTTPS_PROXY -e NO_PROXY \
replicated/ship init \
replicated.app/tci-worker-ship
``` 

Please provide license id if required.

## 3. Upgrade/Migration
[Migration is covered at the bottom of the page where you have the possibility to make a db dump under `SQL Schema`]





