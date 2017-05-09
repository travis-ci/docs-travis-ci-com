---
title: Build Stages
permalink: /user/build-stages/
layout: en
---

<div id="toc"></div>

Build stages let you group jobs together in a stage so that they can be run in
parallel and the stages execute sequentially, one after another. The execution
will stop when any stage fails.

This way jobs can be coordinated in such a way that, for example, one
deployment job can be run **after several** test jobs have all completed
successfully.

Jobs can be assigned to stages by adding a stage name to the job configuration
in the `jobs.include` section of the `.travis.yml` file, like so:

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

This will create a build with three jobs, two of which will start in parallel
in the first stage (named `test`), while the third job on the second stage
(named `deploy`) starts only after the test stage completed successfully.

This screencast demonstrates how such a build would execute:

![](https://cloud.githubusercontent.com/assets/3729517/25229553/0868909c-25d1-11e7-9263-b076fdef9288.gif)

## Stage names

Stage names are arbitrary strings, and you can include spaces or emojis. The
first letter of a stage name will be capitalized for aestethical reasons, so
you don't have to deal with uppercase strings in your `.travis.yml` file.

The default stage name if no stage name is specified is `test`.

Jobs that do not have a stage name will be assigned the previous stage name if
existing, or fall back to the default stage name, `test`. This allows you to
set the stage name only on the first job of each stage.

For example this config is equivalent to the one above, but also adds a second
deploy job that deploys to a different target. As you can see you only need to
specify the stage name once:

```yaml
jobs:
  include:
    - script: ./test 1 # uses the default stage name "test"
    - script: ./test 2
    - stage: deploy
      script: ./deploy target-1
    - script: ./deploy target-2
```

## How does this work with matrix expansion?

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

## How does this work with deployments?

You can combine build stages with our [deployment integration](https://docs.travis-ci.com/user/deployment/).

For example:

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
have a [default test script](http://localhost:4000/user/languages/ruby/#Default-Test-Script)
defined. So in many usecases you might want to overwrite the `script` by
specifying the keyword `skip` or `ignore`.


## Examples

You can find several usage examples in our [Demo repository](https://github.com/travis-ci/build-stages-demo).

