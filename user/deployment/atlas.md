---
title: Atlas Deployment
layout: en
deploy: v1

---

Travis CI can automatically deploy your application to [Atlas](https://atlas.hashicorp.com/) after a successful build.

> Hashicorp [announced](https://www.hashicorp.com/blog/hashicorp-terraform-enterprise-general-availability#decommissioning-atlas) that Atlas is being decommissioned by March 30, 2017. It is replaced by Terraform Enterprise.

To deploy your application to Atlas:

1. Sign in to your Atlas account.
2. [Generate](https://atlas.hashicorp.com/settings/tokens) an Atlas API token for Travis CI.
3. Add the following minimum configuration to your `.travis.yml`

   ```yaml
   deploy:
     provider: atlas
     token: "YOUR ATLAS API TOKEN"
     app: "YOUR ATLAS USERNAME/YOUR ATLAS APP NAME"
   ```
   {: data-file=".travis.yml"}

## Include or Exclude Files

You can include and exclude files by adding the `include` and `exclude` entries to `.travis.yml`. Both are glob patterns of files or directories to include or exclude, and may be specified multiple times. If there is a conflict, excludes have precedence over includes.

```yaml
deploy:
  provider: atlas
  exclude: "*.log"
  include:
   - "build/*"
   - "bin/*"
```
{: data-file=".travis.yml"}

### Use the Version Control System

Get the lists of files to exclude and include from your version control system (Git, Mercurial or Subversion):

```yaml
deploy:
  provider: atlas
  vcs: true
```
{: data-file=".travis.yml"}

## Other Deployment Options

The following section lists other deployment options that are available.

### Specify the Atlas Server Address

Use the following code to specify the Atlas Server Address:

```yaml
deploy:
   provider: atlas
   address: "URL OF THE ATLAS SERVER"
```
{: data-file=".travis.yml"}

### Add Custom Metadata

Add one or more items of metadata:

```yaml
deploy:
  provider: atlas
  metadata:
    - "custom_name=Jane"
    - "custom_surname=Doe"
```
{: data-file=".travis.yml"}

{{ site.data.snippets.conditional_deploy }}

## Run Commands Before or After Deploy

Sometimes, you want to run commands before or after deploying. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  # ⋮
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
