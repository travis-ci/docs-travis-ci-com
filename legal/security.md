---
title: Security Statement
layout: en
no_toc: true
---
of Travis CI GmbH (Travis) regarding the software Travis CI

Security is our major concern when it comes to your source code. At Travis CI, we make sure our infrastructure is protected and secure so that your most valuable asset is safe and protected from unauthorized access.

### System Security

Your code, depending on which platform or language runtime you're using, is run on virtualized servers running in:

- Amazon EC2 datacenters in Ashburn, VA, USA.
- MacStadium datacenters in Atlanta, GA, USA.
- Google Compute Engine datacenters in Berkeley County, SC and Council Bluffs, Iowa, USA.

Your tests run in an isolated environment. The virtualized servers they're running on are disposed of after each run and always restored from a snapshotted image that has no knowledge of any source code other than the code required to create our build environment.

All traffic to and inside of Travis CI is secured and encrypted with SSL/TLS.

We reserve the right to change the underlying infrastructure of Travis CI at any time.

### Services Used and Data Stored in them
We use the following services to run Travis CI:

- Amazon Web Services EC2 (security policy) and Heroku (security policy) to run all of the components that form the Travis CI service and to store data like build logs, OAuth tokens and user data.
- RedisGreen to store non-critical data for real-time tracking of build requests going through our system and for feature flips.
- CloudAMQP to receive and publish information about builds and test logs. Access is fully authenticated and SSL-encrypted.

We store data related to Travis, in anonymized form, with the following services:

- Librato Metrics to collect runtime data about the system to allow us to ensure the service's availability and reliability.
- Papertrail to store logs on all the components of Travis to allow us investigating issues. The logs can include names of users and repositories used, but they're scrubbed of any kind of sensitive information.
- Google Analytics to track visits to our website.

We reserve the right to change the services used to run Travis CI at any time.

Our use of the above services is bound to their respective security precautions and their availability.

### Credit Card Data
Travis does not store or receive any kind of credit card data other than a reference token that allows us to create payments with our payments provider Stripe, a PCI Level 1 certified payments provider. Please refer to their security policy for more details: https://stripe.com/help/security.

### How does Travis access my GitHub account?
When you sign up for Travis, we collect an OAuth token from GitHub, which allows us to request data from the GitHub API on your behalf. This OAuth token is stored securely in our database and is protected from unauthorized access.

The token is bound to permissions set on GitHub, so please make sure you've read their documentation on access control and API access permissions.

We use this token in these situations, and under no other circumstances than described below.

- To synchronize the repositories you have access to. We use this information to show you the available repositories on your profile page so you can enable or disable building them on Travis.
- To configure service hooks on a repository you configure to run on Travis
- To generate and store an SSH key on GitHub, which is used to access your source code on your build machines. We store this key securely and use it every time we get a build notification from GitHub to access your source code on our machines.
- To update the build status of a commit.
- To access the project configuration file .travis.yml from your GitHub repository

Under no circumstances does Travis CI write or modify source code or Git metadata in your GitHub repositories, source code from your repositories is accessed read-only for the sole purpose of automatically executing the tests or any other build commands requested.

However, to allow us to automatically specify SSH keys, service hook configurations and commit status on your GitHub repositories, we have to request write access to them.

We only manually access your code when explicitly requested by you and only in explicit consent with you, and only to debug and help solve build issues.

### How does Travis access my Bitbucket account?
When you sign up for Travis, we collect an OAuth token from Bitbucket, which allows us to request data from the Bitbucket API on your behalf. This OAuth token is stored securely in our database and is protected from unauthorized access.

The token is bound to permissions set on Bitbucket, so please make sure you've read their documentation on access control and API access permissions.

We use this token in these situations, and under no other circumstances than described below.

- To synchronize the repositories and teams you have access to. We use this information to show you the available repositories on your profile page so you can enable or disable building them on Travis.
- To configure service hooks on a repository you configure to run on Travis
- To generate and store an SSH key on Bitbucket, which is used to access your source code on your build machines. We store this key securely and use it every time we get a build notification from Bitbucket to access your source code on our machines.
- To update the build status of a commit.
- To access the project configuration file .travis.yml from your Bitbucket repository

Under no circumstances does Travis CI write or modify source code or Git metadata in your Bitbucket repositories, source code from your repositories is accessed read-only for the sole purpose of automatically executing the tests or any other build commands requested.

However, to allow us to automatically specify SSH keys, service hook configurations and commit status on your Bitbucket repositories, we have to request write access to them.

We only manually access your code when explicitly requested by you and only in explicit consent with you, and only to debug and help solve build issues.

### How does Travis access my GitLab account?
When you sign up for Travis, we collect an OAuth token from GitLab, which allows us to request data from the GitLab API on your behalf. This OAuth token is stored securely in our database and is protected from unauthorized access.

The token is bound to permissions set on GitLab, so please make sure you've read their documentation on access control and API access permissions.

We use this token in these situations, and under no other circumstances than described below.

- To synchronize the repositories and teams you have access to. We use this information to show you the available repositories on your profile page so you can enable or disable building them on Travis.
- To configure service hooks on a repository you configure to run on Travis
- To generate and store an SSH key on GitLab, which is used to access your source code on your build machines. We store this key securely and use it every time we get a build notification from GitLab to access your source code on our machines.
- To update the build status of a commit.
- To access the project configuration file .travis.yml from your GitLab repository

Under no circumstances does Travis CI write or modify source code or Git metadata in your GitLab repositories, source code from your repositories is accessed read-only for the sole purpose of automatically executing the tests or any other build commands requested.

However, to allow us to automatically specify SSH keys, service hook configurations and commit status on your GitLab repositories, we have to request write access to them.

We only manually access your code when explicitly requested by you and only in explicit consent with you, and only to debug and help solve build issues.

### How does Travis access my Assembla account?
When you sign up for Travis, we collect an OAuth token from Assembla, which allows us to request data from the Assembla API on your behalf. This OAuth token is stored securely in our database and is protected from unauthorized access.

The token is bound to permissions set on Assembla, so please make sure you've read their documentation on access control and API access permissions.

We use this token in these situations, and under no other circumstances than described below.

- To synchronize the repositories and spaces you have access to. We use this information to show you the available repositories on your profile page so you can enable or disable building them on Travis.
- To configure service hooks on a repository you configure to run on Travis
- To generate and store an SSH key on Assembla, which is used to access your source code on your build machines. We store this key securely and use it every time we get a build notification from Assembla to access your source code on our machines.
- To update the build status of a commit.
- To access the project configuration file .travis.yml from your Assembla repository

Under no circumstances does Travis CI write or modify source code or Git metadata in your Assembla repositories, source code from your repositories is accessed read-only for the sole purpose of automatically executing the tests or any other build commands requested.

However, to allow us to automatically specify SSH keys, service hook configurations and commit status on your Assembla repositories, we have to request write access to them.

We only manually access your code when explicitly requested by you and only in explicit consent with you, and only to debug and help solve build issues.


### How does Travis access my source code?
Other than reading your .travis.yml to determine the best build strategy, the only time we access your repository directly is when checking out the source code on one of our build machines.

Source code is only accessed via SSH, using SSH keys for authentication. Each project setup up on Travis gets its own SSH key, you'll receive an email notification when we add it to your project. This step happens when you set up the project on Travis CI for the first time. For each forked repository on each pull request to the target repository Travis CI checks and adds an SSH key from the target repository.

### What data do we store from GitHub?
When you push code to GitHub for a repository that is set up to run on Travis, we get a push notification. The same is true for pull requests that are sent to us.

These notifications don't include any sensitive information other than commit references, names of files changed, and who authored and committed the changes.

We store these build notifications for debugging purposes, and for debugging purposes only.

### What data do we store from Bitbucket?
When you push code to Bitbucket for a repository that is set up to run on Travis, we get a push notification. The same is true for pull requests that are sent to us.

These notifications don't include any sensitive information other than commit references, names of files changed, and who authored and committed the changes.

We store these build notifications for debugging purposes, and for debugging purposes only.

We store the user OAuth token to make a call to the Bitbucket API.

We store active user emails to send build notification emails.

### What data do we store from GitLab?
When you push code to GitLab for a repository that is set up to run on Travis, we get a push notification. The same is true for pull requests that are sent to us.

These notifications don't include any sensitive information other than commit references, names of files changed, and who authored and committed the changes.

We store these build notifications for debugging purposes, and for debugging purposes only.

We store the user OAuth token to make a call to the GitLab API.

We store active user emails to send build notification emails.

### What data do we store from Assembla?
When you push code to Assembla for a repository that is set up to run on Travis, we get a push notification. The same is true for pull requests that are sent to us.

These notifications don't include any sensitive information other than commit references, names of files changed, and who authored and committed the changes.

We store these build notifications for debugging purposes, and for debugging purposes only.

We store the user OAuth token to make a call to the Assembla API.

We store active user emails to send build notification emails.

### I have more questions about security and Travis
Send us an email, and we'll get back to you right away!

Version 1.2, Berlin, 7. June 2016: Remove Blue Box

Version 1.1, Berlin, 2. July 2013: Replace Hetzner with Blue Box

Version 1.0, Berlin, 3. January 2013
