---
title: TCIE 2.x Operations Manual
layout: en_enterprise

---

## User Management Commands in TCIE 2.x

Travis CI Enterprise (TCIE) version 2.x has the following user management options.

These commands are run via the command line on the platform instance.

### User Information 

List basic information about users and their status.

`travis users`  - list every user.

`travis users --active` - list every active user.

`travis users --suspended` - list every suspended user.

### Suspend and Unsuspend Users in TCIE 2.x

Suspend or unsuspend users. Builds triggered by suspended users are blocked by `travis-gatekeeper`.

`travis suspend <login>` - suspend a user where `<login>` is the user's GitHub login.

`travis unsuspend <login>` - unsuspend a user where `<login>` is the user's GitHub login.

**Please note**: Using the `suspend` command does not restrict access to the Enterprise platform.
It removes a seat restriction for an archived user. If a *suspended* user logs into the platform, the seat restriction will be imposed again.

### Syncing a User in TCIE 2.x

To sync a user (not technically part of User Management, but a related task):

To sync one user: `travis sync_users --logins=<login>` 

To sync all users: `travis sync_users`.

## Travis CI Enterprise 2.x SSL Certificate Management

This section contains information about SSL certificates and their use in Travis CI Enterprise (TCIE).

By default, Travis CI Enterprise verifies SSL for all traffic between internal platform components, RabbitMQ, and, e.g., Github.com/Github Enterprise. SSL verification helps to ensure that traffic is delivered securely.

> It is **strongly recommended** that you configure your installation with a valid certificate from a trusted authority.

### Use a trial license in TCIE 2.x 

When prompted to provide a custom SSL certificate during installation, you can select the 'Use Self-Signed Cert' option.

### Disable SSL Verification in TCIE 2.x

To disable SSL verification in Travis CI Enterprise 2.x:

1. Log into your dashboard at `https://<your-travis-ci-enterprise-domain>:8800`.
2. Click on 'Settings' in the topmost menu.
3. Click 'Advanced Settings' in the left menu (or scroll down).
4. Check the box for 'Disable SSL cert verification'.
5. Click 'Save' at the bottom of the page.

> Please note that this will require a restart of Travis CI Enterprise to take effect and may cause brief downtime.

This will remove SSL verification checks with internal traffic between Travis CI components. This will also cause all repository hooks created on GitHub to turn off SSL verification for traffic coming to Travis CI.

> Please note that this setting will only apply to hooks created _after_ the setting was enabled.

### Add or Update Certificates in TCIE 2.x

To upload your certificates:

1. Log into your dashboard at `https://<your-travis-ci-enterprise-domain>:8800`.
2. Click the gear icon on the rightmost side of the top menu and select 'Console Settings' from the dropdown.
3. Click 'TLS Key & Cert' in the left menu (or scroll down).
4. Select the appropriate option depending on the location of your certificate files.
5. Enter the paths or select the files to upload.
6. Click 'Save' at the bottom of the page.

> Please note that this will require a restart of Travis CI Enterprise to take effect and may cause brief downtime.

> A valid x509 certificate and private key files are required. The certificate and key must be in PEM format. The key must be unencrypted.

### Intermediate Certificate Chains in TCIE 2.x

To add your certificate chain:

1. Log into your dashboard at `https://<your-travis-ci-enterprise-domain>:8800`.
2. Click on 'Settings' in the topmost menu.
3. Click 'Advanced Settings' in the left menu (or scroll down).
4. Copy and paste your certificate chain into the text box labeled 'Custom Certificate Authority (CA) Bundle'.
5. Click 'Save' at the bottom of the page.

> Please note that this will require a restart of Travis CI Enterprise to take effect and may cause a brief downtime.

Upon restart, you can verify whether SSL verification is working. If you are still experiencing trouble after setting the chain, please contact us at [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com) for assistance.


### How to use a Let's Encrypt SSL Certificate in TCIE 2.x

You can use a certificate from [Let's Encrypt](https://letsencrypt.org/) instead of a self-signed certificate or a certificate purchased from a trusted certificate authority. Certificates from Let's Encrypt are free and behave the same as those purchased from a trusted certificate authority.

What you will need:

- An email address (Let's Encrypt will send notifications regarding urgent renewal and security issues).
- A domain name under which your installation is available.

#### Install certbot in TCIE 2.x

We will be using [certbot](https://certbot.eff.org/#ubuntutrusty-other) to obtain an SSL certificate from Let's Encrypt. To install certbot:

1. Open an SSH connection to the platform machine.
2. Add the certbot personal package archive:
  ```bash
  sudo add-apt-repository ppa:certbot/certbot
  ```
3. Update available packages:
  ```bash
  sudo apt-get update
  ```
3. Install required certbot dependency:
  ```bash
  sudo apt-get install software-properties-common
  ```
5. Install the certbot package:
  ```bash
  sudo apt-get install certbot
  ```

#### Generate a new Let's Encrypt certificate in TCIE 2.x

The certbot tool offers multiple ways to obtain a certificate. We'll pick the 'temporary webserver' option since it requires no additional setup or configuration. The only prerequisite is that the Travis CI Enterprise container must be stopped so that the certbot webserver can bind properly to port 443.

> Your Travis CI Enterprise instance will be unavailable during this process.

Follow these steps to generate a new Let's Encrypt certificate.

1. Open an SSH connection to the platform machine.
2. Stop your Travis CI Enterprise:
  ```bash
  replicatedctl app stop
  ```
3. Start the interactive certificate process:
  ```bash
  sudo certbot certonly
  ```
4. Add the prompt, select option `1` to `Spin up a temporary webserver`:
  ```bash
  How would you like to authenticate with the ACME CA?
  -------------------------------------------------------------------------------
  1: Spin up a temporary webserver (standalone)
  2: Place files in webroot directory (webroot)
  -------------------------------------------------------------------------------
  Select the appropriate number [1-2], then [enter] (press 'c' to cancel): 1
  ```
5. Fill in your email address:
  ```bash
  Enter email address (used for urgent renewal and security notices) (Enter 'c' to
  cancel): ops@example.com
  ```
6. Accept the Terms of Services:
  ```bash
  -------------------------------------------------------------------------------
  Please read the Terms of Service at
  https://letsencrypt.org/documents/LE-SA-v1.1.1-August-1-2016.pdf. You must agree
  to register with the ACME server at
  https://acme-v01.api.letsencrypt.org/directory
  -------------------------------------------------------------------------------
  (A)gree/(C)ancel: A
  ```
7. Decide if you'd like to share your email address with the EFF (this decision has no effect on your certificate or your Travis CI Enterprise instance):
  ```bash
  -------------------------------------------------------------------------------
  Would you be willing to share your email address with the Electronic Frontier
  Foundation, a founding partner of the Let's Encrypt project and the non-profit
  organization that develops Certbot? We'd like to send you an email about EFF and
  our work to encrypt the web, protect its users and defend digital rights.
  -------------------------------------------------------------------------------
  (Y)es/(N)o: N
  ```
8. Provide your domain name:

  ```bash
  Please enter your domain name(s) (comma and/or space separated)  (Enter 'c'
  to cancel): <your-travis-ci-enterprise-domain>
  ```
9. Upon successful completion, you should see a message similar to the following:

  ```bash
  IMPORTANT NOTES:
     Congratulations! Your certificate and chain have been saved at:
     /etc/letsencrypt/live/<your-travis-ci-enterprise-domain>/fullchain.pem
     Your key file has been saved at:
     /etc/letsencrypt/live/<your-travis-ci-enterprise-domain>/privkey.pem
     Your cert will expire on 2018-02-07. To obtain a new or tweaked
     version of this certificate in the future, simply run certbot
     again. To non-interactively renew *all* of your certificates, run
     "certbot renew"
  ```

10. Restart your Travis CI Enterprise instance:

  ```bash
  replicatedctl app start
  ```

Your certificate is now generated and saved on your Travis CI Enterprise platform machine. However, you must take additional steps to configure your Travis CI Enterprise instance to use the new certificate. For instructions, please see the [Using a Let's Encrypt certificate](#using-a-lets-encrypt-certificate) section.

#### Let's Encrypt certificate in TCIE 2.x 

> Your Travis CI Enterprise instance will be unavailable during this process.

To use your generated certificate in your Travis CI Enterprise 2.x instance:

1. Log into your dashboard at `https://<your-travis-ci-enterprise-domain>:8800`.
2. On the rightmost side of the top menu, click the gear icon and select 'Console Settings' from the dropdown.
3. Click 'TLS Key & Cert' in the left menu (or scroll down).
4. Select the 'Server path' option.
5. Enter the paths to your certificate provided in the certbot output above. Example:
  ```
  - SSL Private Key Filename: `/etc/letsencrypt/live/<your-travis-ci-enterprise-domain>/privkey.pem`
  - SSL Certificate Filename: `/etc/letsencrypt/live/<your-travis-ci-enterprise-domain>/fullchain.pem`
  ```
6. Click 'Save' at the bottom of the page.
7. Open an SSH connection to the platform machine.
8. Stop your Travis CI Enterprise instance:
  ```bash
  replicatedctl app stop
  ```
9. Restart your Travis CI Enterprise instance:
  ```bash
  replicatedctl app start
  ```

### Renew the Let's Encrypt Certificate for TCIE 2.x

> Your Travis CI Enterprise instance will be unavailable during this process.

To manually renew your certificate for another 90 days:

1. Open an SSH connection to the platform machine.
2. Stop your Travis CI Enterprise instance:
  ```bash
  replicatedctl app stop
  ```
3. Perform the certificate renewal:
  ```bash
  sudo certbot renew
  ```
4. Restart your Travis CI Enterprise instance:
  ```bash
  replicatedctl app start
  ```

### Use Cron Jobs to Automate the renewal of the Let's Encrypt SSL Certificate in TCIE2.x

You can avoid manual renewals by using a cron job to automate the certbot renewal:

1. Create `/home/ubuntu/renew-certs.sh` containing the following script:

    ```bash
    #!/bin/bash

    set -u

    function usage() {
      echo
      echo "Usage: $(basename $0)"
      echo
      echo "Simple script to renew certs, should be used via a cron. Assumes that certs are already set up."
      echo
      echo "See https://docs.travis-ci.com/user/enterprise/platform-tips/#use-a-lets-encrypt-ssl-certificate for initial setup info."
      echo

      exit 1
    }

    if [[ $# -ne 0 ]]; then
      usage
    fi

    replicatedctl app stop
    sudo certbot renew
    replicatedctl app start
    ```
    {: data-file="/home/ubuntu/renew-certs.sh"}

2. Make the script executable:

    ```sh
    $ chmod +x /home/ubuntu/renew-certs.sh
    ```

3. Create a cronjob by editing `/etc/crontab` and appending the following:

    ```sh
    # Renews certs at 2 am on the 1st of February, May, August, and November.
    # Please change the configuration that applies to the certificate you are creating.
    0 2 1 2,5,8,11 * /home/ubuntu/renew-certs.sh
    ```
    {: data-file="/etc/crontab"}

> This process will introduce a small downtime while the certificates are renewed. We recommend that you communicate with your users before each renewal so they know that their builds will temporarily be stopped until the certificate is renewed.

## Travis CI Enterprise 2.x Troubleshooting 

This section provides guidelines and suggestions for troubleshooting your Travis CI Enterprise installation.

Throughout this document, we'll be using the following terms to refer to the two components of your Travis CI Enterprise 2.x installation:

- `Platform machine`: The instance that runs the main Travis components, including the web frontend.
- `Worker machine`: The worker instance(s) that process and run the builds.

> This guide is geared towards non-High Availability (HA) setups. Please contact us at [enterprise@travis-ci.com](mailto:enterprise@travis-ci.com) if you require support for your HA setup.

### Issue when running Enterprise v2.2 or higher

By default, the Enterprise Platform v2.2 or higher will attempt to route builds to the `builds.trusty` queue. This could lead to build issues if you are not running a Trusty worker to process those builds or targeting a different distribution (e.g., `xenial`).

To address this, either:

- Ensure that you have installed a Trusty worker on a new virtual machine instance: [Trusty installation guide](/user/enterprise/trusty/)
- Override the default queuing behavior to specify a new queue. To override the default queue, you must access the Admin Dashboard at `https://<your-travis-ci-enterprise-domain>:8800/settings#override_default_dist_enable` and toggle the 'Override Default Build Environment' button. This will allow you to specify the new default based on your needs and the workers that you have available.

### Enterprise Container Fails to Start due to 'context deadline exceeded' Error

After a fresh installation or configuration change, the Enterprise container doesn't start, and the following error is visible in the Admin Dashboard found at `https://<your-travis-ci-enterprise-domain>:8800/dashboard`:

```
Ready state command canceled: context deadline exceeded
```

### User Accounts Stuck in Syncing State

One or more user accounts are stuck in the `is_syncing = true` state. When you query the database, the number of currently syncing users does not decrease over time. Example:

```sql
travis_production=> select count(*) from users where is_syncing=true;
 count
-------
  1027
(1 row)
```
#### Workaround

**TCIE 2.x**: Log into the platform machine via SSH. Run `$ travis console`

Next, run:

```bash
>> User.where(is_syncing: true).count
>> ActiveRecord::Base.connection.execute('set statement_timeout to 60000')
>> User.update_all(is_syncing: false)
```

It can happen that organizations are also stuck in the syncing state. Since an organization does not have an `is_syncing` flag, all users that belong to it must be successfully synced.

### Logs contain GitHub API 422 errors

On every commit made when a build runs, a commit status is created for a given SHA. Due to GitHub’s limitations at 1,000 statuses per SHA and context within a repository, if more than 1,000 statuses are created, this leads to a validation error.
This issue should no longer be present in GitHub Apps integrations but will be present in Webhooks integrations.

#### Workaround

The workaround for this issue is to manually re-sync the user account with GitHub. This will generate a fresh token for the user account that has not reached any GitHub API limits.

An administrator can also initiate a sync on behalf of someone else. Follow these steps to sync the account from the CLI with administrator privileges.

**TCIE 2.x**: via the `travis` CLI tool on the platform machine:

> If `—logins=<GITHUB-LOGIN>` is not provided, then this command will trigger a sync on every user. This could result in long runtimes and may impact production operations if you have many total users on your Travis CI Enterprise instance.

1. Open an SSH connection to the platform machine.
2. Initiate a sync by running `travis sync_users —logins=<GITHUB-LOGIN>`

## Contact Enterprise Support

{{ site.data.snippets.contact_enterprise_support }}
