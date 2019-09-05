---
title: Datica Deployment
layout: en
deploy: v2
provider: datica
---

Travis CI can automatically deploy to [Datica](https://datica.com) after
a successful build.

Before configuring your `.travis.yml` you need to:

### Find your Catalyze git remote

Make sure your Catalyze environment is [associated](https://resources.datica.com/compliant-cloud/articles/initial-setup/#sts=4. Associate to Your Environment).

Get the git remote by running `git remote -v`{: #remote} from within the associated repository, and add it to your `.travis.yml`

```yaml
deploy:
  provider: catalyze
  target: ssh://git@git.catalyzeapps.com:2222/app1234.git
```
{: data-file=".travis.yml"}

### Set up the repository's key as a deployment key on Datica

Install the Travis CI [command line client](https://github.com/travis-ci/travis.rb), and get the public SSH key for your Travis CI project and save it to a file by running

```bash
travis pubkey > travis.pub
```

Add the key as a deploy key using the catalyze command line client within the associated repo. For example:

```bash
catalyze deploy-keys add travisci ./travis.pub your-service
```

### Set up Datica as a known host on Travis CI

List your known hosts by running `cat ~/.ssh/known_hosts`, and find and copy the line that includes the git remote found in [Step 1](#remote){: data-proofer-ignore=""}.

It'll look something like:

 ```
 [git.catalyzeapps.com]:2222 ecdsa-sha2-nistp256 BBBB12abZmKlLXNo...
 ```

Update your `before_deploy` step in `.travis.yml` to update the `known_hosts` file:

 ```yaml
 before_deploy: echo "[git.catalyzeapps.com]:2222 ecdsa-sha2-nistp256 BBBB12abZmKlLXNo..." >> ~/.ssh/known_hosts
 ```
 {: data-file=".travis.yml"}

### Deploying a subset of your Files

To only deploy the `build` folder, for example, set `path`:

```yaml
deploy:
  provider: catalyze
  target: ssh://git@git.catalyzeapps.com:2222/app1234.git
  skip_cleanup: true
  path: build
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
