---
title: Script deployment
layout: en

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
{: data-file=".travis.yml"}

If you need to run multiple commands, write a executable wrapper script that runs them all.

If the script returns a nonzero status, deployment is considered
a failure, and the build will be marked as "errored".

## Passing Arguments to the Script

It is possible to pass arguments to a script deployment.

```yaml
deploy:
  # deploy develop to the staging environment
  - provider: script
    script: scripts/deploy.sh staging
    on:
      branch: develop
  # deploy master to production
  - provider: script
    script: scripts/deploy.sh production
    on:
      branch: master
```
{: data-file=".travis.yml"}

The script has access to all the usual [environment variables](/user/environment-variables/#Default-Environment-Variables).

```yaml
deploy:
  provider: script
  script: scripts/deploy.sh production $TRAVIS_TAG
  on:
    tags: true
    all_branches: true
```
{: data-file=".travis.yml"}

## Ruby version

To ensure that deployments run consistently, we use the version of Ruby that is
pre-installed on all of our build images, which may change when images are updated.

* The `travis_internal_ruby` function prints the exact pre-installed Ruby version

If you need to run a command that requires a different Ruby version than the
pre-installed default, you need to set it explicitly:

```yaml
deploy:
  provider: script
  script: rvm use $TRAVIS_RUBY_VERSION do script.rb
```
{: data-file=".travis.yml"}
