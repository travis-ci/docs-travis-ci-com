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
