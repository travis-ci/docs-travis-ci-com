---
title: BitBalloon Deployment
layout: en
deploy: v2
provider: bitballoon
---

Travis CI can automatically deploy files to [BitBalloon](https://www.bitballoon.com/) after a successful build.

To deploy the current directory to BitBalloon, add your encrypted BitBalloon `site-id` and `access-token` to your `.travis.yml`:

```yaml
deploy:
  provider: bitballoon
  site-id:
    secure: "YOUR ENCRYPTED SITE ID"
  access-token:
    secure: "YOUR ENCRYPTED ACCESS TOKEN"
```
{: data-file=".travis.yml"}

## Deploying a specific directory

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

{% include deploy/shared.md %}
