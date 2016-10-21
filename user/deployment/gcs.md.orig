---
title: Google Cloud Storage (GCS) Deployment
layout: en
permalink: /user/deployment/gcs/
---

Travis CI supports uploading to Google Cloud Storage (GCS).

A minimal configuration is:

    deploy:
      provider: gcs
      access_key_id: "GCS Interoperable Access Key ID"
      secret_access_key: "GCS Interoperable Access Secret"
      bucket: "GCS Bucket"

This example is almost certainly not ideal, as you probably want to upload your built binaries and documentation. Set `skip_cleanup` to `true` to prevent Travis CI from deleting your build artifacts.

    deploy:
      provider: gcs
      access_key_id: "GCS Interoperable Access Key ID"
      secret_access_key: "GCS Interoperable Access Secret"
      bucket: "GCS Bucket"
      skip_cleanup: true

You can find your GCS Interoperable Access Keys [here](https://developers.google.com/storage/docs/migrating).
It is recommended to encrypt that key.
Assuming you have the Travis CI command line client installed, you can do it like this:

    travis encrypt --add deploy.secret_access_key

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

    $ travis setup gcs

Keep in mind that the above command has to run in your project directory, so it can modify the `.travis.yml` for you.

### GCS ACL via option

You can set the acl of your uploaded files via the `acl` option like this:

    deploy:
      provider: gcs
      access_key_id: "GCS Interoperable Access Key ID"
      secret_access_key: "GCS Interoperable Access Secret"
      bucket: "GCS Bucket"
      skip_cleanup: true
      acl: public-read

Valid ACL values are: `private`, `public-read`, `public-read-write`, `authenticated-read`, `bucket-owner-read`, `bucket-owner-full-control`. The ACL defaults to `private`.
See the [full documentation on Google Cloud](https://cloud.google.com/storage/docs/reference-headers#xgoogacl).

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Setting `Content-Encoding` header

GCS uploads can optionally set HTTP header `Content-Encoding`.
This header allows files to be sent compressed while retaining file extensions and
the associated MIME types.

To enable this feature, add:

    deploy:
      provider: gcs
      ...
      detect_encoding: true # <== default is false

If the file is compressed with `gzip` or `compress`, it will be uploaded with
the appropriate header.

### HTTP cache control

GCS uploads can optionally set the `Cache-Control` HTTP header.

Set HTTP header `Cache-Control` to suggest that the browser cache the file. Defaults to `no-cache`. Valid options are `no-cache`, `no-store`, `max-age=<seconds>`, `s-maxage=<seconds> no-transform`, `public`, `private`.

    deploy:
      provider: gcs
      ...
      cache_control: "max-age=31536000"

See the [full documentation on Google Cloud](https://cloud.google.com/storage/docs/reference-headers#cachecontrol).
