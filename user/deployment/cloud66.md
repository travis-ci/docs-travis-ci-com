---
title: Cloud 66 Deployment
layout: en
permalink: /user/deployment/cloud66/
---

Travis CI can automatically deploy your [Cloud 66](https://www.cloud66.com/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloud66
  redeployment_hook: "YOUR REDEPLOYMENT HOOK URL"
```

You can find the redeployment hook in the information menu within the Cloud 66 portal.

You can also have the `travis` tool set up everything for you:

```bash
travis setup cloud66
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

```yaml
deploy:
  provider: cloud66
  redeployment_hook: "YOUR REDEPLOYMENT HOOK URL"
  on: production
```

Alternatively, you can also configure it to deploy from all branches:

```yaml
deploy:
  provider: cloud66
  redeployment_hook: "YOUR REDEPLOYMENT HOOK URL"
  on:
    all_branches: true
```

Builds triggered from Pull Requests will never trigger a deploy.

### Conditional Deploys

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
