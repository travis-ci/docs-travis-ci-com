---
title: Build Stages

layout: en
---



## What Are Build Stages?

Build stages is a way to group jobs, and run jobs in each stage in parallel,
but run one stage after another sequentially.

In the simplest and most common use case, you can now make one job run _only_
if several other, parallel jobs have completed successfully.

Let’s say you want to test a library like a Ruby gem or an npm package against
various runtime (Ruby or Node.js) versions in [parallel](/user/customizing-the-build#build-matrix).
And you want to release your gem or package **only** if all tests have passed and
completed successfully. Build stages make this possible.

Of course, there are a lot more and a lot more elaborated use cases than this
one. You can, for example, also use build stages to warm up dependency caches
in a single job on a first stage, then use the cache on several jobs on a
second stage. Or, you could generate a Docker image and push it first, then
test it on several jobs in parallel. Or, you could run unit tests, deploy to
staging, run smoke tests and only then deploy to production.

## How Do Build Stages Work?

The concept of build stages is powerful and flexible, yet simple and
approachable:

Stages group jobs that run in parallel and different stages run sequentially.

A stage is a group of jobs that are allowed to run in parallel. However, each
one of the stages runs one after another and will only proceed, if all jobs in
the previous stage have passed successfully. If one job fails in one stage, all
other jobs on the same stage will still complete, but all jobs in subsequent
stages will be canceled and the build fails.

You can configure as many jobs per stage as you need and you can have as many
stages as your delivery process requires.

In the following example, we are running two jobs on the first stage called
test, and then run a single third job on the second stage called deploy:

![Example screencast](/images/stages/stages.gif)

## How to Define Build Stages?

Here’s how you’d set up the build configuration for this in your `.travis.yml`
file:

```yaml
jobs:
  include:
    - stage: test
      script: ./test 1
    - # stage name not required, will continue to use `test`
      script: ./test 2
    - stage: deploy
      script: ./deploy
```
{: data-file=".travis.yml"}

This configuration creates the build from the screencast above. I.e., it creates
a build with three jobs, two of which start in parallel in the first stage
(named `test`), while the third job on the second stage (named `deploy`) starts
only after the test stage completes successfully.

## Naming Your Build Stages

Stages are identified by their names, which are composed of names and emojis.
The first letter of a stage name is automatically capitalized for
aesthetical reasons, so you don't have to deal with uppercase strings in your
`.travis.yml` file.

Also, you do not have to specify the name on every single job (as shown in the
example above). The default stage is `test`. Jobs that do not have a stage
name are assigned to the previous stage name, if one exists or the default
stage name, if there is no previous stage name. This means that if you set the
stage name on the first job of each stage, the build will work as expected.

For example, the following config is equivalent to the one above, but also adds a
second deploy job to the `deploy` stage that deploys to a different target. As
you can see, you only need to specify the stage name once:

```yaml
jobs:
  include:
    - script: ./test 1 # uses the default stage name "test"
    - script: ./test 2
    - stage: deploy
      script: ./deploy target-1
    - script: ./deploy target-2
```
{: data-file=".travis.yml"}

### Naming Your Jobs within Build Stages

You can also name specific jobs within build stages. We recommend unique job names, but
do not enforce it (though this may change in the future). Jobs defined in the `jobs.include`
section can be given a name attribute as follows:

```yaml
jobs:
  include:
    - stage: "Tests"                # naming the Tests stage
      name: "Unit Tests"            # names the first Tests stage job
      script: ./unit-tests
    - script: ./integration-tests
      name: "Integration Tests"     # names the second Tests stage job
    - stage: deploy
      name: "Deploy to GCP"
      script: ./deploy
```
{: data-file=".travis.yml"}

## Build Stages and Build Matrix Expansion

[Matrix expansion](/user/customizing-the-build/#build-matrix)
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
{: data-file=".travis.yml"}

This will run two jobs on Ruby 2.3 and 2.4 respectively first and assign these
to the default stage test. The third job on the deploy stage starts only after
the test stage has completed successfully.

> Each job included in `jobs.include` inherits the first value of the array
that defines a matrix dimension.
> In the example above, without explicitly setting `rvm: 2.4`, the `include`d job inherits
`rvm: 2.3`.

## Specifying Stage Order and Conditions

You can specify the order for stages in the section `stages`:

```yaml
stages:
  - compile
  - test
  - deploy
```
{: data-file=".travis.yml"}

This is mostly useful in order to "prepend" a stage to the `test` stage that
jobs resulting from the matrix expansion will be assigned to.

On the same section you can also specify conditions for stages, like so:

```yaml
stages:
  - compile
  - test
  - name: deploy
    if: branch = master
```
{: data-file=".travis.yml"}

See [Conditional Builds, Stages, and Jobs](/user/conditional-builds-stages-jobs/) for more details on specifying conditions.


## Build Stages and Deployments

You can combine build stages with [deployments](/user/deployment/):

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
{: data-file=".travis.yml"}

Travis CI does not set or overwrite any of your scripts and most languages
have a [default test script](/user/languages/ruby/#default-build-script)
defined. So in many use cases you might want to overwrite the `script` step by
specifying the keyword `skip` or `ignore`, in other cases you might want to
overwrite other steps, such as the `install` step that runs by default on
several languages.

## Data Persistence between Stages and Jobs

> It is important to note that jobs do not share storage, as each job runs in a fresh VM or container.
If your jobs need to share files (e.g., using build artifacts from the "Test" stage for deployment in the
subsequent "Deploy" stage), you need to use an external storage mechanism such as S3 and a remote
`scp` server.

See [the S3 example](#sharing-files-between-jobs-via-s3) below.

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

### Deploying to NPM

This example has two build stages:

* Four jobs that run tests against Node versions 4 to 7
* One job that deploys (releases) the package to NPM

You can find more [details here](/user/build-stages/deploy-npm/).

### Deploying to GitHub Releases

This example has two build stages:

* Four jobs that run tests
* One job that deploys to GitHub Releases

You can find more [details here](/user/build-stages/deploy-github-releases/).

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

### Sharing a Docker image

This example has 2 build stages:

* One job builds and pushes a Docker image
* Two jobs that pull and test the image

You can find more [details here](/user/build-stages/share-docker-image/).

### Sharing files between jobs via S3

This uses two build stages, sharing files from build stage 1 in stage 2:

* Two jobs that set up files on S3.
* One job that uses both files from stage 1.

You can find more [details here](/user/build-stages/share-files-s3/).

### Defining different steps on different stages

This example has 2 build stages:

* Two jobs that run different suites of tests against Ruby 2.3.1
* One job that runs a custom deploy script that doesn't require running the default `install` or `script` steps

You can find more [details here](/user/build-stages/define-steps/).

### Defining steps using YAML aliases

This example uses YAML aliases to define steps. It has 3 build stages:

* Two jobs that run tests against Ruby 2.2 and 2.3
* One job that deploys to staging
* Three jobs that run test against staging

You can find more [details here](/user/build-stages/using-yaml-aliases/).
