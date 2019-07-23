---
title: BitBalloon Deployment
layout: en

---

[//]: # someone needs to check all 'bitballon' entries, if they still work or have to be replaced by netlify drop

Travis CI can automatically deploy files to
[Netlify Drop](https://app.netlify.com/drop) after a successful build.

To deploy the current directory to Netlify Drop, add your encrypted Netlify Drop `site-id` and `access-token` to your `.travis.yml`:

```yaml
deploy:
  provider: bitballoon
  site-id:
    secure: "YOUR ENCRYPTED SITE ID"
  access-token:
    secure: "YOUR ENCRYPTED ACCESS TOKEN"
```
{: data-file=".travis.yml"}



## Deploying a Specific Directory

To deploy a specific directory to BitBalloon, use the `local-dir` key:

```yaml
deploy:
  provider: bitballoon
  site-id:
    secure: "YOUR ENCRYPTED SITE ID"
  access-token:
    secure: "YOUR ENCRYPTED ACCESS TOKEN"
  local-dir: "_build/"
```
{: data-file=".travis.yml"}

## Running Commands Before and After Deploy

Sometimes you want to run commands before or after deploying. You can use
the `before_deploy` and `after_deploy` stages for this. These will only be
triggered, if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
