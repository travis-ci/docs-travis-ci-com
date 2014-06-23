---
title: Google Cloud Storage (GCS) Deployment
layout: en
permalink: gcs/
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

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).
