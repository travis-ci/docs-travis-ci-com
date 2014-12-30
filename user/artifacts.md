---
title: Uploading Artifacts on Travis CI
layout: en
permalink: /user/artifacts/
---
<div id="toc">
</div>

Travis CI can automatically upload your build artifacts to S3.

For a minimal configuration, all you need to do is add the following to your `.travis.yml`:

    addons:
      artifacts:
        key: "YOUR AWS ACCESS KEY"
        secret: "YOUR AWS SECRET KEY"
        bucket: "S3 Bucket"

You can find your AWS Access Keys
[here](https://console.aws.amazon.com/iam/home?#security_credential). It
is recommended to encrypt that key.  Assuming you have the Travis CI
command line client installed, you can do it like this:

    travis encrypt --add addons.artifacts.key

You will be prompted to enter your api key on the command line.

You can also have the `travis` tool set up everything for you:

    travis setup artifacts

Keep in mind that the above command has to run in your project
directory, so it can modify the `.travis.yml` for you.

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

### Debugging

If you'd like to see more detail about what the artifacts addon is
doing, setting `addons.artifacts.debug` to anything non-empty will turn
on debug logging.

    addons:
      artifacts:
        # ...
        debug: true
