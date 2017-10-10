---
title: Trusty containers for Enterprise (beta)
layout: en_enterprise

---

**Please note: This is a beta feature. We would definitely like to hear if you run into any problems with the Trusty containers. If you have any questions or run into problems, please write an email to: [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com).**

First of all you need to be running Travis Enterprise 2.1.9 or higher.

1. SSH into the platform machine
2. Run `travis console`
3. Then run `Travis::Features.enable_for_all(:template_selection); Travis::Features.enable_for_all(:multi_os)`
4. You can now exit the console and disconnect from the Travis Enterprise platform machine


## AWS
Spin up AWS worker machines (DeviceMapper installer only supports the recommended c3.2xlarge machines due to the storage layout) and run:

`curl -sSL -o /tmp/installer.sh https://gist.githubusercontent.com/bnferguson/4675ea4fadde8a82613f683fed5f8ad3/raw/trusty-devicemapper-installer.sh`

Then run:

`sudo bash /tmp/installer.sh --travis_enterprise_host="[travis.yourhost.com]" --travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]" --aws=true`

## Non-AWS

Start your worker machine and run:

`curl -sSL -o /tmp/installer.sh https://gist.githubusercontent.com/bnferguson/25dfd929bc59382aa8effb7dcc7e7a3f/raw/trusty-installer.sh`

Then run:

`sudo bash /tmp/installer.sh --travis_enterprise_host="[travis.yourhost.com]" --travis_enterprise_security_token="[RabbitMQ Password/Enterprise Security Token]"`

The only difference with this installer is that it uses AUFS instead of DeviceMapper and doesn't have strict storage device layout requirements (for setting up the DeviceMapper volumes).