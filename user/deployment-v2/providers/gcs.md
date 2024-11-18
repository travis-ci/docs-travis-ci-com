---
title: Google Cloud Storage (GCS) Deployment
layout: en
deploy: v2
provider: gcs
---

Travis CI supports uploading to Google Cloud Storage (GCS).

{% capture content %}
  It is recommended to use a [service account key file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)
  for authentication, and add it as an [encrypted file](/user/encrypting-files/) to your repository.
  Alternatively, you can find per-user GCS Interoperable Access Keys [here](https://developers.google.com/storage/docs/migrating).
{% endcapture %}

{% include deploy/providers/gcs.md content=content %}

## Deploy to specific folders

You can set a specific directory to be uploaded using the `local-dir` option like this:

```yaml
deploy:
  provider: gcs
  # ⋮
  local_dir: ./build
```
{: data-file=".travis.yml"}

## Specify an ACL

You can set the ACL of your uploaded files via the `acl` option like this:

```yaml
deploy:
  provider: gcs
  # ⋮
  acl: public-read
```
{: data-file=".travis.yml"}

See the [full documentation on Google Cloud](https://cloud.google.com/storage/docs/reference-headers#xgoogacl).

## HTTP cache control

GCS uploads can optionally set the `Cache-Control` HTTP header.

Set the HTTP header `Cache-Control` to suggest that the browser cache the file.

```yaml
deploy:
  provider: gcs
  # ⋮
  cache_control: max-age=31536000
```
{: data-file=".travis.yml"}

See the [full documentation on Google Cloud](https://cloud.google.com/storage/docs/reference-headers#cachecontrol).

{% include deploy/shared.md %}
