---
title: Upgrading Travis CI Enterprise
layout: en_enterprise

---

<div id='toc'></div>

## Backups

Before upgrading, we **strongly recommend** taking a snapshot of `/etc/travis`
and `/var/travis`.

One good way to do this is to run
```
  sudo tar -cvzf travis-backup-$(date +%s).tar.gz /var/travis /etc/travis/
```   
See [restoring from backups](#Restoring-from-Backups) if you have any questions about the steps or want to do a restore. 

## Updating your Travis CI Enterprise Platform

You can check for new releases by going to the management interface
dashboard `https://:8800` and clicking on the 'Check Now' button. If an
update is available you will be able to read the release notes and
install the update.

**Please note that this will cause downtime for the platform, because
Replicated services get restarted during the update.**

## Updating Replicated on the Platform

To update Replicated on the Platform installation you'll want to run
the install script which will download the latest version. Depending on
whether you are behind a web proxy you'll want to run one of these:

```
  curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install
  sudo bash /tmp/installer.sh
```


```
  curl -sSL -x http://: -o /tmp/installer.sh https://enterprise.travis-ci.com/install
  sudo bash /tmp/installer.sh http-proxy=http://:
```

## Updating your Travis CI Enterprise Worker

In order to update the Worker, you can run the following on each worker
host:

```         
  sudo apt-get update
  sudo apt-get install travis-worker
```

## Restoring from Backups

If the rare event something goes wrong and/or you'd like to restore from a back-up, please use the following steps: 

1. Boot up a replacement machine with a fresh install of Ubuntu 14.04.
1. Follow the directions in the [Installation Guide](/user/enterprise/installation). If you cannot find this, let us know at [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com)
1. Setup your Travis CI instance filling out the settings as needed. Fill in the RabbitMQ password and Travis Encryption Key that you saved. Save the settings and start up the Travis container.
1. Stop the Travis CI container in the Replicated dashboard.
1. As a superuser (to preserve user permissions), unzip the Travis backup you made and copy the directories to the appropriate places (`/var/travis` and `/etc/travis`).
1. Start Travis CI via the Replicated dashboard

Note, that this does still put you on the latest version of Travis CI Enterprise. Rolling back strategies will need to be coordinated with the Travis CI team as it requires changing licenses back to the legacy release channel.

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}