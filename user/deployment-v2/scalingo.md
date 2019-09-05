---
title: Scalingo deployment
layout: en
deploy: v2
provider: scalingo
---

Travis CI can automatically deploy your application to [Scalingo](https://scalingo.com/) application after a successful build.

Chose one of two ways to connect to your Scalingo account:

* Using a [username and password](/user/deployment/scalingo/#connecting-using-a-username-and-password).
* Using an [api key](/user/deployment/scalingo/#connecting-using-an-api-key).

## Connecting using a username and password

Add your Scalingo username and your [encrypted](/user/encryption-keys/#usage)
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

Add your [encrypted](/user/encryption-keys/#usage)
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

{% include deploy/shared.md %}
