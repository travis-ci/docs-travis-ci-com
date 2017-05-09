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
The build fails when any stage fails. For example, one deployment job can be run
**after several** test jobs have all completed successfully.

TODO: Does a stage fail if a single job in it fails?

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

![](https://cloud.githubusercontent.com/assets/3729517/25229553/0868909c-25d1-11e7-9263-b076fdef9288.gif)

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
env:
  - FOO=foo
  - FOO=bar
jobs:
  include:
    - stage: deploy
      env:
        - FOO=foo
      script: ./deploy
```

This will run two jobs with the env vars `FOO=foo` and `FOO=bar` respectively
first, and assign these to the default stage test. The third job on the deploy
stage starts only after the test stage has completed successfully. Be sure to
set the env var `FOO` if your script takes it into account.

TODO: might make more sense to skip the first example and just use the rvm one? I think it is clearer

For example if you use `rvm` (or any other language runtime key) to specify
runtime versions, you **must** also specify the `rvm` version on the included
deploy job:


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

## Build stages and deployments

You can combine build stages with our [deployment integration](https://docs.travis-ci.com/user/deployment/):

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

## Example: Deploying to Heroku

An example with 5 stages:

* Two jobs running unit tests in parallel on stage 1.
* One job deploying the application to Heroku staging.
* One job testing the staging deployment on Heroku.
* One job deploying the application to Heroku production.
* One job testing the production deployment on Heroku.

You can find more [details here](/user/build-stages/deploy-heroku/).

## ExampleL Warming up a cache with expensive dependencies

This example warms up a cache with expensive dependencies in order to optimize test runs:

* One job that installs dependencies and warms up the cache for the given branch.
* Three jobs that run tests, using the cache.

You can find more [details here](/user/build-stages/warm-cache/).
