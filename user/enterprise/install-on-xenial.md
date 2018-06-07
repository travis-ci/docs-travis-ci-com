---
title: Install on Ubuntu 16.04 machines (Beta)
layout: en_enterprise

---

> Note: This is a BETA feature. If you have any questions, suggestions, or run into any trouble, please email [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com?subject=Install%20on%20Xenial). We look forward to your feedback!
{: .beta}

This guide walks you through the installation of Travis CI Enterprise on Ubuntu 16.04 (Xenial) systems.

## Install Platform machine

To install the platform machine the steps are exactly the same as for Ubuntu 14.04.
Please follow the instructions for the [installation here](/user/enterprise/installation#Setting-up-the-Travis-CI-Enterprise-Platform).

## Install worker machine

1. From the Travis CI Enterprise Platform management UI under Settings, retrieve the RabbitMQ password and the hostname for your Travis CI Enterprise installation.
1. Log in to the worker machine as **as a user who has sudo access** and run
    ```
    $ curl -sSL -o /tmp/installer.sh https://raw.githubusercontent.com/travis-ci/travis-enterprise-worker-installers/master/installer.sh
    ```
1. Then, run the installer:
    ```
    $ sudo bash /tmp/installer.sh --travis_enterprise_host="<enterprise host>" --travis_enterprise_security_token="<rabbitmq password>"
    ```

This installs all necesary components, such as Docker and `travis-worker`. It also downloads Trusty build images by default. If this is the first time you're setting up a worker machine with Trusty build images, please enable [this feature flag](/user/enterprise/trusty#Enabling-the-Trusty-Beta-Feature-Flag) on your platform machine.

If you need to use Precise build images, please pass in the `--travis_legacy_build_images=true` flag during installation:

```
$ sudo bash /tmp/installer.sh --travis_enterprise_host="<enterprise host>" --travis_enterprise_security_token="<rabbitmq password>" --travis_legacy_build_images=true
```

This installs Precise build images and also configures the queue to `builds.linux`.