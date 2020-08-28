---
title: Travis CI Enterprise 3.x Overview
layout: en_enterprise
---

Travis CI Enterprise 3.x is a major release of Travis CI Enterprise line. It introduces long requested changes to it's deployment set-up as well as provides majority of features available in our hosted solution.

## Main features

* Feature parity between Travis CI Enterprise 3.x and travis-ci.com - we migrate over bug fixes and features in short timeframes
* Multiple integrations with Version Control systems: 
  * GitHub Cloud
  * GitHub Enterprise Server
  * GitLab cloud solution
  * BitBucket cloud solution
* Database upgraded to PostgreSQL 11
* Kubernetes ready!
  * Simple installation via Replicated KOTS installer (for existing environment in GCE, AWS and for OpenStack) or manage your single machine installation via Replicated https://kurl.sh/ (installs as microk8s cluster on a single instance)
* Build environments (Ubuntu):
  * Trusty (deprecated, available only for backwards compatibility purposes)
  * Xenial
  * Bionic
  * Focal

## Travis CI Enterprise 2.0 End of Life

Travis CI Enterprise 2.x will reach End Of Life in Q1 2021. After Q1 2021, you won't receive any patches or security patches anymore for your Enterprise 2.x installation. We strongly recommend upgrading your existing Travis CI Enterprise 2.x installation to 3.x before that time. If you need more time or have questions, please reach out to [our support team](mailto:enterprise@travis-ci.com?subject=Travis CI Enterprise 2.x Migration).
