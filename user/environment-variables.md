---
title: Environment Variables
layout: en
permalink: /user/environment-variables/
---

A common way to customize the build process is to use environment variables, which can be accessed from any stage in your build process.

<div id="toc"></div>

* Variables defined in [.travis.yml](#Defining-Variables-in-.travis.yml) are tied to a certain commit. Changing them requires a new commit, restarting an old build uses the old values. They are also available automatically on forks of the repository. Define variables in `.travis.yml` that:

	+ are needed for the build to run and that don't contain sensitive data. For instance, a test suite for a Ruby application might require `$RACK_ENV` to be set to `test`.
	+ differ per branch.
	+ differ per job.

* Variables defined in [repository settings](#Defining-Variables-in-Repository-Settings) are the same for all builds. When you restart an old build, it uses the latest values. These variables are not automatically available to forks. Define variables in the Repository Settings that:

	+ differ per repository.
	+ contain sensitive data, such as third-party credentials.

> Notice that the values are not escaped when your builds are executed. Special characters (for bash) should be
escaped accordingly.

* Use [Encrypted variables](#Encrypted-Variables) for sensitive data such as authentication tokens.

> If you define a variable with the same name in `.travis.yml` and in the Repository Settings, the one in `.travis.yml` takes precedence. If you define a variable as both encrypted and unencrypted, the one defined later in the file takes precedence.

There is also a [complete list of default environment variables](#Default-Environment-Variables) which are present in all Travis CI environments.

## Defining Variables in .travis.yml

To define an environment variable in your `.travis.yml`, add the `env` line, for example:

    env:
    - DB=postgres

> Note that environment variable values may need quoting. For example, if they have asterisks (`*`) in them:
> ````
> env:
> PACKAGE_VERSION="1.0.*"
> ````

> Note that environment variables are expected to be in the form:
>
> ```
> env:
>   - VAR=VAL
> ```
>
> If multiple values are given, each will be defined.

### Defining Multiple Variables per Item

When you specify multiple variables per item in the `env` array (matrix variables), one build is triggered per item.

    rvm:
      - 1.9.3
      - rbx
    env:
      - FOO=foo BAR=bar
      - FOO=bar BAR=foo

this configuration triggers **4 individual builds**:

1. Ruby 1.9.3 with `FOO=foo` and `BAR=bar`
2. Ruby 1.9.3 with `FOO=bar` and `BAR=foo`
3. Rubinius latest version (rbx) with `FOO=foo` and `BAR=bar`
4. Rubinius latest version (rbx) with `FOO=bar` and `BAR=foo`


### Global Variables

Sometimes you may want to use environment variables that are global to the matrix, i.e. they're inserted into each matrix row. That may include keys, tokens, URIs or other data that is needed for every build. In such cases, instead of manually adding such keys to each `env` line in matrix, you can use `global` and `matrix` keys to differentiate between those two cases. For example:

    env:
      global:
        - CAMPFIRE_TOKEN=abc123
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false

triggers builds with the following `env` rows:

    USE_NETWORK=true CAMPFIRE_TOKEN=abc123 TIMEOUT=1000
    USE_NETWORK=false CAMPFIRE_TOKEN=abc123 TIMEOUT=1000

## Defining Variables in Repository Settings

To define variables in Repository Settings, make sure you're logged in, navigate to the repository in question, choose "Settings" from the cog menu, and click on "Add new variable" in the "Environment Variables" section.

<figure>
  <img alt="Screenshot of environment variables in settings" src="{{ "/images/settings-env-vars.png" | prepend: site.baseurl }}">
  <figcaption>Environment Variables in the Repository Settings</figcaption>
</figure>

By default, the value of these new environment variables is hidden from the `export` line in the logs. This corresponds to the behavior of [encrypted variables](#Encrypted-Variables) in your `.travis.yml`.

Similarly, we do not provide these values to untrusted builds, triggered by pull requests from another repository.

As an alternative to the web interface, you can also use the CLI's [`env`](https://github.com/travis-ci/travis.rb#env) command.

## Encrypted Variables

Variables can be encrypted so that their content is not shown in the corresponding `export` line in the build. This is used to provide sensitive data, like API credentials, to the Travis CI build. Encrypted variables are not added to untrusted builds such as pull requests coming from another repository.

A `.travis.yml` file containing encrypted variables looks like this:

    env:
      global:
        - secure: <long encrypted string here>
        - TIMEOUT=1000
      matrix:
        - USE_NETWORK=true
        - USE_NETWORK=false
        - secure: <you can also put encrypted vars inside matrix>

> Encrypted environment variables are not available to pull requests from forks due to the security risk of exposing such information to unknown code.

### Encrypting Variables Using a Public Key

Encrypt environment variables using the public key attached to your repository using the travis gem:

    gem install travis
    cd my_project
    travis encrypt MY_SECRET_ENV=super_secret

To automatically add the encrypted environment variable to your `.travis.yml`:

    travis encrypt MY_SECRET_ENV=super_secret --add env.matrix

> Encryption and decryption keys are tied to the repository. If you fork a project and add it to Travis CI, it will have different keys to the original.

The encryption scheme is explained in more detail in [Encryption keys](/user/encryption-keys).

### Convenience Variables

To make using encrypted environment variables easier, the following environment variables are available:

* `TRAVIS_SECURE_ENV_VARS` "true" or "false" depending on the availability of environment variables
* `TRAVIS_PULL_REQUEST` the pull request number if the current job is a pull request, or "false" if it's not a pull request.

## Default Environment Variables

The following default environment variables are available to all builds.

* `CI=true`
* `TRAVIS=true`
* `CONTINUOUS_INTEGRATION=true`
* `DEBIAN_FRONTEND=noninteractive`
* `HAS_JOSH_K_SEAL_OF_APPROVAL=true`
* `USER=travis` (**do not depend on this value**)
* `HOME=/home/travis` (**do not depend on this value**)
* `LANG=en_US.UTF-8`
* `LC_ALL=en_US.UTF-8`
* `RAILS_ENV=test`
* `RACK_ENV=test`
* `MERB_ENV=test`
* `JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"`
* `JAVA_HOME` is set to the appropriate value.

Additionally, Travis CI sets environment variables you can use in your build, e.g.
to tag the build, or to run post-build deployments.

* `TRAVIS_BRANCH`:For builds not triggered by a pull request this is the
  name of the branch currently being built; whereas for builds triggered
  by a pull request this is the name of the branch targeted by the pull
  request (in many cases this will be `master`).
* `TRAVIS_BUILD_DIR`: The absolute path to the directory where the repository
  being built has been copied on the worker.
* `TRAVIS_BUILD_ID`: The id of the current build that Travis CI uses internally.
* `TRAVIS_BUILD_NUMBER`: The number of the current build (for example, "4").
* `TRAVIS_COMMIT`: The commit that the current build is testing.
* `TRAVIS_COMMIT_RANGE`: The range of commits that were included in the push
  or pull request.
* `TRAVIS_JOB_ID`: The id of the current job that Travis CI uses internally.
* `TRAVIS_JOB_NUMBER`: The number of the current job (for example, "4.1").
* `TRAVIS_OS_NAME`: On multi-OS builds, this value indicates the platform the job is running on.
  Values are `linux` and `osx` currently, to be extended in the future.
* `TRAVIS_PULL_REQUEST`: The pull request number if the current job is a pull
  request, "false" if it's not a pull request.
* `TRAVIS_REPO_SLUG`: The slug (in form: `owner_name/repo_name`) of the
	repository currently being built. (for example, "travis-ci/travis-build").
* `TRAVIS_SECURE_ENV_VARS`: Whether or not encrypted environment vars are being
  used. This value is either "true" or "false".
* `TRAVIS_TEST_RESULT`: is set to **0** if the build [is successful](/user/customizing-the-build/#Breaking-the-Build) and **1** if the build [is broken](/user/customizing-the-build/#Breaking-the-Build).
* `TRAVIS_TAG`: If the current build for a tag, this includes the tag's name.

Language-specific builds expose additional environment variables representing
the current version being used to run the build. Whether or not they're set
depends on the language you're using.

* `TRAVIS_DART_VERSION`
* `TRAVIS_GO_VERSION`
* `TRAVIS_HAXE_VERSION`
* `TRAVIS_JDK_VERSION`
* `TRAVIS_JULIA_VERSION`
* `TRAVIS_NODE_VERSION`
* `TRAVIS_OTP_RELEASE`
* `TRAVIS_PERL_VERSION`
* `TRAVIS_PHP_VERSION`
* `TRAVIS_PYTHON_VERSION`
* `TRAVIS_R_VERSION`
* `TRAVIS_RUBY_VERSION`
* `TRAVIS_RUST_VERSION`
* `TRAVIS_SCALA_VERSION`

Other software specific environment variables are set when the software or service is installed or started, and contain the version number:

* `TRAVIS_MARIADB_VERSION`

The following environment variables are available for Objective-C builds.

* `TRAVIS_XCODE_SDK`
* `TRAVIS_XCODE_SCHEME`
* `TRAVIS_XCODE_PROJECT`
* `TRAVIS_XCODE_WORKSPACE`
