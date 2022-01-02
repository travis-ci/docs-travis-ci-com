---
title: Firebase Deployment
layout: en
deploy: v2
provider: firebase
---

Travis CI can automatically deploy to [Firebase](https://firebase.google.com/)
after a successful build.

{% include deploy/providers/firebase.md %}

## Generating a Firebase token

Generate your Firebase token after [installing the Firebase tools](https://github.com/firebase/firebase-tools#installation) by running:

Run this command to generate a token (e.g. `1/AD7sdasdasdKJA824OvEFc1c89Xz2ilBlaBlaBla`)

```bash
firebase login:ci
```

## Deploying to a custom project

To deploy to a different project than the one specified in the `firebase.json`,
use the `project` option:

```yaml
deploy:
  provider: firebase
  # ⋮
  project: <project>
```
{: data-file=".travis.yml"}

## Adding a message to a deployment

To add a message to describe the deployment, use the `message` option:

```yaml
deploy:
  provider: firebase
  # ⋮
  message: <message>
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
