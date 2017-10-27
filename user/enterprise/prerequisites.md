---
title: Enterprise System Prerequisites
layout: en_enterprise

---

Before [installing Travis CI Enterprise](/user/enterprise/installation/), make
sure that you have all of the following prerequisites:  

- At least two dedicated [hosts or hypervisors](#host-machine-specs)
- A GitHub Enterprise [OAuth app](#OAuth-app)
- A valid [Travis CI Enterprise license](#license)

## Host Machine Specs

The standard setup consists of **two hosts**, the *Travis CI Enterprise
Platform* which hosts the web UI and related services, and one or more
*Worker hosts* which run the tests/jobs in isolated containers using LXC
and Docker.

### System Requirements

Each dedicated host or hypervisor (VMWare, OpenStack using KVM, or EC2) should
run **Ubuntu 14.04**, ideally using Linux 3.16 and have at least **16 gigs of
RAM and 8 CPUs**.

If you're running on EC2, we recommend the **c3.2xlarge** instance type. We also
recommend using an image that uses EBS for the root volume, as well as
allocating 40 gigs of space to it. It is also recommended _not_ to destroy the
volume on instance termination.

Each host requires:

- a [Travis CI Enterprise license](#license)
- A GitHub Enterprise [OAuth app](#OAuth-app)

## OAuth App

Travis CI Enterprise connects to GitHub Enterprise via OAuth. You will need to
create an OAuth app on your GitHub Enterprise that Travis CI Enterprise can
connect to.

<!-- TODO: link to GH OAuth app -->

Use the following URLs when you register the OAuth app:

- *Homepage URL* - `https://travis-ci.<your-domain>.com`
- *Authorization callback URL* - `https://travis-ci.<your-domain>.com/api`

## License

To register for a 30 day trial please visit
<a href="https://enterprise.travis-ci.com/signup">our signup page</a>.
Please email [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com) for
more information on pricing.
