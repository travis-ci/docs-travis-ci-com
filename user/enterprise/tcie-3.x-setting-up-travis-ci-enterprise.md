---
title: Setting up Travis CI Enterprise 3.x
layout: en_enterprise
redirect_from:
  - /user/enterprise/installation/
  - /user/enterprise/prerequisites/
---

> Travis CI Enterprise works with your
> * GitHub.com or GitHub Enterprise setup
> * Bitbucket.org
> * GitLab.com

This document describes how to set up and install Travis CI Enterprise Core Services. To run builds, you will need to install and set up:
* Travis CI Enterprise 3.x Core Services (aka Travis CI Enterprise Platform)
* At least one Travis CI Worker (the procedure is described in a separate article)

![TCIE Core Services](/images/tcie-3.x-core-services-graph.png)

Travis CI Enterprise 3.x+ Core Services is distributed through a "Kubernetes Off The Shelf" installation package, containing a Helm chart and docker images for component services. We recommend installing Travis CI Enterprise 3.x Core Services into a Kubernetes managed cluster.

Travis CI Enterprise Worker Images are publicly available and must be installed separately, as described in [Prerequisites](/user/enterprise/prerequisites/).

## Travis CI Enterprise Core Services components

Travis CI Enterprise Core Services consist of components enlisted below. Each service has its own pod. Please pay attention to the *Comments* section, where you can find a list of services that may require replicating pods for handling higher workloads.

| Pod name                | Function                                                          | Comments                                       |
| ----------------------- | ----------------------------------------------------------------- | ---------------------------------------------- |
| travis-admin-web        | Travis Admin web application                                      |                                                |
| travis-admin-worker     | A backend background handler for user synchronization with GitHub triggered on demand from Travis Admin |         |
| travis-api              | Travis API, main Travis entry point for build requests, etc.       | May require a cluster of pods to handle workload | 
| travis-api-cron         | Handles build scheduled by users in Travis Web                    |                                                |
| travis-build            | Service building build script out of instructions parsed by travis-yml | If upscaling travis-yml, consider here as well |
| travis-gatekeeper       | Keeper of the gates, authorizes build requests                    | May require a cluster of pods to handle workload |
| travis-github-sync      | Main synchronization service with GitHub and GitHub Enterprise    | Runs jobs in the background, may require upscaling for many users and repositories |
| travis-hub              | Processes and distributes internal messages, e.g., from jobs, etc.  | Consider replica scaling if high workload noted        |
| travis-hub-drain        | processes messages from AMQP (Rabbit) to travis-hub               | Consider scaling if many jobs are run in parallel |
| travis-hub-web          | Canceled/deleted job status handling, communicating with travis-hub |                                              |
| travis-insights         | Basic build statistics for travis-web                             |                                                |
| travis-listener         | Service for managing webhook notifications from GitHub			  | Consider scaling when many commits triggering jobs present |
| travis-live             | Messages to be displayed in the Travis Web UI                     |                                                |
| travis-logs-* (6 in total) | Build job logs handlers                                    | Consider cluster if many jobs run in parallel  |
| travis-scheduler        | Scheduling build jobs after build request authorized by the Gatekeeper | Consider scaling when many commits triggering jobs present |
| travis-tasks            | Issues notifications received from travis-hub out via email, Slack, etc. |                                          |
| travis-tasks-github     | Sends build statuses to GitHub                                    |                                                |
| travis-vcs-listener-web | General webhook manager for notifications received from cloud-based Version Control Systems (VCS) other than GitHub | Please note: this is Beta in TCI Enterprise 3.x for Git repositories at Assembla, BitBucket, and GitLab |
| travis-vcs-web          | User and repositories synchronization for cloud-based VCS other than GitHub | Please note:  this is Beta in TCI Enterprise 3.x for Git repositories at Assembla, BitBucket, and GitLab |
| travis-vcs-listener-worker and travis-vcs-worker | Various background tasks/jobs for vcs-listener and vcs-worker|                                      |
| travis-web              | Main Travis CI Web UI for the users (talks to API)                |                                                |
| travis-yml              | Main `.travis.yml` parser upon authorized build request and before scheduling |  Consider scaling when many commits triggering jobs present |


Please note: certain services will need to run scheduled background jobs, usually as rake tasks - e.g., github-sync. These may require additional throughput depending on the numbers of, e.g., user/repositories/builds in your environment.

## Prerequisites

You can either install Travis CI Enterprise (TCIE) via [Replicated KOTS](https://kots.io/) to install it into a Kubernetes cluster on GCE, AWS, or OpenStack. 
Alternatively, you can install it on a single machine using the [Replicated kURL](https://kurl.sh/) installer and a configuration prepared by TravisCI (`tci-enterprise-kots`).

To set up your Travis CI Enterprise 3.x, you need:
  * A valid Travis CI Enterprise license or [trial license](https://enterprise.travis-ci.com/signup). 
  >Note: The [High Availability](/user/enterprise/high-availability/) option does not require any additional trial or production license configuration. GitOps and Snapshots support need to be separately enabled for each license.
  * Infrastructure:

|  Infrastructure scenario  | Requirement | Comment                                   |
| ------------------- | ---------------------- | ------------------------------------------------------- |
| not using default k8s service at cloud provider  | **Two virtual machines**  on your private cloud that meet the [system requirements](#system-requirements)    | One vm for Core Services, one for Worker                         |
| using k8s service at cloud provider (e.g. Google KE, Amazon EKS ) | One Kubernetes (k8s) Cluster, one virtual machine that meet the [system requirements](#system-requirements) | Tke k8s cluster is meant for Core Services, the vm is meant for Worker Image |

  * If using a GitHub Cloud or GitHub Enterprise Server: Configure the `secret` and `clientid` of a GitHub.com or GitHub Enterprise [OAuth application](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) with:

    - *Homepage URL* - `https://<your-travis-ci-enterprise-domain>`
    - *Authorization callback URL* - `https://<your-travis-ci-enterprise-domain>/api`

    URLs must include https or http at the beginning and cannot have trailing slashes.
    

### System Requirements

The standard setup consists of the *Travis CI Enterprise
Platform* which hosts Kubernetes cluster with each service in separate pods, and one or more
*Worker hosts* which run the tests/jobs in isolated containers using LXC
and Docker.

Each dedicated host or hypervisor (VMWare, OpenStack, or EC2) should run **Ubuntu 18.04** and have at least **16 gigs of RAM and 8 CPUs**. If the same host is to run as Worker host, the minimum requirement would be **16 gigs of RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c4.2xlarge** instance type for both **Core Service (aka Platform)** and **Worker**. We also recommend using an image that uses EBS for the root volume and allocating 80 gigs of space.

For [high availability (HA)](/user/enterprise/high-availability/) configurations, you will also need to configure appropriately:

* [Redis](https://redis.io/),
* [RabbitMQ](https://www.rabbitmq.com/)
* [Postgres](https://www.postgresql.org/)

## 1. Setting up Travis CI Core Services 

The Travis CI Enterprise Core Services (aka Platform) handles licensing, coordinates Worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed as Kubernetes cluster or on at least one machine instance acting as Kubernetes host 
or multiple instances managed by Kubernetes, separate from that of the Travis CI
Enterprise Worker. We recommend **compute optimized** instance running
Ubuntu 18.04 LTS or later as the underlying operating system.

> If you are migrating from Travis CI Enterprise 2.x, please read and execute the [datbase migration instructions](/user/enterprise/tcie-3.x-migrating-db-from-2.x-to-3.x/) first.

1. *On your infrastructure management platform*, create a Travis CI Core Services (or Platform) Security Group.

    If you're setting up your instance image or Kubernetes cluster for the first time, you need to create 
    Security Groups or Firewall Rules. Create an entry for each port as shown in the table below:

    | Port | Service         | Description                                                                  |
    |:-----|:----------------|:-----------------------------------------------------------------------------|
    | 8800 | Custom TCP Rule | Allow inbound access to the admin dashboard for your Enterprise installation. |
    | 5672 | Custom TCP Rule | Allow inbound access for RabbitMQ Non-SSL connections, e.g. for client.      |
    | 4567 | Custom TCP Rule | Allow inbound access for RabbitMQ SSL, e.g. for client.                      |
    | 3333 | HTTPS           | Allow inbound TCIE 3.x User administration Web application over HTTPS access. |
    | 443  | HTTPS           | Allow inbound Web application over HTTPS access.                             |
    | 80   | HTTP            | Allow inbound Web application access.                                        |
    | 22   | SSH             | Allow inbound SSH traffic to access from your local machine.        |

2. Please configure your hostname now. Skip this step if you will access TCIE through an IP address. Accessing TCIE through IP address is also viable option for your setup.
3. Set up your cluster/machine instances configuration

|  Infrastructure scenario                                          | How to set up TCIE Core Services           | How to Set Up TCIE Worker           |
| ----------------------------------------------------------------- | ------------------------------------------ | ----------------------------------- |
| not using default k8s service at cloud provider                   | Set up one vm as k8s host using Replicated kURL (see point 5 below) | [Set up vm to run Worker Image (docker or lxd)](user/enterprise/setting-up-worker/)                        |
| using k8s service at cloud provider (e.g. Google KE, Amazon EKS ) | See point 6 below                                                   | [Set up Worker Image](user/enterprise/setting-up-worker/) at your convernience, depending on infrastructure setup you use |

In each case the TCIE Core Services will be deployed as k8s cluster. Cluster must be prepared and started.

4. Install Replicated KOTS on *your local machine*. Make sure that you can connect to the Kubernetes cluster containing Travis CI Enterprise Core Services.
     1.  Replicated KOTS [outputs after installation an url including port number](https://docs.replicated.com/vendor/tutorial-installing-without-existing-cluster#create-a-test-server-and-install-the-app-manager) under which Kotsadmin runs. You can also use `kots admin-console -n [your namespace]` to connect
     2.  Altenratively you can just use `kubectl` to verify access to cluster (sometimes bash shell reload `bash -l` may be required). See example in [Kubernetes documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#verify-kubectl-configuration).
6. TCIE 3.x installed on **single** virtual machine instance
    1. On *your new VM instance* run `kurl.sh` via `curl -sSL https://k8s.kurl.sh/tci-enterprise-kots | sudo bash`
    2. Get credentials from the new cluster running on *your new VM instance*. Please view, e.g. [kurl documentation](https://kurl.sh/docs/install-with-kurl/connecting-remotely) where kubectl config with credentials is created and can be used afterward.
    3. Refer to various cluster and installation options in [kURL documentation](https://kurl.sh/docs/install-with-kurl/). Make sure to adjust your setup and configuration according to your needs before progressing with TCIE 3.X installation.
7. TCIE 3.x installed as Kubernetes cluster in the cloud
    1. Connect to your cluster and generate the kubectl config file. Then, download the kubectl config file to your *local machine*. The exact way to obtain generated credentials depends on your Kubernetes cluster provider (see GCloud example below).
8. Run `kubectl kots install tci-enterprise-kots` to install TCIE 3.x. Please note down the administrative password and namespace used during this step.
9. *In your browser*, navigate to `http://localhost:8800` to complete the setup. The TCIE 3.x admin console will automatically enable the during first installation:

   1. Authorize with a password set during the installation process. 
   2. Upload your Travis CI Enterprise license. 
   3. Connect your Source Control System (GitHub Enterprise Server, GitHub.com, or Bitbucket).
   4. Optionally, configure Email, Metrics, and Caches.
   5. Copy the *RabbitMQ password* for the Worker setup.

> If you have decided to use a self-signed certificate or wish to use Let's Encrypt certificate, there may be additional configuration steps required. Please see our page on [SSL Certificate Management](/user/enterprise/ssl-certificate-management) for more information.


### 1.1 Example TCIE 3.x installation for GCE on macOSX

#### 1.1.1 Python

You'll want to make sure you have the latest version of Python 3. If you're on macOSX (a clean install), you'll want to install Homebrew via:

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)
```

Once brew is up and running, you'll install Python via: 

```bash
brew install python
```

Now check if Python is installed via running: 

```bash
python -version
``` 

#### 1.1.2 Google SDK

Install the Google Cloud SDK via: 

```bash
curl https://sdk.cloud.google.com | bash
```

Restart your shell session before running `gcloud init`: 

```bash
exec -l $SHELL
```

Make sure gcloud installed via using the ```version``` arugument: 

```bash
gcloud --version
```
> Please make sure that `kubectl` is installed if you use tooling other than Google SDK. 

#### 1.1.3 Initialize GCloud

> For a provider different than Google, make sure you have your setup ready

Now you'll be able to run ```gcloud init```. Once you've put your credentials in the terminal, it should look similar to this: 

```bash
Welcome! This command will take you through the configuration of gcloud.

Settings from your current configuration [default] are:
compute:
  region: us-central1
  zone: us-central1-b
core:
  account: montana@travis-ci.org
  disable_usage_reporting: 'True'
  project: kubernetes-test-164423

Pick configuration to use:
 [1] Re-initialize this configuration [default] with new settings
 [2] Create a new configuration
Please enter your numeric choice:
```

You'll want to run the following set of variables: 

```bash
1
1
2
Y
10
```

In example case and timezone, the next command to run: 

```bash
gcloud container clusters get-credentials tci-test2 --zone us-central1-b --project kubernetes-test-164423
```

#### 1.1.4 Install Travis CI Enterprise via Replicated KOTS

Using cURL to install Kots on *local machine* via: 

```bash
curl https://kots.io/install | bash
```

Run Kots: 

```bash
kubectl kots install tci-enterprise-kots
```

Once employed with the choice, you can type the following: 

```bash
travis
```

From there, if you have the correct permissions, you can now start Enterprise on local via going to your browser and typing: 

```bash
http://localhost:8800
```

If you get a "permissions" error, please 
* Make sure you have [obtained correct license](/user/enterprise/tcie-3.x-obtain-license). 
* Contact one of your sysadmins to solve the access rights error. 

Once you get the proper permissions, you should have a license file. You'll see where you can drag and drop this on the localhost UI, it will look like this:

![License](/images/tcie-3.x-setting-up-License.png)

#### 1.1.5 Configure Travis CI Enterprise

Next, map your platform host, in example case the platform host is: 

```bash
montana.travis-ci-enterprise.com
```

Example of how this would look like in the localhost UI:

![Port](/images/tcie-3.x-setting-up-Port.png)

Next, you'll want to register a new OAuth application with GitHub. In this case, the application name was ```kubernetes``` and the homepage was the same as the platform host: 

![OAuth](/images/tcie-3.x-setting-up-OAuth.png)

Retrieve your ```Client_ID``` and your ```Secret``` from GitHub and enter them. This is how it would look like in the UI with application name set as ```kubernetes```: 

![Secret](/images/tcie-3.x-setting-up-Secret.png)

Once your ```Client_ID``` and ```Secrets``` are obtained, obtain proper values via going to:

```bash
https://gh-app-setup.travis-ci-enterprise.com
```

Be sure that in GitHub app section to use SSL (Secure Socket Layer) via 
```bash
https://
```

![JSON](/images/tcie-3.x-setting-up-JSON.png)

Fill in the host field with the hostname and click submit, then grab your RSA key: 

![Details](/images/tcie-3.x-setting-up-Details.png)

Once you've grabbed your RSA key, enter it via the UI: 

![RSA](/images/tcie-3.x-setting-up-RSA.png)

Now that you have your RSA key, you'll see a variable of settings, including ```RabbitMQ``` and others. Set them to your liking. Once you've done that click "Continue". Now you should verify your GKE pods are running. So run:

```bash
kubectl get pods -n [NAMESPACE]
``` 
Remember to replace the ```[NAMESPACE]``` with your value from the config form. Now regarding the Load Balancer, below is the default behavior of the Load Balancer: 

![LoadBalancer](/images/tcie-3.x-setting-up-loadbalancer.svg)

Go to your Google Cluster and search for ```nginx```, which is the service that maps/directs to a load balancer on Google Cloud. Copy the IP address from the existing Load Balancer and register it via the DNS provider. Enter the DNS name on the config tab of your Travis Dashboard.

To access the config page, try running: 
```bash
kubectl kots admin-console --namespace travis
```

The above command assumes your namespace is ```travis```, please replace it with yours. Remember registering the Load Balancer is generic. So you run ```kubectl get service nginx``` for example, just make a DNS record to point to the service's external IP. This is true with GCE and AWS. 

## 2. Setting up the Enterprise Worker virtual machine

The Travis CI Enterprise Worker manages to build containers and reports build
statuses back to the platform. It must be installed on a separate machine
instance from the Platform. We recommend using instances running Ubuntu 18.04 LTS or later as the underlying operating system.

Make sure you have already [set up the Enterprise Platform](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-) and have the *RabbitMQ password* and the *hostname* from the Platform Dashboard. 

After that, follow the [instructions to set up a Worker](/user/enterprise/setting-up-worker).

## 3. Running builds!

 Skip over to the [Getting Started Guide](https://docs.travis-ci.com/user/tutorial/) and connect some repositories to your new Travis CI Setup!
