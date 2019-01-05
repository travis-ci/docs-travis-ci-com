---
title: Custom Deployment
layout: en

---

You can deploy to your own server the way you would deploy from your local
machine by adding a custom [`after_success`](/user/customizing-the-build/) step.

You may choose the [Script provider](/user/deployment/script/) instead, as it
provides conditional deployment.

### SFTP

```yaml
env:
  global:
  - 'SFTP_USER=[user]'
  - 'SFTP_PASSWORD=[password]'
  - 'SFTP_KEY=[base64-encoded-rsa-key]'
after_success:
- echo "${SFTP_KEY}" | base64 --decode >/tmp/sftp_rsa
- curl --ftp-create-dirs
       -T filename
       --key /tmp/sftp_rsa
       sftp://${SFTP_USER}:${SFTP_PASSWORD}@example.com/directory/filename
```
{: data-file=".travis.yml"}

The env variables `SFTP_USER` and `SFTP_PASSWORD` can also be
[encrypted](/user/encryption-keys/).

See [curl(1)](http://curl.haxx.se/docs/manpage.html) for more details on how to
use cURL as an SFTP client.

### Git

This should also work with services you can deploy to via git.

```yaml
after_success:
  - eval "$(ssh-agent -s)" #start the ssh agent
  - chmod 600 .travis/deploy_key.pem # this key should have push access
  - ssh-add .travis/deploy_key.pem
  - git remote add deploy DEPLOY_REPO_URI_GOES_HERE
  - git push deploy
```
{: data-file=".travis.yml"}

See ["How can I encrypt files that include sensitive data?"](/user/travis-ci-for-private/#how-can-i-encrypt-files-that-include-sensitive-data) if you don't want to commit the private key unencrypted to your repository.
