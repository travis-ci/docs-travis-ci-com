---
title: Rackspace Cloud Files Deployment
layout: en
deploy: v2
provider: cloudfiles
---

Travis CI can automatically upload your build to [Rackspace Cloud Files](https://www.rackspace.com/cloud/files/) after a successful build.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
deploy:
  provider: cloudfiles
  username: <username>
  api_key: <encrypted api_key>
  region: <region>
  container: <container>
```
{: data-file=".travis.yml"}

{% include deploy/providers/cloudfiles.md %}

      opt '--glob GLOB',      'Paths to upload', default: '**/*'
      opt '--dot_match',      'Upload hidden files starting a dot'

## Specifying files to upload

Often, you don't want to upload your entire project to Cloud Files.

You can specify a glob to only include specific directories or files to the upload:

```yaml
deploy:
  provider: cloudfiles
  # ⋮
  glob: build/*
```
{: data-file=".travis.yml"}

By default, filenames starting with a dot are excluded. Add the option
`dot_match` to make your `glob` match these, too:

```yaml
deploy:
  provider: cloudfiles
  # ⋮
  glob: build/*
  dot_match: true
```
{: data-file=".travis.yml"}

## Deploying to multiple regions or containers:

If you want to upload to multiple regions or containers, you can do this:

```yaml
deploy:
  - provider: cloudfiles
    # ⋮
    region: <region-1>
    container: <container-1>
  - provider: cloudfiles
    # ⋮
    region: <region-2>
    container: <container-2>
```
{: data-file=".travis.yml"}

{% include deploy/shared.md %}
