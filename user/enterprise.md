---
title: Travis CI Enterprise
layout: en_enterprise
---

Whether your team uses GitHub Flow, feature branches, or commits directly to
master, Travis CI Enterprise supports your way of shipping code. Travis CIs’
integration with GitHub gives your team the highest confidence with every change
made.

Summary: This page will give you a brief overview of what Travis CI Enterprise is and its capabilities, basic usage, rules of thumb for sizing, and calculations for necessary infrastructure.

## What is Travis CI Enterprise

Travis CI Enterprise is an on-prem version of Travis CI, which you can deploy in your infrastructure. Think of the ‘server’ version of Travis CI. Using Travis CI allows you to enable an easy-to-use Continuous Integration/Continuous Deployment (CI/CD) system in an environment, which you can configure and secure as you want to.

Travis CI Enterprise enables you to provide a CI/CD service for multiple developments and testing teams, as well as the ones belonging to your organization as your customers. It includes nearly all the same features as the online Travis CI version. An on-prem version allows you to introduce your own customizations to the build environments, thanks to its open-source nature.

Travis CI Enterprise is built to integrate with GitHub Enterprise. Using OAuth
for authentication, we sync your users’ permissions to ensure they only have
access to the repositories you want them to have access to. This allows you to
use LDAP or SAML to manage your user’s access. Travis CI Enterprise also
integrates with GitHub.com, enabling you to have greater control over your security and
to scale out your build infrastructure as needed.


## Why Enterprise over travis-ci.com

Travis CI Enterprise is built to bring the features of the [hosted
platform](/user/travis-pro) to different development processes. So whether you
would like to run CI builds on-premises with your servers or in your private cloud, Enterprise is equipped to fit right into your team's workflow.
Enterprise-specific features include:

* **Support for GitHub Enterprise:** Use your GitHub Enterprise
installation as the authentication and authorization layer for Travis CI
Enterprise, allowing you to leverage your existing LDAP or SAML with no
extra configuration.
* **Support for multiple Version Control Systems:** Starting from Travis CI
Enterprise 3.x, you can use different source code management solutions
together with Travis CI. For more details, see [Travis CI Enterprise 3.x Overview](/user/enterprise/tcie-3.x-overview/).
* **Meets security and regulatory requirements:**  With your servers and hosts
deployed inside your firewall, you have full ownership and control of
your data, making it possible to meet the security requirements of
your company.
* **Customizable images:**  We provide a range of build environment images,
covering an extensive set of languages, updated with the current dependencies
each community is using. If you or your team need specific changes, they are
easily customizable, which can then be deployed for use by your team.
* **Hosted on your infrastructure:** Travis CI Enterprise supports the cloud
or on-premises environment of your choice. This includes AWS, Google Compute
Engine, VMware, OpenStack, and Azure. Starting from version 3.0, you can deploy it in a Kubernetes cluster.
* **Scales to your needs:** Your team has the flexibility to add as much build
capacity as needed. If it’s a busy week before a production release, simply start up some more capacity and let your team test to their
heart’s content.
* **High availability:** Your continuous integration system is just as critical
as your GitHub Enterprise. Travis CI Enterprise can run in a multi-node set up
behind a load balancer, providing safety from hardware failures.

Travis CI Enterprise brings flexibility to your CI/CD process and gives
your entire team visibility and control over the build process. And of course, if
anyone has any questions, our Enterprise-specific support team is here to help
you out.

Please read [Travis CI Enterprise 3 Overview](/user/enterprise/tcie-3.x-overview/) for more details.

## Trials and Licensing

You can get a free trial license at [enterprise.travis-
ci.com](https://enterprise.travis-ci.com/). Your trial license will be full-featured, so you can get a good picture of how Enterprise will work for your
team.

If you're interested in getting started, let us know at [sales@travis-ci.com](mailto:sales@travis-ci.com). We'd love to figure out how Travis CI Enterprise can support your development workflow best. Or, if you'd like to talk more about support and onboarding, please email us at [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com). Our team looks forward to hearing from you!

## Prerequisites

To start using Travis CI Enterprise, make sure you have:
* A GitHub.com or GitHub Enterprise Server account.
* Owner permissions for git-based projects hosted on GitHub or GitHub Enterprise Server (GHE).
* A `.travis.yml` file in the root folder of your project´s GitHub repository (mind the preceding dot!).

Much like Travis CI, it’s enough to sign in to Travis CI Enterprise using the GitHub (or GitHub Enterprise) account and appoint repositories, which will integrate with Travis CI Enterprise. You can also configure details of repositories in Travis CI Enterprise, e.g., commits to which branches should trigger an automatic build.

After that, the team working on the source code in the activated repository can start migrating or building from scratch instructions in the `.travis.yml` file. These instructions constitute the build and testing recipe for the source code. Travis CI will trigger a build once the instructions are done and changes are committed. Each build can consist of one or many jobs. Jobs can run in parallel or in a pre-defined sequence (or even both!), which enables building a sort of pipeline for your project building, testing, and deploying process.

## Product Requirements

Travis CI Enterprise requires a certain infrastructure for deployment. It currently works with GitHub.com and GitHub Enterprise as the version control systems and external identity providers.

![Travis CI Enterprise About page](/images/TCIE-architecture1.png)

### Travis CI Enterprise Core Services and Worker

1. TCI services (or TCI Core Services), responsible for integration with version control systems, authorizing builds, scheduling build jobs, etc.
2. TCI Worker and build environment images (also called OS images).

#### TCI Enterprise Core Services 

1. A PostgreSQL11 (or later) database.
2. An infrastructure to deploy a Kubernetes cluster; it can be deployed in a server cluster or in a single machine if required
3. Depending on your setup, you may want to deploy and configure some of the components on your own, e.g., RabbitMQ - see the [Setting up Travis CI Enterprise](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise/) for more details.

#### TCI Enterprise Worker

1. An infrastructure where a docker image containing the Worker and a linked build image can be deployed.
2. Connectivity to certain Travis CI Core Services components - see the [Setting Up Worker](/user/enterprise/setting-up-worker/) for more details.

The amount of deployed TCI Worker and build environment OS images will determine the total concurrent capacity of Travis CI Enterprise deployment in your infrastructure.

![Travis CI Enterprise About page](/images/TCIE-Architecture2.png)

### Sizing and calculations

Travis CI Enterprise is a scalable solution. Right now, it’s distributed as ready-to-deploy in the Kubernetes cluster. It can start with minimum infrastructure for deployment and one concurrent job capacity. Yet, it may grow with its utilization (and require more infrastructure and/or more advanced environment configuration).

The basic deployment requires at least two virtual machines as hosts (or one larger instance). The more concurrency and jobs running in parallel are required, the more virtual machines you will need for Workers. The exact vCPU requirements will depend on your specific needs. Still, please assume as a rule of thumb that:
* TCI Core Services will require at least 4vCPUs and 8GB of RAM.
* TCI Worker: Each build job environment requires at least 4 vCPUs and preferably 8GB of RAM (OS image and linked Worker) plus some disk space.

At some point, if the workload is high enough, you may need to increase resources for Travis CI Core Services. Since version 3.x Travis CI Enterprise is delivered as a Kubernetes cluster, it is simple to scale up (e.g., by throwing in more docker pods) exactly the parts that need it.

The database required resources depend purely on the expected workload. We also recommend planning your data retention policy ahead (how long you are willing to keep the data in the database) to maintain the cost and sizing as you need it. As a rule of thumb, assume all TCI Core Services are ‘talking’ to the database and require enough computing power and sustainable connection. A rough estimation of the database sizing (with very intense usage: several concurrent jobs running 24/7 and assuming monthly logs are only kept in the database, while older ones are exported to file storage) may assume 5 to 10MB per user each month. For less intensive usage, it will be much less; Travis CI stores no images nor large binary blobs in its database.

You may want to consider having specific online file storage available for the deployment (like S3 or GFS) if you plan to implement keeping your database clean. Travis CI has a set of background tools that can help clean up and backup build logs and build data in your scenario.

Detailed deployment requirements can be found in **‘Setting up’** and subsequent documents.

### Get Started

Set up Travis CI Enterprise by heading over our [set up](/user/enterprise/tcie-3.x-setting-up-travis-ci-enterprise/) page.

Or if you need more information on Travis CI, head back and view our [core concepts](/user/for-beginners/), the [Onboarding](/user/onboarding/) guide, or the [tutorials](/user/tutorials/tutorials-overview/).

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}

## Further Reading
  * [Travis CI Enterprise 3 Overview](/user/enterprise/tcie-3.x-overview/)
  * [Setting up Travis CI Enterprise](/user/enterprise/setting-up-travis-ci-enterprise/)
  * [Setting Up Worker](/user/enterprise/setting-up-worker/)
  * [Customizing Build Images](/user/enterprise/build-images/)
