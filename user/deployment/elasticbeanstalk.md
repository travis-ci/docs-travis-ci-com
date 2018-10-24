---
title: AWS Elastic Beanstalk Deployment
layout: en

---



Travis CI can automatically deploy your application to [Elastic
Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/) after a
successful build.

To deploy to AWS Elastic Beanstalk add the following to your `.travis.yml`:

* `access-key-id`: [Encrypted](/user/encryption-keys#usage) AWS Access Key ID, obtained from your [AWS Console](https://console.aws.amazon.com/iam/home?#security_credential).
* `secret-access-key`: [Encrypted](/user/encryption-keys#usage) AWS Secret Key, obtained from your [AWS Console](https://console.aws.amazon.com/iam/home?#security_credential).
* `region`: **must** be the region the Elastic Beanstalk application is running on, for example `us-east-1`.
* `app`: Application name.
* `env`: Elastic Beanstalk environment the application will be deployed to.
* `bucket_name`: Bucket name to upload the code of your app to. Elastic Beanstalk will create and deploy an application version from the source bundle in this Amazon S3 bucket.

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

* `zip_file`: The zip file to deploy. If this file is created during the build, you also need to set `skip_cleanup` to prevent Travis CI from deleting the zip file at the end of the build.
If you do not specify `zip_file`, one will be created from the directory content according to the [`.ebignore` and `.gitignore` rules](#controlling-which-files-to-include-in-the-zip-archive-with-ebignore-or-gitignore).
* `bucket_path`: Location within Bucket to upload app to.

### Controlling which files to include in the zip archive with `.ebignore` or `.gitignore`

You can control which files are included in the zip archive you upload with `.ebignore` and `.gitignore`,
as described in [AWS CLI documentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-configuration.html).
This rule is effective exactly when `zip_file` is not given.

1. If `.ebignore` file exists in the directory where the deployment takes place, this file is read, and the files matching `.ebignore` will be excluded from the archive.
1. If `.ebignore` does not exist but `.gitignore` does in the deployment directory, `.gitignore` is read, and the [standard rules](https://git-scm.com/docs/git-ls-files#git-ls-files---exclude-standard) apply to exclude files from the archive.
1. If neither file exists, the entire directory content will be included.

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
