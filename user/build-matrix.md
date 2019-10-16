---
title: Build Matrix
layout: en
---

There are two ways to specify multiple parallel jobs (what we call the build matrix) with a single `.travis.yml` configuration file:

* combine a language-and-environment dependent set of configuration options to automatically create a matrix of all possible combinations. This is called matrix expansion.
  For example, the following configuration produces a build matrix that expands to *8 individual (2 * 2 * 2)* jobs.

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

* specify the exact combination of configurations you want in `matrix.include`. For example, if not all of those combinations are interesting, you can specify just the combinations you want:

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

> All build matrixes are currently limited to a maximum of **200 jobs** for both private and public repositories. If you are on an open-source plan, please remember that Travis CI provides this service free of charge to the community. So please only specify the matrix you *actually need*.

## Excluding Jobs

You can also define exclusions to the build matrix:

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

It is also possible to include entries into the matrix with `matrix.include`:

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
  - python: "3.3"
    env: TEST_SUITE=suite_3_3
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

In this example with a 3-job Python build matrix, each job in `matrix.include`
has the `python` value set to `'3.5'`.
You can explicitly set the python version for a specific entry:

```yaml
language: python
python:
  - '3.5'
  - '3.4'
  - '2.7'
jobs:
  include:
    - python: '3.5' # this is not strictly necessary
      env: EXTRA_TESTS=true
    - python: '3.4'
      env: EXTRA_TESTS=true
script: env $EXTRA_TESTS ./test.py $TEST_SUITE
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
top level of the build matrix (i.e., not in `matrix.include`).

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

To mark the build as finished as soon as possible, add `fast_finish: true` to the `matrix` section of your `.travis.yml` like this:

```yaml
jobs:
  fast_finish: true
```
{: data-file=".travis.yml"}

Now, the build result will be determined as soon as all the required jobs finish, based on these results, while the rest of the `allow_failures` jobs continue to run.

## Using Different Programming Languages per Job
You can also use the `matrix.include` feature to have different languages for each job in your build. For example,

```yaml
dist: xenial
language: php
php:
  - '5.6'

jobs:
  include:
    - language: python
      python: 3.6
      script:
      - python -c "print('Hi from Python!')"

    - language: node_js
      node_js: 9
      script:
      - node -e "console.log('Hi from NodeJS!')"

    - language: java
      jdk: openjdk8
      script:
      - javac -help
```
{: data-file=".travis.yml"}
This creates a build with 3 jobs as follows:

* A Python 3.6 job
* A  Node.js 9 job
* A Java OpenJDK 8 job
