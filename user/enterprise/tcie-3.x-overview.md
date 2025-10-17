---
title: Travis CI Enterprise 3.x Overview
layout: en_enterprise
---

Travis CI Enterprise 3.x is a major release of the Travis CI Enterprise line. It introduces long-requested changes to its deployment set-up as well as provides the majority of features available in our hosted solution.

## Main Features

* High feature parity between Travis CI Enterprise 3.x and travis-ci.com, including (but not only):
  * Updated User Interface: user profile settings and repository-specific settings, incl. environmental variables, custom SSH keys for repository access, and security settings.
  * Updated User Interface notifications and build/build job information.
  * Updated build configuration service, including the ability to [import shared build configuration](/user/build-config-imports/) to your .travis.yml, even from other repositories (which may come in handy when structuring complex build definitions or, e.g., importing secrets shared across repositories).
  * [Build configuration validator](/user/build-config-validation/) hinting you on what may be wrong with .travis.yml for your builds.
  * Multiple integrations with Version Control systems:
    * GitHub Cloud
    * GitHub Enterprise Server
    * GitLab cloud solution
    * BitBucket cloud solution
  * Support for Multi CPU architecture builds (arm64, ppc64le, s390x) should you wish to run it on a different infrastructure.
  * Improved Admin Web User Interface.
  * We're porting the changes and bug fixes from travis-ci.com much quicker than in version 2.2.
* Database upgraded to PostgreSQL 11 or higher.
  * Additional travis-backup tool to help with data retention policy.
* Kubernetes ready!
  * Simple installation via Replicated KOTS installer (for existing environment in GCE, AWS, and OpenStack) or manage your single machine installation via Replicated https://kurl.sh/ (installs as microk8s cluster on a single instance).
* Build environments (Ubuntu):
  * Trusty (deprecated, available only for backward compatibility purposes)
  * Xenial
  * Bionic
  * Focal

## Travis CI Enterprise 2.0 Discontinued

Travis CI Enterprise 2.x will reach End-of-Life in Q1 2021. After Q1 2021, you won't receive any patches or security patches for your Enterprise 2.x installation. We strongly recommend upgrading your existing Travis CI Enterprise 2.x installation to 3.x before that time. If you need more time or have questions, please contact [our support team](mailto:enterprise@travis-ci.com?subject=Travis CI Enterprise 2.x Migration).
