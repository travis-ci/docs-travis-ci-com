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

Travis CI Enteprise 3.x+ is ditributed in form of Kubernetes Off The Shell installation package, containing Helm chart and docker images for component services. It is meant to be installed as a Kubernetes managed cluster.

## Prerequisites

Travis CI Enteprrise (TCIE) installation can be executed via [Replicated KOTS](https://kots.io/) installer (for existing environment in GCE, AWS and for OpenStack managed infrastructre) or as single virtual machine installation via [Replicated kURL](https://kurl.sh/) (installs as microk8s cluster on a single instance)

  * A valid Travis CI Enterprise license or [trial license](https://enterprise.travis-ci.com/signup). The [High Availability](/user/enterprise/high-availability/) option does not require any additional trial or production license configuration.

  * At least two virtual machines on your private cloud that meet the [system requirements](#system-requirements) - one of these must be set up as Kubernetes/ microk8s host - or Kubernetes Cluster
  * In case of GitHub: The `secret` and `clientid` of a GitHub.com or GitHub Enterprise [OAuth application](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) configured with:

    - *Homepage URL* - `https://<your-travis-ci-enterprise-domain>`
    - *Authorization callback URL* - `https://<your-travis-ci-enterprise-domain>/api`

    URLs must include https or http at the beginning and cannot have trailing slashes.
    

### System Requirements

The standard setup consists of the *Travis CI Enterprise
Platform* which hosts Kubernetes cluster with each service in separate pod, and one or more
*Worker hosts* which run the tests/jobs in isolated containers using LXC
and Docker.

Each dedicated host or hypervisor (VMWare, OpenStack, or EC2) should run **Ubuntu 18.04** and have at least **8 gigs of RAM and 4 CPUs**. If the same host is to run as Worker host, inimum requirement would be **16 gigs of RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c4.2xlarge** instance type for both **Platform** and **Worker**. We also recommend using an image that uses EBS for the root volume, as well as allocating 80 gigs of space to it.

For [high availability (HA)](/user/enterprise/high-availability/) configurations, you will also need self-hosted:

* [Redis](https://redis.io/),
* [RabbitMQ](https://www.rabbitmq.com/)
* [Postgres](https://www.postgresql.org/)

## 1. Setting up Enterprise Platform 

The Travis CI Enterprise Platform handles licensing, coordinates worker
processes, and maintains the Enterprise user and admin dashboard. It must be
installed as Kubernetes cluster or on at least one machine instance acting as microk8s host 
or multiple instances managed by Kubernetes, separate from that of the Travis CI
Enterprise worker. We recommend **compute optimized** instance running
Ubuntu 18.04 LTS or later as the underlying operating system.

> If you are migrating from Travis CI enteprise 2.x, please make sure to read and execute the [datbase migration instructions](/user/enterprise/tcie-3.x-migrating-db-from-2.x-to-3.x./) first.

1. *On your infrastructure management platform*, create a Travis CI Platform Security Group.

    If you're setting up your instance image or Kubernetes cluster for the first time, you most probably need to create some kind of
    a Security Group. Create an entry for each port in the table below:

    | Port | Service         | Description                                                                  |
    |:-----|:----------------|:-----------------------------------------------------------------------------|
    | 8800 | Custom TCP Rule | This port is to access the admin dashboard for your Enterprise installation. |
    | 5672 | Custom TCP Rule | For RabbitMQ Non-SSL.                                                        |
    | 4567 | Custom TCP Rule | For RabbitMQ SSL.                                                            |
    | 3333 | HTTPS           | TCIE 3.x User administration Web application over HTTPS access.              |
    | 443  | HTTPS           | Web application over HTTPS access.                                           |
    | 80   | HTTP            | Web application access.                                                      |
    | 22   | SSH             | SSH access.                                                                  |

2. If you're using a hostname and not just an IP address, this would be a time to configure it.
3. Set-up your cluster/machine instances configuration - at least 1 virtual machine is needed (in microk8s scenario) or Kubernetes cluster prepared and started
4. On *your local machine*, assuming the proper connection with the cluster exists, install Replicated KOTS.
5. TCIE 3.x installed on **single** virtual machine instance
    1. On *your new virtual machine instance* run kurl.sh via 'curl https://kurl.sh/latest | sudo bash' 
    2. Get credentials from microk8s cluster running on *your new vm instance*
    3. Please refer to various cluster and installation options in [kURL documentation](https://kurl.sh/docs/install-with-kurl/). Please adjust your setup and configuration according to your needs before progressing with TCIE 3.X installation
6. TCIE 3.x installed as Kubernetes cluster in the cloud
    1. Connect to your cluster and get it's configuration, particularly credentials
5. Run `kubectl kots install tci-enterprise-kots` to install TCIE 3.x. Please note down administrative password and namespace used during this step.
6. *In your browser*, navigate to `http://localhost:8800` to complete the setup. The TCIE 3.x admin console will be automatically enabled during first installation :

   1. Authorize with a password set during the installation process 
   2. Upload your Travis CI Enterprise license. 
   3. Connect your GitHub Enterprise or GitHub.com (or other VCS).
   4. Optionally, configure Email, Metrics and Caches.
   5. Copy the *RabbitMQ password* for the Worker setup.

> If you have decided to use a self-signed certificate or wish to use Let's Encrypt certificate, there may be additional configuration steps required. Please see our page on [SSL Certificate Management](/user/enterprise/ssl-certificate-management) for more information.


### 1.1 Example TCIE 3.x installation for GCE on MacOSX

#### 1.1.1 Python

You'll want to make sure you have the latest version of Python 3, if you're on Mac OSX (a clean install) you'll want to install Homebrew via:

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

If you try to run at this point ```gcloud init``` it will not work, you must restart your shell via:

```bash
exec -l $SHELL
```

Make sure gcloud installed via using the ```version``` arugument: 

```bash
gcloud --version
```
> Please make sure that `kubectl` is installed if you are using tooling other than Google SDK. 

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

From there if you have the correct permissions, you can now start Enterprise on local via going to your browser and typing: 

```bash
http://localhost:8800
```

If you get a "permissions" error, please 
* make sure you have [obtained correct license](/user/enterprise/tcie-3.x-obtain-license) 
* contact one of your sysadmins to solve the access rights error. 

Once you get the proper permissions, you should have a license file. You'll see where you can drag and drop this on the localhost UI, it will look like this:

![License](/images/tcie-3.x-setting-up-License.png)

#### 1.1.5 Configure Travis CI Enterprise

Next map your platform host, in example case the platform host is: 

```bash
montana.travis-ci-enterprise.com
```

Example of how this would look like in the localhost UI:

![Port](/images/tcie-3.x-setting-up-Port.png)

Next you'll want to register a new OAuth application with GitHub in this case, application name was ```kubernetes``` and homepage was the same as the platform host: 

![OAuth](/images/tcie-3.x-setting-up-OAuth.png)

Retrieve your ```Client_ID``` and your ```Secret``` from GitHub and enter them, this is how it would look like in the UI with application name set as ```kubernetes```: 

![Secret](/images/tcie-3.x-setting-up-Secret.png)

Once your ```Client_ID``` and ```Secrets``` are obtained, obtain proper values via going to:

```bash
https://storage.googleapis.com/gatestxxx/app03.html
```

Be sure in GitHub app section to use SSL (Secure Socket Layer) via 
```bash
https://
```

![JSON](/images/tcie-3.x-setting-up-JSON.png)

Fill in the host field with the hostname and click submit, then grab your RSA key: 

![Details](/images/tcie-3.x-setting-up-Details.png)

Once you've grabbed your RSA key, enter it via the UI: 

![RSA](/images/tcie-3.x-setting-up-RSA.png)

Now that you have your RSA key, you'll see a variable of settings, including ```RabbitMQ``` and others. Set them to your liking. Once you've done that click "Continue". **To finally run the TCI Enterprise Platform, the entire process must be applied to GKE**, so this means you need to open terminal up, and run: 

```bash
kubectl apply -f rendered.yaml -n [NAMESPACE]
```
Note that ```[NAMESPACE]``` should be the value set in the configuration form. Now you should verify your GKE pods are running. So run:

```bash
kubectl get pods -n [NAMESPACE]
``` 
Remember replace the ```[NAMESPACE]``` with your value from the config form. Now regarding the Load Balancer, below is the default behavior of the Load Balancer: 

![LoadBalancer](/images/tcie-3.x-setting-up-loadbalancer.svg)

Go to your Google Cluster and search for ```nginx``` which is the service that maps/directs to a load balancer on Google Cloud. Copy the IP address from the existing load balancer and register it via the DNS provider. Enter the DNS name on the config tab of your Travis Dashboard.

To access the config page try running: 
```bash
kubectl kots admin-console --namespace travis
```

The above command assumes your namespace is ```travis```, please replace it with yours. Remember registering the load balancer is generic. You run ```kubectl get service nginx``` for example, just make a DNS record to point to the service's external IP. This is true with GCE and AWS. 

## 2. Setting up the Enterprise Worker virtual machine

The Travis CI Enterprise Worker manages build containers and reports build
statuses back to the platform. It must be installed on a separate machine
instance from the Platform. We recommend using instance running Ubuntu 18.04 LTS or later as the underlying operating system.

Make sure you have already [set up the Enterprise Platform](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise/#1-setting-up-enterprise-platform-) and have the *RabbitMQ password* and the *hostname* from the Platform Dashboard. 

After that, follow [instructions to set up a Worker](/user/enterprise/setting-up-worker).

## 3. Running builds!

 Skip over to the [Getting Started Guide](https://docs.travis-ci.com/user/tutorial/) and connect some repositories to your new Travis CI Setup!
