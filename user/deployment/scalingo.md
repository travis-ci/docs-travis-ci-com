---
title: Scalingo deployment
layout: en

---

<div id="toc"></div>

Travis CI can automatically deploy your application to
[Scalingo](https://scalingo.com/) application after a successful build.

<aside markdown="block" class="ataglance">

## Options

{{ site.data.dpl.scalingo }}

</aside>

Chose one of two ways to connect to your Scalingo account:

* Using a [username and password](/user/deployment/scalingo/#Connecting-using-a-username-and-password).
* Using an [api key](/user/deployment/scalingo/#Connecting-using-an-api-key).

<!-- I'm not 100% sure if you need to connect to scalingo manually using the cli
tool the first time -->

## Connecting using a username and password

Add your Scalingo username and your [encrypted](/user/encryption-keys/#Usage)
Scalingo password to your `.travis.yml`:

```yaml
deploy:
  provider: scalingo
  user: "<Your username>"
  password:
    secure: "YOUR ENCRYPTED PASSWORD"
```
{: data-file=".travis.yml"}

## Connecting using an api key

Add your [encrypted](/user/encryption-keys/#Usage)
Scalingo `api_key` to your `.travis.yml`:

```yaml
deploy:
  provider: scalingo
  api_key:
    secure: "YOUR ENCRYPTED PASSWORD"
```
{: data-file=".travis.yml"}

## Optional settings

* `remote`: Remote url or git remote name of your git repository. The default
  remote name is "scalingo".
* `branch`: Branch of your git repository to deploy. The default branch name is
  "master".
* `app`: Only necessary if your repository does not contain the appropriate
  remote. Specifying the `app` will add a remote to your local repository: `git
  remote add <remote> git@scalingo.com:<app>.git`

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
{: data-file=".travis.yml"}
