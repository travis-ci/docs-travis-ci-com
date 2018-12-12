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
