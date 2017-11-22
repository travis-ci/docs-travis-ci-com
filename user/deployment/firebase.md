---
title: Firebase Deployment
layout: en

---

<div id="toc"></div>

Travis CI can automatically deploy your application to [Firebase](https://firebase.google.com/)
application after a successful build.

<aside markdown="block" class="ataglance">

## Options

{{ site.data.dpl.firebase }}

</aside>

To use the default configuration, add your [encrypted](/user/encryption-keys/#Usage) Firebase [token](/user/deployment/firebase/#Generating-your-Firebase-token) to your `.travis.yml`, all other information is read from your `firebase.json`:

```yaml
deploy:
  provider: firebase
  token:
    secure: "YOUR ENCRYPTED token"
```
{: data-file=".travis.yml"}

## Generating your Firebase token

Generate your Firebase token after [installing the Firebase tools](https://github.com/firebase/firebase-tools#installation) by running:

```bash
# This generates a token, e.g. "1/AD7sdasdasdKJA824OvEFc1c89Xz2ilBlaBlaBla"
firebase login:ci
# Encrypt this token
travis encrypt "1/AD7sdasdasdKJA824OvEFc1c89Xz2ilBlaBlaBla" --add
# This command may generate a warning ("If you tried to pass the name of the repository as the first argument, you probably won't get the results you wanted"). You can ignore it.
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
{: data-file=".travis.yml"}

## Adding a message to a deployment

To add a message to describe the deployment, use the `message` key in your `.travis.yml`:

```yaml
deploy:
  provider: firebase
  token:
    secure: "YOUR ENCRYPTED token"
  message: "your message"
```
{: data-file=".travis.yml"}

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
{: data-file=".travis.yml"}
