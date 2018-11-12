---
title: Google Cloud Storage (GCS) Deployment
layout: en

---

Travis CI supports uploading to Google Cloud Storage (GCS).

A minimal configuration is:

```yaml
deploy:
  provider: gcs
  credentials: gcs_credentials.json
  bucket: "GCS Bucket"
```
{: data-file=".travis.yml"}

This example is almost certainly not ideal, as you probably want to upload your built binaries and documentation. Set `skip_cleanup` to `true` to prevent Travis CI from deleting your build artifacts.

```yaml
deploy:
  provider: gcs
  credentials: gcs_credentials.json
  bucket: "GCS Bucket"
  skip_cleanup: true
```
{: data-file=".travis.yml"}

`gcs_credentials.json` is the path to the GCS credentials JSON file.
The account specified in the file must have "Storage Admin" role assigned to it.

Read [Google's documentation](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) on how to manage
the service accounts, and how to obtain the JSON file suitable for use.

## Setting up GCS credentials

As deployment requires admin access, it is essential that [the file be encrypted](/user/encrypting-files).
Assuming you have the Travis CI command line client installed, run the following in the repository root:

    travis encrypt-file gcs_credentials.json

(If you builds run on https://travis-ci.com, add `--com`: `travis encrypt-files --com gcs_credentials.json`)
This will display something like this:

<pre>
$ travis encrypt-file gcs_creds.json
encrypting gcs_creds.json for OWNER/REPO
storing result as gcs_creds.json.enc
storing secure env variables for decryption

Please add the following to your build script (before_install stage in your .travis.yml, for instance):

    openssl aes-256-cbc -K $encrypted_4b99afaeb775_key -iv $encrypted_4b99afaeb775_iv -in gcs_creds.json.enc -out gcs_creds.json -d

Pro Tip: You can add it automatically by running with --add.

Make sure to add gcs_creds.json.enc to the git repository.
Make sure not to add gcs_creds.json to the git repository.
Commit all changes to your .travis.yml.
</pre>

Add the resulting encrypted file `gcs_creds.json.enc` to your repository, and edit `.travis.yml` so that `openssl …` command runs during the build.
This can be in `before_install`, as the message suggests, or in `before_deploy`, where the command fits naturally.

### GCS ACL via option

You can set the access control list of your uploaded files via the `acl` option:

```yaml
deploy:
  provider: gcs
  credentials: gcs_credentials.json
  bucket: "GCS Bucket"
  skip_cleanup: true
  acl: public_read
```
{: data-file=".travis.yml"}

For the list of valid values for `acl`, consult the `acl` parameter [documentation](http://googleapis.github.io/google-cloud-ruby/docs/google-cloud-storage/latest/Google/Cloud/Storage/Bucket.html#create_file-instance_method).

### Deploying specific folder

You can set specific directory to be uploaded using `local-dir` option like this:

```yaml
deploy:
  provider: gcs
  credentials: gcs_credentials.json
  bucket: "GCS Bucket"
  skip_cleanup: true
  local_dir: directory-name
```
{: data-file=".travis.yml"}

This value is relative to the directory the build is in when the deployment
takes place.
This could be a source of confusion if your build changes directories during
the build.

If the `directory-name` is generated during build process, it will be deleted (cleaned up) before deploying, unless `skip_cleanup` is set to true.

### Conditional releases

You can deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#conditional-releases-with-on).

### HTTP cache control

GCS uploads can optionally set the `Cache-Control` HTTP header.

Set HTTP header `Cache-Control` to suggest that the browser cache the file. Defaults to `no-cache`.

```yaml
deploy:
  provider: gcs
  ...
  cache_control: "max-age=31536000"
```
{: data-file=".travis.yml"}

For valid values for `cache_control`, consult [Google's documentation](http://googleapis.github.io/google-cloud-ruby/docs/google-cloud-storage/latest/Google/Cloud/Storage/Bucket.html#create_file-instance_method) on the `cache_control` option.
