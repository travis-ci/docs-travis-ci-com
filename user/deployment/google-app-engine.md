---
title: Google App Engine Deployment
layout: en

---

Travis CI can automatically deploy your [Google App Engine](https://cloud.google.com/appengine/docs) or [Managed VMs](https://cloud.google.com/appengine/docs/managed-vms/) application after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:
  
```yaml
deploy:
  provider: gae
  keyfile: "YOUR SERVICE ACCOUNT JSON FILE"
  project: "YOUR PROJECT ID"
```
{: data-file=".travis.yml"}

Then go to the [Google Cloud Console Dashboard](http://console.developers.google.com) and:

1. Enable "Google App Engine Admin API",
2. Go to "Credentials", click "Add Credential" and "Service account key", finally click "JSON" to download your Service Account JSON file.

It is *strongly* recommended that you encrypt your key before committing it to a repo.
First make sure you have the [Travis command line tool](https://github.com/travis-ci/travis.rb#readme) installed.
Then execute the following command from the terminal:

```bash
travis encrypt-file client-secret.json --add
```

The `--add` flag automatically adds the decryption step to the .travis file.

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

More detailed instructions for encrypting keys using Travis can be found [here](http://docs.travis-ci.com/user/encrypting-files/).

### Project to deploy

By default, the project will be deployed with the same name as the repository. Usually, you will want to explicilty configure the **project** option to match the project ID found in your Cloud console (note that this is sometimes, but not always, the same as the project name).

You can explicitly set the project id via the **project** option:

```yaml
deploy:
  provider: gae
  keyfile: ...
  project: continuous-deployment-demo
```
{: data-file=".travis.yml"}

### Version to deploy

Either the **version** flag or the **default** option must be set. If default is true, the default version will be deployed to, which will be `http://your-project-id.appspot.com`. If the **version** flag is set instead, it will deploy to `http://version-dot-your-project-id.appspot.com`.

### Branch to deploy from

By default, Travis will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

```yaml
deploy:
  provider: gae
  keyfile: ...
  project: ...
  on: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure it to deploy from all branches:

```yaml
deploy:
  provider: gae
  keyfile: ...
  project: ...
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying without Promoting

By default, when your application is deployed it will be promoted to receive all traffic. You can disable that using the `no_promote` option:

```yaml
deploy:
  provider: gae
  keyfile: ...
  project: continuous-deployment-demo
  no_promote: true
```
{: data-file=".travis.yml"}

In addition to that, and according to the [Google Cloud SDK changelog](https://cloud.google.com/sdk/release_notes#0981_20151007), *"in a future Cloud SDK release, deployments that promote the new version to receive all traffic will stop the previous version by default"*.

You can prevent that from happening by setting the option `no_stop_previous_version`:

```yaml
deploy:
  provider: gae
  keyfile: ...
  project: continuous-deployment-demo
  no_stop_previous_version: true
```
{: data-file=".travis.yml"}

### Skipping Cleanup

Many App Engine apps use [pip](https://pip.pypa.io/en/latest/installing.html) to vendor library requirements into the directory, and sometimes you need build artifacts or other
credentials to deploy. If so, you want to avoid the Travis cleanup step that will clean you working directory before the deploy.

```yaml
deploy:
    provider: gae
    skip_cleanup: true
```
{: data-file=".travis.yml"}

### Example Repo

See [this link](https://github.com/googlecloudplatform/continuous-deployment-demo/tree/appengine_travis_deploy) for an example
App Engine app with a Travis deployment configured. See the other branches in the project for Managed VMs examples, and examples
without using this provider.

### Other Available Configuration Options

- **project**: [Project ID](https://developers.google.com/console/help/new/#projectnumber) used to identify the project on Google Cloud.
- **keyfile**: Path to the JSON file containing your [Service Account](https://developers.google.com/console/help/new/#serviceaccounts) credentials in [JSON Web Token](https://tools.ietf.org/html/rfc7519) format. To be obtained via the [Google Developers Console](https://console.developers.google.com/project/_/apiui/credential). Defaults to `"service-account.json"`. Note that this file should be handled with care as it contains authorization keys.
- **config**: Path to your module configuration file. Defaults to `"app.yaml"`. This file is runtime dependent ([Go](https://cloud.google.com/appengine/docs/go/config/appconfig), [Java](https://cloud.google.com/appengine/docs/java/config/appconfig), [PHP](https://cloud.google.com/appengine/docs/php/config/appconfig), [Python](https://cloud.google.com/appengine/docs/python/config/appconfig))
- **version**: The version of the app that will be created or replaced by this deployment. If you do not specify a version, one will be generated for you. See [`gcloud preview app deploy`](https://cloud.google.com/sdk/gcloud/reference/app/deploy)
- **default**: Flag to set the deployed version to be the default serving version. See [`gcloud preview app deploy`](https://cloud.google.com/sdk/gcloud/reference/app/deploy)
- **verbosity**: Let's you adjust the verbosity when invoking `"gcloud"`. Defaults to `"warning"`. See [`gcloud`](https://cloud.google.com/sdk/gcloud/reference/).
- **docker_build**: If deploying a Managed VM, specifies where to build your image. Typical values are `"remote"` to build on Google Cloud Engine and `"local"` which requires Docker to be set up properly (to utilize this on Travis CI, read [Using Docker on Travis CI](http://blog.travis-ci.com/2015-08-19-using-docker-on-travis-ci/)). Defaults to `"remote"`.
