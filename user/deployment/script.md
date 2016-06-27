---
title: Script deployment
layout: en
permalink: /user/deployment/script/
---

If your deployment needs more customization than the `after_success` method allows,
use a custom script.

The following example runs `scripts/deploy.sh` on the `develop` branch of your repository if the build is successful.

```yaml
deploy:
  provider: script
  script: scripts/deploy.sh
  on:
    branch: develop
```

`script` must be a scalar pointing to an executable file or command.

If you need to run multiple commands, write a executable wrapper script that runs them all.

If the script returns a nonzero status, deployment is considered
a failure, and the build is marked "errored".
