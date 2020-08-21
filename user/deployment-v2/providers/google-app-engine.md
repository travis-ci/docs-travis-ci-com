---
title: Google App Engine Deployment
layout: en
deploy: v2
provider: gae
---

Travis CI can automatically deploy to [Google App Engine](https://cloud.google.com/appengine/docs) or [Managed VMs](https://cloud.google.com/appengine/docs/managed-vms/) after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: gae
  keyfile: <keyfile>
  edge: true # opt in to dpl v2
```
{: data-file=".travis.yml"}

Then go to the [Google Cloud Console Dashboard](http://console.developers.google.com) and:

* Enable "Google App Engine Admin API",
* Go to "Credentials", click "Add Credential" and "Service account key", finally click "JSON" to download your Service Account JSON file.

Add this file as an [encrypted file](/user/encrypting-files/) to your repository and `.travis.yml` file.

{% include deploy/providers/gae.md minimal=false %}

### Project to deploy

By default, the project will be deployed with the same name as the repository.
Usually, you will want to explicilty configure the **project** option to match
the project ID found in your Cloud console (note that this is sometimes, but
not always, the same as the project name).

You can explicitly set the project id via the **project** option:

```yaml
deploy:
  provider: gae
  # ⋮
  project: continuous-deployment-demo
```
{: data-file=".travis.yml"}

### Version to deploy

Either the `version` flag or the `default` option must be set. If default
is true, the default version will be deployed to, which will be
`http://project-id.appspot.com`. If the `version` flag is set instead, it will
deploy to `http://version.project-id.appspot.com`.

### Deploying without Promoting

By default, when your application is deployed it will be promoted to receive
all traffic. You can disable that using the `no_promote` option:

```yaml
deploy:
  provider: gae
  # ⋮
  no_promote: true
```
{: data-file=".travis.yml"}

In addition to that, and according to the [Google Cloud SDK changelog](https://cloud.google.com/sdk/release_notes#0981_20151007),
*"in a future Cloud SDK release, deployments that promote the new version to
receive all traffic will stop the previous version by default"*.

You can prevent that from happening by setting the option `no_stop_previous_version`:

```yaml
deploy:
  provider: gae
  # ⋮
  no_stop_previous_version: true
```
{: data-file=".travis.yml"}

### Example Repo

See [this repository](https://github.com/googlecloudplatform/continuous-deployment-demo/tree/appengine_travis_deploy)
for an example App Engine app with a Travis deployment configured. See the
other branches in the project for Managed VMs examples, and examples without
using this provider.

{% include deploy/shared.md %}
