---
title: Build Stages
permalink: /user/build-stages/
layout: en
---

<div id="toc"></div>

> Build stages are still in BETA. There is more information about what this means, and how you can give us feedback on this new feature in the [GitHub issue](https://github.com/travis-ci/beta-features/issues/11).
{: .beta}

With this new feature you can group jobs together in 'stages'. Jobs in a stage
run in parallel, and the stages themselves run sequentially, one after another.
The build fails when any stage fails, i.e. if any job in this stage fails.

For example, you can configure a deployment stage to run only after several test
jobs have all completed successfully.

Assign jobs to stages by adding a stage name to the job configuration
in the `jobs.include` section of your `.travis.yml` file:

```yaml
jobs:
  include:
    - stage: test
      script: ./test 1
    - stage: test
      script: ./test 2
    - stage: deploy
      script: ./deploy
```

The previous yaml creates a build with three jobs, two of which start in
parallel in the first stage (named `test`), while the third job on the second
stage (named `deploy`) starts only after the test stage completes successfully.

This screencast demonstrates how the two stages work:

![Example screencast](https://cloud.githubusercontent.com/assets/3729517/25229553/0868909c-25d1-11e7-9263-b076fdef9288.gif)

## Naming your stages

Stage names are arbitrary strings, and can include spaces or emojis. The first
letter of a stage name is automatically capitalized for aesthetical reasons, so
you don't have to deal with uppercase strings in your `.travis.yml` file.

The default stage is `test`. Jobs that do not have a stage name are assigned to
the previous stage name if one exists, or the default stage name if there is no
previous stage name. `test`. This means that if you set the stage name on the
first job of each stage, the build will work as expected.

For example the following config is equivalent to the one above, but also adds a
second deploy job to the `deploy` stage that deploys to a different target. As
you can see you only need to specify the stage name once:

```yaml
jobs:
  include:
    - script: ./test 1 # uses the default stage name "test"
    - script: ./test 2
    - stage: deploy
      script: ./deploy target-1
    - script: ./deploy target-2
```

## Build stages and build matrix expansion

[Matrix expansion](https://docs.travis-ci.com/user/customizing-the-build/#Build-Matrix)
means that certain top level configuration keys expand into a matrix of jobs.

For example:

```yaml
rvm:
  - 2.3
  - 2.4
jobs:
  include:
    - stage: deploy
      rvm: 2.4
      env:
        - FOO=foo
      script: ./deploy
```

This will run two jobs with on Ruby 2.3 and 2.4 respectively first, and assign
these to the default stage test. The third job on the deploy stage starts only
after the test stage has completed successfully. Be sure to set the set the
`rvm` key on your included deploy job, too.

## Build stages and deployments

You can combine build stages with [deployments](https://docs.travis-ci.com/user/deployment/):

```yaml
jobs:
  include:
    - script: ./test 1 # uses the default stage name "test"
    - script: ./test 2
    - stage: deploy
      script: skip     # usually you do not want to rerun any tests
      deploy: &heroku
        provider: heroku
        # ...
```

Travis CI does not set or overwrite any of your scripts, and most languages
have a [default test script](https://docs.travis-ci.com/user/languages/ruby/#Default-Test-Script)
defined. So in many use cases you might want to overwrite the `script` by
specifying the keyword `skip` or `ignore`.

## Examples

### Deploying to Heroku

An example with 5 stages:

* Two jobs running unit tests in parallel on stage 1.
* One job deploying the application to Heroku staging.
* One job testing the staging deployment on Heroku.
* One job deploying the application to Heroku production.
* One job testing the production deployment on Heroku.

You can find more [details here](/user/build-stages/deploy-heroku/).

### Deploying to Rubygems

This example has two build stages:

* Two jobs that run tests against Ruby 2.2 and 2.3 respectively
* One job that publishes the gem to rubygems.org

You can find more [details here](/user/build-stages/deploy-rubygems/).

### Combining build stages with matrix expansion

This example has two build stages:

* Four test jobs that have been expanded from `rvm` and `env` matrix keys.
* One deploy job.

You can find more [details here](/user/build-stages/matrix-expansion/).

### Warming up a cache with expensive dependencies

This uses two build stages in order to warm up a cache with expensive dependencies, and optimize test run times:

* One job that installs dependencies and warms up the cache for the given branch.
* Three jobs that run tests, using the cache.

You can find more [details here](/user/build-stages/warm-cache/).

### Sharing files between jobs via S3

This uses two build stages, sharing files from build stage 1 in stage 2:

* Two jobs that set up files on S3.
* One job that uses both files from stage 1.

You can find more [details here](/user/build-stages/share-files-s3/).
