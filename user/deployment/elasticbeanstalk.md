---
title: AWS Elastic Beanstalk Deployment
layout: en

---

<div id="toc"></div>

Travis CI can automatically deploy your application to [Elastic
Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/) after a
successful build.

To deploy to AWS Elastic Beastalk add the following to your `.travis.yml`:

* `access-key-id`: [Encrypted](/user/encryption-keys#Usage) AWS Access Key ID, obtained from your [AWS Console](https://console.aws.amazon.com/iam/home?#security_credential).
* `secret-access-key`: [Encrypted](/user/encryption-keys#Usage) AWS Secret Key, obtained from your [AWS Console](https://console.aws.amazon.com/iam/home?#security_credential).
* `region`: **must** be the region the Elastic Beanstalk application is running on, for example `us-east-1`.
* `app`: Application name.
* `env`: Elastic Beanstalk environment the application will be deployed to.
* `bucket_name`: Bucket name to upload app to.

```yaml
deploy:
  provider: elasticbeanstalk
  access_key_id: "Encrypted <access-key-id>="
  secret_access_key:
    secure: "Encypted <secret-access-key>="
  region: "us-east-1"  
  app: "example-app-name"
  env: "example-app-environment"
  bucket_name: "the-target-S3-bucket"
```
{: data-file=".travis.yml"}

Alternatively, use the Travis CI command line setup tool to add the deployment `travis setup elasticbeanstalk`.

## Creating an application without deploying it

To create an application without deploying it, add `only_create_app_version: "true"` to your `.travis.yml`.

## Optional settings

* `zip_file`: The zip file to deploy. You also need to set `skip_cleanup` to prevent Travis CI deleting the zip file at the end of the build. If this is left unspecified, a zip file will be created from all the files that are part of the repository under test (determined with `git ls-files`).
* `bucket_path`: Location within Bucket to upload app to.

## Environment variables

The following environment variables are available:

* `ELASTIC_BEANSTALK_ENV`: Used if the `env` key is not set in your `.travis.yml`.
* `ELASTIC_BEANSTALK_LABEL`: Label name of the new version.
* `ELASTIC_BEANSTALK_DESCRIPTION`: Description of the new version.      Defaults to the last commit message.

## Running commands before and after deploy

Sometimes you want to run commands before or after deploying. You can use
the `before_deploy` and `after_deploy` stages for this. These will only be
triggered if Travis CI is actually deploying.

```yaml
before_deploy: "echo 'ready?'"
deploy:
  ..
after_deploy:
  - ./after_deploy_1.sh
  - ./after_deploy_2.sh
```
{: data-file=".travis.yml"}
