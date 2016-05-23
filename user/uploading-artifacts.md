---
title: Uploading Artifacts on Travis CI
layout: en
permalink: /user/uploading-artifacts/
---
<div id="toc">
</div>

Travis CI can automatically upload your build artifacts to S3. Unless you
programatically generate unique filenames and folders, artifacts are
overwritten every build.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    addons:
      artifacts: true

and add the following environment variables in the repository settings:

    ARTIFACTS_KEY=(AWS access key id)
    ARTIFACTS_SECRET=(AWS secret access key)
    ARTIFACTS_BUCKET=(S3 bucket name)

The region defaults to `us-east-1`. For any other region, either define the `ARTIFACTS_REGION` environment variable or add it under the artifacts configuration key:
    
    addons:
      artifacts:
        s3_region: "us-west-1" # defaults to "us-east-1"

You can find your AWS Access Keys [here](https://console.aws.amazon.com/iam/home?#security_credential).

### Deploy specific paths

The default paths uploaded to S3 are found via `git ls-files -o` in
order to find any files in the git working copy that aren't tracked.
If any additional paths need to be uploaded, they may be specified via
the `addons.artifacts.paths` key like so:

    addons:
      artifacts:
        # ...
        paths:
        - $(git ls-files -o | tr "\n" ":")
        - $(ls /var/log/*.log | tr "\n" ":")
        - $HOME/some/other/thing.log

or as an environment variable in repository settings:

    # ':'-delimited paths, e.g.
    ARTIFACTS_PATHS="./logs:./build:/var/log"

### Debugging

If you'd like to see more detail about what the artifacts addon is
doing, setting `addons.artifacts.debug` to anything non-empty will turn
on debug logging.

    addons:
      artifacts:
        # ...
        debug: true

or define this as a repository settings environment variable, or in the `env.global` section:

    ARTIFACTS_DEBUG=1
