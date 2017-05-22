---
title: Build Matrix
layout: en
permalink: /user/essentials/build-matrix/
---

## Build Matrix

When you combine the three main configuration options of *Runtime*, *Environment* and *Exclusions/Inclusions* you have a matrix of all possible combinations.

Below is an example configuration for a build matrix that expands to *56 individual (7 * 4 * 2)* jobs.

```yaml
rvm:
  - 1.9.3
  - 2.0.0
  - 2.2
  - ruby-head
  - jruby
  - rbx-2
  - ree
gemfile:
  - gemfiles/Gemfile.rails-2.3.x
  - gemfiles/Gemfile.rails-3.0.x
  - gemfiles/Gemfile.rails-3.1.x
  - gemfiles/Gemfile.rails-edge
env:
  - ISOLATED=true
  - ISOLATED=false
```

You can also define exclusions to the build matrix:

```yaml
matrix:
  exclude:
  - rvm: 1.9.3
    gemfile: gemfiles/Gemfile.rails-2.3.x
    env: ISOLATED=true
  - rvm: jruby
    gemfile: gemfiles/Gemfile.rails-2.3.x
    env: ISOLATED=true
```

> All build matrixes are currently limited to a maximum of **200 jobs** for both private and public repositories. If you are on an open-source plan, please remember that Travis CI provides this service free of charge to the community. So please only specify the matrix you *actually need*.

### Excluding Jobs

If the jobs you want to exclude from the build matrix share the same matrix
parameters, you can specify only those and omit the varying parts.

Suppose you have:

```yml
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

This results in a 3×3×4 build matrix. To exclude all jobs which have `rvm` value `2.0.0` *and*
`gemfile` value `Gemfile`, you can write:

```yml
matrix:
  exclude:
  - rvm: 2.0.0
    gemfile: Gemfile
```

Which is equivalent to:

```yml
matrix:
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

### Explicitly Including Jobs

It is also possible to include entries into the matrix with `matrix.include`:

```yaml
matrix:
  include:
  - rvm: ruby-head
    gemfile: gemfiles/Gemfile.rails-3.2.x
    env: ISOLATED=false
```

This adds a particular job to the build matrix which has already been populated.

This is useful if you want to only test the latest version of a dependency together with the latest version of the runtime.

You can use this method to create a build matrix containing only specific combinations.
For example,

```yaml
language: python
matrix:
  include:
  - python: "2.7"
    env: TEST_SUITE=suite_2_7
  - python: "3.3"
    env: TEST_SUITE=suite_3_3
  - python: "pypy"
    env: TEST_SUITE=suite_pypy
script: ./test.py $TEST_SUITE
```

creates a build matrix with 3 jobs, which runs test suite for each version
of Python.

#### Explicitly Included Jobs need complete definitions

When including jobs, it is important to ensure that each job defines a unique value
to any matrix dimension that the matrix defines.

For example, with a 3-job Python build matrix, each job in `matrix.include` must also
have the `python` value defined:

```yaml
language: python
python:
  - '3.5'
  - '3.4'
  - '2.7'
matrix:
  include:
    - python: '3.5'
      env: EXTRA_TESTS=true
    - python: '3.4'
      env: EXTRA_TESTS=true
script: env $EXTRA_TESTS ./test.py $TEST_SUITE
```

### Rows that are Allowed to Fail

You can define rows that are allowed to fail in the build matrix. Allowed
failures are items in your build matrix that are allowed to fail without causing
the entire build to fail. This lets you add in experimental and
preparatory builds to test against versions or configurations that you are not
ready to officially support.

Define allowed failures in the build matrix as key/value pairs:

```yaml
matrix:
  allow_failures:
  - rvm: 1.9.3
```

#### Matching Jobs with `allow_failures`

When matching jobs against the definitions given in `allow_failures`, _all_
conditions in `allow_failures` must be met exactly, and
all the keys in `allow_failures` element must exist in the
top level of the build matrix (i.e., not in `matrix.include`).

##### `allow_failures` Examples

Consider

```yaml
language: ruby

rvm:
- 2.0.0
- 2.1.6

env:
  global:
  - SECRET_VAR1=SECRET1
  matrix:
  - SECRET_VAR2=SECRET2

matrix:
  allow_failures:
    - env: SECRET_VAR1=SECRET1 SECRET_VAR2=SECRET2
```

Here, no job is allowed to fail because no job has the `env` value
`SECRET_VAR1=SECRET1 SECRET_VAR2=SECRET2`.

Next,

```yaml
language: php
php:
- 5.6
- 7.0
env: # important!
matrix:
  include:
  - php: 7.0
    env: KEY=VALUE
  allow_failures:
  - php: 7.0
    env: KEY=VALUE
```

Without the top-level `env`, no job will be allowed to fail.

### Fast Finishing

If some rows in the build matrix are allowed to fail, the build won't be marked as finished until they have completed.

To mark the build as finished as soon as possible, add `fast_finish: true` to the `matrix` section of your `.travis.yml` like this:

```yaml
matrix:
  fast_finish: true
```

Now, the build result will be determined as soon as all the required jobs finish, based on these results, while the rest of the `allow_failures` jobs continue to run.

## Implementing Complex Build Steps

If you have a complex build environment that is hard to configure in the `.travis.yml`, consider moving the steps into a separate shell script.
The script can be a part of your repository and can easily be called from the `.travis.yml`.

Consider a scenario where you want to run more complex test scenarios, but only for builds that aren't coming from pull requests. A shell script might be:

```bash
#!/bin/bash
set -ev
bundle exec rake:units
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
	bundle exec rake test:integration
fi
```

Note the `set -ev` at the top. The `-e` flag causes the script to exit as soon as one command returns a non-zero exit code. This can be handy if you want whatever script you have to exit early. It also helps in complex installation scripts where one failed command wouldn't otherwise cause the installation to fail.

The `-v` flag makes the shell print all lines in the script before executing them, which helps identify which steps failed.

Assuming the script above is stored as `scripts/run-tests.sh` in your repository, and with the right permissions too (run `chmod ugo+x scripts/run-tests.sh` before checking it in), you can call it from your `.travis.yml`:

```
script: ./scripts/run-tests.sh
```

### How does this work? (Or, why you should not use `exit` in build steps)

The steps specified in the build lifecycle are compiled into a single bash script and executed on the worker.

When overriding these steps, do not use `exit` shell built-in command.
Doing so will run the risk of terminating the build process without giving Travis a chance to
perform subsequent tasks.

Using `exit` inside a custom script which will be invoked from during a build is fine.
