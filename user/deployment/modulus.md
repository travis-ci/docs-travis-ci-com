---
title: Modulus Deployment
layout: en
permalink: /user/deployment/modulus/
---

Travis CI can automatically deploy your [Modulus](https://modulus.io/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```
deploy:
  provider: modulus
  api_key: "YOUR API KEY"
  project_name: "YOUR PROJECT NAME"
```

You can create an API key by running `modulus token create` or retrieve an existing one by running `modulus token list`.
It is recommended to encrypt that key. Assuming you have the Modulus and Travis CI command line clients installed, you can do it like this:

```
$ modulus token create
Welcome to Modulus
You are logged in as USER
[✓] Token: THE-API-TOKEN
...
$ travis encrypt THE-API-TOKEN --add deploy.api_key
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to deploy from

By default, Travis CI will only deploy from your **master** branch.

You can explicitly specify the branch to deploy from with the **on** option:

```
deploy:
  provider: modulus
  api_key: ...
  project_name: ...
  on: production
```

Alternatively, you can also configure it to deploy from all branches:

```
deploy:
  provider: modulus
  api_key: ...
  project_name: ...
  on:
    all_branches: true
```

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests run and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```
deploy:
  provider: modulus
  api_key: ...
  project_name: ...
  skip_cleanup: true
```

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

```
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
