---
title: Firebase Deployment
layout: en
permalink: /user/deployment/firebase/
---

<div id="toc"></div>

Travis CI can automatically deploy your application to [Firebase](https://firebase.google.com/)
application after a successful build.

To use the default configuration, add your [encrypted](/user/encryption-keys/#Usage) Firebase [token](/user/deployment/firebase/#Generating-your-Firebase-token) to your `.travis.yml`, all other information is read from your `firebase.json`:

```yaml
deploy:
  provider: firebase
  token:
    secure: "YOUR ENCRYPTED token"
```

## Generating your Firebase token

Generate your Firebase after [installing the Firebase tools](https://github.com/firebase/firebase-tools#installation) by running:

```bash
firebase login:ci
```

Remember to [encrypt](/user/encryption-keys/#Usage) the token before adding it to your `.travis.yml`

## Deploying to a custom project

To deploy to a different project than the one specified in the `firebase.json`, use the `project` key in your `.travis.yml`:

```yaml
deploy:
  provider: firebase
  token:
    secure: "YOUR ENCRYPTED token"
  project: "myapp-staging"
```

## Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use
the `before_deploy` and `after_deploy` stages for this. These will only be
triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
