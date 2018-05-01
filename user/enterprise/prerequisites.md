---
title: Enterprise System Prerequisites
layout: en_enterprise
---

Before [installing Travis CI Enterprise](/user/enterprise/installation/), make
sure that you have all of the following prerequisites:  

- At least two dedicated [hosts or hypervisors](#Host-Machine-Specs)
- A GitHub [OAuth app](#OAuth-App) - either for GitHub Enterprise or GitHub.com
- A valid [Travis CI Enterprise license](#License)

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

## OAuth App

Travis CI Enterprise connects to either GitHub.com or GitHub Enterprise via an OAuth app. Check out GitHub's docs on[registering an OAuth app](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps/) to get started. The URLs you will need will be in the formats as below:

- *Homepage URL* - `https://travis-ci.<your-domain>.com`
- *Authorization callback URL* - `https://travis-ci.<your-domain>.com/api`

Note: URLs must include `https` or `http` at the beginning and cannot have trailing slashes

## License

To register for a 30 day trial please visit
[our signup page](https://enterprise.travis-ci.com/signup) to receive a trial license. Please email [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com) for
more information on pricing.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
