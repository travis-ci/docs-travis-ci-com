---
title: Firebase Deployment
layout: en

---



Travis CI can automatically deploy your application to [Firebase](https://firebase.google.com/)
after a successful build.

To use the default configuration, add your [encrypted](/user/encryption-keys/#usage) Firebase [token](/user/deployment/firebase/#generating-your-firebase-token) to your `.travis.yml`, all other information is read from your `firebase.json`:

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
When using `travis encrypt --add` you are likely to receive `WARNING: The name of the repository is now passed to the command with the -r option` (see https://github.com/travis-ci/travis-ci/issues/7869). The token will be added to your `.travis.yml`, regardless. Inspect and move the token to the `secure:` section of your `.travis.yml` if it isn't added there. 

Remember to [encrypt](/user/encryption-keys/#usage) the token before adding it to your `.travis.yml`

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
