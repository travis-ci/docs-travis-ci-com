---
title: Google App Engine Deployment
layout: en
permalink: /user/deployment/google-app-engine/
---

Travis CI can automatically deploy your [Google App Engine](https://cloud.google.com/appengine/docs) or [Managed VMs](https://cloud.google.com/appengine/docs/managed-vms/) application after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    deploy:
      provider: gae
      keyfile: "YOUR SERVICE ACCOUNT JSON FILE"
      default: true
      project: "YOUR PROJECT ID"

You can create a Service Account by going to the [Google Cloud Console](http://console.developers.google.com), go to "APIs & auth" -> "Credentials",
then click "Add Credential" and "Service Account", finally clicking "JSON" to download the JSON key.

It is *strongly* recommended that you encrypt your key before committing it to a repo. First make sure you have the Travis command line tool installed.

    travis encrypt-file client-secret.json --add

The `--add` flag automatically adds the decryption step to the .travis file.

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

More detailed instructions for encrypting keys using Travis can be found [here](http://docs.travis-ci.com/user/encrypting-files/).


### Project to deploy

By default, the project will be deployed with the same name as the repository. Usually, you will want to explicilty configure the **project** option to match the project ID found in your Cloud console (note that this is sometimes, but not always, the same as the project name).

You can explicitly set the project id via the **project** option:

    deploy:
      provider: gae
      keyfile: ...
      project: continuous-deployment-demo

### Version to deploy

Either the **version** flag or the **default** option must be set. If default is true, the default version will be deployed to, which will be http://your-project-id.appspot.com. If the **version** flag is set instead, it will deploy to http://version-dot-your-project-id.appspot.com.


### Branch to deploy from

By default, Travis will only deploy from your **master** branch.

You can also explicitly specify the branch to deploy from with the **on** option:

    deploy:
      provider: gae
      keyfile: ...
      project: ...
      on: production

Alternatively, you can also configure it to deploy from all branches:

    deploy:
      provider: gae
      keyfile: ...
      project: ...
      on:
        all_branches: true

Builds triggered from Pull Requests will never trigger a deploy.

### Skipping Cleanup

Many App Engine apps use [pip](https://pip.pypa.io/en/latest/installing.html) to vendor library requirements into the directory, and sometimes you need build artifacts or other
credentials to deploy. If so, you want to avoid the Travis cleanup step that will clean you working directory before the deploy.

    deploy:
        provider: gae
        skip_cleanup: true

### Example Repo

See [this link](https://github.com/googlecloudplatform/continuous-deployment-demo/tree/appengine_travis_deploy) for an example
App Engine app with a Travis deployment configured. See the other branches in the project for Managed VMs examples, and examples
without using this provider.

### Other Available Configuration Options
* **project**: [Project ID](https://developers.google.com/console/help/new/#projectnumber) used to identify the project on Google Cloud.
* **keyfile**: Path to the JSON file containing your [Service Account](https://developers.google.com/console/help/new/#serviceaccounts) credentials in [JSON Web Token](https://tools.ietf.org/html/rfc7519) format. To be obtained via the [Google Developers Console](https://console.developers.google.com/project/_/apiui/credential). Defaults to `"service-account.json"`. Note that this file should be handled with care as it contains authorization keys.
* **config**: Path to your module configuration file. Defaults to `"app.yaml"`. This file is runtime dependent ([Go](https://cloud.google.com/appengine/docs/go/config/appconfig), [Java](https://cloud.google.com/appengine/docs/java/config/appconfig), [PHP](https://cloud.google.com/appengine/docs/php/config/appconfig), [Python](https://cloud.google.com/appengine/docs/python/config/appconfig))
* **version**: The version of the app that will be created or replaced by this deployment. If you do not specify a version, one will be generated for you. See [`gcloud preview app deploy`](https://cloud.google.com/sdk/gcloud/reference/preview/app/deploy)
* **default**: Flag to set the deployed version to be the default serving version. See [`gcloud preview app deploy`](https://cloud.google.com/sdk/gcloud/reference/preview/app/deploy)
* **verbosity**: Let's you adjust the verbosity when invoking `"gcloud"`. Defaults to `"warning"`. See [`gcloud`](https://cloud.google.com/sdk/gcloud/reference/).
* **docker_build**: If deploying a Managed VM, specifies where to build your image. Typical values are `"remote"` to build on Google Cloud Engine and `"local"` which requires Docker to be set up properly (to utilize this on Travis CI, read [Using Docker on Travis CI](http://blog.travis-ci.com/2015-08-19-using-docker-on-travis-ci/)). Defaults to `"remote"`.
