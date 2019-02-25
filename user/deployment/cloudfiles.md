---
title: Rackspace Cloud Files Deployment
layout: en

---

Travis CI can automatically upload your build to [Rackspace Cloud Files](https://www.rackspace.com/cloud/files/) after a successful build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloudfiles
  username: "RACKSPACE USERNAME"
  api_key: "RACKSPACE API KEY"
  region: "CLOUDFILE REGION"
  container: "CLOUDFILES CONTAINER NAME"
```
{: data-file=".travis.yml"}

This example is almost certainly not ideal, as you probably want to upload your built binaries and documentation. Set skip_cleanup to true to prevent Travis CI from deleting your build artifacts.

```yaml
deploy:
  provider: cloudfiles
  username: "RACKSPACE USERNAME"
  api_key: "RACKSPACE API KEY"
  region: "CLOUDFILE REGION"
  container: "CLOUDFILES CONTAINER NAME"
  skip_cleanup: true
```
{: data-file=".travis.yml"}

It is recommended encrypt that you encrypt your Rackspace api key.
Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
travis encrypt --add deploy.api-key
```

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

```bash
travis setup cloudfiles
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Deploy On Tags

Often, you want to deploy only when you release a new version of your code.

You can tell Travis CI only to deploy on tags, like this:

```yaml
deploy:
  provider: cloudfiles
  username: "RACKSPACE USERNAME"
  api_key: "RACKSPACE API KEY"
  region: "CLOUDFILE REGION"
  container: "CLOUDFILES CONTAINER NAME"
  skip_cleanup: true
  on:
    tags: true
```
{: data-file=".travis.yml"}

### Deploy To Only One Folder

Often, you don't want to upload your entire project to Cloud Files. You can tell Travis CI to only upload a single folder to Cloud Files. This example uploads the build directory of your project to Cloud Files:

```yaml
before_deploy: "cd build"
deploy:
  provider: cloudfiles
  username: "RACKSPACE USERNAME"
  api_key: "RACKSPACE API KEY"
  region: "CLOUDFILE REGION"
  container: "CLOUDFILES CONTAINER NAME"
  skip_cleanup: true
```
{: data-file=".travis.yml"}

### Deploy to Multiple Containers:

If you want to upload to multiple containers, you can do this:

```yaml
deploy:
  - provider: cloudfiles
    username: "RACKSPACE USERNAME"
    api_key: "RACKSPACE API KEY"
    region: "CLOUDFILE REGION"
    container: "CLOUDFILES CONTAINER NAME"
    skip_cleanup: true
  - provider: cloudfiles
    username: "RACKSPACE USERNAME"
    api_key: "RACKSPACE API KEY"
    region: "CLOUDFILE REGION"
    container: "CLOUDFILES CONTAINER NAME"
    skip_cleanup: true
```
{: data-file=".travis.yml"}

### Branch to release from

You can explicitly specify the branch to release from with the **on** option:

```yaml
deploy:
  provider: cloudfiles
  username: "RACKSPACE USERNAME"
  api_key: "RACKSPACE API KEY"
  region: "CLOUDFILE REGION"
  container: "CLOUDFILES CONTAINER NAME"
  skip_cleanup: true
  on:
    branch: production
```
{: data-file=".travis.yml"}

Alternatively, you can also configure Travis CI to release from all branches:

```yaml
deploy:
  provider: cloudfiles
  username: "RACKSPACE USERNAME"
  api_key: "RACKSPACE API KEY"
  region: "CLOUDFILE REGION"
  container: "CLOUDFILES CONTAINER NAME"
  skip_cleanup: true
  on:
    all_branches: true
```
{: data-file=".travis.yml"}

Builds triggered from Pull Requests will never trigger a release.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#conditional-releases-with-on).

### Running commands before and after release

Sometimes you want to run commands before or after releasing a gem. You can use the `before_deploy` and `after_deploy` stages for this. These will only be triggered if Travis CI is actually pushing a release.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
