---
title: Rackspace Cloud Files Deployment
layout: en
deploy: v2
provider: cloudfiles
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

It is recommended that you encrypt your Rackspace api key. Assuming you have the Travis CI command line client installed, you can do it like this:

```bash
travis encrypt --add deploy.api-key
```

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

```bash
travis setup cloudfiles
```

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

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
  - provider: cloudfiles
    username: "RACKSPACE USERNAME"
    api_key: "RACKSPACE API KEY"
    region: "CLOUDFILE REGION"
    container: "CLOUDFILES CONTAINER NAME"
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
