---
title: Catalyze Deployment
layout: en

---

<div id="toc"></div>

Travis CI can automatically deploy to [Catalyze](https://www.catalye.io/) after
a successful build.

Before configuring your `.travis.yml` you need to:

1. Find your Catalyze git remote:
    1. Make sure your Catalyze environment is
       [associated](https://resources.datica.com/compliant-cloud/articles/initial-setup/#sts=4. Associate to Your Environment).
    2. Get the git remote by running `git remote -v`{: #remote} from within the associated repository.

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
    2. Find and copy the line from known_hosts that includes the git remote found in [Step 1](#remote){: data-proofer-ignore=""}. It'll look something like

       ```
       [git.catalyzeapps.com]:2222 ecdsa-sha2-nistp256 BBBB12abZmKlLXNo...
       ```

    3. Update your `before_deploy` step in `.travis.yml` to update the `known_hosts` file:

       ```yaml
       before_deploy:  echo "[git.catalyzeapps.com]:2222 ecdsa-sha2-nistp256 BBBB12abZmKlLXNo..." >> ~/.ssh/known_hosts
       ```

### Deploying a subset of your Files

To only deploy the `build` folder, for example, set `skip_cleanup: true` and
path: "build":

```yaml
deploy:
  provider: catalyze
  target: "ssh://git@git.catalyzeapps.com:2222/app1234.git"
  skip_cleanup: true
  path: "build"
```

### Running commands before and after deploy

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
