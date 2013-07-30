---
title: Custom Deployment
layout: en
permalink: custom/
---

You can easily deploy to your own server the way you would deploy from your local machine by adding a custom [`after_success`](/docs/user/build-configuration/#Define-custom-build-lifecycle-commands) step.

### FTP

    env:
      global:
        - "FTP_USER=user"
        - "FTP_PASSWORD=password"
    after_success:
        "wget -r ftp://server.com/ --user $FTP_USER --password $FTP_PASSWORD"

The env variables `FTP_USER` and `FTP_PASSWORD` can also be [encrypted](/docs/user/encryption-keys/).

### Git

This should also work with services you can deploy to via git.

    after_success:
      - chmod 600 .travis/deploy_key.pem # this key should have push access
      - ssh-add .travis/deploy_key.pem
      - git remote add deploy DEPLOY_REPO_URI_GOES_HERE
      - git push deploy

See ["How can I encrypt files that include sensitive data?"](/docs/user/travis-pro/#How-can-I-encrypt-files-that-include-sensitive-data%3F) if you don't want to commit the private key unencrypted to your repository.
