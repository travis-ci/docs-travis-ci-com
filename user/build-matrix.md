---
title: Build Matrix
layout: en
---

A build matrix is made up by several multiple jobs that run in parallel.

This can be useful in many cases, but the two primary reasons to use a build matrix are:

* [Reducing the overall build execution time](/user/speeding-up-the-build)
* Running tests against different versions of runtimes or dependencies

The examples on this page focus on the latter use case.

There are two ways to define a matrix in the `.travis.yml` file:

* Using the Matrix Expansion feature
* Listing individual job configs

Both features can be combined.

## Matrix Expansion

Certain keys are defined as matrix expansion keys that take arrays of values,
creating an additional job per value. If several matrix expansion keys are
given, this multiplies the number of jobs created.

For example, the following configuration produces a build matrix that expands
to *8 individual (2 * 2 * 2)* jobs, combining each value from the three
matrix expansion keys `rvm`, `gemfile`, and `env`.

```yaml
rvm:
- 2.5
- 2.2
gemfile:
- gemfiles/Gemfile.rails-3.2.x
- gemfiles/Gemfile.rails-3.0.x
env:
- ISOLATED=true
- ISOLATED=false
```
{: data-file=".travis.yml"}

## Listing individual jobs

In addition, jobs can be specified by adding entries to the key `jobs.include`.

For example, if not all of those combinations of the matrix expansion above are
relevant, jobs can be specified individually like so:

```yaml
jobs:
  include:
  - rvm: 2.5
    gemfile: gemfiles/Gemfile.rails-3.2.x
    env: ISOLATED=false
  - rvm: 2.2
    gemfile: gemfiles/Gemfile.rails-3.0.x
    env: ISOLATED=true
```
{: data-file=".travis.yml"}

> Build matrixes are currently limited to a maximum of **200 jobs** for both
> private and public repositories. If you are on an open-source plan, please
> remember that Travis CI provides this service free of charge to the
> community. So please only specify the matrix you *actually need*.

> You can also have a look at the [Language](https://config.travis-ci.com/ref/language) section in our [Travis CI Build Config Reference](https://config.travis-ci.com/).

## Excluding Jobs

The build matrix expansion sometimes produced unwanted combinations. In that
case it can be convenient to exclude certain combinations using the key
`jobs.exclude`, instead of listing all jobs individually.

For example, this would exclude two jobs from the build matrix:

```yaml
jobs:
  exclude:
  - rvm: 1.9.3
    gemfile: gemfiles/Gemfile.rails-2.3.x
    env: ISOLATED=true
  - rvm: jruby
    gemfile: gemfiles/Gemfile.rails-2.3.x
    env: ISOLATED=true
```
{: data-file=".travis.yml"}

If the jobs you want to exclude from the build matrix share the same matrix
parameters, you can specify only those and omit the varying parts.

Suppose you have:

```yaml
language: ruby
rvm:
- 1.9.3
- 2.0.0
- 2.1.0
env:
- DB=mongodb
- DB=redis
- DB=mysql
gemfile:
- Gemfile
- gemfiles/rails4.gemfile
- gemfiles/rails31.gemfile
- gemfiles/rails32.gemfile
```
{: data-file=".travis.yml"}

This results in a 3×3×4 build matrix. To exclude all jobs which have `rvm` value `2.0.0` *and*
`gemfile` value `Gemfile`, you can write:

```yaml
jobs:
  exclude:
  - rvm: 2.0.0
    gemfile: Gemfile
```
{: data-file=".travis.yml"}

Which is equivalent to:

```yaml
jobs:
  exclude:
  - rvm: 2.0.0
    gemfile: Gemfile
    env: DB=mongodb
  - rvm: 2.0.0
    gemfile: Gemfile
    env: DB=redis
  - rvm: 2.0.0
    gemfile: Gemfile
    env: DB=mysql
```
{: data-file=".travis.yml"}

### Excluding jobs with `env` value

When excluding jobs with `env` values, the value must match
_exactly_.

For example,

```yaml
language: ruby
rvm:
- 1.9.3
- 2.0.0
- 2.1.0
env:
- DB=mongodb SUITE=all
- DB=mongodb SUITE=compact
- DB=redis
- DB=mysql
jobs:
  exclude:
    - rvm: 1.9.3
      env: DB=mongodb
```
{: data-file=".travis.yml"}

defines a 3×4 matrix, because the `env` value does not match with
any job defined in the matrix.

To exclude all Ruby 1.9.3 jobs with `DB=mongodb` set, write:

```yaml
language: ruby
rvm:
- 1.9.3
- 2.0.0
- 2.1.0
env:
- DB=mongodb SUITE=all
- DB=mongodb SUITE=compact
- DB=redis
- DB=mysql
jobs:
  exclude:
    - rvm: 1.9.3
      env: DB=mongodb SUITE=all # not 'env: DB=mongodb' or 'env: SUITE=all DB=mongodb'
    - rvm: 1.9.3
      env: DB=mongodb SUITE=compact # not 'env: SUITE=compact DB=mongodb'
```
{: data-file=".travis.yml"}

## Explicitly Including Jobs

It is also possible to include entries into the matrix with `jobs.include`:

```yaml
jobs:
  include:
  - rvm: ruby-head
    gemfile: gemfiles/Gemfile.rails-3.2.x
    env: ISOLATED=false
```
{: data-file=".travis.yml"}

This adds a particular job to the build matrix which has already been populated.

This is useful if you want to only test the latest version of a dependency together with the latest version of the runtime.

You can use this method to create a build matrix containing only specific combinations.
For example,

```yaml
language: python
jobs:
  include:
  - python: "2.7"
    env: TEST_SUITE=suite_2_7
  - python: "3.8"
    env: TEST_SUITE=suite_3_8
  - python: "pypy"
    env: TEST_SUITE=suite_pypy
script: ./test.py $TEST_SUITE
```
{: data-file=".travis.yml"}

creates a build matrix with 3 jobs, which runs test suite for each version
of Python.

### Explicitly included jobs inherit the first value in the array

The jobs which are explicitly included inherit the first value of the expansion
keys defined.

In this example with a 3-job Python build matrix, each job in `jobs.include`
has the `python` value set to `'3.8'`.
You can explicitly set the python version for a specific entry:

```yaml
language: python
python:
  - '3.8'
  - '3.7'
  - '2.7'
jobs:
  include:
    - python: '3.8' # this is not strictly necessary
      env: EXTRA_TESTS=true
    - python: '3.7'
      env: EXTRA_TESTS=true
script: env $EXTRA_TESTS ./test.py $TEST_SUITE
```
{: data-file=".travis.yml"}

### Explicitly included jobs with only one element in the build matrix

As a special case, if your build matrix has only one element _and_ you have
explicitly included jobs, matrix expansion is not done and the explicit jobs
_completely_ define your build. For example:

```yaml
language: python
python:
  - '3.8'
jobs:
  include:
    - env: EXTRA_TESTS=true
# only defines one job with `python: 3.8` and `env: EXTRA_TESTS=true`
```
{: data-file=".travis.yml"}

If you need the (sole) job from the matrix in such a case, too,
add a blank job entry to the explicit list (as it would
[inherit all values from the matrix](#explicitly-included-jobs-inherit-the-first-value-in-the-array)
with no changes):

```yaml
language: python
python:
  - '3.8'
jobs:
  include:
    -
    - env: EXTRA_TESTS=true
# defines two jobs:
#   - python: 3.8
#   - python: 3.8
#     env: EXTRA_TESTS=true
```
{: data-file=".travis.yml"}

## Rows that are Allowed to Fail

You can define rows that are allowed to fail in the build matrix. Allowed
failures are items in your build matrix that are allowed to fail without causing
the entire build to fail. This lets you add in experimental and
preparatory builds to test against versions or configurations that you are not
ready to officially support.

Define allowed failures in the build matrix as key/value pairs:

```yaml
jobs:
  allow_failures:
  - rvm: 1.9.3
```
{: data-file=".travis.yml"}

### Matching Jobs with `allow_failures`

When matching jobs against the definitions given in `allow_failures`, _all_
conditions in `allow_failures` must be met exactly, and
all the keys in `allow_failures` element must exist in the
top level of the build matrix (i.e., not in `jobs.include`).

#### `allow_failures` Examples

Consider

```yaml
language: ruby

rvm:
- 2.0.0
- 2.1.6

env:
  global:
  - SECRET_VAR1=SECRET1
  jobs:
  - SECRET_VAR2=SECRET2

jobs:
  allow_failures:
    - env: SECRET_VAR1=SECRET1 SECRET_VAR2=SECRET2
```
{: data-file=".travis.yml"}

Here, no job is allowed to fail because no job has the `env` value
`SECRET_VAR1=SECRET1 SECRET_VAR2=SECRET2`.

Next,

```yaml
language: php
php:
- 5.6
- 7.0
jobs:
  include:
  - php: 7.0
    env: KEY=VALUE
  allow_failures:
  - php: 7.0
    env: KEY=VALUE
```
{: data-file=".travis.yml"}

Without the top-level `env`, no job will be allowed to fail.

## Fast Finishing

If some rows in the build matrix are allowed to fail, the build won't be marked as finished until they have completed.

To mark the build as finished as soon as possible, add `fast_finish: true` to the `jobs` section of your `.travis.yml` like this:

```yaml
jobs:
  fast_finish: true
```
{: data-file=".travis.yml"}

Now, the build result will be determined as soon as all the required jobs finish, based on these results, while the rest of the `allow_failures` jobs continue to run.

## Using Different Programming Languages per Job
You can also use the `jobs.include` feature to have different languages for each job in your build. For example,

```yaml
dist: xenial
language: php
php:
  - '5.6'

jobs:
  include:
    - language: python
      python: 3.8
      script:
      - python -c "print('Hi from Python!')"

    - language: node_js
      node_js: 12
      script:
      - node -e "console.log('Hi from NodeJS!')"

    - language: java
      jdk: openjdk8
      script:
      - javac -help
```
{: data-file=".travis.yml"}
This creates a build with 3 jobs as follows:

* A Python 3.8 job
* A  Node.js 12 job
* A Java OpenJDK 8 job

## Job Names

Jobs listed in `jobs.include` can be named by using the key `name`, like so:

```yaml
jobs:
  include:
  - name: Job 1
    script: echo "Running job 1"

```

This name will appear on the build matrix UI and can be convenient in order to
quickly identify jobs in a large matrix.

Jobs generated through the Matrix Expansion feature cannot be named.

## Job Uniqueness and Duplicate Jobs

Jobs need to be unique, and duplicate jobs are dropped during the [Build Config Validation](/user/build-config-validation)
process.

For example, this config would result in only one job using the [YAML anchors and aliases](/user/build-config-yaml#private-keys-as-yaml-anchors-and-aliases-and-external-tooling):

```yaml
_shared_job: &shared_job
  script: echo "shared script config"
jobs:
  include:
  - <<: *shared_job
  - <<: *shared_job
```

In rare circumstances it can still be desirable to execute multiple jobs with the same config. In such cases, job uniqueness can be achieved by specifying any additional key, e.g. a job name:

```yaml
_shared_job: &shared_job
  script: echo "shared script config"
jobs:
  include:
  - name: Job 1
    <<: *shared_job
  - name: Job 2
    <<: *shared_job
```
