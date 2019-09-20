---
title: Uploading Artifacts on Travis CI
layout: en

---

Travis CI can automatically upload your build artifacts to Amazon S3 at the
end of the job, after the [`after_script`](/user/job-lifecycle/) phase.

> Note that the artifacts addon is not available for pull request builds.

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
addons:
  artifacts: true
```
{: data-file=".travis.yml"}

and add the following environment variables in the repository settings:

```bash
ARTIFACTS_KEY=(AWS access key id)
ARTIFACTS_SECRET=(AWS secret access key)
ARTIFACTS_BUCKET=(S3 bucket name)
```

The region defaults to `us-east-1`. For any other region, either define the `ARTIFACTS_REGION` environment variable or add it under the artifacts configuration key:

```yaml
addons:
  artifacts:
    s3_region: "us-west-1" # defaults to "us-east-1"
```
{: data-file=".travis.yml"}

You can find your AWS Access Keys [here](https://console.aws.amazon.com/iam/home?#security_credential).

### Deploy specific paths

The default paths uploaded to S3 are found via `git ls-files -o` in
order to find any files in the git working copy that aren't tracked.
If any additional paths need to be uploaded, they may be specified via
the `addons.artifacts.paths` key like so:

```yaml
addons:
  artifacts:
    # ⋮
    paths:
    - $(git ls-files -o | tr "\n" ":")
    - $(ls /var/log/*.log | tr "\n" ":")
    - $HOME/some/other/thing.log
```
{: data-file=".travis.yml"}

or as an environment variable in repository settings:

```bash
# ':'-delimited paths, e.g.
ARTIFACTS_PATHS="./logs:./build:/var/log"
```

Please keep in mind that in the example above, colon (`:`) is used as a
delimiter which means file names cannot contain this character.

### Working directory

If you'd like to upload file from a specific directory, you can change your working directory by setting `addons.artifacts.working_dir`.


```yaml
addons:
  artifacts:
    # ⋮
    working_dir: out
```
{: data-file=".travis.yml"}

### Target Paths

By default, artifacts will be uploaded to the path in the bucket
defined by `/${TRAVIS_REPO_SLUG}/${TRAVIS_BUILD_NUMBER}/${TRAVIS_JOB_NUMBER}`.
You can change the upload path at build time using the `target_paths`
key, for example:

```yaml
addons:
  artifacts:
    target_paths:
    - /$TRAVIS_OS_NAME/$((lsb_release -rs 2>/dev/null || sw_vers -productVersion) | grep --only -E '^[0-9]+\.[0-9]+')
```
{: data-file=".travis.yml"}

### Debugging

If you'd like to see more detail about what the artifacts addon is
doing, setting `addons.artifacts.debug` to anything non-empty will turn
on debug logging.

```yaml
addons:
  artifacts:
    # ⋮
    debug: true
```
{: data-file=".travis.yml"}

or define this as a repository settings environment variable, or in the `env.global` section:

```bash
ARTIFACTS_DEBUG=1
```

### Travis CI Artifact Uploader
For more complicated artifact uploads, you can use the [Artifact Uploader Tool](https://github.com/travis-ci/artifacts) which is installed on your build VM by default. 
