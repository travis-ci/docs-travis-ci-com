---
title: Catalyze Deployment
layout: en
permalink: /user/deployment/catalyze/
---

<div id="toc"></div>

Travis CI can automatically deploy to [Catalyze](https://www.catalye.io/) after
a successful build.

Before configuring your `.travis.yml` you need to:

1. Find your Catalyze git remote:
    1. Make sure your Catalyze environment is
       [associated](https://resources.catalyze.io/paas/paas-cli-reference/#associate).
    2. Get the git remote by running `git remote -v` from within the associated
       repository.
       {: #remote}
    3. Edit your `.travis.yml`:

       ```yaml
       deploy:
         provider: catalyze
         target: "ssh://git@git.catalyzeapps.com:2222/app1234.git"
       ```
2. Set up a deployment key to Catalyze for Travis CI:
    1. Install the Travis CI [command line client](https://github.com/travis-ci/travis.rb).
    2. Get the public SSH key for your Travis CI project and save it to a file by running

       ```bash
       travis pubkey > travis.pub
       ```

    3. Add the key as a deploy key using the catalyze command line client within
       the associated repo. For example:

       ```bash
       catalyze deploy-keys add travisci ./travis.pub code-1
       ```

       where `code-1` is the name of your service.

3. Set up Catalyze as a known host for Travis CI:
    1. List your known hosts by running `cat ~/.ssh/known_hosts`.
    2. Find and copy the line from known_hosts that includes the git remote found in [Step 1](#remote). It'll look something like

       ```
       [git.catalyzeapps.com]:2222 ecdsa-sha2-nistp256 BBBB12abZmKlLXNo...
       ```

    3. Update your `before_deploy` step in `.travis.yml` to update the `known_hosts` file:

       ```yaml
       before_deploy:  echo "[git.catalyzeapps.com]:2222 ecdsa-sha2-nistp256 BBBB12abZmKlLXNo..." >> ~/.ssh/known_hosts
       ```


To use the default configuration, add your encrypted TODO api key to your


You can also use the Travis CI command line setup tool `travis setup TODO`.

## Deploying Custom Application Names

By default, we will try to deploy to an application by the same name as
the repository. For example, if you deploy an application from the GitHub
repository
[travis-ci/travis-chat](https://github.com/travis-ci/travis-chat) without
explicitly specify the name of the application, Travis CI will try to
deploy to a TODO app named *travis-chat*.

You can explicitly set the name via the **app** option:

```
deploy:
  provider: TODO
  api_key: ...
```

### Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use
the `before_deploy` and `after_deploy` stages for this. These will only be
triggered if Travis CI is actually deploying.

```
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
