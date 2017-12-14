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

## Upgrading from 1.x to 2.x

### Step 1: Let the Travis team know you're ready to upgrade to 2.0

Let us know you want to upgrade to Travis CI Enterprise 2.0 by emailing [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com). This will let us put your license in "Migration Mode" and change your release channel to "2.0" so you can see the newest Travis CI. Additionally we'll provide you with a backup of your license in case you need to restore from back ups or do a fresh install.

### Step 2: Back up the Travis Encryption Key and RabbitMQ password

Once your License is in "Migration Mode" you'll see a new field at the bottom of the Admin Settings page (`https://[your travis URL]:8800/settings`) called "Travis Encryption Key". It's in the "Advanced Settings" section. **Copy down your Travis Encryption Key and store it in a safe place, without this you won't be able to read your database in the event you need to restore from a backup.**

Additionally, towards the top of the same settings page, there's a field named "RabbitMQ Password", this is the password that all of your workers use to connect to the platform server. **Copy down your RabbitMQ Password as well.**

### Step 3: Back up the databases and configuarion

SSH into the Platform machine and **back up `/var/travis` and `/etc/travis`**. One good way to do this is to run
```
  sudo tar -cvzf travis-backup-$(date +%s).tar.gz /var/travis /etc/travis/
```       

This will create a timestamped back up of these directories.

### Step 4: Confirm you have enough diskspace free for an upgrade

While SSH'd into the Platform machine, make sure you have sufficient disk space free to finish the migration by running `df -h`. Five gigs should be plenty.

### Step 5: Upgrade to the latest version of Replicated

Check to see if replicated needs to be upgraded to the latest version by running `replicated --version`. Also, check the version of Docker that you have installed by running `docker --version`. If your Docker version is less than 1.9.x you'll want to upgrade to the latest version by following the directions here before upgrading your version of Replicated. If Replicated is 2.0 or higher and Docker is 1.9 or higher, run:

```
  curl -sSL -o /tmp/installer.sh https://enterprise.travis-ci.com/install
  sudo bash /tmp/installer.sh
```

If it's less than 2.0, you'll need to migrate to the 2.X version of Replicated. You can do this by running:

```
  curl -sSL -o /tmp/migrate-v2.sh https://get.replicated.com/migrate-v2
  sudo bash /tmp/migrate-v2.sh
```    

These steps will stop Travis CI Enterprise while they run. So it's important to plan for downtime when you run them. The Replicated migration/upgrade tends to take less than 5-10 minutes but can depend on your network connection and size of database.

### Step 6: Check for the newest Travis CI Enterprise Release

Once the new version of Replicated is running, go to `http(s)://[your hostname]:8080/releases` and press the "Check Now" button. This will check for new versions of Travis Enterprise CI, wait until it has finished loading all of the releases before clicking install.

### Step 7: Install Travis CI Enterprise

Click "Install". Once this finishes, your Travis CI Enterprise container will restart to bring up the new one you just downloaded. This can introduce a small amount of downtime while it restarts. But once done you'll be on the latest version of Travis CI Enterprise!

### Restoring from backups

In the rare event of something going wrong during the upgrade you may need to restore from backup. To do that, follow these steps:

1. Boot up a replacement machine with a fresh install of Ubuntu 14.04.
1. Follow the directions at https://docs.travis-ci.com/user/enterprise/installation/ and use the license we supplied you with in Step 1 in the migration steps. If you cannot find this, contact us at enterprise@travis-ci.com
1. Setup your Travis CI instance filling out the settings as needed. Fill in the RabbitMQ password and Travis Encryption Key that you saved. Save the settings and start up the Travis container.
1. Stop the Travis CI container in the Replicated dashboard.
1. As a superuser (to preserve user permissions), unzip the Travis backup you made and copy the directories to the appropriate places (/var/travis and /etc/travis).
1. Start Travis CI via the Replicated dashboard

Note, that this does still put you on the latest version of Travis CI Enterprise. Rolling back strategies will need to be coordinated with the Travis CI team as it requires changing licenses back to the legacy release channel.
